// lib/controller/centercontroller/verifycodecentercontroller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'addinstructorpagecontroller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class VerifyCodeCenterController extends GetxController {
  Future<void> checkCode(String enteredOtp);
  void goToSuccessSignup();
}

class VerifyCodeCenterControllerAddImp extends VerifyCodeCenterController {
  /// Grab the same instance of AddInstructorPageControllerImp
  final AddInstructorPageControllerImp instructorCtrl = Get.find();

  final GetStorage _storage = GetStorage();
  String? _savedOtp;

  @override
  void onInit() {
    super.onInit();
    _savedOtp = _storage.read<String>('otp_code');
  }

  @override
  Future<void> checkCode(String enteredOtp) async {
    if (_savedOtp == null) {
      Get.snackbar('Error', 'No OTP in storage. Please resend.');
      return;
    }

    if (enteredOtp != _savedOtp) {
      Get.snackbar('Error', 'Invalid OTP. Please try again.');
      return;
    }

    // ✅ OTP matches → create all pending instructors
    try {
      // Loop through each pending instructor data
      for (final data in instructorCtrl.pendingInstructors) {
        // 1) Initialize (or reuse) a secondary Firebase app
        FirebaseApp secondaryApp;
        try {
          secondaryApp = await Firebase.initializeApp(
            name: 'SecondaryApp',
            options: Firebase.app().options,
          );
        } catch (_) {
          secondaryApp = Firebase.app('SecondaryApp');
        }
        final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

        // 2) Create the Auth user
        final cred = await secondaryAuth.createUserWithEmailAndPassword(
          email: data['email'] as String,
          password: data['password'] as String,
        );
        final instrId = cred.user!.uid;

        // 3) Write the instructor document
        await FirebaseFirestore.instance
            .collection('instructors')
            .doc(instrId)
            .set({
              'email': data['email'],
              'centerId': instructorCtrl.centerId,
              'username': data['username'],
              'phone': data['phone'],
              'bdate': data['bdate'],
              'gender': data['gender'],
              'createdAt': FieldValue.serverTimestamp(),
              'emailVerified': true, // because center has verified via OTP
              'uid': instrId,
              'availability': data['availability'],
            });

        // 4) Clean up the secondary app
        await secondaryAuth.signOut();
        await secondaryApp.delete();
      }

      // 5) Clear the pending queue
      instructorCtrl.pendingInstructors.clear();

      Get.snackbar('Success', 'All instructors added successfully!');
      goToSuccessSignup();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create instructors: $e');
    }
  }

  @override
  void goToSuccessSignup() {
    Get.offAllNamed(AppRoute.instructorsuccesspage);
  }
}
