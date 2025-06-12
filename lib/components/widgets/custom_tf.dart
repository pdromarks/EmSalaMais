import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final Color? labelColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? width;
  final double? maxWidth;
  final double? height;
  final double? fontSize;
  final IconData? prefixIcon;
  final Color? iconColor;
  final double? iconSize;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.labelColor,
    this.borderColor,
    this.backgroundColor,
    this.width,
    this.maxWidth,
    this.height,
    this.fontSize,
    this.prefixIcon,
    this.iconColor,
    this.iconSize,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para cálculos responsivos
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isDesktop = screenWidth > 1024;

    // Define valores padrão baseados no tamanho da tela
    final defaultFontSize = screenWidth * 0.04;
    final defaultIconSize = isDesktop ? 22.0 : defaultFontSize * 1.2;

    // Get theme colors
    final themeColor = widget.borderColor ?? Theme.of(context).primaryColor;

    // Calcula a largura efetiva considerando o maxWidth
    final effectiveWidth =
        widget.width != null
            ? (widget.maxWidth != null
                ? (widget.width! > widget.maxWidth!
                    ? widget.maxWidth
                    : widget.width)
                : widget.width)
            : null;

    return Container(
      width: effectiveWidth,
      constraints:
          widget.maxWidth != null
              ? BoxConstraints(maxWidth: widget.maxWidth!)
              : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: themeColor,
            selectionColor: themeColor.withOpacity(0.2),
            selectionHandleColor: themeColor,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          style: TextStyle(fontSize: widget.fontSize ?? defaultFontSize),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: widget.labelColor ?? themeColor,
              fontWeight: FontWeight.bold,
              fontSize: (widget.fontSize ?? defaultFontSize) * 0.9,
            ),
            filled: true,
            fillColor: widget.backgroundColor ?? Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: themeColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: themeColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: themeColor,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: 12,
            ),
            prefixIcon:
                widget.prefixIcon != null
                    ? Icon(
                      widget.prefixIcon,
                      color: widget.iconColor ?? themeColor,
                      size: widget.iconSize ?? defaultIconSize,
                    )
                    : null,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ),
    );
  }
}
