import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const EmSalaMaisApp());
}

class EmSalaMaisApp extends StatelessWidget {
  const EmSalaMaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.verdeUNICV,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.verdeUNICV,
          primary: AppColors.verdeUNICV,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff1f1f1),
      ),
      home: const HomeScreen(),
    );
  }
}
