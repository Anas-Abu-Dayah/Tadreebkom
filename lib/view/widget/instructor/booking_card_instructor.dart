import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tadreebkomapplication/core/functions/openmaps.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final String buttonState; // 'start' | 'stop' | 'feedback'
  final VoidCallback onButtonPressed;
  final VoidCallback onRemove;

  const BookingCard({
    super.key,
    required this.booking,
    required this.buttonState,
    required this.onButtonPressed,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = booking['date'] as String;
    final timeStr = booking['time'] as String;
    final raw = '$dateStr $timeStr'.replaceAll(RegExp(r'[\u00A0\u202F]'), ' ');
    final dt = DateFormat('yyyy-MM-dd h:mm a').parse(raw);

    final formattedDate = DateFormat('MMM d, yyyy').format(dt);
    final formattedTime = DateFormat('h:mm a').format(dt);
    final location = booking['Location'] ?? 'Not specified';
    final phonenumber = booking['phone'] ?? 'Not specified';
    final status = booking['status'] as String;

    final lat = booking['latitude'] as double;
    final lng = booking['longitude'] as double;

    Color statusColor;
    if (status == 'pending') {
      statusColor = Colors.orange.shade100;
    } else if (status == 'started') {
      statusColor = Colors.green.shade100;
    } else {
      statusColor = Colors.grey.shade100;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ID: ${(booking['id'] as String).substring(0, 8)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(formattedDate, style: const TextStyle(fontSize: 15)),
                const Spacer(),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(formattedTime, style: const TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(location, style: const TextStyle(fontSize: 15)),
                ),
                InkWell(
                  onTap: () => openMaps(lat, lng),
                  child: Row(
                    children: const [
                      Icon(Icons.map, size: 17, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        'View on Map',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Phone
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(phonenumber, style: const TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 6),

            // Student Name (from FutureBuilder)
            FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(booking['userId'] as String)
                      .get(),
              builder: (ctx, snap) {
                if (!snap.hasData) {
                  return Row(
                    children: const [
                      Icon(Icons.person, size: 16, color: Colors.grey),
                      SizedBox(width: 6),
                      Text(
                        'Loading student...',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  );
                }
                final user = snap.data!.data() as Map<String, dynamic>;
                final name =
                    user['Fullname'] ?? user['displayName'] ?? 'Unknown';
                return Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(name, style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onButtonPressed,
                    icon: Icon(
                      buttonState == 'start'
                          ? Icons.play_arrow
                          : buttonState == 'stop'
                          ? Icons.stop
                          : Icons.feedback,
                      size: 18,
                    ),
                    label: Text(
                      buttonState == 'start'
                          ? 'Start'
                          : buttonState == 'stop'
                          ? 'Stop'
                          : 'Feedback',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor:
                          buttonState == 'start'
                              ? Colors.green
                              : buttonState == 'stop'
                              ? Colors.red
                              : Colors.orangeAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red.shade700,
                  onPressed: onRemove,
                  tooltip: 'Remove Booking',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
