import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

import '../services/https.dart' as https;
import '../services/spotify.dart' as spotify;
import '../models/song.dart';

class Lyrics extends StatelessWidget {
  Future<String> loadLyrics(List<String> artists, String songName) async {
    print('loadingLyrics');
    var lyrics = '';
    final link = await https.queryAZLyrics(artists, songName);
    lyrics = await https.parseLyrics(link);
    return lyrics;
  }

  @override
  Widget build(BuildContext context) {
    Song song = Provider.of<Song>(context);
    List<String> artists = song.artists;
    String songName = song.name;
    bool isPlaying = song.currentlyPlaying;

    if (isPlaying == null &&
        !(isPlaying == null && artists != null && songName != null))
      return Container();
    if (isPlaying == false) {
      return RaisedButton(
        child: Text('Refresh'),
        onPressed: () async {
          await spotify.getCurrentlyPlaying(
              GlobalConfiguration().getString('accessToken'), context);
        },
      );
    }

    return FutureBuilder<String>(
      future: loadLyrics(artists, songName),
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
                  print('refreshing with $artists $songName');
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
