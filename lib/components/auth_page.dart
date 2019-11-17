import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart' as auth;
import '../services/spotify.dart' as spotify;
import '../models/song.dart';

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
        print('Code: $code');

        try {
          String accessToken = await auth.getAccessToken(code);
          GlobalConfiguration().updateValue("accessToken", accessToken);
          print('Access Token: $accessToken');
          flutterWebviewPlugin.close();

          await spotify.getCurrentlyPlaying(accessToken, context);
        } catch (err) {
          flutterWebviewPlugin.close();
          print(err);
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
    // TODO Tried to make this not build (possible?) exist when
    //   already authenticated
    Song song = Provider.of<Song>(context);

    if (song.currentlyPlaying != null) return Container();


    return RaisedButton(
      child: Text('Authenticate with Spotify'),
      onPressed: () {
        flutterWebviewPlugin.launch(url);
      },
    );
  }
}
