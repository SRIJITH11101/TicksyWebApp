import 'dart:convert';

class SignUpReq {
  final String staffName;
  final String email;
  final String password;
  final String department;

  SignUpReq({
    required this.staffName,
    required this.email,
    required this.password,
    required this.department,
  });

  Map<String, dynamic> toJson() => {
    'staffName': staffName,
    'email': email,
    'password': password,
    'department': department,
  };

  String toRawJson() => jsonEncode(toJson());
}
