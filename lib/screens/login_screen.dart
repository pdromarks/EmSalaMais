import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../theme/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para responsividade
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    
    // Calcula tamanhos proporcionais
    final double horizontalPadding = width * 0.08;
    final double logoHeight = height * 0.15;
    final double verticalSpacing = height * 0.015;
    final double fontSize = width * 0.03;
    
    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.08),
                    SizedBox(
                      height: logoHeight,
                      child: Image.asset('assets/images/emsalamais.png'),
                    ),
                    SizedBox(height: height * 0.06),
                    const CustomTextField(
                      label: 'Login',
                      borderColor: AppColors.ciano,
                      labelColor: AppColors.ciano,
                    ),
                    SizedBox(height: verticalSpacing),
                    const CustomTextField(
                      label: 'Senha',
                      isPassword: true,
                      borderColor: AppColors.ciano,
                      labelColor: AppColors.ciano,
                    ),
                    SizedBox(height: verticalSpacing),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Esqueci a minha senha',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    CustomButton(
                      text: 'Entrar',
                      onPressed: () {},
                      backgroundColor: AppColors.ciano,
                      width: width * 0.45,
                      height: height * 0.055,
                      fontSize: width * 0.035,
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}