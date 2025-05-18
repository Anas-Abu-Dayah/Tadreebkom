// lib/view/widget/user/center_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/core/constant/app_theme.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/data/model/center_data.dart';

class CenterCard extends StatelessWidget {
  final CenterData centerData;
  final VoidCallback? onSelect;

  const CenterCard({super.key, required this.centerData, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final imageUrl = centerData.imageUrl.trim();
    final hasImage = imageUrl.isNotEmpty;

    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: AppTheme.cardDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
            child:
                !hasImage
                    ? const Icon(Icons.image, size: 28, color: Colors.grey)
                    : null,
          ),

          const SizedBox(height: 4),

          // Name (single line)
          Text(
            centerData.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),
          const Divider(height: 8, thickness: 1),
          const SizedBox(height: 14),

          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Select
              GestureDetector(
                onTap:
                    onSelect ??
                    () {
                      Get.toNamed(
                        AppRoute.booking,
                        arguments: {'center': centerData},
                      );
                    },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange.shade100,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 20,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text('Select', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              // Profile
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoute.centerProfileView,
                    arguments: {'centerId': centerData.id},
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
