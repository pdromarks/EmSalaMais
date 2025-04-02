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
    
    // Determina se é desktop ou mobile
    final bool isDesktop = width > 800;
    final bool isTablet = width > 600 && width <= 800;
    
    // Implementação de fontes responsivas usando MediaQuery
    // Calculadas como porcentagem da largura da tela
    final double titleFontSize = width * (isDesktop ? 0.02 : isTablet ? 0.03 : 0.05);
    final double regularFontSize = width * (isDesktop ? 0.015 : isTablet ? 0.02 : 0.04);
    final double buttonFontSize = width * (isDesktop ? 0.016 : isTablet ? 0.022 : 0.042);
    final double smallFontSize = width * (isDesktop ? 0.012 : isTablet ? 0.018 : 0.035);
    
    // Calcula tamanhos proporcionais
    final double logoHeight = height * 0.15;
    final double verticalSpacing = height * 0.015;
    final double cardWidth = isDesktop ? width * 0.4 : isTablet ? width * 0.7 : width * 0.9;
    
    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Container(
                width: cardWidth,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.all(isDesktop ? 40 : isTablet ? 30 : 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.15,
                      child: Image.asset('assets/images/emsalamais.png'),
                    ),
                    SizedBox(height: height * 0.04),
                    // Campo de email com ícone de envelope
                    CustomTextField(
                      label: 'Email',
                      borderColor: AppColors.ciano,
                      labelColor: AppColors.ciano,
                      prefixIcon: Icons.email,
                      iconColor: AppColors.ciano,
                      width: isDesktop ? width * 0.35 : null,
                      height: height * 0.08 ,
                      maxWidth: 400,
                      fontSize: regularFontSize,
                    ),
                    SizedBox(height: verticalSpacing),
                    // Campo de senha com ícone de cadeado
                    CustomTextField(
                      label: 'Senha',
                      isPassword: true,
                      borderColor: AppColors.ciano,
                      labelColor: AppColors.ciano,
                      prefixIcon: Icons.lock,
                      iconColor: AppColors.ciano,
                      width: isDesktop ? width * 0.35 : null,
                      height: height * 0.08,
                      maxWidth: 400,
                      fontSize: regularFontSize,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Esqueci a minha senha',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontSize: smallFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    CustomButton(
                      text: 'Entrar',
                      onPressed: () {},
                      backgroundColor: AppColors.ciano,
                      width: isDesktop ? width * 0.25 : isTablet ? width * 0.35 : width * 0.45,
                      maxWidth: 200,
                      height: height * 0.08,
                      fontSize: buttonFontSize,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}