import 'package:flutter/material.dart';
import '../../theme/theme.dart';


Widget preview(){
    return CustomSwitch(
        value: true,
        onChanged: (value) {},
        label: 'Label',
        width: 100,
        height: 50,
    );
}

class CustomSwitch extends StatefulWidget {
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
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para cálculos responsivos
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;


    // Define valores padrão baseados no tamanho da tela
    final defaultHeight = screenHeight * 0.05;
    final defaultFontSize = screenWidth * 0.04;
    final switchWidth = screenWidth * 0.12;
    final switchHeight = screenHeight * 0.028;

    return Container(
      height: widget.height ?? defaultHeight,
      width: widget.width,
      child: Row(
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: AppColors.verdeUNICV,
              fontSize: widget.fontSize ?? defaultFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => widget.onChanged(!widget.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: switchWidth,
              height: switchHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(switchHeight),
                color: widget.value ? AppColors.verdeUNICV : Colors.grey.shade300,
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    left: widget.value ? switchWidth - switchHeight : 0,
                    right: widget.value ? 0 : switchWidth - switchHeight,
                    child: Container(
                      width: switchHeight,
                      height: switchHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
