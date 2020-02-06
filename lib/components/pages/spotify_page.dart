import 'package:flutter/material.dart';

import 'package:lyrics_finder/components/pages/auth_page.dart';
import 'package:lyrics_finder/components/player.dart';
import 'package:lyrics_finder/components/side_menu.dart';
import 'package:lyrics_finder/components/song_info.dart';
import 'package:lyrics_finder/components/lyrics.dart';
import 'package:lyrics_finder/services/spotify_service.dart' as spotifyService;

class SpotifyPage extends StatelessWidget {
  refreshSong(BuildContext context) async {
    await spotifyService.getCurrentlyPlaying(context);
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: SongInfo(),
      ),
      body: GestureDetector(
        onTap: () {/* workaround for refreshing on tap */},
        child: RefreshIndicator(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  AuthPage(),
                  Player(), // TODO remove for non premium users
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Lyrics(),
                  ),
                ],
              ),
            ),
          ),
          onRefresh: () => refreshSong(context),
        ),
      ),
      endDrawer: SideMenu(),
    );
  }
}
