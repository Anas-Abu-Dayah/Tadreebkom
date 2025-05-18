import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/centercontroller.dart';
import 'center_card.dart'; // Import CenterCard

class CentersSection extends StatelessWidget {
  final String title;

  const CentersSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final CentersController controller = Get.put(
      CentersController(),
    ); // Initialize the controller

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(() {
          // Show loading indicator while data is being fetched
          if (controller.centers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SizedBox(
            height: 180, // Adjusted height to fit the CenterCard
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.centers.length,
              itemBuilder: (context, index) {
                final center = controller.centers[index];
                return CenterCard(centerData: center).animate().fadeIn(
                  duration: 500.ms,
                  delay: Duration(milliseconds: 100 * index),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
