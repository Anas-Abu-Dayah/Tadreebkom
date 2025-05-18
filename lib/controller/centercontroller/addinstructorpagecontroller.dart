import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tadreebkomapplication/core/functions/generaterandompassword.dart';
import 'package:tadreebkomapplication/core/functions/sendotp.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class AddInstructorPageController extends GetxController {
  Future<void> signUp();
  Future<void> sendOtpToCenter();
  void goToSignIn();
}

class AddInstructorPageControllerImp extends AddInstructorPageController {
  final formState = GlobalKey<FormState>();
  late TextEditingController email, phone, username, password, bdate;
  String? gender;
  String otpCode = "";
  String? centerEmail;
  String? centerId;

  final isLoading = false.obs;

  /// ➊ In‐memory queue of all the instructors the center has “added”
  final pendingInstructors = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    email = TextEditingController();
    phone = TextEditingController();
    username = TextEditingController();
    password = TextEditingController();
    bdate = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    phone.dispose();
    username.dispose();
    password.dispose();
    bdate.dispose();
    super.dispose();
  }

  /// Generate 7 days × hours 9–18 availability
  Future<List<Map<String, dynamic>>> generateAvailability({
    int hoursStart = 9,
    int hoursEnd = 18,
    int monthsAhead = 3,
  }) async {
    final List<Map<String, dynamic>> availability = [];
    final DateTime today = DateTime.now();
    // Dart will roll years/months correctly if month > 12
    final DateTime endDate = DateTime(
      today.year,
      today.month + monthsAhead,
      today.day,
    );

    final hours = List<int>.generate(
      hoursEnd - hoursStart + 1,
      (i) => hoursStart + i,
    );

    for (
      DateTime date = today;
      date.isBefore(endDate);
      date = date.add(const Duration(days: 1))
    ) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final times =
          hours.map((hour) {
            final slot = DateTime(date.year, date.month, date.day, hour);
            final label = DateFormat.jm('en_US').format(slot);
            return {'time': label, 'available': true};
          }).toList();

      availability.add({'date': formattedDate, 'times': times});
    }

    return availability;
  }

  @override
  Future<void> signUp() async {
    // ➋ Instead of immediately creating, _validate_ and queue
    final form = formState.currentState;
    if (form == null || !form.validate()) return;

    final generatedPassword = generateRandomPassword();
    final availability = await generateAvailability();

    pendingInstructors.add({
      'email': email.text.trim(),
      'username': username.text.trim(),
      'phone': phone.text.trim(),
      'bdate': bdate.text.trim(),
      'gender': gender,
      'password': generatedPassword,
      'availability': availability,
    });

    // clear form for next instructor
    username.clear();
    email.clear();
    phone.clear();
    bdate.clear();
    gender = null;

    Get.snackbar('Queued', 'Instructor added to the pending list');
  }

  @override
  Future<void> sendOtpToCenter() async {
    // ➌ only send OTP if we have at least one pending
    if (pendingInstructors.isEmpty) {
      Get.snackbar('Error', 'No instructors to confirm.');
      return;
    }

    isLoading.value = true;
    try {
      // original logic below
      centerEmail = await _getCenterEmail();
      if (centerEmail == null) {
        Get.snackbar("Error", "Center email not found.");
        return;
      }
      otpCode = _generateOtp();
      await sendOtpWithSendGrid(centerEmail!, otpCode);
      storage.write("otp_code", otpCode);
      // navigate to your verify‐OTP page
      Get.toNamed(AppRoute.verifycodecenterpage);
    } catch (e) {
      Get.snackbar("Error", "Failed to send verification code: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _getCenterEmail() async {
    centerId = _auth.currentUser?.uid ?? storage.read("centerId");
    if (centerId == null) {
      Get.snackbar("Error", "Center not authenticated.");
      return null;
    }
    final doc = await _firestore.collection('centers').doc(centerId).get();
    if (!doc.exists) {
      Get.snackbar("Error", "Center document not found.");
      return null;
    }
    return (doc.data()!)['email'] as String?;
  }

  String _generateOtp() {
    final rand = Random();
    return (1000 + rand.nextInt(9000)).toString();
  }

  @override
  void goToSignIn() {
    Get.offAllNamed(AppRoute.centerhomepage);
  }
}
