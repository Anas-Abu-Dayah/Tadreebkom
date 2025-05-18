import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/data/model/card_data.dart';

class NewCardController extends GetxController {
  // Controllers for the card details input
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cardholderNameController = TextEditingController();
  final cvvController = TextEditingController();

  // Firestore and Firebase Authentication instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser; // Get current user

  @override
  void onInit() {
    super.onInit();
    // Listen to text field changes and update reactive variables
    cardNumberController.addListener(() {
      // Update card number as user types
    });
    expiryDateController.addListener(() {
      // Update expiry date as user types
    });
    cardholderNameController.addListener(() {
      // Update cardholder name as user types
    });
    cvvController.addListener(() {
      // Update CVV as user types
    });
  }

  // Method to add the new card to Firestore
  void addCard() async {
    // Check if all fields are filled
    if (cardNumberController.text.isEmpty ||
        expiryDateController.text.isEmpty ||
        cardholderNameController.text.isEmpty ||
        cvvController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields.');
      return;
    }

    final card = CardData(
      cardholderName: cardholderNameController.text,
      cardNumber: cardNumberController.text,
      expiryDate: expiryDateController.text,
      cvv: cvvController.text,
    );

    // Save to Firebase Firestore
    if (currentUser != null) {
      try {
        final userId = currentUser!.uid; // Get current user ID
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cards')
            .add({
              'cardholderName': card.cardholderName,
              'cardNumber': card.cardNumber,
              'expiryDate': card.expiryDate,
              'cvv': card.cvv,
            });
        Get.back(result: card); // Return to previous screen with the added card
      } catch (e) {
        Get.snackbar('Error', 'Failed to save card: $e');
      }
    }
  }

  @override
  void onClose() {
    // Dispose controllers to release resources
    cardNumberController.dispose();
    expiryDateController.dispose();
    cardholderNameController.dispose();
    cvvController.dispose();
    super.onClose();
  }
}
