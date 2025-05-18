// lib/controller/usercontroller/student_feedback_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentFeedbackController extends GetxController {
  late String studentId;
  final feedbackText = TextEditingController();
  final rating = 0.obs;
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Must be called from the View’s build method:
  void init(String id) {
    studentId = id;
  }

  void setRating(int r) => rating.value = r;

  Future<void> submit() async {
    if (rating.value == 0 || feedbackText.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a rating and enter a comment.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar(
        'Error',
        'You must be signed in as an instructor.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _db
          .collection('users') // your students are in "users"
          .doc(studentId)
          .collection('instructorFeedback') // sub-coll for instructor’s notes
          .add({
            'instructorId': user.uid,
            'rating': rating.value,
            'comment': feedbackText.text.trim(),
            'timestamp': FieldValue.serverTimestamp(),
          });

      Get.snackbar(
        'Thank you!',
        'Your feedback was submitted.',
        backgroundColor: Colors.green.withAlpha((0.1 * 255).round()),
        colorText: Colors.green,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        snackPosition: SnackPosition.BOTTOM,
      );

      Future.delayed(const Duration(seconds: 1), () => Get.back());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit feedback: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    feedbackText.dispose();
    super.onClose();
  }
}
