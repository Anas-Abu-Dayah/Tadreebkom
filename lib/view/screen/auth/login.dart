import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/auth/logincontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/imagesasset.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/core/functions/validateinput.dart';
import 'package:tadreebkomapplication/view/widget/auth/custom_icon_auth.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/customtextformauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/cutomtitleauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/textsignup.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginControllerImplement());
    return GetBuilder<LoginControllerImplement>(
      builder:
          (controller) => Scaffold(
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
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: controller.formstate,
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      CustomTitleAuth(title: "Log in"),
                      const SizedBox(height: 10),
                      Image.asset(ImagesAsset.roleImage),
                      const SizedBox(height: 60),
                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: "Enter your Email",
                        labeltext: "Email",
                        icondata: Icons.person_2_outlined,
                        mycontroller: controller.email,
                        valid: (val) {
                          return validateInput(val!, 5, 70, "email");
                        },
                      ),
                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: "Enter your password",
                        labeltext: "Password",
                        icondata: Icons.remove_red_eye_outlined,
                        onTapIon: () {
                          controller.showPassword();
                        },
                        obscureText: controller.isShowPassword,
                        mycontroller: controller.password,
                        valid: (val) {
                          return validateInput(val!, 8, 50, "password");
                        },
                      ),
                      InkWell(
                        onTap: () {
                          controller.goToForgetPassword();
                        },
                        child: const Text(
                          "Forget Password",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      CustomButtonAuth(
                        text: "Log in",
                        onPressed: () {
                          controller.login();
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
                            " Login with social accounts ",
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
                            onPressed: () {},
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
                        textone: "Don't have an account ?",
                        texttwo: "Sign Up",
                        onTap: () {
                          controller.goToRole();
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

// tasks to do..
// try make the google maps pages or addresses or wait to the design
// make success page for the messing pages and if you want make otp pages and add the text
// finish the sign up page for the driving center
// make the password to show and hide 
// make application when you want to go out give you a message.