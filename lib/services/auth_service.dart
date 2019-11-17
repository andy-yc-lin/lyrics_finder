import './https.dart' as https;
import '../models/token.dart';

Future<String> getAccessToken(code) async {
  Token token = await https.postUserToken(code);
  return token.accessToken;
}
