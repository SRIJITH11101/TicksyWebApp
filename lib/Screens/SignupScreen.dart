import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticksy_web/Controllers/SignupController.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    TextScaler textScale = MediaQuery.of(context).textScaler;
    return GetBuilder(
      init: SignupController(),
      builder: (SignupController sgController) {
        return Scaffold(
          body: Row(
            children: [
              Container(
                width: Get.width / 1.78,
                child: Image.asset(
                  'assets/images/authbg1.jpg',
                  fit: BoxFit.contain, // keeps aspect ratio
                ),
              ),
              Container(
                child: Form(
                  key: sgController.signUpKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(height: Get.height / 50),
                      Text(
                        "Agent\nRegister",
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
                            //key: spController.formUsrKey,
                            style: GoogleFonts.alata(
                              fontSize: textScale.scale(18),
                              fontWeight: FontWeight.w200,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: Icon(Icons.person),
                              hintText: 'Enter Username',
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
                            controller: sgController.agentnameController,
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
                            controller: sgController.emailController,
                            validator: (value) =>
                                sgController.validateEmail(value),
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
                            obscureText: sgController.isPasswordHidden,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  sgController.isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  sgController.isPasswordHidden =
                                      !sgController.isPasswordHidden;
                                  sgController.update();
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
                            controller: sgController.passwordController,
                            validator: (value) =>
                                sgController.validatePassword(value),
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
                          items: sgController.deptList,
                          onChanged: (val) {
                            sgController.selectedDept = val!;
                          },
                        ),
                      ),
                      SizedBox(height: Get.height / 25.71),
                      Container(
                        width: Get.width / 2.86,
                        height: Get.height / 12.55,
                        child: ElevatedButton(
                          onPressed: () {
                            sgController.signup();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: sgController.isSigningUp
                              ? CircularProgressIndicator()
                              : Text(
                                  'Sign up',
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
                        'Already have an account you can',
                        style: GoogleFonts.alata(
                          fontSize: textScale.scale(17),
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Handle register tap
                          Get.back();
                        },
                        child: Text(
                          'Login Here!',
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
