import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:lyrics_finder/components/pages/query_page.dart';
import 'package:lyrics_finder/components/pages/spotify_page.dart';
import 'package:lyrics_finder/services/spotify_service.dart' as spotifyService;

class ModeSelectionPage extends StatelessWidget {
  refreshSong(BuildContext context) async {
    final token = GlobalConfiguration().getString("accessToken");
    if (token == "1") return;
    await spotifyService.getCurrentlyPlaying(context);
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
                    builder: (context) => SpotifyPage(),
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
                    builder: (context) => QueryPage(),
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
