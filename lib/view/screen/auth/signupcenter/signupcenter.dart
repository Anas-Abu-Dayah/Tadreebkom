import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/auth/signupcentercontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/core/functions/validateinput.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/customtextformauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/cutomtitleauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/textsignup.dart';

class SignUpCenter extends StatelessWidget {
  const SignUpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignupCenterControllerImp());
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

        child: GetBuilder<SignupCenterControllerImp>(
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
                        hinttext: "Enter Driving Center name",
                        labeltext: "Centername",
                        icondata: Icons.person_2_outlined,
                        mycontroller: controller.drivingCenterName,
                        valid: (val) {
                          return validateInput(val!, 3, 20, "username");
                        },
                      ),

                      CustomTextFormAuth(
                        isNumber: true,
                        hinttext: "Enter your phone number",
                        labeltext: "Phonenumber",
                        icondata: Icons.phone,
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
                          return validateInput(val!, 5, 80, "email");
                        },
                      ),
                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: "Enter your password",
                        labeltext: "Password",
                        icondata: Icons.lock_outline,
                        mycontroller: controller.password,
                        valid: (val) {
                          return validateInput(val!, 8, 20, "password");
                        },
                      ),
                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: "Confirm password",
                        labeltext: "password",
                        icondata: Icons.lock_outline,
                        mycontroller: controller.confirmpassword,
                        valid: (val) {
                          return validateInput(val!, 8, 20, "password");
                        },
                      ),
                      CustomTextFormAuth(
                        isNumber: false,
                        hinttext: controller.hinttext,
                        labeltext: "License",
                        readonly: true,
                        onTapIon: () {
                          controller.pickImage();
                        },
                        icondata: Icons.add_a_photo_outlined,
                        mycontroller: controller.license,
                        valid: (val) {
                          val = controller.hinttext;
                          return validateInput(val, 0, 100000, "License");
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomButtonAuth(
                        text: "Sign up",
                        onPressed: () {
                          controller.signUpCenter();
                        },
                      ),

                      const SizedBox(height: 25),
                      CustomTextSignupOrSignin(
                        textone: "Already have account ?",
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
