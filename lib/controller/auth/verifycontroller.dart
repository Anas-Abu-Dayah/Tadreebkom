import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class VerifyCodeController extends GetxController {
  checkCode(String enteredOtp);
}

class VerifyCodeControllerImp extends VerifyCodeController {
  late String sentOtp;
  late String email;

  @override
  void onInit() {
    sentOtp = Get.arguments["otp"];
    email = Get.arguments["email"];
    super.onInit();
  }

  @override
  Future<void> checkCode(String enteredOtp) async {
    if (enteredOtp == sentOtp) {
      try {
        // Sign in the user anonymously to allow password reset
        await FirebaseAuth.instance.signInAnonymously();

        // Navigate to the reset password screen
        Get.offNamed(AppRoute.resetpassword, arguments: {"email": email});
      } catch (e) {
        Get.snackbar("Error", "Authentication failed: $e");
      }
    } else {
      Get.snackbar("Error", "Invalid OTP. Please try again.");
    }
  }
}
