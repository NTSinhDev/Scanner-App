class Auth {
  final String token;

  Auth({required this.token});

  String get getToken => 'Bearer $token';

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(token: map['token'] as String);
  }

  @override
  String toString() => 'Auth(accessToken: $token)';
}
