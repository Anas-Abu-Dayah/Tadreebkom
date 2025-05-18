import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/checkout_controller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/data/model/card_data.dart';
import 'package:tadreebkomapplication/view/widget/user/card_widget.dart';

Widget buildCardSelection(CheckoutController controller) {
  return Obx(() {
    if (controller.selectedPaymentMethod.value == 'Cash') {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select a Card :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.orange),
              onPressed: () async {
                final newCard = await Get.toNamed(AppRoute.newCard);
                if (newCard != null) {
                  controller.addCard(newCard as CardData);
                }
              },
            ),
          ],
        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
        const SizedBox(height: 8),
        if (controller.cards.isEmpty)
          const Text(
            'No cards available. Please add a new card.',
          ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
        if (controller.cards.isNotEmpty)
          SizedBox(
            height:
                200, // Increased height from 150 to 200 to make cards bigger
            child: PageView.builder(
              itemCount: controller.cards.length,
              onPageChanged:
                  (index) => controller.selectCard(controller.cards[index]),
              itemBuilder: (context, index) {
                final card = controller.cards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CardWidget(cardData: card)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, duration: 500.ms),
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        if (controller.cards.isNotEmpty)
          Center(
            child: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  controller.cards.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          controller.selectedCard.value ==
                                  controller.cards[index]
                              ? Colors.orange
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
          ),
      ],
    );
  });
}
