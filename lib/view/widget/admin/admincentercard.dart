// lib/view/widget/admin/admin_center_card.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminCenterCard extends StatelessWidget {
  final Map<String, dynamic> centerData;
  final VoidCallback onDelete;

  const AdminCenterCard({
    super.key,
    required this.centerData,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final id = centerData['id'] as String;
    final name = centerData['drivingCenterName'] ?? 'Unnamed Center';
    final email = centerData['email'] ?? 'No email';
    final phone = centerData['phone'] ?? 'No phone';
    final city = centerData['city'] ?? 'No address';
    final state = centerData['state'] ?? 'No state';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Email: $email'),
            Text('Phone: $phone'),
            Text('city: $city'),
            Text('state: $state'),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (c) => AlertDialog(
                          title: const Text('Delete center?'),
                          content: Text(
                            'Are you sure you want to delete $name?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(c);
                                await FirebaseFirestore.instance
                                    .collection('centers')
                                    .doc(id)
                                    .delete();
                                onDelete();
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
