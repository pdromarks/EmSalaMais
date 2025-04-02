import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final IconData? icon;
  final double? width;
  final double? maxWidth;
  final double? height;
  final double? fontSize;
  final double? iconSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.teal,
    this.borderRadius = 20.0,
    this.icon,
    this.width,
    this.maxWidth,
    this.height,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para cálculos responsivos
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Define valores padrão baseados no tamanho da tela
    final defaultWidth = screenWidth * 0.4;
    final defaultHeight = screenHeight * 0.055;
    final defaultFontSize = screenWidth * 0.035;
    final defaultIconSize = screenWidth * 0.05;
    
    // Calcula o padding interno com base no tamanho da tela
    final horizontalPadding = screenWidth * 0.015;
    
    // Calcula a largura efetiva considerando o maxWidth
    final effectiveWidth = width != null 
        ? (maxWidth != null ? 
            (width! > maxWidth! ? maxWidth : width) 
            : width)
        : defaultWidth;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      height: height ?? defaultHeight,
      width: effectiveWidth,
      constraints: maxWidth != null 
          ? BoxConstraints(maxWidth: maxWidth!) 
          : null,
      child: SizedBox(
        width: double.infinity,
        height: height ?? defaultHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius * 0.75),
            ),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize ?? defaultFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (icon != null) 
                Padding(
                  padding: EdgeInsets.only(left: horizontalPadding),
                  child: Icon(
                    icon, 
                    color: Colors.white,
                    size: iconSize ?? defaultIconSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
