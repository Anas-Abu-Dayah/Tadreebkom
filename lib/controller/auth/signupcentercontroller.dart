import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class SignupCenterController extends GetxController {
  Future<void> signUpCenter();
  void goToSignIn();
}

class SignupCenterControllerImp extends SignupCenterController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController drivingCenterName;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController confirmpassword;
  late TextEditingController license;

  File? image;
  final imagePicker = ImagePicker();
  String hinttext = "Press on add button to insert image";

  /// Select an image from the gallery
  Future<void> pickImage() async {
    final picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      image = File(picked.path);
      hinttext = "Image selected";
      update();
    } else {
      Get.snackbar("Error", "No image selected");
    }
  }

  /// Sign up a driving center
  @override
  Future<void> signUpCenter() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      if (image == null) {
        Get.snackbar("Error", "Please select an image before signing up.");
        return;
      }

      try {
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.text.trim(),
              password: password.text.trim(),
            );

        // Upload the image to ImgBB and get URL
        String imageUrl = await uploadImageToFirebaseStorage(
          credential.user!.uid,
        );

        await FirebaseFirestore.instance
            .collection("centers")
            .doc(credential.user!.uid)
            .set({
              "id": credential.user!.uid,
              "drivingCenterName": drivingCenterName.text,
              "email": email.text,
              "phone": phone.text,
              "address": address.text,
              "license": imageUrl.toString(),
              "imageUrl": "",
              "verifiedAdmin": false,
              "createdAt": FieldValue.serverTimestamp(),
            });

        Get.snackbar("Success", "Signup completed successfully!");
        Get.offNamed(AppRoute.addresscenter);
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Error", e.message ?? "Signup failed.");
      } catch (e) {
        Get.snackbar("Error", "Signup failed: $e");
      }
    } else {
      Get.snackbar("Error", "Please enter all details.");
    }
  }

  /// Upload image to ImgBB and return the image URL
  Future<String> uploadImageToFirebaseStorage(String uid) async {
    if (image == null) {
      throw "❌ No image selected";
    }

    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        "center_images_Licenes/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      UploadTask uploadTask = storageRef.putFile(image!);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw "Failed to upload image to Firebase Storage: $e";
    }
  }

  /// Navigate to Sign In page
  @override
  void goToSignIn() {
    Get.offAllNamed(AppRoute.login);
  }

  /// Initialize controllers
  @override
  void onInit() {
    username = TextEditingController();
    password = TextEditingController();
    drivingCenterName = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    address = TextEditingController();
    license = TextEditingController();
    confirmpassword = TextEditingController();
    super.onInit();
  }

  /// Dispose controllers
  @override
  void dispose() {
    drivingCenterName.dispose();
    email.dispose();
    phone.dispose();
    address.dispose();
    username.dispose();
    password.dispose();
    confirmpassword.dispose();
    license.dispose();
    super.dispose();
  }
}
