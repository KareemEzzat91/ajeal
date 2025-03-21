// widgets/date_navigation_button.dart
import 'package:flutter/material.dart';

class DateNavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const DateNavigationButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: Colors.grey.shade600,
        onPressed: onPressed,
      ),
    );
  }
}