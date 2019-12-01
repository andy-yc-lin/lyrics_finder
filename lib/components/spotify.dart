import 'package:flutter/material.dart';
import 'package:lyrics_finder/components/side_menu.dart';

import 'auth_page.dart';
import 'song_info.dart';
import 'lyrics.dart';
import '../services/spotify.dart' as spotify;
import 'package:global_configuration/global_configuration.dart';

class Spotify extends StatelessWidget {
  refreshSong(BuildContext context) async {
    await spotify.getCurrentlyPlaying(
        GlobalConfiguration().getString("accessToken"), context);
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: GestureDetector(
        onTap: () {/* do nothing */},
        child: RefreshIndicator(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  AuthPage(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SongInfo(),
                  ),
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
