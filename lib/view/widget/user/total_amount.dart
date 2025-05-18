import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tadreebkomapplication/controller/usercontroller/checkout_controller.dart';

Widget buildTotalAmount(CheckoutController controller) {
  return Text(
    'TOTAL AMOUNT: ${controller.totalAmount}JD',
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ).animate().fadeIn(duration: 500.ms, delay: 500.ms);
}
