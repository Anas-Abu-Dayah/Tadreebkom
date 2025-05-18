//instructor_navbar_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/instructorcontroller/instrutor_navbar_controller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/view/screen/instructor/schedualeview.dart';
import 'package:tadreebkomapplication/view/screen/instructor/setting_instructorview.dart';

class InstructorNavBarView extends StatelessWidget {
  const InstructorNavBarView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InstructorNavBarController());

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex,
          children: const [
            ScheduleView(), // Schedule page
            InstructorSettingsView(), // Profile page (reused from student)
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex,
            onTap: controller.changeTabIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
