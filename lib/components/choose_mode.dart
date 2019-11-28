import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:lyrics_finder/components/query.dart';

import './spotify.dart';
import '../services/spotify.dart' as spotify;

class ChooseMode extends StatelessWidget {
  refreshSong(BuildContext context) async {
    final token = GlobalConfiguration().getString("accessToken");
    if (token == "1") return;
    await spotify.getCurrentlyPlaying(token, context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: () {
                refreshSong(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Spotify(),
                  ),
                );
              },
              child: Text('Song from Spotify'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Query(),
                  ),
                );
              },
              child: Text('Manual search'),
            ),
          ),
        ],
      ),
    );
  }
}
