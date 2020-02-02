import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lyrics_finder/models/song.dart';

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
          icon: Icon(
            Icons.skip_previous,
            size: 32,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: song.currentlyPlaying == true
              ? Icon(
                  Icons.pause,
                  size: 32,
                )
              : Icon(
                  Icons.play_arrow,
                  size: 32,
                ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.skip_next,
            size: 32,
          ),
          onPressed: () {},
        ),
      ],
    ));
  }
}
