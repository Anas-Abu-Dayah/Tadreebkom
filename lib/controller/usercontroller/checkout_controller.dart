import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tadreebkomapplication/controller/usercontroller/home_controller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/data/model/card_data.dart';

class CheckoutController extends GetxController {
  final selectedPaymentMethod = 'Card'.obs;
  final selectedCard = Rxn<CardData>();
  final cards = <CardData>[].obs;
  final totalAmount = 7.0;
  final storage = GetStorage();
  final controller = Get.put(HomeController());

  final _firestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  String? selectedCenterId;
  String? selectedLocation;
  String? phonenumber;
  double? latitude;
  double? longitude;

  @override
  void onInit() {
    super.onInit();
    selectedCenterId = storage.read('selectedCenter') as String?;
    if (_currentUser != null) {
      fetchCards(_currentUser.uid);
      fetchUserStateLocation();
      fetchUserPhonenumber();
      fetchUserLatitude();
      fetchUserlongitude();
    }
  }

  Future<void> fetchUserStateLocation() async {
    try {
      final uid = _currentUser?.uid;
      if (uid == null) return;

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final state = userDoc.data()?['state'];
        if (state != null && state is String) {
          selectedLocation = state;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user state: $e');
    }
  }

  Future<void> fetchUserPhonenumber() async {
    try {
      final uid = _currentUser?.uid;
      if (uid == null) return;

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final phone = userDoc.data()?['phone'];
        if (phone != null && phone is String) {
          phonenumber = phone;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user state: $e');
    }
  }

  Future<void> fetchUserLatitude() async {
    try {
      final uid = _currentUser?.uid;
      if (uid == null) return;

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final lat = userDoc.data()?['latitude'];
        if (lat != null && lat is double) {
          latitude = lat;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user state: $e');
    }
  }

  Future<void> fetchUserlongitude() async {
    try {
      final uid = _currentUser?.uid;
      if (uid == null) return;

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final long = userDoc.data()?['longitude'];
        if (long != null && long is double) {
          longitude = long;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user state: $e');
    }
  }

  Future<void> fetchCards(String userId) async {
    try {
      final snap =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cards')
              .get();
      cards.value = snap.docs.map((d) => CardData.fromMap(d.data())).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cards: $e');
    }
  }

  void selectPaymentMethod(String m) {
    selectedPaymentMethod.value = m;
    if (m == 'Cash') selectedCard.value = null;
  }

  void selectCard(CardData card) => selectedCard.value = card;

  void addCard(CardData card) {
    cards.add(card);
    selectedCard.value = card;
    if (_currentUser != null) {
      _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('cards')
          .add({
            'cardholderName': card.cardholderName,
            'cardNumber': card.cardNumber,
            'expiryDate': card.expiryDate,
            'cvv': card.cvv,
          });
    }
  }

  String convertTo24HourFormat(String time12h) {
    final cleaned = time12h.replaceAll(RegExp(r'\s+'), ' ').trim();
    try {
      final dt = DateFormat.jm('en_US').parse(cleaned);
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return time12h;
    }
  }

  String normalizeAmPm(String s) {
    final ascii = s.replaceAll(RegExp(r'[\u00A0\u202F]'), ' ');
    return ascii.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> blockInstructorSlot(
    String instructorId,
    String date,
    String rawSelectedTime,
  ) async {
    final ref = _firestore.collection('instructors').doc(instructorId);
    final doc = await ref.get();
    if (!doc.exists) return;

    final availability = (doc.data()?['availability'] as List<dynamic>?) ?? [];
    bool updated = false;

    String normalize(String s) =>
        s
            .replaceAll(RegExp(r'[\u00A0\u202F]'), ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();

    final normSelected = normalize(rawSelectedTime);

    final updatedAvailability =
        availability
            .map((day) {
              if (day['date'] == date) {
                final times = (day['times'] as List<dynamic>?) ?? [];
                final newTimes =
                    times.map((slot) {
                      final rawSlot = slot['time'].toString();
                      final normSlot = normalize(rawSlot);

                      if (!updated && normSlot == normSelected) {
                        updated = true;
                        return {'time': slot['time'], 'available': false};
                      }
                      return Map<String, dynamic>.from(slot);
                    }).toList();
                return {'date': day['date'], 'times': newTimes};
              }
              return Map<String, dynamic>.from(day);
            })
            .cast<Map<String, dynamic>>()
            .toList();

    if (!updated) {}
    await ref.update({'availability': updatedAvailability});
  }

  Future<void> payNow() async {
    if (selectedPaymentMethod.value == 'Card' && selectedCard.value == null) {
      Get.snackbar('Error', 'Please select or add a card.');
      return;
    }

    final instructorId = storage.read('selectedInstructorId');
    final rawDate = storage.read('selecteddate');
    final rawTime = storage.read('selectedtime');

    if (selectedCenterId == null ||
        instructorId == null ||
        rawDate == null ||
        rawTime == null) {
      Get.snackbar('Error', 'Booking information is missing or incomplete.');
      return;
    }

    final bookingDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.parse(rawDate));
    final bookingTime = convertTo24HourFormat(rawTime);

    final bookingData = {
      'userId': _currentUser!.uid,
      'centerId': selectedCenterId,
      'instructorId': instructorId,
      'date': bookingDate,
      'time': bookingTime,
      'amount': totalAmount,
      'phone': phonenumber ?? 'Unknown',
      'Location': selectedLocation ?? 'Unknown',
      'latitude': latitude,
      'longitude': longitude,
      'status': 'pending',
      'paid': selectedPaymentMethod.value == 'Card',
    };

    if (selectedPaymentMethod.value == 'Card') {
      bookingData['cardDetails'] = {
        'cardholderName': selectedCard.value!.cardholderName,
        'cardNumber': selectedCard.value!.cardNumber,
        'expiryDate': selectedCard.value!.expiryDate,
      };
    }

    try {
      await _firestore.collection('booking').add(bookingData);
      await blockInstructorSlot(instructorId, bookingDate, rawTime);
      Get.snackbar('Success', 'Booking completed successfully!');
      controller.fetchAppointments();
      Get.offAllNamed(AppRoute.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save booking: $e');
    }
  }
}
