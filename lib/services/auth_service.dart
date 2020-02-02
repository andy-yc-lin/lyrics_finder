import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

import 'package:lyrics_finder/models/token.dart';

Future<String> getAccessToken(code) async {
  final id = GlobalConfiguration().getString('id');
  final secret = GlobalConfiguration().getString('secret');
  final creds64 = base64.encode(utf8.encode('$id:$secret'));
  final response = await http.post(
    'https://accounts.spotify.com/api/token',
    headers: {"Authorization": "Basic $creds64"},
    body: {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': GlobalConfiguration().getString('callbackUrlScheme'),
    },
  );

  final res = response.body;
  if (response.statusCode == 200) {
    Token token = Token.fromJson(json.decode(res));
    return token.accessToken;
  } else {
    print('postUserToken $res');
    throw Exception(res);
  }
}
