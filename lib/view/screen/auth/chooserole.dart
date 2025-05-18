import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:tadreebkomapplication/controller/auth/rolecontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/imagesasset.dart';
import 'package:tadreebkomapplication/view/widget/auth/customrolebuttonauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/cutomtitleauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/textsignup.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({super.key});

  @override
  Widget build(BuildContext context) {
    RoleControllerImp controller = Get.put(RoleControllerImp());
    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            Image.asset(ImagesAsset.signinImage),
            const SizedBox(height: 100),
            CustomTitleAuth(title: "I am A"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomRoleButtonAuth(
                      imageName: ImagesAsset.drivinglicense,
                      iocn: Icons.keyboard_arrow_right_outlined,
                      text: "Student",
                      onPressed: () {
                        controller.goToStudentSignUP();
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomRoleButtonAuth(
                      imageName: ImagesAsset.drivingSchool,
                      iocn: Icons.keyboard_arrow_right_outlined,
                      text: "School",
                      onPressed: () {
                        controller.goToSchoolSignUp();
                      },
                    ),
                    SizedBox(height: 60),
                    CustomTextSignupOrSignin(
                      textone: "Alraedy have an account?",
                      texttwo: "Sign in",
                      onTap: () {
                        controller.goTOsignIn();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
