import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticksy_web/Controllers/LoginController.dart';
import 'package:ticksy_web/Screens/SignupScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextScaler textScale = MediaQuery.of(context).textScaler;
    return GetBuilder(
      init: LoginController(),
      builder: (LoginController lgController) {
        return Scaffold(
          body: Row(
            children: [
              Container(
                width: Get.width / 1.78,
                child: Image.asset(
                  'assets/images/authbg1.jpg',
                  fit: BoxFit.fill, // keeps aspect ratio
                ),
              ),
              SizedBox(width: 60),
              Container(
                child: Form(
                  key: lgController.loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height / 50),
                      Text(
                        "Agent\nLogin",
                        style: GoogleFonts.alexandria(
                          color: Colors.blue,
                          fontSize: textScale.scale(75),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      Container(
                        child: SizedBox(
                          width: Get.width / 2.86,
                          child: TextFormField(
                            style: GoogleFonts.alata(
                              fontSize: textScale.scale(18),
                              fontWeight: FontWeight.w200,
                            ),

                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: Icon(Icons.email),
                              hintText: 'Enter Email',
                              hintStyle: GoogleFonts.alata(
                                fontSize: textScale.scale(18),
                                fontWeight: FontWeight.w200,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ), // when focused
                              ),
                            ),
                            controller: lgController.emailController,
                            validator: (value) =>
                                lgController.validateEmail(value),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height / 25.71),
                      Container(
                        child: SizedBox(
                          width: Get.width / 2.86,
                          child: TextFormField(
                            style: GoogleFonts.alata(
                              fontSize: textScale.scale(18),
                              fontWeight: FontWeight.w200,
                            ),
                            obscureText: lgController.isPasswordHidden,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  lgController.isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  lgController.isPasswordHidden =
                                      !lgController.isPasswordHidden;
                                  lgController.update();
                                },
                              ),
                              hintText: 'Enter Password',
                              hintStyle: GoogleFonts.alata(
                                fontSize: textScale.scale(18),
                                fontWeight: FontWeight.w200,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ), // when focused
                              ),
                            ),
                            controller: lgController.passwordController,
                            validator: (value) =>
                                lgController.validatePassword(value),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height / 25.71),
                      Container(
                        width: Get.width / 2.86,
                        height: Get.height / 12.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownFlutter(
                          hintText: "Select Department",
                          items: lgController.deptList,
                          onChanged: (val) {
                            lgController.selectedDept = val!;
                          },
                        ),
                      ),
                      SizedBox(height: Get.height / 25.71),
                      Container(
                        width: Get.width / 2.86,
                        height: Get.height / 12.55,
                        child: ElevatedButton(
                          onPressed: () {
                            lgController.login();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: lgController.isLoggingIn
                              ? CircularProgressIndicator()
                              : Text(
                                  'Log In',
                                  style: GoogleFonts.alata(
                                    fontSize: textScale.scale(18),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: Get.height / 25.71),
                      Text(
                        'if you don’t an account you can',
                        style: GoogleFonts.alata(
                          fontSize: textScale.scale(17),
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Handle register tap
                          Get.to(() => SignupScreen());
                        },
                        child: Text(
                          'Register Here!',
                          style: GoogleFonts.alata(
                            fontSize: textScale.scale(17),
                            fontWeight: FontWeight.w200,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
