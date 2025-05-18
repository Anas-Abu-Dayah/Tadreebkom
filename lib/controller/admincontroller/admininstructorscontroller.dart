// lib/controller/admincontroller/admin_all_instructors_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAllInstructorsController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  var isLoading = true.obs;
  var allInstructors = <Map<String, dynamic>>[].obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllInstructors();
  }

  Future<void> fetchAllInstructors() async {
    try {
      isLoading.value = true;
      final snapshot = await firestore.collection('instructors').get();
      allInstructors.value =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
    } catch (e) {
      // handling errors
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteInstructor(String userEmail) async {
    try {
      if (userEmail.trim().isEmpty) {
        Get.snackbar("Error", "Email address is required for deletion");
        return;
      }
      final user = FirebaseAuth.instance.currentUser;
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await user!.getIdToken(true);

      final callable = FirebaseFunctions.instance.httpsCallable(
        'deleteInstructorUser',
      );
      await callable.call({'userEmail': userEmail.trim()});

      Get.back();
      Get.snackbar(
        "Success",
        "Instructor deleted",
        snackPosition: SnackPosition.BOTTOM,
      );
      await fetchAllInstructors();
    } catch (err) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar(
        "Error",
        "Failed to delete instructor: $err",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
