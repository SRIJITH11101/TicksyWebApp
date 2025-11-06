class AuthRes {
  final String accessToken;
  final String refreshToken;
  final String staffId;
  final String staffName;

  factory AuthRes.fromJson(Map<String, dynamic> json) {
    return AuthRes(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      staffId: json['staffId'] ?? '',
      staffName: json['staffName'] ?? '',
    );
  }

  AuthRes({
    required this.accessToken,
    required this.refreshToken,
    required this.staffId,
    required this.staffName,
  });
}
