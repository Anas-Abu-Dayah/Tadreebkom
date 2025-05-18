import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tadreebkomapplication/controller/usercontroller/booking_controller.dart';
import 'package:tadreebkomapplication/view/widget/user/custom_chips.dart';

Widget buildDatePicker(BookingController controller) {
  final days = List.generate(7, (index) {
    final date = DateTime.now().add(Duration(days: index));
    return date;
  });

  return Obx(() {
    final currentDate = controller.selectedDate.value;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            days.map((date) {
              final isSelected =
                  date.day == currentDate.day &&
                  date.month == currentDate.month &&
                  date.year == currentDate.year;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CustomChip(
                  isSelected: isSelected,
                  onTap: () => controller.updateSelectedDate(date),
                  child: Column(
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 18,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        [
                          'Mo',
                          'Tu',
                          'Wed',
                          'Th',
                          'Fr',
                          'Sa',
                          'Su',
                        ][date.weekday - 1],
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  });
}
