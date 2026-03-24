import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFFEA4335); // Gmail Red
  static const primaryDark = Color(0xFFC5221F);
  static const primaryLight = Color(0xFFFFEBEA);
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF9F9F9);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6B6B);
  static const textHint = Color(0xFFAAAAAA);
  static const border = Color(0xFFE0E0E0);
  static const success = Color(0xFF34A853); // confirmed
  static const warning = Color(0xFFFBBC04); // urgent
  static const error = Color(0xFFEA4335);
  static const cardShadow = Color(0x0F000000);

  // Urgency
  static const urgencyRoutine = success;
  static const urgencyUrgent = warning;
  static const urgencyCritical = primary;
}
