// lib/controller/usercontroller/centerprofileviewcontroller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/data/model/center_data.dart';

class CenterProfController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final String centerId;
  final isLoading = true.obs;
  final centerName = ''.obs;
  final centerImage = ''.obs;
  final aboutUs = ''.obs;
  final rating = 0.0.obs;
  final instructorCount = 0.obs;
  final studentCount = 0.obs;
  final lessonCount = 0.obs;
  final reviews = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) throw Exception('No arguments for CenterProfController');
    if (args.containsKey('centerId')) {
      centerId = args['centerId'];
    } else if (args.containsKey('center') && args['center'] is CenterData) {
      centerId = (args['center'] as CenterData).id;
    } else {
      throw Exception('Must provide centerId or center');
    }
    fetchCenterData();
  }

  Future<void> fetchCenterData() async {
    isLoading.value = true;
    try {
      final centerDoc = await _db.collection('centers').doc(centerId).get();
      if (!centerDoc.exists) throw Exception('Center not found');
      final data = centerDoc.data()!;
      centerName.value = data['drivingCenterName'] ?? '';
      centerImage.value = data['imageUrl'] ?? '';
      aboutUs.value = data['about'] ?? '';
      rating.value = (data['rating'] as num?)?.toDouble() ?? 0.0;

      await Future.wait([
        _loadInstructorCount(),
        _loadLessonAndStudentCounts(),
        _fetchReviews(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load center: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadInstructorCount() async {
    final snap =
        await _db
            .collection('instructors')
            .where('centerId', isEqualTo: centerId)
            .get();
    instructorCount.value = snap.docs.length;
  }

  Future<void> _loadLessonAndStudentCounts() async {
    final snap =
        await _db
            .collection('booking')
            .where('centerId', isEqualTo: centerId)
            .get();
    lessonCount.value = snap.docs.length;
    final uids = <String>{};
    for (var doc in snap.docs) {
      final uid = doc.data()['userId'] as String?;
      if (uid != null) uids.add(uid);
    }
    studentCount.value = uids.length;
  }

  Future<void> _fetchReviews() async {
    try {
      final snap =
          await _db
              .collection('reviews')
              .where('centerId', isEqualTo: centerId)
              .orderBy('createdAt', descending: true)
              .get();
      reviews.value =
          snap.docs.map((d) {
            final m = d.data();
            final ts = m['createdAt'];
            return {
              'reviewerName': m['reviewerName'] as String? ?? 'Anonymous',
              'rating': (m['rating'] as num?)?.toDouble() ?? 0.0,
              'comment': m['comment'] as String? ?? '',
              'createdAt': ts is Timestamp ? ts.toDate() : ts,
            };
          }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch reviews: $e');
    }
  }

  /// Adds a new review, looking up the user’s name in Firestore if available.
  Future<void> addReview(String comment, double starRating) async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to comment.');
      return;
    }

    // 1️⃣ Try to fetch a “username” (or “name”) field from your users collection
    String reviewerName;
    try {
      final userDoc = await _db.collection('users').doc(user.uid).get();
      final udata = userDoc.data();
      reviewerName =
          udata?['Fullname'] as String? ??
          udata?['name'] as String? ??
          user.displayName ??
          user.email?.split('@').first ??
          'Anonymous';
    } catch (_) {
      // fallback if the lookup fails
      reviewerName =
          user.displayName ?? user.email?.split('@').first ?? 'Anonymous';
    }

    // 2️⃣ Build review object
    final reviewData = {
      'centerId': centerId,
      'userId': user.uid,
      'reviewerName': reviewerName,
      'comment': comment,
      'rating': starRating,
      'createdAt': FieldValue.serverTimestamp(),
    };

    // 3️⃣ Write to Firestore
    try {
      await _db.collection('reviews').add(reviewData);
      await _fetchReviews();
      Get.snackbar('Thank you!', 'Your review has been posted.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to post review: $e');
    }
  }
}
