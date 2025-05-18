import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminPendingCentersController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  var isLoading = true.obs;
  var pendingCenters = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingCenters();
  }

  Future<void> fetchPendingCenters() async {
    try {
      isLoading.value = true;
      final snapshot =
          await _firestore
              .collection('centers')
              .where('verifiedAdmin', isEqualTo: false)
              .get();

      pendingCenters.value =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
    } catch (e) {
      // handle error (e.g. show a snackbar)
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCenter(String userEmail) async {
    try {
      if (userEmail.trim().isEmpty) {
        Get.snackbar("Error", "Email address is required for deletion");
        return;
      }

      // Ensure fresh token
      final user = FirebaseAuth.instance.currentUser;
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await user!.getIdToken(true);

      final callable = FirebaseFunctions.instance.httpsCallable('deleteCenter');
      await callable.call({'userEmail': userEmail.trim()});

      Get.back(); // dismiss loading
      Get.snackbar(
        "Success",
        "Instructor deleted",
        snackPosition: SnackPosition.BOTTOM,
      );
      await fetchPendingCenters();
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
