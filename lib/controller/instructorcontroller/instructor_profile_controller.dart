// lib/controller/instructorcontroller/instructor_profile_controller.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InstructorProfileController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Loading flag
  var isLoading = false.obs;

  /// Profile fields
  var instructorImage = ''.obs;
  var instructorName = ''.obs;
  var bio = ''.obs;

  /// Stats
  var studentCount = 0.obs;
  var lessonCount = 0.obs;
  var rating = 0.0.obs;

  /// All reviews
  var reviews = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInstructorData();
  }

  Future<void> fetchInstructorData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    isLoading.value = true;

    // 1️⃣ Load instructor doc
    final doc = await _db.collection('instructors').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      instructorImage.value = data['photoURL'] as String? ?? '';
      instructorName.value = data['username'] as String? ?? 'You';
      bio.value = data['bio'] as String? ?? '';
    }

    // 2️⃣ Count lessons from bookings
    final bookingSnap =
        await _db
            .collection('booking')
            .where('instructorId', isEqualTo: uid)
            .get();
    lessonCount.value = bookingSnap.docs.length;

    // 3️⃣ Pull feedback from sub‐collection
    final fbSnap =
        await _db
            .collection('instructors')
            .doc(uid)
            .collection('studentFeedback')
            .get();

    double sumRatings = 0;
    final students = <String>{};
    final tmp = <Map<String, dynamic>>[];

    for (var d in fbSnap.docs) {
      final m = d.data();
      final r = (m['rating'] ?? 0).toDouble();
      final c = (m['comment'] as String?) ?? '';
      final sid = m['studentId'] as String? ?? '';
      final ts =
          m['timestamp'] is Timestamp
              ? (m['timestamp'] as Timestamp).toDate()
              : null;

      if (r > 0) {
        tmp.add({
          'rating': r,
          'comment': c,
          'studentId': sid,
          'createdAt': ts?.toString() ?? '',
        });
        sumRatings += r;
        if (sid.isNotEmpty) students.add(sid);
      }
    }

    reviews.value = tmp;
    studentCount.value = students.length;
    rating.value = tmp.isEmpty ? 0.0 : sumRatings / tmp.length;

    isLoading.value = false;
  }

  /// Pick & upload a new profile picture
  Future<void> changeProfilePicture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final uid = _auth.currentUser!.uid;
    final file = File(picked.path);
    final ref = FirebaseStorage.instance.ref('instructor_profiles/$uid.jpg');

    isLoading.value = true;
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    await _db.collection('instructors').doc(uid).update({'photoURL': url});
    instructorImage.value = url;
    isLoading.value = false;

    Get.snackbar('Success', 'Profile picture updated.');
  }

  /// Rename
  Future<void> updateInstructorName(String newName) async {
    final uid = _auth.currentUser!.uid;
    await _db.collection('instructors').doc(uid).update({'username': newName});
    instructorName.value = newName;
    Get.back();
  }

  /// Edit bio
  Future<void> updateBio(String newBio) async {
    final uid = _auth.currentUser!.uid;
    await _db.collection('instructors').doc(uid).update({'bio': newBio});
    bio.value = newBio;
    Get.back();
  }
}
