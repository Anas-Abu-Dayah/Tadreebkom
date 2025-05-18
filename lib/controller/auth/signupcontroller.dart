import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class Signupcontroller extends GetxController {
  signUp();
  goToSignIn();
  signInWithFacebook();
  signInWithGoogle();
}

class SignupcontrollerImp extends Signupcontroller {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController confirmpassword;
  late TextEditingController bdate;
  String? gender;

  @override
  Future<void> signUp() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      if (password.text != confirmpassword.text) {
        Get.snackbar("Error", "Passwords do not match.");
        return;
      }

      try {
        // 🔹 Create user in Firebase Auth
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );

        // 🔹 Get the UID of the newly created user
        String uid = credential.user!.uid;

        // 🔹 Store additional user data in Firestore
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "email": email.text,
          "phone": phone.text,
          "Fullname": username.text,
          "Bdate": bdate.text,
          "gender": gender,
          "created_at": FieldValue.serverTimestamp(),
        });

        // ✅ Redirect to the address page after successful signup
        Get.offNamed(AppRoute.addressstudent);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Error", "The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Error", "The account already exists for that email.");
        } else {
          Get.snackbar("Error", "Signup failed: ${e.message}");
        }
      } catch (e) {
        Get.snackbar("Error", "An unexpected error occurred: $e");
      }
    }
  }

  @override
  goToSignIn() {
    Get.offAllNamed(AppRoute.login);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  @override
  void onInit() {
    username = TextEditingController();
    password = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    bdate = TextEditingController();
    confirmpassword = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    phone.dispose();
    username.dispose();
    password.dispose();
    confirmpassword.dispose();
    bdate.dispose();
    super.dispose();
  }
}
