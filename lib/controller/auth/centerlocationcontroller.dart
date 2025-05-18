import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/core/functions/generateotp.dart';
import 'package:tadreebkomapplication/core/functions/sendotp.dart';

abstract class CenterLocationController extends GetxController {
  void confirmAddressLocation();
  void getCurrentLocation();
  Future<void> sendOtpVerification();
}

class CenterLocationControllerImp extends CenterLocationController {
  Position? position;
  CameraPosition? cameraPosition;
  GoogleMapController? gmc;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  var street = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var country = ''.obs;

  var isLoading = false.obs;
  Set<Marker> markers = {};

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  @override
  void confirmAddressLocation() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String otp = generateOtp(); // Generate OTP
        await saveCenterLocationToFirestore(
          user.uid,
          otp,
        ); // Save location + OTP
        await sendOtpWithSendGrid(user.email!, otp); // Send OTP via email
        Get.offNamed(AppRoute.verifycodecenter); // Navigate to OTP verification
      } else {
        Get.snackbar("Error", "User not logged in.");
      }
    } else {
      Get.snackbar("Error", "Please enter a valid address.");
    }
  }

  Future<void> saveCenterLocationToFirestore(
    String centerId,
    String otp,
  ) async {
    try {
      DocumentReference centerRef = FirebaseFirestore.instance
          .collection('centers')
          .doc(centerId);

      await centerRef.set({
        "street": street.value,
        "city": city.value,
        "state": state.value,
        "country": country.value,
        "latitude": position?.latitude,
        "longitude": position?.longitude,
        "otp": otp, // Store OTP for verification
        "otpVerified": false, // Mark as not verified yet
        "timestamp": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      Get.snackbar("Error", "Failed to save location.");
    }
  }

  @override
  Future<void> sendOtpVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      Get.snackbar("Error", "No user is logged in or email is missing.");
      return;
    }
    final box = GetStorage();

    final String otp = generateOtp();
    box.write("center_otp", otp); // ✅ Save OTP locally
    await sendOtpWithSendGrid(user.email!, otp);
    Get.offNamed(AppRoute.verifycodecenter);

    Get.snackbar("OTP Sent", "Check your email for the OTP.");
  }

  @override
  getCurrentLocation() async {
    isLoading.value = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      isLoading.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied.');
        isLoading.value = false;
        return;
      }
    }

    try {
      position = await Geolocator.getCurrentPosition();
      cameraPosition = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        zoom: 14.0,
      );

      await fetchAddressFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      addMarker(
        LatLng(position!.latitude, position!.longitude),
        "Your Location",
      );

      update();
      gmc?.moveCamera(CameraUpdate.newCameraPosition(cameraPosition!));
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        street.value = place.street ?? '';
        city.value = place.locality ?? '';
        state.value = place.subLocality ?? '';
        country.value = place.country ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch address details: $e');
    }
  }

  void addMarker(LatLng position, String title) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("selected_location"),
        position: position,
        infoWindow: InfoWindow(title: title),
      ),
    );
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    gmc = controller;
  }

  void onMapTap(LatLng tappedPosition) {
    addMarker(tappedPosition, "Selected Location");

    fetchAddressFromCoordinates(
      tappedPosition.latitude,
      tappedPosition.longitude,
    );

    gmc?.moveCamera(CameraUpdate.newLatLng(tappedPosition));

    update();
  }
}
