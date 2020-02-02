import 'dart:async';
import 'dart:convert';
import 'package:html/parser.dart' as html show parse;
import 'package:http/http.dart' as http;

// TODO split this package into separate classes
//   and build generic http request helper

Future<String> getLyrics(String link) async {
  final response = await http.get(link);

  final body = response.body;
  if (response.statusCode == 200) {
    final decodedResponse = utf8.decode(response.bodyBytes);
    final document = html.parse(decodedResponse);
    final lyricsDiv = document.querySelectorAll('div.ringtone ~ div');
    final lyrics = lyricsDiv[0].text;
    return lyrics.replaceAll('\\n', '').trim();
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