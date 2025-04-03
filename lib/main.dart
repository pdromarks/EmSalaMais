import 'package:em_sala_mais/backend/user/user.service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gwbbvnaszswrtgvrwoum.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd3YmJ2bmFzenN3cnRndnJ3b3VtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2Mzk5ODIsImV4cCI6MjA1OTIxNTk4Mn0.Rmoi6eeM7hHLfCG2jCtPHf6HvpkLuE6bLvjCNeeOjlc', // Replace with your Supabase anon key key
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
