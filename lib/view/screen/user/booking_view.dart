import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/booking_controller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/view/widget/user/date_picker.dart';
import 'package:tadreebkomapplication/view/widget/user/instructor_list.dart';
import 'package:tadreebkomapplication/view/widget/user/time_picker.dart';
import 'package:tadreebkomapplication/view/widget/user/booknow_button.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.pagePrimaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Get.back(),
        ),
        title: const Text('Select Your Free Time'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              buildDatePicker(controller),
              const SizedBox(height: 16),
              const Text(
                'Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              buildTimePicker(controller),
              const SizedBox(height: 16),
              Expanded(child: buildInstructorsList(controller)),
              const SizedBox(height: 16),
              Obx(
                () =>
                    controller.selectedInstructor.value != null
                        ? buildBookNowButton(controller)
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
