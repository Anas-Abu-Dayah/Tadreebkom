import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

class CenterProfileController extends GetxController {
  // Observable variables
  var centerName = ''.obs;
  var centerImage = ''.obs;
  var aboutUs = ''.obs;
  var rating = 0.0.obs;
  var instructorCount = 0.obs;
  var studentCount = 0.obs;
  var lessonCount = 0.obs;
  var reviews = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;
  GetStorage storage = GetStorage();

  late String userId;

  @override
  void onInit() {
    super.onInit();
    fetchUserId();
    final centerId = FirebaseAuth.instance.currentUser!.uid;
    GetStorage().write("centerId", centerId);
  }

  // User Management
  void fetchUserId() {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        userId = user.uid;

        fetchCenterData();
      } else {
        Get.snackbar("Error", "User not logged in");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user ID: $e");
    }
  }

  // Center Profile Operations
  Future<void> fetchCenterData() async {
    try {
      isLoading.value = true;
      final doc =
          await FirebaseFirestore.instance
              .collection('centers')
              .doc(userId)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        centerName.value = data['drivingCenterName'] ?? 'Center Name';
        centerImage.value = data['imageUrl'] ?? '';
        aboutUs.value = data['about'] ?? '';
        rating.value = data['rating']?.toDouble() ?? 0.0;

        await _fetchInstructorCount();
        await _fetchStudentCount();
        await _fetchLessonCount();
        await _fetchReviews();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch center data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoute.login);
  }

  // Image Handling
  Future<void> uploadImage(File imageFile) async {
    try {
      if (!imageFile.path.endsWith('.jpg') &&
          !imageFile.path.endsWith('.png')) {
        throw "Please select a valid image file (JPG/PNG)";
      }

      isLoading.value = true;
      final ref = FirebaseStorage.instance
          .ref()
          .child('center_images')
          .child('$userId.jpg');

      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('centers').doc(userId).update(
        {'imageUrl': url},
      );

      centerImage.value = url;
      Get.snackbar("Success", "Image uploaded successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteImage() async {
    try {
      isLoading.value = true;
      if (centerImage.value.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(centerImage.value).delete();
        await FirebaseFirestore.instance
            .collection('centers')
            .doc(userId)
            .update({'imageUrl': ''});
        centerImage.value = '';
        Get.snackbar("Success", "Image removed");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete image: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // UI Image Picker
  void showImageOptions() {
    Get.bottomSheet(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            if (centerImage.value.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  deleteImage();
                },
              ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      Get.back();
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        await uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  // About Us Section
  Future<void> updateAboutUs(String newText) async {
    try {
      isUpdating.value = true;
      await FirebaseFirestore.instance.collection('centers').doc(userId).update(
        {'about': newText},
      );
      aboutUs.value = newText;
      Get.snackbar("Success", "About Us updated");
    } catch (e) {
      Get.snackbar("Error", "Failed to update About Us: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  void editAboutUs() {
    Get.defaultDialog(
      title: "Edit About Us",
      content: Column(
        children: [
          TextField(
            controller: TextEditingController(text: aboutUs.value),
            decoration: const InputDecoration(
              hintText: "Enter new About Us text",
            ),
            maxLines: 5,
            onChanged: (value) => aboutUs.value = value,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (aboutUs.value.trim().isNotEmpty) {
                updateAboutUs(aboutUs.value);
                Get.back();
              } else {
                Get.snackbar("Error", "About Us cannot be empty");
              }
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Future<void> _fetchInstructorCount() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('instructors')
            .where('centerId', isEqualTo: userId)
            .get();
    instructorCount.value = snapshot.docs.length;
  }

  Future<void> _fetchStudentCount() async {
    final snap =
        await FirebaseFirestore.instance
            .collection('booking')
            .where('centerId', isEqualTo: userId)
            .get();
    lessonCount.value = snap.docs.length;
    final uids = <String>{};
    for (var doc in snap.docs) {
      final uid = doc.data()['userId'] as String?;
      if (uid != null) uids.add(uid);
    }
    studentCount.value = uids.length;
  }

  Future<void> _fetchLessonCount() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('booking')
            .where('centerId', isEqualTo: userId)
            .get();
    lessonCount.value = snapshot.docs.length;
  }

  Future<void> updateCenterName(String newName) async {
    try {
      isUpdating.value = true;
      await FirebaseFirestore.instance.collection('centers').doc(userId).update(
        {'drivingCenterName': newName},
      );
      centerName.value = newName;
      Get.snackbar("Success", "Center name updated");
    } catch (e) {
      Get.snackbar("Error", "Failed to update name: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> _fetchReviews() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('reviews')
              .where('centerId', isEqualTo: userId)
              .orderBy('createdAt', descending: true) // Optional: newest first
              .get();

      reviews.value =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'reviewerName': data['reviewerName'] ?? 'Anonymous',
              'rating': data['rating'] ?? 0.0,
              'comment': data['comment'] ?? '',
              'createdAt': data['createdAt'],
            };
          }).toList();

      await _updateAverageRating();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch reviews: $e");
    }
  }

  Future<void> _updateAverageRating() async {
    if (reviews.isEmpty) {
      rating.value = 0.0;
      return;
    }

    final total = reviews.fold(
      0.0,
      (summ, review) => summ + (review['rating'] ?? 0.0),
    );
    final average = total / reviews.length;

    await FirebaseFirestore.instance.collection('centers').doc(userId).update({
      'rating': average,
    });

    rating.value = average;
  }
}
