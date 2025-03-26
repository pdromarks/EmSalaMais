import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../theme/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80,),
              Container(
                height: 140,
                child: Image.asset('assets/images/emsalamais.png')),
              const SizedBox(height: 60),
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
                    fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    );
  }
}
