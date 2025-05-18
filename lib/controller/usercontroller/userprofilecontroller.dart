// lib/controller/usercontroller/user_profile_controller.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// Loading flag
  final isLoading = false.obs;

  /// Basic user info
  final displayName = ''.obs;
  final email = ''.obs;
  final photoUrl = ''.obs;

  /// Booking stats
  final totalBookings = 0.obs;
  final upcomingLessons = 0.obs;
  final completedLessons = 0.obs;

  /// A few upcoming lessons to preview
  final upcomingList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    isLoading.value = true;
    await Future.wait([
      _loadUserInfo(),
      _loadBookingStats(),
      _loadUpcomingLessons(),
    ]);
    isLoading.value = false;
  }

  Future<void> _loadUserInfo() async {
    final user = _auth.currentUser;
    if (user == null) return;
    displayName.value = user.displayName ?? 'Student';
    email.value = user.email ?? '';
    photoUrl.value = user.photoURL ?? '';
  }

  /// Uses the `paid` flag to split completed vs upcoming lessons
  Future<void> _loadBookingStats() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snap =
        await _db
            .collection('booking')
            .where('userId', isEqualTo: user.uid)
            .get();

    final docs = snap.docs;
    totalBookings.value = docs.length;

    // completed = paid == true
    final doneCount =
        docs.where((d) => (d.data()['paid'] ?? false) as bool).length;
    // upcoming = paid == false
    final upcomingCount = docs.length - doneCount;

    completedLessons.value = doneCount;
    upcomingLessons.value = upcomingCount;
  }

  Future<void> _loadUpcomingLessons() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snap =
        await _db
            .collection('booking')
            .where('userId', isEqualTo: user.uid)
            .where('paid', isEqualTo: false)
            .orderBy('date')
            .limit(5)
            .get();

    upcomingList.value =
        snap.docs.map((doc) {
          final d = doc.data();
          return {
            'name': d['name'] ?? 'Instructor',
            'date': d['date'] as String? ?? '',
            'time': d['time'] as String? ?? '',
            'dateRaw': d['date'] as String? ?? '',
            'timeRaw': d['time'] as String? ?? '',
            'bookingId': doc.id,
            'instructorId': d['instructorId'] as String? ?? '',
          };
        }).toList();
  }

  /// Pick & upload a new profile picture
  Future<void> changeProfilePicture() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;

    final uid = _auth.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref('user_profiles/$uid.jpg');
    final file = File(img.path);
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    // update both Auth and Firestore (if you store user docs)
    await _auth.currentUser!.updatePhotoURL(url);
    await _db.collection('users').doc(uid).update({'photoURL': url});

    photoUrl.value = url;
  }

  /// Rename display name
  Future<void> updateDisplayName(String name) async {
    final uid = _auth.currentUser!.uid;
    await _auth.currentUser!.updateDisplayName(name);
    await _db.collection('users').doc(uid).update({'displayName': name});
    displayName.value = name;
  }

  /// Public re-load if ever needed
  Future<void> loadAll() async => _loadAll();
}
