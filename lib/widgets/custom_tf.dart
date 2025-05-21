import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color borderColor;
  final Color labelColor;
  final double fontSize;
  final IconData? prefixIcon;
  final Color iconColor;
  final double iconSize;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.borderColor = Colors.blue,
    this.labelColor = Colors.blue,
    this.fontSize = 16.0,
    this.prefixIcon,
    this.iconColor = Colors.blue,
    this.iconSize = 24.0,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: labelColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: iconColor,
                size: iconSize,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }
} 