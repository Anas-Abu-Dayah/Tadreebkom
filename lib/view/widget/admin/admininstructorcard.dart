// lib/view/widget/admin/admin_instructor_card.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminInstructorCard extends StatelessWidget {
  final Map<String, dynamic> instructorData;
  final VoidCallback onDelete;

  const AdminInstructorCard({
    super.key,
    required this.instructorData,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final id = instructorData['id'] as String;
    final username = instructorData['username'] ?? 'Unnamed';
    final email = instructorData['email'] ?? 'No email';
    final phone = instructorData['phone'] ?? 'No phone';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Email: $email'),
                  Text('Phone: $phone'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (c) => AlertDialog(
                        title: const Text('Delete instructor?'),
                        content: Text(
                          'Are you sure you want to delete $username?',
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
                                  .collection('instructors')
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
          ],
        ),
      ),
    );
  }
}
