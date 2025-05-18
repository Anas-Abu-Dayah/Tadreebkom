import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

class ProfileTabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final RxString selectedTab;

  const ProfileTabButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedTab.value = label;
          if (label == "Home" &&
              Get.currentRoute != AppRoute.centerprofilepage) {
            Get.offNamed(AppRoute.centerprofilepage);
          } else if (label == "Instructors" &&
              Get.currentRoute != AppRoute.centerhomepage) {
            Get.offNamed(AppRoute.centerhomepage);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient:
                isActive
                    ? const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    )
                    : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
