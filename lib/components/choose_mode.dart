import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import './auth_page.dart';
import './query_form.dart';
import './lyrics.dart';
import '../services/spotify.dart' as spotify;
import './song_info.dart';

_onRefresh(BuildContext context) async {
  await spotify.getCurrentlyPlaying(
      GlobalConfiguration().getString("accessToken"), context);

  return 'success';
}

class ChooseMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // TODO add toggle to close query form, or switch mode?
            AuthPage(),
            QueryForm(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SongInfo(),
            ),
            Lyrics(),
          ],
        ),
      ),
      onRefresh: () => _onRefresh(context),
    );
  }
}
