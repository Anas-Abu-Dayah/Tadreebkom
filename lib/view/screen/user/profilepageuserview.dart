// lib/view/screen/user/user_profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/userprofilecontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/view/widget/user/appointment_card.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(UserProfileController());

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: ctrl.loadAll,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Avatar ─────────────────────────────
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          ctrl.photoUrl.value.isNotEmpty
                              ? NetworkImage(ctrl.photoUrl.value)
                              : null,
                      child:
                          ctrl.photoUrl.value.isEmpty
                              ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )
                              : null,
                    ),
                    GestureDetector(
                      onTap: ctrl.changeProfilePicture,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // ─── Name & Email ────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      ctrl.displayName.value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      final nameCtrl = TextEditingController(
                        text: ctrl.displayName.value,
                      );
                      Get.defaultDialog(
                        title: 'Edit Name',
                        content: Column(
                          children: [
                            TextField(controller: nameCtrl),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                final newName = nameCtrl.text.trim();
                                if (newName.isNotEmpty) {
                                  ctrl.updateDisplayName(newName);
                                  Get.back();
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Icon(Icons.edit, size: 18, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Center(
                child: Obx(
                  () => Text(
                    ctrl.email.value,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              // ─── Stats ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatBox(label: 'Total', value: ctrl.totalBookings.value),
                  _StatBox(
                    label: 'Upcoming',
                    value: ctrl.upcomingLessons.value,
                  ),
                  _StatBox(label: 'Done', value: ctrl.completedLessons.value),
                ],
              ),

              const SizedBox(height: 30),
              // ─── Upcoming Lessons ─────────────────
              const Text(
                "Upcoming Lessons",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (ctrl.upcomingList.isEmpty) {
                  return const Center(child: Text("No upcoming lessons."));
                }
                return Column(
                  children:
                      ctrl.upcomingList.map((a) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppointmentCard(
                                  name: a['name'] as String,
                                  date: a['date'] as String,
                                  time: a['time'] as String,
                                  isFinished: false,
                                  isPaid: false,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
