import 'package:flutter/material.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';

class CustomRoleButtonAuth extends StatelessWidget {
  final String imageName;
  final String text;
  final IconData iocn;
  final void Function()? onPressed;

  const CustomRoleButtonAuth({
    super.key,
    required this.imageName,
    required this.text,
    required this.iocn,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 12),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          spacing: 60,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(imageName, width: 50, height: 50, fit: BoxFit.fill),

            Text(text, style: TextStyle(color: Colors.white, fontSize: 25)),

            Icon(iocn, size: 40, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
