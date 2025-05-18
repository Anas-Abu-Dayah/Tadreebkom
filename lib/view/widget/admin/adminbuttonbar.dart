import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

class AdminScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AdminScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  static const _titles = ['Pending Centers', 'All Instructors', 'All Centers'];

  void _onTabTapped(int idx) {
    if (idx == currentIndex) return;
    switch (idx) {
      case 0:
        Get.offAllNamed(AppRoute.adminPendingCentersView);
        break;
      case 1:
        Get.offAllNamed(AppRoute.adminAllInstructorsView);
        break;
      case 2:
        Get.offAllNamed(AppRoute.adminAllCentersView);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut;
          Get.offAllNamed(AppRoute.login);
        },
        backgroundColor: Colors.redAccent,
        shape: CircleBorder(),
        child: Icon(Icons.logout_outlined),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titles[currentIndex], textAlign: TextAlign.center),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orangeAccent,
        unselectedFontSize: 3,
        selectedFontSize: 4,
        showSelectedLabels: false,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'Instructors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Centers',
          ),
        ],
      ),
    );
  }
}
