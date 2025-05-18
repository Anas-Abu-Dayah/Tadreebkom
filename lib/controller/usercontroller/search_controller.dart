import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tadreebkomapplication/data/model/center_data.dart';

class SearchController extends GetxController {
  final searchTextController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilters = <String>[].obs;
  final filterCategories = const ['Nearby', 'Top Rated'];

  /// All centers loaded once from Firestore
  RxList<CenterData> centers = <CenterData>[].obs;

  /// Distance (in meters) from user for each center.id
  RxMap<String, double> distances = <String, double>{}.obs;

  Position? userLocation;

  @override
  void onInit() {
    super.onInit();
    _loadCenters();
    _determinePosition();
    _applyInitialFilters();
  }

  /// 1️⃣ Fetch all centers
  Future<void> _loadCenters() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('centers').get();
      centers.value =
          snap.docs.map((d) => CenterData.fromMap(d.data(), d.id)).toList();
      _computeDistances();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load centers: $e');
    }
  }

  /// 2️⃣ Get user location for “Nearby” filter
  Future<void> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permission denied.');
        return;
      }
    }
    if (perm == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permission permanently denied.');
      return;
    }
    userLocation = await Geolocator.getCurrentPosition();
    _computeDistances();
  }

  /// 3️⃣ Compute distances after both centers & userLocation are set
  void _computeDistances() {
    if (userLocation == null) return;
    distances.clear();
    for (var c in centers) {
      final d = Geolocator.distanceBetween(
        userLocation!.latitude,
        userLocation!.longitude,
        c.latitude,
        c.longitude,
      );
      distances[c.id] = d;
    }
  }

  /// 4️⃣ Apply any initialFilter passed via Get.arguments
  void _applyInitialFilters() {
    final args = Get.arguments;
    if (args != null && args['initialFilter'] != null) {
      toggleFilter(args['initialFilter'] as String);
    }
  }

  void updateSearchQuery(String q) => searchQuery.value = q;

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    selectedFilters.clear();
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
      if (filter == 'Nearby') {
        _determinePosition();
      }
    }
    selectedFilters.refresh();
  }

  /// Combines text‐search + Nearby + Top Rated into one list for the UI
  List<CenterData> get displayedCenters {
    var list = centers.toList();

    // text search
    final q = searchQuery.value.toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((c) => c.name.toLowerCase().contains(q)).toList();
    }

    // Nearby sort
    if (selectedFilters.contains('Nearby') && userLocation != null) {
      list.sort((a, b) {
        final da = distances[a.id] ?? double.infinity;
        final db = distances[b.id] ?? double.infinity;
        return da.compareTo(db);
      });
    }

    // Top Rated sort
    if (selectedFilters.contains('Top Rated')) {
      list.sort((a, b) => (b.rating).compareTo(a.rating));
    }

    return list;
  }
}
