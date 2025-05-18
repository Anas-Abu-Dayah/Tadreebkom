// lib/controller/centercontroller/view_instructor_profile_controller.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ViewInstructorProfileController extends GetxController {
  final String instructorId;
  ViewInstructorProfileController(this.instructorId);

  final _db = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var instructorImage = ''.obs;
  var instructorName = ''.obs;
  var bio = ''.obs;

  var studentCount = 0.obs;
  var lessonCount = 0.obs;
  var rating = 0.0.obs;

  var reviews = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInstructorData();
  }

  Future<void> fetchInstructorData() async {
    isLoading.value = true;

    try {
      final doc = await _db.collection('instructors').doc(instructorId).get();
      if (!doc.exists) {
      } else {
        final data = doc.data()!;
        instructorImage.value = data['photoURL'] as String? ?? '';
        instructorName.value = data['username'] as String? ?? '';
        bio.value = data['bio'] as String? ?? '';
      }
    } catch (e) {
      // catch errors
    }

    try {
      final fbSnap =
          await _db
              .collection('instructors')
              .doc(instructorId)
              .collection('studentFeedback')
              .orderBy('timestamp', descending: true)
              .get();

      lessonCount.value = fbSnap.docs.length;

      var sum = 0.0;
      final students = <String>{};
      final tmp = <Map<String, dynamic>>[];

      for (final d in fbSnap.docs) {
        final m = d.data();
        final r = (m['rating'] ?? 0).toDouble();
        final c = (m['comment'] as String?) ?? '';
        final sid = (m['studentId'] as String?) ?? '';
        final ts = (m['timestamp'] as Timestamp?)?.toDate();

        if (r > 0) {
          tmp.add({
            'rating': r,
            'comment': c,
            'createdAt': ts == null ? '' : DateFormat.yMd().add_jm().format(ts),
          });
          sum += r;
          if (sid.isNotEmpty) students.add(sid);
        }
      }

      reviews.value = tmp;
      studentCount.value = students.length;
      rating.value = tmp.isEmpty ? 0.0 : sum / tmp.length;
    } catch (e) {
      // catch errors
    }

    isLoading.value = false;
  }

  /// Pick & upload a new profile picture
  Future<void> changeProfilePicture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    isLoading.value = true;
    try {
      final ref = FirebaseStorage.instance.ref(
        'instructor_profiles/$instructorId.jpg',
      );
      await ref.putFile(File(picked.path));
      final url = await ref.getDownloadURL();
      await _db.collection('instructors').doc(instructorId).update({
        'photoURL': url,
      });
      instructorImage.value = url;
      Get.snackbar('Success', 'Profile picture updated');
    } catch (e) {
      Get.snackbar('Error', 'Could not upload picture: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateInstructorName(String newName) async {
    try {
      await _db.collection('instructors').doc(instructorId).update({
        'username': newName,
      });
      instructorName.value = newName;
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Could not update name: $e');
    }
  }

  Future<void> updateBio(String newBio) async {
    try {
      await _db.collection('instructors').doc(instructorId).update({
        'bio': newBio,
      });
      bio.value = newBio;
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Could not update bio: $e');
    }
  }
}
