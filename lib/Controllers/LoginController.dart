import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ticksy_web/ApiCalls/ApiRequests.dart';
import 'package:ticksy_web/Models/AuthRes.dart';
import 'package:ticksy_web/Models/LoginReq.dart';
import 'package:ticksy_web/Screens/DesktopLayout.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final api = ApiRequests();
  bool isPasswordHidden = true;
  bool isLoggingIn = false;
  final loginKey = GlobalKey<FormState>();
  final authStorage = GetStorage();
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

  Future<void> login() async {
    if (!loginKey.currentState!.validate()) return;

    if (selectedDept.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select your department',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoggingIn = true;
      update();

      final loginData = LoginReq(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        department: selectedDept,
      );

      print(
        '${loginData.email} .... ${loginData.password} .... ${loginData.department}',
      );

      AuthRes? res = await api.loginStaff(loginData);

      if (res != null) {
        authStorage.write('accessToken', res.accessToken ?? '');
        authStorage.write('refreshToken', res.refreshToken ?? '');
        authStorage.write('staffId', res.staffId ?? '');
        authStorage.write('staffName', res.staffName ?? '');
        authStorage.write('department', selectedDept ?? '');
      } else {
        Get.snackbar(
          'Error',
          'Login failed: Invalid response from server',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      Get.to(() => DesktopLayout());
    } catch (e) {
      print('Login Exception: $e');
      Get.snackbar(
        'Error',
        'Login failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoggingIn = false;
      update();
    }
  }
}
