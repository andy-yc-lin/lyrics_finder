import 'package:provider/provider.dart';

import 'https.dart' as http;
import '../models/song.dart';

Future<Song> getCurrentlyPlaying(accessToken, context) async {
  Song song = Provider.of<Song>(context);
  print('getCurrPlaying');
  try {
    Map<String, dynamic> json = await http.getCurrentlyPlaying(accessToken);
    print(json);
    song.songFromJson(json);
  } catch (err) {
    print(err);
  }
  return song;
}
