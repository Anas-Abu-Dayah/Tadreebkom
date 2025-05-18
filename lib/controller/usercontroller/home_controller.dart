import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;

  /// NEW: loading indicator
  final isLoading = false.obs;

  /// Reactive list of appointments
  RxList<Map<String, dynamic>> appointments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    if (_user == null) return;
    isLoading.value = true; // start spinner

    try {
      final snap =
          await _db
              .collection('booking')
              .where('userId', isEqualTo: _user.uid)
              .orderBy('date', descending: true)
              .get();

      final List<Map<String, dynamic>> list = [];
      for (var doc in snap.docs) {
        final data = doc.data();
        final instrId = data['instructorId'] as String?;

        // Fetch instructor username
        String name = 'Instructor';
        if (instrId != null) {
          final iDoc = await _db.collection('instructors').doc(instrId).get();
          if (iDoc.exists) {
            name = (iDoc.data()?['username'] as String?) ?? name;
          }
        }

        // Parse & display date
        DateTime? dt;
        final rawDate = data['date'];
        if (rawDate is String) {
          dt = DateTime.tryParse(rawDate);
        } else if (rawDate is Timestamp) {
          dt = rawDate.toDate();
        }
        final displayDate =
            dt != null ? DateFormat('EEE, MMM d').format(dt) : '';

        // Raw for logic
        final isoDate =
            rawDate is String ? rawDate : dt?.toIso8601String() ?? '';
        final timeRaw = data['time'] as String? ?? '';

        list.add({
          'bookingId': doc.id,
          'instructorId': instrId,
          'name': name,
          'date': displayDate,
          'time': timeRaw,
          'dateRaw': isoDate,
          'timeRaw': timeRaw,
        });
      }
      appointments.value = list;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch appointments: $e');
    } finally {
      isLoading.value = false; // stop spinner
    }
  }

  Future<void> deleteAppointment(
    String bookingId,
    String instructorId,
    String dateRaw,
    String timeRaw,
  ) async {
    try {
      await _db.collection('booking').doc(bookingId).delete();
      await _updateInstructorAvailability(instructorId, dateRaw, timeRaw, true);
      await fetchAppointments();
      Get.snackbar('Deleted', 'Appointment removed and slot reopened.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete appointment: $e');
    }
  }

  Future<void> _updateInstructorAvailability(
    String instructorId,
    String date,
    String rawTime,
    bool available,
  ) async {
    final ref = _db.collection('instructors').doc(instructorId);
    final doc = await ref.get();
    if (!doc.exists) return;

    final availList = (doc.data()?['availability'] as List<dynamic>?) ?? [];

    String normalize(String s) =>
        s
            .replaceAll(RegExp(r'[\u00A0\u202F]'), ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();

    final want = normalize(rawTime);

    final updated =
        availList
            .map((day) {
              if (day['date'] == date) {
                final times = (day['times'] as List<dynamic>?) ?? [];
                final newTimes =
                    times.map((slot) {
                      if (normalize(slot['time'] as String) == want) {
                        return {'time': slot['time'], 'available': available};
                      }
                      return Map<String, dynamic>.from(slot);
                    }).toList();
                return {'date': day['date'], 'times': newTimes};
              }
              return Map<String, dynamic>.from(day);
            })
            .cast<Map<String, dynamic>>()
            .toList();

    await ref.update({'availability': updated});
  }

  Future<void> postponeAppointment({
    required String bookingId,
    required String instructorId,
    required String oldDate,
    required String oldTime,
    required String newDate,
    required String newTime,
  }) async {
    // 1️⃣ reopen old slot
    await _updateSlot(instructorId, oldDate, oldTime, true);

    // 2️⃣ block new slot
    await _updateSlot(instructorId, newDate, newTime, false);

    // 3️⃣ update booking doc
    await _db.collection('booking').doc(bookingId).update({
      'date': newDate,
      'time': newTime,
    });

    // 4️⃣ refresh UI
    await fetchAppointments();
    Get.snackbar('Rescheduled', 'Your lesson has been moved.');
  }

  Future<void> _updateSlot(
    String instrId,
    String date,
    String time,
    bool avail,
  ) async {
    final ref = _db.collection('instructors').doc(instrId);
    final doc = await ref.get();
    if (!doc.exists) return;
    final availList = (doc.data()?['availability'] as List<dynamic>?) ?? [];

    String norm(String s) =>
        s
            .replaceAll(RegExp(r'[\u00A0\u202F]'), ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();

    final want = norm(time);

    final updated =
        availList
            .map((day) {
              if (day['date'] == date) {
                final times = (day['times'] as List<dynamic>?) ?? [];
                final newTimes =
                    times.map((slot) {
                      if (norm(slot['time'] as String) == want) {
                        return {'time': slot['time'], 'available': avail};
                      }
                      return Map<String, dynamic>.from(slot);
                    }).toList();
                return {'date': day['date'], 'times': newTimes};
              }
              return Map<String, dynamic>.from(day);
            })
            .cast<Map<String, dynamic>>()
            .toList();

    await ref.update({'availability': updated});
  }
}
