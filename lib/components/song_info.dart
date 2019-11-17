import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';

class SongInfo extends StatelessWidget {
  String formatArtists(artists) {
    var artistsAsString = artists.toString();
    return artistsAsString.substring(1, artistsAsString.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    Song song = Provider.of<Song>(context);
    String name = song.name;
    String artists = formatArtists(song.artists);
    bool isPlaying = song.currentlyPlaying;

    if (isPlaying == null) return Container();
    if (isPlaying == false) return Text('No song playing on Spotify');

    return Container(
      child: Text(
        'Currently playing: $artists - $name',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}