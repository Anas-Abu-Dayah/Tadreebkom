import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/auth/successresetpassswordcontroller.dart';
import 'package:tadreebkomapplication/controller/auth/timercontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/imagesasset.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/cutomtitleauth.dart';

class SuccessResetPassword extends StatelessWidget {
  const SuccessResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    SuccessResetPasswordControllerImp controller = Get.put(
      SuccessResetPasswordControllerImp(),
    );
    TimerController timerController = Get.put(TimerController());

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(ImagesAsset.resetpassword),
              const SizedBox(height: 20),
              const CustomTitleAuth(title: "Password Reset Email Sent"),
              const SizedBox(height: 10),

              /// 🔹 Wrap in `Obx` to make it reactive
              Obx(
                () => Text(
                  controller.userEmail.value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Your Account Security is Our Priority; We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected",
                style: TextStyle(
                  color: Color.fromARGB(255, 128, 127, 127),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: 400,
                child: CustomButtonAuth(
                  text: "Done",
                  onPressed: () {
                    controller.goToLoginPage();
                  },
                ),
              ),
              const SizedBox(height: 10),

              Obx(
                () => TextButton(
                  onPressed:
                      timerController.canResend.value
                          ? () {
                            FirebaseAuth.instance.sendPasswordResetEmail(
                              email: controller.userEmail.toString(),
                            );
                            timerController
                                .startResendTimer(); // Restart the timer
                          }
                          : null,
                  child: Text(
                    timerController.canResend.value
                        ? "Resend Email"
                        : "Resend in ${timerController.resendTimer.value} sec",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color:
                          timerController.canResend.value
                              ? Colors.orange[500]
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
