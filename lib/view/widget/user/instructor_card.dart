// lib/view/widget/user/instructor_card_view.dart

import 'package:flutter/material.dart';
import 'package:tadreebkomapplication/core/constant/app_theme.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/data/model/instructor_data.dart';
import 'package:get/get.dart';

class InstructorCardViewPage extends StatelessWidget {
  final InstructorData instructorData;
  final VoidCallback? onSelect;
  final VoidCallback? onProfile;
  final bool enableSelect; // ← toggle whether Select is active

  const InstructorCardViewPage({
    super.key,
    required this.instructorData,
    this.onSelect,
    this.onProfile,
    this.enableSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = instructorData.imageUrl.trim();
    final hasImage = imageUrl.isNotEmpty;

    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: AppTheme.cardDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          // avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
            child:
                !hasImage
                    ? const Icon(Icons.person, size: 28, color: Colors.grey)
                    : null,
          ),
          const SizedBox(height: 4),
          // name
          Text(
            instructorData.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Divider(thickness: 1),
          const SizedBox(height: 30),

          // actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Select button
              GestureDetector(
                onTap:
                    enableSelect
                        ? (onSelect ??
                            () {
                              Get.toNamed(
                                AppRoute.booking,
                                arguments: {'instructor': instructorData},
                              );
                            })
                        : null,
                child: Opacity(
                  opacity: enableSelect ? 1.0 : 0.4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              enableSelect
                                  ? Colors.orange.shade100
                                  : Colors.grey.shade300,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 20,
                          color:
                              enableSelect
                                  ? Colors.orange
                                  : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              enableSelect
                                  ? Colors.black
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Profile button
              GestureDetector(
                onTap:
                    onProfile ??
                    () {
                      Get.toNamed(
                        AppRoute.studentInstructorProfilePageView,
                        arguments: {'instructorId': instructorData.id},
                      );
                    },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueGrey.shade50,
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text('Profile', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
