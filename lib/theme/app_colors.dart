import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF3F51B5);
  static const Color primaryLight = Color(0xFF757DE8);
  static const Color primaryDark = Color(0xFF002984);

  // Accent
  static const Color accent = Color(0xFF536DFE);
  static const Color accentLight = Color(0xFF8F9BFF);
  static const Color accentDark = Color(0xFF0043CB);

  // Score colors
  static const Color scoreExcellent = Color(0xFF4CAF50);
  static const Color scoreGood = Color(0xFF8BC34A);
  static const Color scoreAverage = Color(0xFFFFC107);
  static const Color scoreBelowAverage = Color(0xFFFF9800);
  static const Color scorePoor = Color(0xFFF44336);

  // Glassmorphism
  static const Color glassLight = Color(0x33FFFFFF);
  static const Color glassDark = Color(0x33000000);
  static const Color glassBorder = Color(0x44FFFFFF);

  // Favorites
  static const Color favoriteGold = Color(0xFFFFD700);

  // Dark theme
  static const Color darkSurface = Color(0xFF1E1E2E);
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkCard = Color(0xFF252540);

  // Light theme
  static const Color lightSurface = Color(0xFFF5F5FA);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  static Color scoreColor(int score) {
    if (score >= 80) return scoreExcellent;
    if (score >= 60) return scoreGood;
    if (score >= 40) return scoreAverage;
    if (score >= 20) return scoreBelowAverage;
    return scorePoor;
  }
}
