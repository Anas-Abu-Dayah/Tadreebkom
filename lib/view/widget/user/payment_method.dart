import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tadreebkomapplication/controller/usercontroller/checkout_controller.dart';
import 'package:tadreebkomapplication/view/widget/user/build_payemnt_method_chip.dart';

Widget buildPaymentMethods(CheckoutController controller) {
  return Obx(() {
    return Row(
      children: [
        buildPaymentMethodChip(
          controller,
          method: 'Card',
          isSelected: controller.selectedPaymentMethod.value == 'Card',
        ),
        const SizedBox(width: 16),
        buildPaymentMethodChip(
          controller,
          method: 'Cash',
          isSelected: controller.selectedPaymentMethod.value == 'Cash',
        ),
      ],
    );
  });
}
