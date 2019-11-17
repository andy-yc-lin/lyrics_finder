import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

import '../services/https.dart' as https;
import '../services/spotify.dart' as spotify;
import '../models/song.dart';

class Lyrics extends StatelessWidget {
  Future<String> loadLyrics(List<String> artists, String songName) async {
    var lyrics = '';
    final link = await https.queryAZLyrics(artists, songName);
    lyrics = await https.parseLyrics(link);
    return lyrics;
  }

  @override
  Widget build(BuildContext context) {
    Song song = Provider.of<Song>(context);
    List<String> _artists = song.artists;
    String _songName = song.name;
    if (_artists == null || _songName == null) return Container();
    if (song.currentlyPlaying == false)
      return RaisedButton(
        child: Text('Refresh'),
        onPressed: () async {
          await spotify.getCurrentlyPlaying(
              GlobalConfiguration().getString('accessToken'), context);
        },
      );

    return FutureBuilder<String>(
      future: loadLyrics(_artists, _songName),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Text(
            '${snapshot.data}',
            textAlign: TextAlign.center,
          );
        if (snapshot.hasError) {
          return Column(
            children: <Widget>[
              Text(
                snapshot.error.toString(),
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              RaisedButton(
                child: Text('Refresh'),
                onPressed: () async {
                  print('refreshing with $_artists $_songName');
                  await spotify.getCurrentlyPlaying(
                      GlobalConfiguration().getString('accessToken'), context);
                },
              )
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
