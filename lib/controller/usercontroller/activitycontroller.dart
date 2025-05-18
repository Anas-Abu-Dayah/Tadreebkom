// lib/controller/usercontroller/activity_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tadreebkomapplication/data/model/center_data.dart';
import 'package:tadreebkomapplication/data/model/instructor_data.dart';

class ActivityController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;

  /// Stream of all paid bookings, newest first
  final paidBookings = <Map<String, dynamic>>[].obs;

  /// Most‐recent center & instructor
  final latestCenter = Rxn<CenterData>();
  final latestInstructor = Rxn<InstructorData>();

  @override
  void onInit() {
    super.onInit();
    if (_user != null) _listenPaidBookings();
  }

  void _listenPaidBookings() {
    _db
        .collection('booking')
        .where('userId', isEqualTo: _user!.uid)
        .where('paid', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots()
        .listen(
          (snap) async {
            final List<Map<String, dynamic>> list = [];

            for (final doc in snap.docs) {
              final d = doc.data();
              final centerId = d['centerId'] as String?;
              final instructorId = d['instructorId'] as String?;
              final rawDate = d['date'] as String? ?? '';
              final rawTime = d['time'] as String? ?? '';

              // 1️⃣ fetch CenterData
              CenterData? centerData;
              if (centerId != null) {
                final cdoc =
                    await _db.collection('centers').doc(centerId).get();
                if (cdoc.exists) {
                  centerData = CenterData.fromMap(cdoc.data()!, cdoc.id);
                }
              }

              // 2️⃣ fetch InstructorData
              InstructorData? instrData;
              if (instructorId != null) {
                final idoc =
                    await _db.collection('instructors').doc(instructorId).get();
                if (idoc.exists) {
                  instrData = InstructorData.fromMap(idoc.data()!, idoc.id);
                }
              }

              // 3️⃣ format display date
              String displayDate = '';
              try {
                displayDate = DateFormat(
                  'EEE, MMM d',
                ).format(DateTime.parse(rawDate));
              } catch (_) {}

              list.add({
                'bookingId': doc.id,
                'centerId': centerId,
                'instructorId': instructorId,
                'centerData': centerData,
                'instructorData': instrData,
                'date': displayDate,
                'time': rawTime,
              });
            }

            // update reactive list
            paidBookings.value = list;

            // update “most recent” shortcuts
            if (list.isNotEmpty) {
              latestCenter.value = list.first['centerData'] as CenterData?;
              latestInstructor.value =
                  list.first['instructorData'] as InstructorData?;
            }
          },
          onError:
              (e) =>
                  Get.snackbar('Error', 'Could not load your paid lessons: $e'),
        );
  }
}
