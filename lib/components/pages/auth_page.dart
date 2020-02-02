import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

import 'package:lyrics_finder/services/auth_service.dart' as auth;
import 'package:lyrics_finder/services/spotify_service.dart' as spotifyService;
import 'package:lyrics_finder/models/song.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  String url;

  @override
  void initState() {
    super.initState();
    String clientId = GlobalConfiguration().getString('id');
    String callbackUrlScheme =
        GlobalConfiguration().getString('callbackUrlScheme');
    waitForUserAuth(clientId, callbackUrlScheme);
  }

  waitForUserAuth(clientId, callbackUrlScheme) {
    url = Uri.https('accounts.spotify.com', '/de/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': '$callbackUrlScheme',
      'scope':
          'user-read-private user-read-email user-read-currently-playing user-read-playback-state',
    }).toString();

    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      print("loading url: $url");
      if (url.startsWith('$callbackUrlScheme')) {
        var code = url.split("code=")[1];
        if (code.endsWith('#_=_')) code = code.split('#_=_')[0];
        print('Code: $code');
        flutterWebviewPlugin.stopLoading();

        String accessToken;
        try {
          accessToken = await auth.getAccessToken(code);
          GlobalConfiguration().updateValue("accessToken", accessToken);
          print('Access Token: $accessToken');
        } catch (err) {
          print(err);
        } finally {
          await spotifyService.getCurrentlyPlaying(accessToken, context);
          await flutterWebviewPlugin.close();
        }
      } else {
        // TODO Error
        // example.com/callback?error=access_denied&state=STATE
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Song song = Provider.of<Song>(context);
    if (song.currentlyPlaying == null) flutterWebviewPlugin.launch(url);
    return Container();
  }
}
