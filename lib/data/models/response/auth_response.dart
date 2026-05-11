class AuthResponse {
  final bool success;
  final String? token;
  final String? refreshToken;
  final String? errorMessage;
  final String? userId;
  final int? roleId;

  AuthResponse({
    required this.success,
    this.token,
    this.refreshToken,
    this.errorMessage,
    this.userId,
    this.roleId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] == true,
      token: json['token']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      userId: json['userId']?.toString(),
      roleId: json['roleId'] is int ? json['roleId'] : int.tryParse(json['roleId']?.toString() ?? ''),
    );
  }
}
