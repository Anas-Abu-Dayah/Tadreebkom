import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/booking_controller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/view/widget/user/instructor_card.dart';

Widget buildInstructorsList(BookingController controller) {
  return Obx(() {
    final availableInstructors = controller.availableInstructors;
    if (availableInstructors.isEmpty) {
      return const Center(
        child: Text('No instructors available at this time.'),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.73,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: availableInstructors.length,
      itemBuilder: (context, index) {
        final instructor = availableInstructors[index];
        return InstructorCardViewPage(
          instructorData: instructor,
          onSelect: () {
            controller.selectInstructor(instructor);
            Get.toNamed(AppRoute.checkout);
          },
        );
      },
    );
  });
}
