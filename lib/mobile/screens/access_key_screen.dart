import 'package:em_sala_mais/components/widgets/custom_switch.dart';
import 'package:flutter/material.dart';
import '../../components/widgets/custom_tf.dart';
import '../../components/widgets/custom_btn.dart';
import '../../theme/theme.dart';

class AccessKeyScreen extends StatelessWidget {
  const AccessKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para responsividade
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final bool isDesktop = width > 1024;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Calcula tamanhos proporcionais
    double horizontalPadding;
    double logoHeight;
    double verticalSpacing;
    double cardWidth;
    double cardPadding;
    double fontSize;
    double buttonFontSize;
    double iconSize;

    if (isDesktop) {
      // Valores para desktop
      horizontalPadding = 0; // Não usado no layout desktop
      logoHeight = width * 0.08; // Logo responsivo para desktop
      verticalSpacing = height * 0.03;
      cardWidth = width * 0.25; // Card responsivo
      cardWidth = cardWidth.clamp(340.0, 420.0); // Limites min e max
      cardPadding = 30.0;
      fontSize = 16.0 / textScaleFactor;
      buttonFontSize = 16.0 / textScaleFactor;
      iconSize = 22.0 / textScaleFactor;
    } else {
      // Cálculos para dispositivos móveis
      horizontalPadding = width * 0.08;
      logoHeight = height * 0.15;
      verticalSpacing = height * 0.05;
      cardWidth = width - (horizontalPadding * 2);
      cardPadding = width * 0.06;
      fontSize = 16.0 / textScaleFactor;
      buttonFontSize = 16.0 / textScaleFactor;
      iconSize = 22.0 / textScaleFactor;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : horizontalPadding,
                vertical: verticalSpacing * 1.5,
              ),
              child:
                  isDesktop
                      ? _buildDesktopLayout(
                        logoHeight,
                        verticalSpacing,
                        cardWidth,
                        cardPadding,
                        fontSize,
                        buttonFontSize,
                        iconSize,
                      )
                      : _buildMobileLayout(
                        height,
                        logoHeight,
                        verticalSpacing,
                        cardPadding,
                        fontSize,
                        buttonFontSize,
                        iconSize,
                      ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(
    double logoHeight,
    double verticalSpacing,
    double cardWidth,
    double cardPadding,
    double fontSize,
    double buttonFontSize,
    double iconSize,
  ) {
    return SizedBox(
      width: cardWidth,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: logoHeight,
              child: Image.asset('assets/images/emsalamais.png'),
            ),
            SizedBox(height: verticalSpacing * 1.2),
            CustomTextField(
              label: 'Chave de Acesso',
              borderColor: AppColors.ciano,
              labelColor: AppColors.ciano,
              fontSize: fontSize,
              prefixIcon: Icons.vpn_key_outlined,
              iconColor: AppColors.ciano,
              iconSize: iconSize,
            ),
            SizedBox(height: verticalSpacing * 1.2),
            CustomButton(
              text: 'Próximo',
              onPressed: () {},
              backgroundColor: AppColors.ciano,
              icon: Icons.arrow_forward_rounded,
              width: double.infinity,
              height: 48,
              fontSize: buttonFontSize,
              iconSize: iconSize,
            ),
            SizedBox(height: verticalSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    double height,
    double logoHeight,
    double verticalSpacing,
    double cardPadding,
    double fontSize,
    double buttonFontSize,
    double iconSize,
  ) {
    return Padding(
      padding: EdgeInsets.all(cardPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: logoHeight,
            child: Image.asset('assets/images/emsalamais.png'),
          ),
          SizedBox(height: verticalSpacing * 1.1),
          CustomTextField(
            label: 'Chave de Acesso',
            borderColor: AppColors.ciano,
            labelColor: AppColors.ciano,
            fontSize: fontSize,
            prefixIcon: Icons.vpn_key_outlined,
            iconColor: AppColors.ciano,
            iconSize: iconSize,
          ),
          SizedBox(height: verticalSpacing * 1.1),
          CustomButton(
            text: 'Próximo',
            onPressed: () {},
            backgroundColor: AppColors.ciano,
            icon: Icons.arrow_forward_rounded,
            width: double.infinity,
            height: height * 0.055,
            fontSize: buttonFontSize,
            iconSize: iconSize,
          ),
          SizedBox(height: verticalSpacing * 0.3),
        ],
      ),
    );
  }
}
