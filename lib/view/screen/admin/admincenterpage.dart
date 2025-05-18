import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/admincontroller/admincentercontroller.dart';
import 'package:tadreebkomapplication/view/widget/admin/adminbuttonbar.dart';
import 'package:tadreebkomapplication/view/widget/admin/admincentercard.dart';

class AdminAllCentersView extends StatelessWidget {
  final controller = Get.put(AdminAllCentersController());

  AdminAllCentersView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 2,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final filtered =
            controller.allCenters.where((ctr) {
              final name =
                  (ctr['drivingCenterName'] as String?)?.toLowerCase() ?? '';
              final email = (ctr['email'] as String?)?.toLowerCase() ?? '';
              final q = controller.searchText.value.toLowerCase();
              return name.contains(q) || email.contains(q);
            }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search centers...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (val) => controller.searchText.value = val,
              ),
            ),
            Expanded(
              child:
                  filtered.isEmpty
                      ? const Center(child: Text('No centers found'))
                      : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final ctr = filtered[i];
                          return AdminCenterCard(
                            centerData: ctr,
                            onDelete: () async {
                              var user =
                                  await FirebaseFirestore.instance
                                      .collection('centers')
                                      .doc(ctr['id'])
                                      .get();
                              await controller.deleteCenter(user['email']);
                              controller.fetchAllCenters();
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
