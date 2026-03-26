import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Genel yardımcı fonksiyonlar
class Helpers {
  Helpers._();

  /// Zorluk seviyesine göre renk
  static Color difficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return AppColors.easy;
      case 2:
        return AppColors.medium;
      case 3:
        return AppColors.hard;
      default:
        return AppColors.easy;
    }
  }

  /// Zorluk seviyesine göre metin
  static String difficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Kolay';
      case 2:
        return 'Orta';
      case 3:
        return 'Zor';
      default:
        return 'Kolay';
    }
  }

  /// Puan → renk
  static Color scoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  /// Süreyi formatla (saniye → "02:30")
  static String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Süreyi formatla (dakika → "2 saat 30 dk")
  static String formatMinutes(int totalMinutes) {
    if (totalMinutes < 60) return '$totalMinutes dk';
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (mins == 0) return '$hours saat';
    return '$hours saat $mins dk';
  }

  /// Yüzde formatla
  static String formatPercent(double value) {
    return '%${value.toStringAsFixed(1)}';
  }
}
