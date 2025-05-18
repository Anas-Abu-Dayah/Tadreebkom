// lib/controller/usercontroller/feedback_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

class FeedbackController extends GetxController {
  late String instructorId;
  final feedbackText = TextEditingController();
  final rating = 0.obs;
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Call this from your View’s build
  void init(String id) {
    instructorId = id;
  }

  void setRating(int r) => rating.value = r;

  Future<void> submit() async {
    // simple validation
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
        'You must be signed in to submit feedback.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // write into instructors/{instructorId}/studentFeedback
      await _db
          .collection('instructors')
          .doc(instructorId)
          .collection('studentFeedback')
          .add({
            'studentId': user.uid,
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
      Get.offAllNamed(AppRoute.home);

      // pop back after a short delay
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
