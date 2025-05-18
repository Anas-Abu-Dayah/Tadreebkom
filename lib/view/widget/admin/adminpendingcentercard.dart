import 'package:flutter/material.dart';

class AdminPendingCenterCard extends StatelessWidget {
  final Map<String, dynamic> centerData;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const AdminPendingCenterCard({
    super.key,
    required this.centerData,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // pull fields, defaulting to empty string if missing
    final name = centerData['drivingCenterName'] ?? 'Unnamed Center';
    final email = centerData['email'] ?? 'No email';
    final phone = centerData['phone'] ?? 'No phone';
    final city = centerData['city'] ?? 'No City';
    final state = centerData['state'] ?? 'No address';
    final licenseImage = (centerData['license'] as String?) ?? '';

    // debug print
    // you can watch your console to see whether this ever prints a URL

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text("Email: $email"),
            Text("Phone: $phone"),
            Text("City: $city"),
            Text("Address: $state"),
            const SizedBox(height: 12),

            // if URL non-empty, show it; otherwise a placeholder box
            licenseImage.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    licenseImage,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.fill,
                    errorBuilder:
                        (_, __, ___) => const Text(
                          '⚠️ Failed to load license image',
                          style: TextStyle(color: Colors.red),
                        ),
                  ),
                )
                : Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Text("No license image")),
                ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check),
                  label: const Text("Accept"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close),
                  label: const Text("Reject"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
