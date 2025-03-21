// utils/ui_helpers.dart
import 'package:flutter/material.dart';

class UIHelpers {
  static Color getSenderColor(String sender) {
    switch (sender) {
      case 'Doctor':
        return Colors.blue.shade50;
      case 'Teacher':
        return Colors.green.shade50;
      case 'Parent':
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  static Color getSenderIconColor(String sender) {
    switch (sender) {
      case 'Doctor':
        return Colors.blue;
      case 'Teacher':
        return Colors.green;
      case 'Parent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  static IconData getSenderIcon(String sender) {
    switch (sender) {
      case 'Doctor':
        return Icons.medical_services;
      case 'Teacher':
        return Icons.school;
      case 'Parent':
        return Icons.family_restroom;
      default:
        return Icons.person;
    }
  }
}
