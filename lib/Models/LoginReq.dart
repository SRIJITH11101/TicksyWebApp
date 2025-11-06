import 'dart:convert';

class LoginReq {
  final String email;
  final String password;
  final String department;

  LoginReq({
    required this.email,
    required this.password,
    required this.department,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'department': department,
  };

  String toRawJson() => jsonEncode(toJson());
}
