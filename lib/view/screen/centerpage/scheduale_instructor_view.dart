import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tadreebkomapplication/controller/centercontroller/schedualeviewcontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/view/widget/instructor/booking_card_instructor.dart';
import 'package:tadreebkomapplication/view/screen/instructor/feedback_student_view.dart';

class CenterSchedulePageView extends StatelessWidget {
  const CenterSchedulePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final instructorId = args?['instructorId'] as String?;
    if (instructorId == null) {
      return Scaffold(
        body: Center(child: Text("❌ Missing instructorId in arguments")),
      );
    }
    final ctrl = Get.put(CenterScheduleControllerView(instructorId));
    final now = DateTime.now();
    final selectedDate = now.obs;

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        title: const Text('Instructor Schedule'),
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
      ),
      body: Column(
        children: [
          // 📅 Date picker
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return Text(
                      'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate.value)}',
                      style: const TextStyle(fontSize: 16),
                    );
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      selectedDate.value = picked;
                    }
                  },
                ),
              ],
            ),
          ),

          // 📋 Booking list
          Expanded(
            child: Obx(() {
              final all = ctrl.bookings;
              if (all.isEmpty) {
                return const Center(
                  child: Text(
                    'No bookings found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              // filter by day
              final filtered =
                  all.where((b) {
                    final d = DateFormat(
                      'yyyy-MM-dd',
                    ).parse(b['date'] as String);
                    return d.year == selectedDate.value.year &&
                        d.month == selectedDate.value.month &&
                        d.day == selectedDate.value.day;
                  }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    'No bookings on ${DateFormat('MMMM d, yyyy').format(selectedDate.value)}.',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final b = filtered[i];
                  final status = b['status'] as String? ?? 'pending';
                  late String label;
                  late VoidCallback onTap;

                  if (status == 'pending') {
                    label = 'Start';
                    onTap = () => ctrl.updateBookingStatus(b['id'], 'started');
                  } else if (status == 'started') {
                    label = 'Stop';
                    onTap =
                        () => ctrl.updateBookingStatus(b['id'], 'completed');
                  } else {
                    label = 'Feedback';
                    final studentId = b['userId'] as String;
                    onTap = () {
                      Get.to(
                        () => InstructorFeedbackView(studentId: studentId),
                      );
                    };
                  }

                  return BookingCard(
                    booking: b,
                    buttonState: label.toLowerCase(),
                    onButtonPressed: onTap,
                    onRemove: () {}, // center shouldn’t remove slots
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
