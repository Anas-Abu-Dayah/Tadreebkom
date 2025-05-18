import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CenterScheduleControllerView extends GetxController {
  final String instructorId;
  CenterScheduleControllerView(this.instructorId);

  /// All bookings for the given instructor
  final bookings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _listenToInstructorBookings();
  }

  void _listenToInstructorBookings() {
    FirebaseFirestore.instance
        .collection('booking')
        .where('instructorId', isEqualTo: instructorId)
        .where('status', whereIn: ['pending', 'started', 'completed'])
        .snapshots()
        .listen(
          (snap) {
            bookings.value =
                snap.docs.map((doc) {
                  final m = Map<String, dynamic>.from(doc.data());
                  m['id'] = doc.id;
                  return m;
                }).toList();
          },
          onError: (e) {
            Get.snackbar('Error', 'Could not load bookings: $e');
          },
        );
  }

  /// flip pending→started, started→completed (+ mark paid), completed stays
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
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e');
    }
  }
}
