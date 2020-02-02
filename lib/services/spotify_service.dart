import 'package:provider/provider.dart';
import 'package:lyrics_finder/models/song.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Song> getCurrentlyPlaying(accessToken, context) async {
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
