import 'package:flutter/material.dart';
import 'package:tadreebkomapplication/controller/usercontroller/checkout_controller.dart';

Widget buildPaymentMethodChip(
  CheckoutController controller, {
  required String method,
  required bool isSelected,
}) {
  return AnimatedScale(
    duration: const Duration(milliseconds: 300),
    scale: isSelected ? 1.05 : 1.0,
    child: ChoiceChip(
      label: Row(
        children: [
          Icon(
            method == 'Card' ? Icons.credit_card : Icons.qr_code_scanner,
            size: 20,
            color: isSelected ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 8),
          Text(method),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => controller.selectPaymentMethod(method),
      selectedColor: Colors.orange,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 2,
      pressElevation: 4,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.1),
    ),
  );
}
