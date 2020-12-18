import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lyrics_finder/services/spotify_service.dart' as spotifyService;
import 'package:lyrics_finder/services/http_service.dart' as http;
import 'package:lyrics_finder/models/song.dart';

class Lyrics extends StatelessWidget {
  Future<String> loadLyrics(List<String> artists, String songName) async {
    print('loadingLyrics');
    var lyrics = '';
    final link = await http.queryAZLyrics(artists, songName);
    lyrics = await http.getLyrics(link);
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
          await spotifyService.getCurrentlyPlaying(context);
        },
      );
    }

    Future.delayed(
        Duration(milliseconds: song.duration),
        () => {
              print('auto reload'),
              spotifyService.getCurrentlyPlaying(context),
            });

    // TODO refactor into stateful widget??
    return FutureBuilder<String>(
      future: loadLyrics(artists, songName),
      builder: (context, snapshot) {
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
                  await spotifyService.getCurrentlyPlaying(context);
                },
              )
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // Need this because snapshot seems to return with old lyrics while loading
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          print(snapshot);
          return Text(
            '${snapshot.data}',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
