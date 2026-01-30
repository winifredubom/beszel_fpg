class AuthenticationRequest {
  final String identity;
  final String password;

  AuthenticationRequest({
    required this.identity,
    required this.password,
  });

  factory AuthenticationRequest.fromJson(Map<String, dynamic> json) {
    return AuthenticationRequest(
      identity: json['identity'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identity': identity,
      'password': password,
    };
  }
}
class AuthenticationResponse {
  final String token;
  final Map<String, dynamic> record;

  AuthenticationResponse({
    required this.token,
    required this.record,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      token: json['token'] as String,
      record: json['record'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'record': record,
    };
  }
}