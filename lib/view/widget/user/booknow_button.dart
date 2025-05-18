import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/booking_controller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

Widget buildBookNowButton(BookingController controller) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => Get.toNamed(AppRoute.checkout),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF06543), Color(0xFFFFBE3D)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 50),
          child: const Text(
            'Book Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
