// lib/controller/usercontroller/centers_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/data/model/center_data.dart';

class CentersController extends GetxController {
  /// The user’s current lat/lng, loaded from Firestore.
  final userLatitude = 0.0.obs;
  final userLongitude = 0.0.obs;

  /// All centers loaded from Firestore.
  var centers = <CenterData>[].obs;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _loadAndFilter();
  }

  /// 1) Load user location
  /// 2) Fetch all centers
  /// 3) Filter by proximity
  Future<void> _loadAndFilter() async {
    await _fetchUserLocation();
    await _fetchCenters();
    _applyProximityFilter();
  }

  /// Pull the signed-in user’s lat/lng from Firestore.
  Future<void> _fetchUserLocation() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return;
    }
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        return;
      }
      final data = doc.data()!;
      final lat = data['latitude'];
      final lng = data['longitude'];
      userLatitude.value = (lat is num) ? lat.toDouble() : userLatitude.value;
      userLongitude.value = (lng is num) ? lng.toDouble() : userLongitude.value;
    } catch (e) {
      // catch errors
    }
  }

  /// Fetch all centers from Firestore into `centers`.
  Future<void> _fetchCenters() async {
    try {
      final snap = await _firestore.collection('centers').get();
      centers.value =
          snap.docs.map((doc) {
            final map = doc.data();
            return CenterData.fromMap(map, doc.id);
          }).toList();
    } catch (e) {
      // catch errors
    }
  }

  /// Remove any center further than 13 km from the user.
  void _applyProximityFilter() {
    if (userLatitude.value == 0.0 && userLongitude.value == 0.0) {
      return;
    }

    final filtered =
        centers.where((c) {
          final dist = Geolocator.distanceBetween(
            userLatitude.value,
            userLongitude.value,
            c.latitude,
            c.longitude,
          );
          return dist <= 15_000; // 15 km
        }).toList();

    centers.value = filtered;
  }
}
