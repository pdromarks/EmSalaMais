import 'package:em_sala_mais/backend/dto/schedule_teacher_dto.dart';
import 'package:em_sala_mais/backend/model/enums.dart';
import 'package:em_sala_mais/backend/services/schedule_teacher.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'web/screens/home_screen.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final scheduleTeacherService = ScheduleTeacherService();
  final scheduleTeacher = await scheduleTeacherService.createScheduleTeacher(
    ScheduleTeacherDTO(
      scheduleId: 1,
      teacherId: 1,
      groupId: 2,
      subjectId: 2,
      dayOfWeek: DayOfWeek.segunda,
      updatedAt: DateTime.now(),
    ),
  );
  print(scheduleTeacher);
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
      locale: const Locale('pt', 'BR'),
      home: const HomeScreen(),
    );
  }
}
