import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/booking_controller.dart';
import 'package:tadreebkomapplication/view/widget/user/custom_chips.dart';

Widget buildTimePicker(BookingController controller) {
  final times = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 12, minute: 0),
    const TimeOfDay(hour: 13, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
  ];

  return Obx(() {
    final currentTime = controller.selectedTime.value;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            times.map((time) {
              final isSelected =
                  time.hour == currentTime.hour &&
                  time.minute == currentTime.minute;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CustomChip(
                  isSelected: isSelected,
                  onTap: () => controller.updateSelectedTime(time),
                  child: Text(
                    time.format(Get.context!),
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  });
}
