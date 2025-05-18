import 'package:flutter/material.dart';

class CardBackWidget extends StatelessWidget {
  final String cvv;

  const CardBackWidget({super.key, required this.cvv});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2,
          style: BorderStyle.solid,
          color: Colors.transparent,
        ),
        gradient: const LinearGradient(
          colors: [Color(0xFFF06543), Color(0xFFFFBE3D)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),

              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: double.infinity, height: 40, color: Colors.black),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 40,
              color: Colors.grey.shade200,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 60,
                    height: 30,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        cvv.isEmpty ? 'CVV' : cvv,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
