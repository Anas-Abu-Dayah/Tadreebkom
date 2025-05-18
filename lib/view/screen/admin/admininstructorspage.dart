import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/admincontroller/admininstructorscontroller.dart';
import 'package:tadreebkomapplication/view/widget/admin/adminbuttonbar.dart';
import 'package:tadreebkomapplication/view/widget/admin/admininstructorcard.dart';

class AdminAllInstructorsView extends StatelessWidget {
  final controller = Get.put(AdminAllInstructorsController());

  AdminAllInstructorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentIndex: 1,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final filtered =
            controller.allInstructors.where((inst) {
              final name = (inst['username'] as String?)?.toLowerCase() ?? '';
              final email = (inst['email'] as String?)?.toLowerCase() ?? '';
              final q = controller.searchText.value.toLowerCase();
              return name.contains(q) || email.contains(q);
            }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search instructors...',
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
                      ? const Center(child: Text('No instructors found'))
                      : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final inst = filtered[i];
                          return AdminInstructorCard(
                            instructorData: inst,
                            onDelete: () async {
                              var user =
                                  await FirebaseFirestore.instance
                                      .collection('instructors')
                                      .doc(inst['id'])
                                      .get();
                              await controller.deleteInstructor(user['email']);
                              controller.fetchAllInstructors();
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
