import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final String label;
  final T value;
  final T groupValue;
  final List<Map<String, T>> options;
  final ValueChanged<T?> onChanged;
  final double? fontSize;

  const CustomRadioButton({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.options,
    required this.onChanged,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.bold,
            color: AppColors.verdeUNICV,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children:
              options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      Radio<T>(
                        value: option['value'] as T,
                        groupValue: groupValue,
                        onChanged: onChanged,
                        activeColor: AppColors.verdeUNICV,
                      ),
                      Text(
                        option['label'] as String,
                        style: TextStyle(fontSize: (fontSize ?? 16) - 2),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
