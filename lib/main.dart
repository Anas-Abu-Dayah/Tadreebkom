import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadreebkomapplication/login_binding.dart';
import 'package:tadreebkomapplication/routes.dart';
import 'package:tadreebkomapplication/view/screen/admin/adminpendinginstructors.dart';
import 'package:tadreebkomapplication/view/screen/auth/login.dart';
import 'package:tadreebkomapplication/view/screen/centerpage/centerprofilepage.dart';
import 'package:tadreebkomapplication/view/screen/instructor/instructor_navbar_view.dart';
import 'package:tadreebkomapplication/view/screen/user/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Firebase.initializeApp();

  await GetStorage.init();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  bool isSignedIn = false;
  bool isVerified = false;
  String? userRole;

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    isSignedIn = true;
    final email = user.email;

    if (email != null) {
      final userSnap =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();
      final centerSnap =
          await FirebaseFirestore.instance
              .collection('centers')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();
      final adminSnap =
          await FirebaseFirestore.instance
              .collection('Admin')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();
      final instructorSnap =
          await FirebaseFirestore.instance
              .collection('Instructor')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (userSnap.docs.isNotEmpty) {
        isVerified = userSnap.docs.first['emailVerified'] ?? false;
        userRole = 'User';
      } else if (centerSnap.docs.isNotEmpty) {
        isVerified = centerSnap.docs.first['emailVerified'] ?? false;
        userRole = 'Center';
      } else if (adminSnap.docs.isNotEmpty) {
        isVerified = adminSnap.docs.first['EmailVerified'] ?? false;
        userRole = 'Admin';
      } else if (instructorSnap.docs.isNotEmpty) {
        isVerified = instructorSnap.docs.first['emailVerified'] ?? false;
        userRole = 'Instructor';
      }
    }

    if (!isVerified) {
      await FirebaseAuth.instance.signOut();
      isSignedIn = false;
    }
  }

  runApp(
    MyApp(isSignedIn: isSignedIn, isVerified: isVerified, userRole: userRole),
  );
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;
  final bool isVerified;
  final String? userRole;

  const MyApp({
    super.key,
    required this.isSignedIn,
    required this.isVerified,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    Widget homePage;

    if (!isSignedIn || !isVerified) {
      homePage = const Login();
    } else {
      switch (userRole) {
        case 'Admin':
          homePage = AdminPendingCentersView();
          break;
        case 'Student':
          homePage = const HomeView();
          break;
        case 'Center':
          homePage = CenterProfilePage();
          break;
        case 'Instructor':
          homePage = const InstructorNavBarView();
          break;
        default:
          // fallback for other roles (e.g. general user or center)
          homePage = const Login();
      }
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: LoginBinding(),
      getPages: routes,
      home: homePage,
    );
  }
}
