import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:tadreebkomapplication/controller/auth/signupcontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/core/functions/validateinput.dart';
import 'package:tadreebkomapplication/view/widget/auth/custom_icon_auth.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/customgenderbutton.dart';
import 'package:tadreebkomapplication/view/widget/auth/customtextformauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/customtextformdatepicker.dart';
import 'package:tadreebkomapplication/view/widget/auth/cutomtitleauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/textsignup.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignupcontrollerImp());
    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
        elevation: 0.0,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final shouldPop = await alertExitApp();
            if (shouldPop) {
              Get.back(); // Pop manually if confirmed
            }
          }
        },
        child: GetBuilder<SignupcontrollerImp>(
          builder:
              (controller) => Container(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: controller.formstate,
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      CustomTitleAuth(title: "Sign Up"),
                      const SizedBox(height: 10),

                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: "Enter your Fullname",
                        labeltext: "Fullname",
                        icondata: Icons.person_2_outlined,
                        mycontroller: controller.username,
                        valid: (val) {
                          return validateInput(val!, 5, 70, "username");
                        },
                      ),
                      CustomTextFormBirthdateAuth(
                        hinttext: "Enter your birthdate",
                        labeltext: "Birthdate",
                        mycontroller: controller.bdate,
                        icondata: Icons.calendar_today,
                        valid: (val) {
                          return validateInput(val!, 5, 70, "birthdate");
                        },
                        isNumber: false,
                        onChange: (val) {
                          controller.bdate.text = val;
                        },
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 30),
                        child: Text("Gender:"),
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 60),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Wrap(
                            children: [
                              CustomGenderButton(
                                onGenderSelected: (selectedGender) {
                                  controller.gender = selectedGender;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      CustomTextFormAuth(
                        isNumber: true,
                        hinttext: "Enter your phone number",
                        labeltext: "Phonenumber",
                        icondata: Icons.person_2_outlined,
                        mycontroller: controller.phone,
                        valid: (val) {
                          return validateInput(val!, 10, 13, "phone");
                        },
                      ),
                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: "Enter your Email",
                        labeltext: "Email",
                        icondata: Icons.email_outlined,
                        mycontroller: controller.email,
                        valid: (val) {
                          return validateInput(val!, 5, 50, "email");
                        },
                      ),
                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: "Enter your password",
                        labeltext: "Password",
                        icondata: Icons.lock_outline,
                        mycontroller: controller.password,
                        valid: (val) {
                          return validateInput(val!, 8, 50, "password");
                        },
                      ),
                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: "Confirm password",
                        labeltext: "Password",
                        icondata: Icons.lock_outline,
                        mycontroller: controller.confirmpassword,
                        valid: (val) {
                          return validateInput(val!, 8, 50, "password");
                        },
                      ),

                      CustomButtonAuth(
                        text: "Sign up",
                        onPressed: () {
                          controller.signUp();
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "━━",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            " Sign up with social accounts ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "━━",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconAuth(
                            iconWidget: FontAwesomeIcons.facebook,
                            onPressed: () {
                              controller.signInWithFacebook();
                            },
                          ),
                          CustomIconAuth(
                            iconWidget: FontAwesomeIcons.google,
                            onPressed: () {
                              controller.signInWithGoogle();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextSignupOrSignin(
                        textone: "Already have aaccount ?",
                        texttwo: "Sign in",
                        onTap: () {
                          controller.goToSignIn();
                        },
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
