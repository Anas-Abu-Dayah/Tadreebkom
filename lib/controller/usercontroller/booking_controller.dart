import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart'; // ← import intl
import 'package:tadreebkomapplication/data/model/instructor_data.dart';
import 'package:tadreebkomapplication/data/model/center_data.dart';

class BookingController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay(hour: 9, minute: 0).obs;
  final selectedInstructor = Rxn<InstructorData>();
  RxList<InstructorData> instructors = <InstructorData>[].obs;
  RxList<Map<String, dynamic>> appointmentData = <Map<String, dynamic>>[].obs;
  final GetStorage storage = GetStorage();
  Rx<CenterData?> selectedCenter = Rx<CenterData?>(null);

  @override
  void onInit() {
    super.onInit();

    // Grab the center, fetch data, and log for debug
    final CenterData center = Get.arguments['center'];
    fetchInstructors(center.id);
    fetchAllAppointments();

    // Whenever date, time, instructors or appointments change, log availability
    everAll([selectedDate, selectedTime, instructors, appointmentData], (_) {});
  }

  String formatTime(TimeOfDay time) {
    final dt = DateTime(0, 0, 0, time.hour, time.minute);
    return DateFormat.jm('en_US').format(dt);
  }

  void updateSelectedTime(TimeOfDay time) {
    selectedTime.value = time;
    selectedInstructor.value = null;
    storage.write('selectedtime', formatTime(time));
  }

  List<InstructorData> get availableInstructors {
    final dateStr = selectedDate.value.toIso8601String().substring(0, 10);
    final timeStr = formatTime(selectedTime.value);

    return instructors.where((instr) {
      final day = instr.availability.firstWhere(
        (a) => a.date == dateStr,
        orElse: () => Availability(date: '', times: []),
      );
      final slot = day.times.firstWhere(
        (t) => t.time == timeStr && t.available,
        orElse: () => TimeSlot(time: '', available: false),
      );
      if (!slot.available) return false;

      final alreadyBooked = appointmentData.any(
        (appt) =>
            appt['instructorId'] == instr.id &&
            appt['date'].toString().substring(0, 10) == dateStr &&
            appt['time'] == timeStr,
      );
      return !alreadyBooked;
    }).toList();
  }

  Future<void> fetchInstructors(String centerId) async {
    storage.write('selectedCenter', centerId);
    try {
      final snap =
          await FirebaseFirestore.instance
              .collection('instructors')
              .where('centerId', isEqualTo: centerId)
              .get();
      instructors.value =
          snap.docs.map((d) => InstructorData.fromMap(d.data(), d.id)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load instructors: $e');
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    selectedInstructor.value = null;
    storage.write('selecteddate', date.toIso8601String());
  }

  void selectInstructor(InstructorData i) {
    selectedInstructor.value = i;
    storage.write('selectedInstructorId', i.id);
  }

  Future<void> fetchAllAppointments() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('booking').get();
      appointmentData.value = snap.docs.map((d) => d.data()).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch bookings: $e');
    }
  }
}
