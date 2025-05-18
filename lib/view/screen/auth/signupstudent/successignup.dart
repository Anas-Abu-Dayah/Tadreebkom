import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/auth/successsignupcontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/cutomtitleauth.dart';

class SuccessSignUp extends StatelessWidget {
  const SuccessSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    SuccessSignUpdControllerImp controller = Get.put(
      SuccessSignUpdControllerImp(),
    );
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
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Icon(
                  Icons.check_circle_outline_outlined,
                  size: 200,
                  color: Colors.orange,
                  weight: 10.0,
                ),
              ),
              const SizedBox(height: 15),
              const CustomTitleAuth(title: "Succefully Created"),

              const Text("Your account has been created successfully"),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: CustomButtonAuth(
                  text: "Go to Login",
                  onPressed: () {
                    controller.goToLoginPage();
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
