import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:tadreebkomapplication/controller/auth/timercontroller.dart';
import 'package:tadreebkomapplication/controller/centercontroller/verifycodeaddinstructor.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/core/functions/alertexitappverifycode.dart';
import 'package:tadreebkomapplication/view/widget/auth/textsignup.dart';

class VerifyCenterCodeSignUp extends StatelessWidget {
  const VerifyCenterCodeSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final VerifyCodeCenterControllerAddImp controller = Get.put(
      VerifyCodeCenterControllerAddImp(),
    );
    final TimerController timerController = Get.put(TimerController());

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
            final shouldPop = await alertExitAppVerifyUser();
            if (shouldPop) {
              Get.back(); // Pop manually if confirmed
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Enter OTP Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              const Text(
                "We have sent a 4-digit code to your email. Please enter it below.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),

              OtpTextField(
                focusedBorderColor: Colors.orange,
                enabledBorderColor: Colors.black,
                fieldWidth: 60.0,
                borderRadius: BorderRadius.circular(15),
                numberOfFields: 4,
                borderColor: Colors.brown,
                showFieldAsBox: true,
                onSubmit: (String verificationCode) {
                  controller.checkCode(verificationCode);
                },
              ),

              const SizedBox(height: 20),

              // Resend OTP Button with Timer
              Obx(
                () => TextButton(
                  onPressed:
                      timerController.canResend.value
                          ? () {
                            controller.instructorCtrl.sendOtpToCenter();
                            timerController
                                .startResendTimer(); // Restart the timer
                          }
                          : null,
                  child: Text(
                    timerController.canResend.value
                        ? "Resend OTP"
                        : "Resend in ${timerController.resendTimer.value}s",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          timerController.canResend.value
                              ? Colors.orange[500]
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7),
              CustomTextSignupOrSignin(
                textone: "Get back to ",
                texttwo: "Add Instructor",
                onTap: () {
                  Get.offAllNamed(AppRoute.centerhomepage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
