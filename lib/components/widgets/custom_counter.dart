import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class CustomCounter extends StatefulWidget {
  final String label;
  final int value;
  final Function(int) onChanged;
  final double? fontSize;
  final Color? color;

  const CustomCounter({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.fontSize,
    this.color,
  });

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  void _increment() {
    widget.onChanged(widget.value + 1);
  }

  void _decrement() {
    if (widget.value > 0) {
      widget.onChanged(widget.value - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = AppColors.verdeUNICV;
    final Color color = widget.color ?? defaultColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.fontSize ?? 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: color),
                onPressed: widget.value > 0 ? _decrement : null,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 40),
                child: Text(
                  widget.value.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: widget.fontSize ?? 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: color),
                onPressed: _increment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
