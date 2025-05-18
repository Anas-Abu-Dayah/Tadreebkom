// lib/view/admin_pending_centers_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/admincontroller/admincontroller.dart';
import 'package:tadreebkomapplication/view/widget/admin/adminbuttonbar.dart';
import 'package:tadreebkomapplication/view/widget/admin/adminpendingcentercard.dart';

class AdminPendingCentersView extends StatelessWidget {
  final controller = Get.put(AdminPendingCentersController());

  AdminPendingCentersView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      // index 0 corresponds to "Pending Centers"
      currentIndex: 0,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = controller.pendingCenters;
        if (list.isEmpty) {
          return const Center(child: Text("No pending centers"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with count
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                'You have ${list.length} pending request${list.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // List of pending center cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: list.length,
                itemBuilder: (ctx, i) {
                  final center = list[i];
                  return AdminPendingCenterCard(
                    centerData: center,
                    onAccept: () async {
                      await FirebaseFirestore.instance
                          .collection('centers')
                          .doc(center['id'])
                          .update({'verifiedAdmin': true});
                      controller.fetchPendingCenters();
                    },
                    onReject: () async {
                      var user =
                          await FirebaseFirestore.instance
                              .collection('centers')
                              .doc(center['id'])
                              .get();
                      await controller.deleteCenter(user['email']);

                      controller.fetchPendingCenters();
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
