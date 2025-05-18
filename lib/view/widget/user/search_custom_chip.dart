import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const CustomChip({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: [Color(0xFFF06543), Color(0xFFFFBE3D)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                  : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: child,
        ),
      ),
    );
  }
}
