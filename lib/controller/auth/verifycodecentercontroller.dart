import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tadreebkomapplication/controller/auth/centerlocationcontroller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class VerifyCodeCenterController extends GetxController {
  checkCode(String enteredOtp);
  goToSuccessSignup();
}

class VerifyCodeCenterControllerImp extends VerifyCodeCenterController {
  int numberoftimeserrorcode = 0;
  String? storedOtp;
  final CenterLocationControllerImp centerLocationController = Get.put(
    CenterLocationControllerImp(),
  );

  @override
  checkCode(String enteredOtp) async {
    User? user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;
    final box = GetStorage();
    String? storedOtp = box.read("center_otp"); // ✅ Read the OTP
    if (enteredOtp.trim() == storedOtp!.trim()) {
      try {
        // ✅ Add emailVerified without overwriting other data
        await FirebaseFirestore.instance.collection("centers").doc(userId).set(
          {"emailVerified": true},
          SetOptions(merge: true), // ✅ Ensures existing data is not removed
        );

        Get.snackbar("Success", "OTP Verified Successfully");
        goToSuccessSignup();
      } catch (e) {
        Get.snackbar("Error", "Failed to update verification status.");
      }
    } else {
      numberoftimeserrorcode++;

      if (numberoftimeserrorcode > 6) {
        await FirebaseFirestore.instance
            .collection("centers")
            .doc(userId)
            .delete();
        await FirebaseAuth.instance.currentUser!.delete(); //make this..
      }

      Get.snackbar("Error", "Invalid OTP. Please try again.");
    }
  }

  @override
  goToSuccessSignup() {
    Get.offNamed(AppRoute.successSignup);
  }

  @override
  void dispose() {
    centerLocationController.dispose();
    super.dispose();
  }
}
