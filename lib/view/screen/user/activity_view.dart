// lib/view/screen/user/activity_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/activitycontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/view/screen/user/feedback_view.dart';
import 'package:tadreebkomapplication/view/widget/user/appointment_card.dart';
import 'package:tadreebkomapplication/view/widget/user/center_card.dart';
import 'package:tadreebkomapplication/view/widget/user/instructor_card.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ActivityController());

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (ctrl.paidBookings.isEmpty) {
            return const Center(
              child: Text(
                "You haven't taken any paid lessons yet.",
                textAlign: TextAlign.center,
              ),
            );
          }

          final lc = ctrl.latestCenter.value;
          final li = ctrl.latestInstructor.value;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Most Recent Center',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (lc != null) ...[
                  const SizedBox(height: 8),
                  CenterCard(centerData: lc),
                ],

                const SizedBox(height: 24),
                const Text(
                  'Most Recent Instructor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (li != null) ...[
                  const SizedBox(height: 8),
                  InstructorCardViewPage(
                    instructorData: li,
                    enableSelect: false,
                  ),
                ],

                const SizedBox(height: 24),
                const Text(
                  'Your Paid Lessons',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                // ← must constrain the ListView!
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: ctrl.paidBookings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, idx) {
                      final appt = ctrl.paidBookings[idx];
                      return AppointmentCard(
                        name: appt['name'] ?? '',
                        date: appt['date'] as String,
                        time: appt['time'] as String,

                        isPaid: true,
                        isFinished: true,
                        onFeedback: () {
                          Get.to(
                            () => FeedbackStudentView(
                              instructorId: appt['instructorId'],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
