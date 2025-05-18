import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tadreebkomapplication/controller/usercontroller/checkout_controller.dart';

Widget buildPayNowButton(CheckoutController controller) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: controller.payNow,
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
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withAlpha((0.3 * 255).round()),

              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
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
    ).animate().scale(duration: 300.ms, curve: Curves.bounceOut),
  );
}
