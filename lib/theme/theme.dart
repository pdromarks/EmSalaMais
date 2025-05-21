import 'package:flutter/material.dart';

class AppColors {
  static const Color verdeUNICV = Color(0xff507E32);
  static const Color ciano = Color(0xff3FBFAD);
  static const Color background = Color(0xfff1f1f1);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.verdeUNICV,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: AppColors.verdeUNICV),
        titleTextStyle: TextStyle(
          color: AppColors.verdeUNICV,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeUNICV,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.verdeUNICV,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.verdeUNICV, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.verdeUNICV, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.verdeUNICV, width: 2),
        ),
        labelStyle: const TextStyle(
          color: AppColors.verdeUNICV,
          fontWeight: FontWeight.w600,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.verdeUNICV;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.verdeUNICV.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.5);
        }),
      ),
    );
  }
}
