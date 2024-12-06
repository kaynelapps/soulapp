import 'package:flutter/material.dart';

class DateCategory {
  final String title;
  final IconData icon;
  final Color color;
  final Color secondaryColor; // Add this field
  final String route;

  DateCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.secondaryColor, // Add this parameter
    required this.route,
  });
}
