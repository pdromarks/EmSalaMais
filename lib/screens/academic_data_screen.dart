import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_dropdown.dart';
import '../theme/theme.dart';

class AcademicDataScreen extends StatelessWidget {
  const AcademicDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Container(
                height: 140,
                child: Image.asset('assets/images/LogoUNICV.png'),
              ),
              const SizedBox(height: 30),
              Text(
                'Seus Dados',
                style: TextStyle(
                  color: AppColors.verdeUNICV,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Seu Nome',
                borderColor: AppColors.verdeUNICV,
                labelColor: AppColors.verdeUNICV,
              ),
              const SizedBox(height: 10),
              CustomDropdown(
                items: [
                  'Engenharia de Software',
                  'Direito',
                  'Análise e Desenvolvimento de Sistemas',
                ],
                onChanged: (value) => print('Selecionado: $value'),
              ),
              const SizedBox(height: 100),
              CustomButton(
                text: 'Próximo',
                onPressed: () {},
                backgroundColor: AppColors.verdeUNICV,
                icon: Icons.arrow_forward_rounded,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
