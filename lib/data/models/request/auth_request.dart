class LoginRequest {
  final String idToken;

  LoginRequest({required this.idToken});

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
    };
  }
}
