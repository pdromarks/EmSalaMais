import 'package:flutter/material.dart';
import 'screens/access_key_screen.dart';
import 'screens/login_screen.dart';
import 'screens/academic_data_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      debugShowCheckedModeBanner: false,
      home: const AcademicDataScreen(),
    );
  }
}
