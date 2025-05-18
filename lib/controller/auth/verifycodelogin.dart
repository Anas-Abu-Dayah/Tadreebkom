import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:tadreebkomapplication/controller/auth/logincontroller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class VerifyCodeLoginController extends GetxController {
  Future<void> checkCode(String enteredOtp);
  void goToHomePage();
}

class VerifyCodeLoginControllerImp extends VerifyCodeLoginController {
  int numberOfErrors = 0;
  final box = GetStorage();
  final LoginControllerImplement loginController =
      Get.find<LoginControllerImplement>();
  var isLoading = false.obs;

  @override
  Future<void> checkCode(String enteredOtp) async {
    String? storedOtp = box.read("otpCode");
    if (enteredOtp != storedOtp) {
      numberOfErrors++;
      if (numberOfErrors > 5) {
        Get.offAllNamed(AppRoute.login);
      }
      Get.snackbar("Error", "Invalid OTP. Please try again.");
      return;
    }

    isLoading.value = true;
    showLoadingDialog();

    // determine role and verification status
    final role = await _getUserRole();
    isLoading.value = false;
    Get.back(); // dismiss loading dialog

    if (role != null) {
      switch (role) {
        case 'admin':
          Get.offAllNamed(AppRoute.adminPendingCentersView);
          break;
        case 'center':
          Get.offAllNamed(AppRoute.centerhomepage);
          break;
        case 'instructor':
          Get.offAllNamed(AppRoute.instructorNavBarView);
          break;
        case 'user':
        default:
          Get.offAllNamed(AppRoute.home);
      }
    } else {
      Get.snackbar("Error", "Your email is not verified or not registered.");
    }
  }

  /// Checks Firestore for the user’s document in each collection,
  /// returns the role if found & emailVerified is true.
  Future<String?> _getUserRole() async {
    final userEmail = box.read("userEmail") as String?;
    if (userEmail == null) return null;

    try {
      // 1️⃣ Admin
      final adminSnap =
          await FirebaseFirestore.instance
              .collection("Admin")
              .where("email", isEqualTo: userEmail)
              .limit(1)
              .get();
      if (adminSnap.docs.isNotEmpty &&
          (adminSnap.docs.first.data()['EmailVerified'] ?? false)) {
        return 'admin';
      }

      // 2️⃣ Center
      final centerSnap =
          await FirebaseFirestore.instance
              .collection("centers")
              .where("email", isEqualTo: userEmail)
              .limit(1)
              .get();
      if (centerSnap.docs.isNotEmpty &&
          (centerSnap.docs.first.data()['emailVerified'] ?? false)) {
        return 'center';
      }

      // 3️⃣ Instructor
      final instrSnap =
          await FirebaseFirestore.instance
              .collection("instructors")
              .where("email", isEqualTo: userEmail)
              .limit(1)
              .get();
      if (instrSnap.docs.isNotEmpty &&
          (instrSnap.docs.first.data()['emailVerified'] ?? false)) {
        return 'instructor';
      }

      // 4️⃣ Regular user
      final userSnap =
          await FirebaseFirestore.instance
              .collection("users")
              .where("email", isEqualTo: userEmail)
              .limit(1)
              .get();
      if (userSnap.docs.isNotEmpty &&
          (userSnap.docs.first.data()['emailVerified'] ?? false)) {
        return 'user';
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to check user role: $e");
    }

    return null;
  }

  /// Displays a blocking progress indicator
  void showLoadingDialog() {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  @override
  void goToHomePage() {
    Get.offAllNamed(AppRoute.home);
  }
}
