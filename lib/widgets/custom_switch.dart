import 'package:flutter/material.dart';
import '../theme/theme.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final double? width;
  final double? height;
  final double? fontSize;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.width,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double defaultFontSize = (screenSize.width * 0.04).clamp(14.0, 20.0);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? defaultFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.verdeUNICV,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.verdeUNICV,
        ),
      ],
    );
  }
} 