import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

import 'package:tadreebkomapplication/data/model/card_data.dart';
import 'package:tadreebkomapplication/view/widget/user/editable_card_widget.dart';
import 'package:tadreebkomapplication/view/widget/user/card_bucket_widget.dart';

class NewCardView extends StatelessWidget {
  const NewCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Get.back(),
        ),
        title: const Text('Add New Card'),
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
            padding: const EdgeInsets.all(25.0),
            child: NewCardForm(),
          ),
        ),
      ),
    );
  }
}

class NewCardForm extends StatefulWidget {
  const NewCardForm({super.key});

  @override
  NewCardFormState createState() => NewCardFormState();
}

class NewCardFormState extends State<NewCardForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cvvFocusNode = FocusNode();

  late AnimationController _animationController;
  Animation<double>? _flipAnimation;
  bool _isFlipped = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _isInitialized = true;

    _cvvFocusNode.addListener(() {
      if (_cvvFocusNode.hasFocus) {
        _animationController.forward();
        setState(() {
          _isFlipped = true;
        });
      } else {
        _animationController.reverse();
        setState(() {
          _isFlipped = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cardholderNameController.dispose();
    _cvvController.dispose();
    _cvvFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _addCard() {
    if (_formKey.currentState!.validate()) {
      final newCard = CardData(
        cardNumber: _cardNumberController.text,
        expiryDate: _expiryDateController.text,
        cardholderName: _cardholderNameController.text,
        cvv: _cvvController.text,
      );
      Get.back(result: newCard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isInitialized && _flipAnimation != null
                ? AnimatedBuilder(
                  animation: _flipAnimation!,
                  builder: (context, child) {
                    return Transform(
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(_flipAnimation!.value),
                      alignment: Alignment.center,
                      child:
                          _flipAnimation!.value <= math.pi / 2
                              ? EditableCardWidget(
                                cardNumber: _cardNumberController.text,
                                expiryDate: _expiryDateController.text,
                                cardholderName: _cardholderNameController.text,
                                cvv: _cvvController.text,
                                isFlipped: _isFlipped,
                              )
                              : Transform(
                                transform: Matrix4.identity()..rotateY(math.pi),
                                alignment: Alignment.center,
                                child: CardBackWidget(cvv: _cvvController.text),
                              ),
                    );
                  },
                ).animate().scale(duration: 300.ms, curve: Curves.bounceOut)
                : const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
            const SizedBox(height: 60),
            TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: const Icon(
                      Icons.credit_card,
                      color: Colors.orange,
                    ),
                    suffixIcon:
                        _cardNumberController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.orange,
                              ),
                              onPressed: () => _cardNumberController.clear(),
                            )
                            : null,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CardNumberInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a card number';
                    }
                    final digits = value.replaceAll(' ', '');
                    if (digits.length != 16) {
                      return 'Card number must be exactly 16 digits';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 16),
            TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date ',
                    hintText: 'MM/YY',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.orange,
                    ),
                    suffixIcon:
                        _expiryDateController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.orange,
                              ),
                              onPressed: () => _expiryDateController.clear(),
                            )
                            : null,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                    LengthLimitingTextInputFormatter(5),
                    ExpiryDateInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the expiry date';
                    }
                    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                      return 'Format must be MM/YY';
                    }
                    final parts = value.split('/');
                    final month = int.tryParse(parts[0]);
                    final year = int.tryParse(parts[1]);
                    if (month == null ||
                        year == null ||
                        month < 1 ||
                        month > 12) {
                      return 'Invalid month or year';
                    }
                    final currentDate = DateTime(2025, 4, 27);
                    final expiryDate = DateTime(2000 + year, month);
                    if (expiryDate.isBefore(currentDate) ||
                        (expiryDate.year == currentDate.year &&
                            expiryDate.month <= currentDate.month)) {
                      return 'Expiry date must be after April 2025';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 300.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 16),
            TextFormField(
                  controller: _cardholderNameController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    hintText: 'First Last',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: const Icon(Icons.person, color: Colors.orange),
                    suffixIcon:
                        _cardholderNameController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.orange,
                              ),
                              onPressed:
                                  () => _cardholderNameController.clear(),
                            )
                            : null,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the cardholder name';
                    }
                    if (!RegExp(r'^[A-Za-z]+\s[A-Za-z]+$').hasMatch(value)) {
                      return 'Name must contain exactly two parts (First Last) with no numbers or symbols';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 400.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 16),
            TextFormField(
                  controller: _cvvController,
                  focusNode: _cvvFocusNode,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                    suffixIcon:
                        _cvvController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.orange,
                              ),
                              onPressed: () => _cvvController.clear(),
                            )
                            : null,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the CVV';
                    }
                    if (value.length != 3) {
                      return 'CVV must be exactly 3 digits';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 500.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addCard,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFFF06543),
                  highlightColor: const Color(0xFFFFBE3D),
                  period: const Duration(milliseconds: 1500),
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
                          color: Colors.orange.withAlpha((0.4 * 255).round()),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(minHeight: 50),
                      child: const Text(
                        'Add Card',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ).animate().scale(duration: 300.ms, curve: Curves.bounceOut),
          ],
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) {
      text = text.substring(0, 16);
    }
    StringBuffer newText = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        newText.write(' ');
      }
      newText.write(text[i]);
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    if (text.length > 5) {
      text = text.substring(0, 5);
    }
    if (text.length >= 2 && !text.contains('/')) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
