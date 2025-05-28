import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_switch.dart';
import '../widgets/custom_counter.dart';
import '../widgets/custom_dropdown.dart';
import '../../theme/theme.dart';

class CustomFormField {
  final String label;
  final TextEditingController? controller;
  final IconData? icon;
  final bool isPassword;
  final String? value;
  final Function(String?)? onChanged;
  final List<DropdownMenuItem<String>>? items;
  final bool isDropdown;
  final bool isCounter;
  final int? counterValue;
  final Function(int)? onCounterChanged;
  final bool isSwitch;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;

  CustomFormField({
    required this.label,
    this.controller,
    this.icon,
    this.isPassword = false,
    this.value,
    this.onChanged,
    this.items,
    this.isDropdown = false,
    this.isCounter = false,
    this.counterValue,
    this.onCounterChanged,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
  });
}

class CustomFormDialog extends StatefulWidget {
  final String title;
  final List<CustomFormField> fields;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;
  final Map<String, dynamic>? initialData;
  final Widget? customWidget;

  const CustomFormDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
    required this.onCancel,
    this.initialData,
    this.customWidget,
  });

  @override
  State<CustomFormDialog> createState() => _CustomFormDialogState();
}

class _CustomFormDialogState extends State<CustomFormDialog> {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(maxHeight: maxDialogHeight),
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
                ...widget.fields.map((field) {
                  Widget fieldWidget;

                  if (field.isDropdown) {
                    fieldWidget = CustomDropdown(
                      items: field.items?.map((item) => DropdownValueModel(
                        value: item.value ?? '',
                        label: item.child is Text ? (item.child as Text).data ?? '' : item.child.toString(),
                      )).toList() ?? [],
                      selectedValue: field.value != null
                          ? DropdownValueModel(
                              value: field.value!,
                              label: field.items
                                      ?.firstWhere(
                                        (item) => item.value == field.value,
                                        orElse: () => const DropdownMenuItem(
                                          value: '',
                                          child: Text(''),
                                        ),
                                      )
                                      .child is Text
                                  ? (field.items!.firstWhere(
                                      (item) => item.value == field.value,
                                      orElse: () => const DropdownMenuItem(
                                        value: '',
                                        child: Text(''),
                                      ),
                                    ).child as Text)
                                      .data ??
                                      ''
                                  : '',
                            )
                          : null,
                      onChanged: (value) => field.onChanged?.call(value?.value),
                      label: field.label,
                      dropdownId: field.label,
                      enableSearch: true,
                    );
                  } else if (field.isCounter) {
                    fieldWidget = CustomCounter(
                      label: field.label,
                      value: field.counterValue ?? 0,
                      onChanged: field.onCounterChanged ?? (_) {},
                      fontSize: fontSize,
                      color: AppColors.verdeUNICV,
                    );
                  } else if (field.isSwitch) {
                    fieldWidget = Row(
                      children: [
                        Text(
                          field.label,
                          style: TextStyle(
                            fontSize: fontSize * 0.9,
                            color: AppColors.verdeUNICV,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: field.switchValue ?? false,
                          onChanged: field.onSwitchChanged,
                          activeColor: AppColors.verdeUNICV,
                        ),
                      ],
                    );
                  } else {
                    fieldWidget = CustomTextField(
                      label: field.label,
                      controller: field.controller ?? TextEditingController(),
                      borderColor: AppColors.verdeUNICV,
                      labelColor: AppColors.verdeUNICV,
                      fontSize: fontSize,
                      prefixIcon: field.icon,
                      iconColor: AppColors.verdeUNICV,
                      iconSize: iconSize,
                      isPassword: field.isPassword,
                    );
                  }

                  return Column(
                    children: [fieldWidget, SizedBox(height: height * 0.02)],
                  );
                }).toList(),
                if (widget.customWidget != null) widget.customWidget!,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Cancelar',
                      onPressed: widget.onCancel,
                      backgroundColor: Colors.grey,
                      width: isDesktop ? width * 0.1 : width * 0.25,
                      height: height * 0.05,
                      fontSize: buttonFontSize,
                    ),
                    SizedBox(width: width * 0.02),
                    CustomButton(
                      text: 'Salvar',
                      onPressed: () {
                        final Map<String, dynamic> formData = {
                          'id':
                              widget.initialData?['id'] ??
                              DateTime.now().toString(),
                        };

                        for (var field in widget.fields) {
                          if (field.controller != null) {
                            formData[field.label.toLowerCase().replaceAll(
                                  ' ',
                                  '_',
                                )] =
                                field.controller!.text;
                          } else if (field.isDropdown) {
                            formData[field.label.toLowerCase().replaceAll(
                                  ' ',
                                  '_',
                                )] =
                                field.value;
                          } else if (field.isCounter) {
                            formData[field.label.toLowerCase().replaceAll(
                                  ' ',
                                  '_',
                                )] =
                                field.counterValue;
                          } else if (field.isSwitch) {
                            formData[field.label.toLowerCase().replaceAll(
                                  ' ',
                                  '_',
                                )] =
                                field.switchValue;
                          }
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
