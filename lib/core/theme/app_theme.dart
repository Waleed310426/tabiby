// ============================================================
// ملف: app_theme.dart
// الوصف: إعدادات الثيم الكاملة لتطبيق طبيبي
// الخطوط تُحمَّل من assets/fonts/ مباشرة (Cairo المحلي)
// ============================================================

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  // ─── الثيم النهاري (Light Theme) ────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Cairo', // خط Cairo المحلي من assets/fonts/

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.backgroundCard,
      ),

      textTheme: _buildTextTheme(isLight: true),

      // ─── شريط التطبيق ──────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // ─── الأزرار الرئيسية ───────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── أزرار الحدود ───────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── أزرار النص ─────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── حقول الإدخال ───────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textHint,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.error,
          fontSize: 12,
        ),
      ),

      // ─── البطاقات ───────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // ─── شريط التنقل السفلي ─────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.infoLight,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.primary,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      scaffoldBackgroundColor: AppColors.backgroundLight,
    );
  }

  // ─── الثيم الليلي (Dark Theme) ──────────────────────────────
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Cairo',

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        error: AppColors.error,
        surface: const Color(0xFF1E1E1E),
      ),

      textTheme: _buildTextTheme(isLight: false),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      scaffoldBackgroundColor: AppColors.backgroundDark,

      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
      ),
    );
  }

  // ─── بناء نظام الخطوط ────────────────────────────────────────
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color mainColor =
        isLight ? AppColors.textPrimary : Colors.white;
    final Color secondaryColor =
        isLight ? AppColors.textSecondary : Colors.white70;

    return TextTheme(
      displayLarge: TextStyle(fontFamily: 'Cairo', fontSize: 32, fontWeight: FontWeight.bold, color: mainColor),
      headlineLarge: TextStyle(fontFamily: 'Cairo', fontSize: 24, fontWeight: FontWeight.bold, color: mainColor),
      headlineMedium: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.bold, color: mainColor),
      titleLarge: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w600, color: mainColor),
      titleMedium: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w600, color: mainColor),
      bodyLarge: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.normal, color: mainColor),
      bodyMedium: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.normal, color: mainColor),
      bodySmall: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.normal, color: secondaryColor),
      labelLarge: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w600, color: mainColor),
      labelSmall: TextStyle(fontFamily: 'Cairo', fontSize: 10, fontWeight: FontWeight.normal, color: secondaryColor),
    );
  }
}
