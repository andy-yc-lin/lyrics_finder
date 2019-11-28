import 'package:provider/provider.dart';
import 'package:lyrics_finder/models/song.dart';

import 'https.dart' as http;

Future<Song> getCurrentlyPlaying(accessToken, context) async {
  Song song = Provider.of<Song>(context);
  print('getCurrPlaying');
  try {
    Map<String, dynamic> json = await http.getCurrentlyPlaying(accessToken);
    song.songFromJson(json);
  } catch (err) {
    print(err);
  }
  return song;
}
