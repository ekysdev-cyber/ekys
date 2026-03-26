import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Ana renkler
  static const primary = Color(0xFF1565C0);       // Koyu mavi
  static const primaryLight = Color(0xFF42A5F5);   // Açık mavi
  static const primaryDark = Color(0xFF0D47A1);    // Çok koyu mavi
  static const secondary = Color(0xFF00897B);      // Teal
  static const accent = Color(0xFFFF6F00);         // Turuncu amber

  // Yüzey renkleri
  static const surface = Color(0xFFF5F7FA);
  static const surfaceDark = Color(0xFF1A1A2E);
  static const card = Colors.white;
  static const cardDark = Color(0xFF16213E);

  // Metin renkleri
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const textOnPrimary = Colors.white;
  static const textPrimaryDark = Color(0xFFE0E0E0);
  static const textSecondaryDark = Color(0xFF9E9E9E);

  // Durum renkleri
  static const success = Color(0xFF2E7D32);
  static const error = Color(0xFFC62828);
  static const warning = Color(0xFFF9A825);
  static const info = Color(0xFF0288D1);

  // Zorluk seviyeleri
  static const easy = Color(0xFF4CAF50);
  static const medium = Color(0xFFFF9800);
  static const hard = Color(0xFFF44336);

  // Gradient
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, Color(0xFF4DB6AC)],
  );

  static const darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  );
}
