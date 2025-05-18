import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/centercontroller/addinstructorpagecontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/core/functions/validateinput.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/customgenderbutton.dart';
import 'package:tadreebkomapplication/view/widget/auth/customtextformauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/customtextformdatepicker.dart';
import 'package:tadreebkomapplication/view/widget/auth/cutomtitleauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/textsignup.dart';

class Addinstructorsignup extends StatelessWidget {
  const Addinstructorsignup({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AddInstructorPageControllerImp());
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
        child: GetBuilder<AddInstructorPageControllerImp>(
          builder:
              (controller) => Container(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: controller.formState,
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      CustomTitleAuth(title: "Add Instructor"),
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

                      CustomButtonAuth(
                        text: "Add Instructor",
                        onPressed: () {
                          controller.signUp();
                        },
                      ),

                      CustomButtonAuth(
                        text: "Finish & Send OTP",
                        onPressed: () {
                          controller.sendOtpToCenter();
                        },
                      ),

                      SizedBox(height: 10),

                      CustomTextSignupOrSignin(
                        textone: "Go Back To",
                        texttwo: "HomePage",
                        onTap: () {
                          Get.offAllNamed(AppRoute.centerprofilepage);
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
