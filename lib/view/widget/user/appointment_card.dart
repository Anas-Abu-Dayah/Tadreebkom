// lib/view/widget/user/appointment_card.dart

import 'package:flutter/material.dart';
import 'package:tadreebkomapplication/core/constant/app_theme.dart';

class AppointmentCard extends StatelessWidget {
  final String name;
  final String date;
  final String time;
  final bool isPaid;
  final bool isFinished;
  final VoidCallback? onEdit;
  final VoidCallback? onFeedback;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.date,
    required this.time,
    this.isPaid = false,
    this.isFinished = false,
    this.onEdit,
    this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final canEdit = !isFinished;
    final canFeedback = isPaid && isFinished && onFeedback != null;

    return SizedBox(
      width: 240,
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name & date/time row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.today, color: Colors.orange, size: 18),
                    const SizedBox(width: 4),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        date,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.access_time,
                      color: Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            const SizedBox(height: 12),

            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: canEdit ? onEdit : null,
                  icon: const Icon(Icons.edit_calendar, size: 18),
                  label: const Text('Edit', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: const Color.fromRGBO(250, 248, 248, 0.9),
                    foregroundColor: canEdit ? Colors.orange : Colors.grey,
                    elevation: 1,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: canFeedback ? onFeedback : null,
                  icon: const Icon(Icons.star_border_outlined, size: 18),
                  label: const Text('Feedback', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: const Color.fromRGBO(250, 248, 248, 0.9),
                    foregroundColor: canFeedback ? Colors.orange : Colors.grey,
                    elevation: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
