import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  AppTheme._();

  // ────────────────────────────────────────────────
  // LIGHT THEME
  // ────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.surface,
        textTheme: _textTheme(Brightness.light),
        appBarTheme: _appBarTheme(Brightness.light),
        cardTheme: _cardTheme(Brightness.light),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(Brightness.light),
        bottomNavigationBarTheme: _bottomNavTheme(Brightness.light),
        chipTheme: _chipTheme(Brightness.light),
      );

  // ────────────────────────────────────────────────
  // DARK THEME
  // ────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primaryLight,
          secondary: AppColors.secondary,
          surface: AppColors.surfaceDark,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.surfaceDark,
        textTheme: _textTheme(Brightness.dark),
        appBarTheme: _appBarTheme(Brightness.dark),
        cardTheme: _cardTheme(Brightness.dark),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(Brightness.dark),
        bottomNavigationBarTheme: _bottomNavTheme(Brightness.dark),
        chipTheme: _chipTheme(Brightness.dark),
      );

  // ────────────────────────────────────────────────
  // TEXT THEME
  // ────────────────────────────────────────────────
  static TextTheme _textTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? AppColors.textPrimary
        : AppColors.textPrimaryDark;
    return GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontHeading,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontTitle,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontXl,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontLg,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontLg,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontMd,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: AppSizes.fontSm,
        color: brightness == Brightness.light
            ? AppColors.textSecondary
            : AppColors.textSecondaryDark,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontMd,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  // ────────────────────────────────────────────────
  // APP BAR
  // ────────────────────────────────────────────────
  static AppBarTheme _appBarTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      backgroundColor: isLight ? AppColors.surface : AppColors.surfaceDark,
      foregroundColor: isLight ? AppColors.textPrimary : AppColors.textPrimaryDark,
      titleTextStyle: GoogleFonts.inter(
        fontSize: AppSizes.fontXl,
        fontWeight: FontWeight.w600,
        color: isLight ? AppColors.textPrimary : AppColors.textPrimaryDark,
      ),
    );
  }

  // ────────────────────────────────────────────────
  // CARD
  // ────────────────────────────────────────────────
  static CardThemeData _cardTheme(Brightness brightness) {
    return CardThemeData(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      color: brightness == Brightness.light ? AppColors.card : AppColors.cardDark,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
    );
  }

  // ────────────────────────────────────────────────
  // BUTTONS
  // ────────────────────────────────────────────────
  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontLg,
          fontWeight: FontWeight.w600,
        ),
        elevation: 2,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontLg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // INPUT
  // ────────────────────────────────────────────────
  static InputDecorationTheme _inputDecorationTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return InputDecorationTheme(
      filled: true,
      fillColor: isLight ? Colors.white : AppColors.cardDark,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(
          color: isLight ? Colors.grey.shade300 : Colors.grey.shade700,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(
          color: isLight ? Colors.grey.shade300 : Colors.grey.shade700,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: GoogleFonts.inter(
        color: isLight ? AppColors.textSecondary : AppColors.textSecondaryDark,
      ),
    );
  }

  // ────────────────────────────────────────────────
  // BOTTOM NAV
  // ────────────────────────────────────────────────
  static BottomNavigationBarThemeData _bottomNavTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isLight ? Colors.white : AppColors.cardDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isLight ? AppColors.textSecondary : AppColors.textSecondaryDark,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: AppSizes.fontSm,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: AppSizes.fontSm,
      ),
    );
  }

  // ────────────────────────────────────────────────
  // CHIP
  // ────────────────────────────────────────────────
  static ChipThemeData _chipTheme(Brightness brightness) {
    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
    );
  }
}
