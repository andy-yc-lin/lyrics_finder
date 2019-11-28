import 'dart:async';
import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:html/parser.dart' as html show parse;
import 'package:http/http.dart' as http;

import '../models/token.dart';

// TODO split this package into separate classes
//   and build generic http request helper

Future<String> parseLyrics(String link) async {
  final response = await http.get(link);

  final body = response.body;
  if (response.statusCode == 200) {
    final document = html.parse(body);
    final lyricsDiv = document.querySelectorAll('div.ringtone ~ div');
    return lyricsDiv[0].text.replaceAll('\\n', '').trim();
  } else {
    print(body);
    throw Exception(body);
  }
}

Future<String> queryAZLyrics(List<String> artists, String songName) async {
  final query = buildQuery(artists, songName);
  final url = 'https://search.azlyrics.com/search.php?q=$query';
  print('Query Url $url');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final document = html.parse(response.body);
    final lyricsDiv = document.querySelectorAll('tbody .text-left a');

    // TODO make this Dynamic in case first link is incorrect song
    // lyricsDiv.forEach((td) => {});

    if (lyricsDiv.length < 1 || lyricsDiv[0].attributes == null) {
      throw Exception('Search returned no results.');
    }
    final lyricsUrl = lyricsDiv[0].attributes['href'];
    print('Lyrics Url $lyricsUrl');
    return lyricsUrl;
  } else {
    throw Exception(response);
  }
}

String buildQuery(List<String> artists, String songName) {
  var query = '';
  artists.forEach((artist) {
    query += '${normalizeString(artist)}+';
  });
  query += normalizeString(songName);
  return '$query';
}

String normalizeString(String string) {
  var sanitized = string.toLowerCase();
  final wordsToRemove = [
    '-',
    'feat',
    'remaster',
    'rerecord',
  ];
  wordsToRemove.forEach((word) {
    if (sanitized.contains(word)) {
      sanitized = sanitized.substring(0, sanitized.indexOf(word));
    }
  });
  return sanitized
      .replaceAll(RegExp('\\W'), ' ')
      .trim()
      .replaceAll(RegExp('\\s+'), '+');
}

Future<Token> postUserToken(code) async {
  final id = GlobalConfiguration().getString('id');
  final secret = GlobalConfiguration().getString('secret');
  final creds64 = base64.encode(utf8.encode('$id:$secret'));
  final response = await http.post(
    'https://accounts.spotify.com/api/token',
    headers: {"Authorization": "Basic $creds64"},
    body: {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': GlobalConfiguration().getString('callbackUrlScheme'),
    },
  );

  final res = response.body;
  if (response.statusCode == 200) {
    return Token.fromJson(json.decode(res));
  } else {
    print('postUserToken $res');
    throw Exception(res);
  }
}

Future<Map<String, dynamic>> getCurrentlyPlaying(token) async {
  final response = await http.get(
    'https://api.spotify.com/v1/me/player',
    headers: {"Authorization": "Bearer $token"},
  );

  final res = response.body;
  if (response.statusCode == 200 || response.statusCode == 204) {
    return res.isEmpty ? null : json.decode(res);
  } else {
    print('getCurrentlyPlaying $res');
    throw Exception(res);
  }
}
