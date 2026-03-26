import 'package:flutter/material.dart';

/// Responsive boyutlar — her telefona uygun tasarım için
class AppSizes {
  AppSizes._();

  // Padding & Margin
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Border Radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  // Icon
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // Font
  static const double fontXs = 10;
  static const double fontSm = 12;
  static const double fontMd = 14;
  static const double fontLg = 16;
  static const double fontXl = 20;
  static const double fontXxl = 24;
  static const double fontTitle = 28;
  static const double fontHeading = 32;

  // Button
  static const double buttonHeight = 52;
  static const double buttonHeightSm = 40;

  // Card
  static const double cardElevation = 2;

  /// Responsive genişlik oranı hesapla
  static double widthPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent / 100;
  }

  /// Responsive yükseklik oranı hesapla
  static double heightPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * percent / 100;
  }

  /// Ekran genişliğine göre padding
  static EdgeInsets screenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return const EdgeInsets.symmetric(horizontal: 12);
    if (width < 400) return const EdgeInsets.symmetric(horizontal: 16);
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  /// Safe area + padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      top: padding.top + md,
      left: md,
      right: md,
      bottom: padding.bottom + md,
    );
  }

  /// Ekran küçük mü kontrol (width < 360)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  /// Text scale factor — büyük fontlu cihazlarda taşmayı önler
  static double textScaleFactor(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1.0);
    return scale.clamp(0.8, 1.2);
  }
}
