import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  /// All bookings (pending, started AND completed)
  final bookings = <Map<String, dynamic>>[].obs;

  /// Per‐booking button state: 'start', 'stop', or 'feedback'
  final buttonStates = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToBookings();
  }

  void _listenToBookings() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('booking')
        .where('instructorId', isEqualTo: user.uid)
        // include completed so cards don't disappear
        .where('status', whereIn: ['pending', 'started', 'completed'])
        .snapshots()
        .listen(
          (snap) {
            bookings.value =
                snap.docs.map((doc) {
                  final data = Map<String, dynamic>.from(doc.data());
                  data['id'] = doc.id;
                  // init button state if unseen
                  if (!buttonStates.containsKey(doc.id)) {
                    final st = data['status'] as String? ?? 'pending';
                    buttonStates[doc.id] =
                        st == 'started'
                            ? 'stop'
                            : st == 'completed'
                            ? 'feedback'
                            : 'start';
                  }
                  return data;
                }).toList();
          },
          onError: (e) {
            Get.snackbar('Error', 'Could not load schedule: $e');
          },
        );
  }

  /// Flip pending→started, started→completed (and mark paid), completed→feedback
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    final updates = <String, dynamic>{
      'status': newStatus,
      if (newStatus == 'completed') 'paid': true,
    };
    try {
      await FirebaseFirestore.instance
          .collection('booking')
          .doc(bookingId)
          .update(updates);
      // update local state immediately
      buttonStates[bookingId] =
          newStatus == 'started'
              ? 'stop'
              : newStatus == 'completed'
              ? 'feedback'
              : 'start';
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking: $e');
    }
  }

  /// Delete a booking entirely
  Future<void> deleteBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('booking')
          .doc(bookingId)
          .delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete booking: $e');
    }
  }
}
