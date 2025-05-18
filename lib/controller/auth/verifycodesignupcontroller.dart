import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/auth/studentlocationcontroller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class VerifyCodeSignUPController extends GetxController {
  checkCode(String enteredOtp);
  goToSuccessSIgnup();
}

class VerifyCodeSignUpControllerImp extends VerifyCodeSignUPController {
  int numberoftimeserrorcode = 0;
  User? user;
  var userid;

  final StudentLocationControllerImp studentLocationControllerImp = Get.put(
    StudentLocationControllerImp(),
  );

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    userid = user!.uid;
    super.onInit();
  }

  @override
  checkCode(String enteredOtp) async {
    if (enteredOtp == studentLocationControllerImp.otpCode) {
      try {
        // ✅ Add emailVerified field without overwriting other data
        await FirebaseFirestore.instance.collection("users").doc(userid).set({
          "emailVerified": true,
        }, SetOptions(merge: true));

        Get.snackbar("Success", "OTP Verified Successfully");
        goToSuccessSIgnup();
      } catch (e) {
        Get.snackbar("Error", "Failed to update verification status.");
      }
    } else {
      numberoftimeserrorcode++;

      if (numberoftimeserrorcode > 6) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userid)
            .delete();
        await FirebaseAuth.instance.currentUser!.delete();
      }

      Get.snackbar("Error", "Invalid OTP. Please try again.");
    }
  }

  @override
  goToSuccessSIgnup() {
    Get.toNamed(AppRoute.successSignup);
  }

  @override
  void dispose() {
    studentLocationControllerImp.dispose();
    super.dispose();
  }
}
