import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tadreebkomapplication/controller/instructorcontroller/scheduale_controller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/view/screen/instructor/feedback_student_view.dart';
import 'package:tadreebkomapplication/view/widget/instructor/booking_card_instructor.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ScheduleController());
    final DateTime now = DateTime.now();
    final Rx<DateTime> selectedDate = now.obs;

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
      ),
      body: Column(
        children: [
          // Date picker at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate.value)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null && picked != selectedDate.value) {
                      selectedDate.value = picked;
                      // Re-filter bookings based on selected date
                      ctrl.bookings
                          .refresh(); // Trigger re-evaluation of the Obx
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = ctrl.bookings;
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'No bookings scheduled.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              // Filter bookings by selected date
              final filteredBookings =
                  list.where((booking) {
                    final bookingDateStr = booking['date'] as String;
                    final bookingDate = DateFormat(
                      'yyyy-MM-dd',
                    ).parse(bookingDateStr);
                    return bookingDate.year == selectedDate.value.year &&
                        bookingDate.month == selectedDate.value.month &&
                        bookingDate.day == selectedDate.value.day;
                  }).toList();

              if (filteredBookings.isEmpty) {
                return Center(
                  child: Text(
                    'No bookings for ${DateFormat('MMMM d, yyyy').format(selectedDate.value)}.',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredBookings.length,
                itemBuilder: (ctx, i) {
                  final b = filteredBookings[i];
                  final status = b['status'] as String? ?? 'pending';
                  String btnLabel;
                  VoidCallback onTap;
                  onRemove() {
                    // Remove booking from the UI only
                    ctrl.bookings.remove(b);
                    ctrl.bookings.refresh(); // Update the UI
                  }

                  if (status == 'pending') {
                    btnLabel = 'Start';
                    onTap = () => ctrl.updateBookingStatus(b['id'], 'started');
                  } else if (status == 'started') {
                    btnLabel = 'Stop';
                    onTap =
                        () => ctrl.updateBookingStatus(b['id'], 'completed');
                  } else {
                    btnLabel = 'Feedback';
                    final studentId = b['userId'] as String;
                    onTap =
                        () => Get.to(
                          () => InstructorFeedbackView(studentId: studentId),
                        );
                  }

                  return BookingCard(
                    booking: b,
                    buttonState: btnLabel.toLowerCase(),
                    onButtonPressed: onTap,
                    onRemove: onRemove,
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
