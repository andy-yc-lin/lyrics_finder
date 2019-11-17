class Token {
  String accessToken;
  String tokenType;
  int expiresIn;
  String refreshToken;
  String scope;

  Token({this.accessToken, this.tokenType, this.expiresIn, this.refreshToken, this.scope});
  factory Token.fromJson(Map<String, dynamic> json) => _tokenFromJson(json);
}

Token _tokenFromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
      refreshToken: json['refresh_token'] as String,
      scope: json['scope'] as String,
    );
  }