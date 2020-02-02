import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:lyrics_finder/models/song.dart';

Future<Song> getCurrentlyPlaying(context) async {
  var accessToken = GlobalConfiguration().getString('accessToken');
  Song song = Provider.of<Song>(context);

  print('getCurrPlaying');
  try {
    final response = await http.get(
      'https://api.spotify.com/v1/me/player',
      headers: {"Authorization": "Bearer $accessToken"},
    );

    final res = response.body;
    Map<String, dynamic> decodedJSON;
    if (response.statusCode == 200 || response.statusCode == 204) {
      decodedJSON = res.isEmpty ? null : json.decode(res);
    } else {
      print('getCurrentlyPlaying $res');
      throw Exception(res);
    }

    song.songFromJson(decodedJSON);
  } catch (err) {
    print(err);
  }
  return song;
}

playNext() async {
  var accessToken = GlobalConfiguration().getString('accessToken');
  try {
    final response = await http.post(
      'https://api.spotify.com/v1/me/player/next',
      headers: {"Authorization": "Bearer $accessToken"},
    );
    final res = response.body;
    if (response.statusCode == 204) {
      print('played next');
      return;
    } else {
      print('failed to play next song $res');
      throw Exception(res);
    }
  } catch (err) {
    print(err);
  }
}

playPrevious() async {
  var accessToken = GlobalConfiguration().getString('accessToken');
  try {
    final response = await http.post(
      'https://api.spotify.com/v1/me/player/previous',
      headers: {"Authorization": "Bearer $accessToken"},
    );
    final res = response.body;
    if (response.statusCode == 204) {
      print('played previous');
      return;
    } else {
      print('failed to play previous song $res');
      throw Exception(res);
    }
  } catch (err) {
    print(err);
  }
}

playPause(isCurrentlyPlaying) async {
  var accessToken = GlobalConfiguration().getString('accessToken');
  try {
    final response = await http.put(
      'https://api.spotify.com/v1/me/player/${isCurrentlyPlaying ? 'pause' : 'play'}',
      headers: {"Authorization": "Bearer $accessToken"},
    );
    final res = response.body;
    if (response.statusCode == 204) {
      print('play pause');
      return;
    } else {
      print('failed to play or pause current song $res');
      throw Exception(res);
    }
  } catch (err) {
    print(err);
  }
}
