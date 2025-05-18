import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';

class InstructorController extends GetxController {
  var instructors = <Map<String, dynamic>>[].obs;
  var filteredInstructors = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var isCenterVerified = false.obs;

  late StreamSubscription instructorSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _listenToInstructors();
    fetchCenterVerificationStatus();
    ever(searchQuery, (_) => _filterInstructors());
  }

  Future<void> fetchCenterVerificationStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('centers').doc(uid).get();
    if (doc.exists) {
      isCenterVerified.value = doc['verifiedAdmin'] ?? false;
    }
  }

  void _listenToInstructors() {
    final centerId = _auth.currentUser?.uid;
    if (centerId == null) {
      return;
    }

    _storage.write("centerId", centerId);

    try {
      instructorSubscription = _firestore
          .collection("instructors")
          .where("centerId", isEqualTo: centerId)
          .snapshots()
          .listen(
            (QuerySnapshot snapshot) {
              final docs =
                  snapshot.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    // Safely handle missing fields
                    return {
                      "id": doc.id,
                      "username": data["username"] ?? "Unknown",
                      "email": data["email"] ?? "",
                      "profileImage": data["photoURL"] ?? "",
                      "uid": data["uid"] ?? doc.id,
                    };
                  }).toList();

              instructors.value = docs;
              _filterInstructors();
            },
            onError: (error) {
              Get.snackbar(
                "Error",
                "Failed to load instructors. Please try again.",
              );
            },
          );
    } catch (e) {
      Get.snackbar("Error", "Failed to setup instructor listener: $e");
    }
  }

  void _filterInstructors() {
    if (searchQuery.value.isEmpty) {
      filteredInstructors.value = List.from(instructors);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredInstructors.value =
          instructors.where((instructor) {
            final username =
                instructor["username"]?.toString().toLowerCase() ?? "";
            final email = instructor["email"]?.toString().toLowerCase() ?? "";
            return username.contains(query) || email.contains(query);
          }).toList();
    }
  }

  Future<void> loadInstructors() async {
    isLoading.value = true;

    try {
      final centerId = _auth.currentUser?.uid;
      if (centerId == null) {
        Get.snackbar("Error", "Not authenticated as a center");
        isLoading.value = false;
        return;
      }

      final querySnapshot =
          await _firestore
              .collection("instructors")
              .where("centerId", isEqualTo: centerId)
              .get();

      instructors.value =
          querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            return {
              "id": doc.id,
              "username": data["username"] ?? "Unknown",
              "email": data["email"] ?? "",
              "profileImage": data["profileImage"] ?? "",
              "uid": data["uid"] ?? doc.id,
            };
          }).toList();

      _filterInstructors();
    } catch (e) {
      Get.snackbar("Error", "Failed to load instructors: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Update this method in your InstructorController class

  Future<void> deleteInstructor(String userEmail) async {
    try {
      // Debug logging

      // Validate email
      if (userEmail.isEmpty) {
        Get.snackbar("Error", "Email address is required for deletion");
        return;
      }

      // Check if user is authenticated
      User? user = FirebaseAuth.instance.currentUser;

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        // Refresh auth token
        await user!.getIdToken(true);

        // Call Cloud Function with email parameter
        final callable = FirebaseFunctions.instance.httpsCallable(
          'deleteInstructorUser',
        );

        // Create the parameters map with the email
        final params = {'userEmail': userEmail.trim()};

        final response = await callable.call(params);

        // Handle the response
        // ignore: avoid_print
        print("Function response: ${response.data}");

        // Close loading dialog
        Get.back();

        // Show success message
        Get.snackbar(
          "Success",
          "Instructor deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        // Refresh the list
        await loadInstructors();
      } catch (functionError) {
        // Close loading dialog
        if (Get.isDialogOpen == true) Get.back();

        Get.snackbar(
          "Error",
          "Failed to delete instructor: $functionError",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) Get.back();

      Get.snackbar(
        "Error",
        "Operation failed: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    instructorSubscription.cancel();
    super.onClose();
  }
}
