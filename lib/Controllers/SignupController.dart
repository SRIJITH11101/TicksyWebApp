import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ticksy_web/ApiCalls/ApiRequests.dart';
import 'package:ticksy_web/Models/AuthRes.dart';
import 'package:ticksy_web/Models/SignUpReq.dart';
import 'package:ticksy_web/Screens/DesktopLayout.dart';

class SignupController extends GetxController {
  final api = ApiRequests();
  final emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController agentnameController = TextEditingController();
  final signUpKey = GlobalKey<FormState>();
  final authStorage = GetStorage();
  bool isPasswordHidden = true;
  bool isSigningUp = false;
  String selectedDept = "";

  List<String> deptList = [
    "Technical Support",
    "Customer Service",
    "Billing and Payments",
    "Product Support",
    "IT Support",
    "Returns and Exchanges",
    "Sales and Pre-Sales",
    "Human Resources",
    "Service Outages and Maintenance",
    "General Inquiry",
  ];

  Future<void> signup() async {
    if (!signUpKey.currentState!.validate()) return;

    try {
      isSigningUp = true;
      update();
      print(agentnameController.text);
      print(emailController.text);
      print(passwordController.text);
      print(selectedDept);
      final signupData = SignUpReq(
        staffName: agentnameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        department: selectedDept,
      );

      print(signupData);
      AuthRes? res = await api.signupStaff(signupData);
      //AuthRes? res = await api.login(loginData);
      print("Signup mid.......");
      if (res != null) {
        authStorage.write('accessToken', res.accessToken);
        authStorage.write('refreshToken', res.refreshToken);
        authStorage.write('staffId', res.staffId);
        authStorage.write('staffName', res.staffName);
        authStorage.write('department', selectedDept);
      }

      Get.snackbar(
        'Success',
        'Signup completed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      Get.to(() => DesktopLayout());
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Signup failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isSigningUp = false;
      update();
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#\$&*~]').hasMatch(value);

    if (!hasUpper) return 'Password must contain at least one uppercase letter';
    if (!hasLower) return 'Password must contain at least one lowercase letter';
    if (!hasDigit) return 'Password must contain at least one number';
    if (!hasSpecial) {
      return 'Password must contain at least one special character (!@#\$&*~)';
    }
    return null;
  }
}
