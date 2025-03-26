import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../theme/theme.dart';

class AccessKeyScreen extends StatelessWidget {
  const AccessKeyScreen({super.key});

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
              const SizedBox(height: 120),
              const CustomTextField(
                label: 'Chave de Acesso',
                borderColor: AppColors.ciano,
                labelColor: AppColors.ciano,
              ),
              const SizedBox(height: 100),
              CustomButton(
                text: 'Próximo',
                onPressed: () {},
                backgroundColor: AppColors.ciano,
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
