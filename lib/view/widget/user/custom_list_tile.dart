import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const CustomListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: Colors.orange),
      selectedColor: Colors.orange,
      onTap: onTap,
    );
  }
}
