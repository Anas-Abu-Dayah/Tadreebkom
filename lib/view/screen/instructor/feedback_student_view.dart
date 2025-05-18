// lib/view/screen/instructor/student_feedback_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tadreebkomapplication/controller/instructorcontroller/student_feedback_controller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/imagesasset.dart';

class InstructorFeedbackView extends StatelessWidget {
  final String studentId;
  const InstructorFeedbackView({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(StudentFeedbackController());
    ctrl.init(studentId);

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.orange),
          onPressed: () => Get.back(),
        ),
        title: const Text('Feedback for Student'),
        backgroundColor: AppColor.pagePrimaryColor,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Lesson completed!\nHow would you rate your student?',
                style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.4),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  ImagesAsset.amico1,
                  height: 180,
                  fit: BoxFit.contain,
                ).animate().scale(duration: 500.ms, curve: Curves.easeOut),
              ),

              const SizedBox(height: 24),
              const Text(
                'Your Feedback',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

              const SizedBox(height: 8),
              TextField(
                controller: ctrl.feedbackText,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your comments here...',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

              const SizedBox(height: 16),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < ctrl.rating.value;
                    return IconButton(
                      icon: Icon(
                        filled ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 36,
                      ),
                      onPressed: () => ctrl.setRating(i + 1),
                    );
                  }),
                );
              }).animate().fadeIn(delay: 400.ms, duration: 500.ms),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: ctrl.submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF06543), Color(0xFFFFBE3D)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withAlpha((0.4 * 255).round()),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().scale(
                delay: 500.ms,
                duration: 500.ms,
                curve: Curves.bounceOut,
              ),

              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.snackbar(
                      'Contact Us',
                      'This feature isn’t implemented yet.',
                      backgroundColor: Colors.orange.withAlpha(
                        (0.1 * 255).round(),
                      ),

                      colorText: Colors.orange,
                      icon: const Icon(Icons.email, color: Colors.orange),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text(
                    'ANY PROBLEM? CONTACT US',
                    style: TextStyle(
                      color: Colors.orange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
