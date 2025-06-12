import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_switch.dart';
import '../../theme/theme.dart';

class CustomFormField {
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final bool isPassword;

  CustomFormField({
    required this.label,
    required this.controller,
    this.icon,
    this.isPassword = false,
  });
}

class CustomFormDialog extends StatefulWidget {
  final String title;
  final List<CustomFormField> fields;
  final bool showSwitch;
  final String switchLabel;
  final bool initialSwitchValue;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;
  final Map<String, dynamic>? initialData;

  const CustomFormDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
    required this.onCancel,
    this.showSwitch = true,
    this.switchLabel = 'Ativo',
    this.initialSwitchValue = true,
    this.initialData,
  });

  @override
  State<CustomFormDialog> createState() => _CustomFormDialogState();
}

class _CustomFormDialogState extends State<CustomFormDialog> {
  bool _switchValue = true;
  Map<String, bool> _passwordVisibility = {};

  @override
  void initState() {
    super.initState();
    _switchValue = widget.initialData?['ativo'] ?? widget.initialSwitchValue;
    for (var field in widget.fields) {
      if (field.isPassword) {
        _passwordVisibility[field.label] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final bool isDesktop = width > 1024;
    
    final double fontSize = (width * 0.04).clamp(14.0, 20.0);
    final double titleFontSize = (width * 0.06).clamp(18.0, 32.0);
    final double buttonFontSize = (width * 0.035).clamp(14.0, 18.0);
    final double iconSize = (width * 0.05).clamp(20.0, 24.0);
    final double dialogWidth = isDesktop ? width * 0.4 : width * 0.9;
    final double maxDialogHeight = height * 0.8;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: maxDialogHeight,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: AppColors.verdeUNICV,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onCancel,
                      color: AppColors.verdeUNICV,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                ...widget.fields.map((field) => Column(
                  children: [
                    CustomTextField(
                      label: field.label,
                      controller: field.controller,
                      borderColor: AppColors.verdeUNICV,
                      labelColor: AppColors.verdeUNICV,
                      fontSize: fontSize,
                      prefixIcon: field.icon,
                      iconColor: AppColors.verdeUNICV,
                      iconSize: iconSize,
                      obscureText: field.isPassword && !(_passwordVisibility[field.label] ?? false),
                      suffixIcon: field.isPassword
                          ? IconButton(
                              icon: Icon(
                                (_passwordVisibility[field.label] ?? false)
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.verdeUNICV,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisibility[field.label] =
                                      !(_passwordVisibility[field.label] ?? false);
                                });
                              },
                            )
                          : null,
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                )).toList(),
                if (widget.showSwitch) ...[
                  CustomSwitch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                    label: widget.switchLabel,
                    fontSize: fontSize * 0.9,
                  ),
                  SizedBox(height: height * 0.02),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Cancelar',
                      onPressed: widget.onCancel,
                      backgroundColor: Colors.grey,
                      width: isDesktop ? width * 0.08 : width * 0.25,
                      height: height * 0.05,
                      fontSize: buttonFontSize,
                    ),
                    SizedBox(width: width * 0.02),
                    CustomButton(
                      text: 'Salvar',
                      onPressed: () {
                        final formData = {
                          'id': widget.initialData?['id'] ?? DateTime.now().toString(),
                          'ativo': _switchValue,
                        };
                        
                        for (var field in widget.fields) {
                          formData[field.label.toLowerCase().replaceAll(' ', '_')] = 
                              field.controller.text;
                        }
                        
                        widget.onSave(formData);
                      },
                      backgroundColor: AppColors.verdeUNICV,
                      width: isDesktop ? width * 0.08 : width * 0.25,
                      height: height * 0.05,
                      fontSize: buttonFontSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
