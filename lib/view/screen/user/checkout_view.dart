import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/checkout_controller.dart';
import 'package:tadreebkomapplication/view/widget/user/card_selection.dart';
import 'package:tadreebkomapplication/view/widget/user/payment_method.dart';
import 'package:tadreebkomapplication/view/widget/user/paynow_button.dart';
import 'package:tadreebkomapplication/view/widget/user/total_amount.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Get.back(),
        ),
        title: const Text('Checkout'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select your payment method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 16),
                buildPaymentMethods(controller),
                const SizedBox(height: 16),
                buildCardSelection(controller),
                const Spacer(),
                buildTotalAmount(controller),
                const SizedBox(height: 16),
                buildPayNowButton(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
