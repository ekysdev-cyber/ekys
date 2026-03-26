import 'package:flutter/material.dart';

/// Genel yardımcı extension'lar
extension StringExtension on String {
  /// İlk harfi büyük yap
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  /// Null veya boş kontrolü
  bool get isNullOrEmpty => isEmpty;
}

extension ContextExtension on BuildContext {
  /// Tema kısayolları
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Ekran boyutu
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Padding
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  /// Snackbar göster
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  /// "Bugün", "Dün", "2 gün önce" formatı
  String get timeAgoText {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inDays == 0) return 'Bugün';
    if (diff.inDays == 1) return 'Dün';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} hafta önce';
    return '${(diff.inDays / 30).floor()} ay önce';
  }
}
