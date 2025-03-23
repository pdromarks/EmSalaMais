import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Widgets/CustomTf.dart';
import 'Widgets/CustomBtn.dart';
import 'Tema/Tema.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f1f1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Em Sala+',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ciano,
                ),
              ),
              const SizedBox(height: 40),
              const CustomTextField(
                label: 'Login',
                borderColor: AppColors.ciano,
                labelColor: AppColors.ciano,
              ),
              const SizedBox(height: 10),
              const CustomTextField(
                label: 'Senha',
                isPassword: true,
                borderColor: AppColors.ciano,
                labelColor: AppColors.ciano,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Esqueci a minha senha',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              CustomButton(
                text: 'Entrar',
                onPressed: () {},
                backgroundColor: AppColors.ciano,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10,),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10,),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
