import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class ResetPasswordController extends GetxController {
  resetPassword();
}

class ResetPasswordControllerImp extends ResetPasswordController {
  late TextEditingController password;
  late TextEditingController confirmPassword;
  late String email;

  @override
  void onInit() {
    password = TextEditingController();
    confirmPassword = TextEditingController();
    email = Get.arguments["email"];
    super.onInit();
  }

  @override
  Future<void> resetPassword() async {
    if (password.text != confirmPassword.text) {
      Get.snackbar("Error", "Passwords do not match.");
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "No authenticated session found.");
        return;
      }

      await user.updatePassword(password.text);
      Get.offNamed(AppRoute.successresetpassword);
    } catch (e) {
      Get.snackbar("Error", "Failed to reset password: $e");
    }
  }

  @override
  void dispose() {
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
}
