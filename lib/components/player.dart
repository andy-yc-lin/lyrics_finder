import 'package:flutter/material.dart';
import 'package:lyrics_finder/models/song.dart';
import 'package:provider/provider.dart';

class Player extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Song song = Provider.of<Song>(context);
    if (song.currentlyPlaying == null) return Container();

    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: () {},
        ),
        IconButton(
          icon: song.currentlyPlaying == true
              ? Icon(Icons.pause)
              : Icon(Icons.play_arrow),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: () {},
        ),
      ],
    ));
  }
}
