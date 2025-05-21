import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;
  final double? maxWidth;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.icon,
    this.width,
    this.height,
    this.fontSize,
    this.iconSize,
    this.maxWidth,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double defaultFontSize = (screenSize.width * 0.04).clamp(14.0, 18.0);
    final double defaultIconSize = (screenSize.width * 0.05).clamp(18.0, 24.0);
    final double defaultHeight = screenSize.height * 0.06;
    final double horizontalPadding = 16;
    
    // Determina a largura do botão
    double effectiveWidth = width ?? (screenSize.width * 0.3);
    final double borderRadius = 20.0;
    
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
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius * 0.75),
            ),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          ),
          child: isLoading
              ? SizedBox(
                  height: (fontSize ?? defaultFontSize) * 1.2,
                  width: (fontSize ?? defaultFontSize) * 1.2,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Row(
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