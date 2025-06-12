import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
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
  late Map<String, dynamic> _internalFormData;
  Map<String, bool> _passwordVisibility = {};

  @override
  void initState() {
    super.initState();
    _internalFormData = {};
    // Inicializa _internalFormData com os valores iniciais dos campos
    for (var field in widget.fields) {
      String fieldKey = field.label; // Usar field.label como chave única para o mapa

      if (field.isPassword) {
        _passwordVisibility[fieldKey] = false;
      } else if (field.isDropdown) {
        _internalFormData[fieldKey] = field.value;
      } else if (field.isCounter) {
        _internalFormData[fieldKey] = field.counterValue;
      } else if (field.isSwitch) {
        _internalFormData[fieldKey] = field.switchValue;
      }
      // TextEditingControllers são gerenciados externamente e não precisam ser armazenados aqui
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
                  String fieldKey = field.label; // Chave para _internalFormData

                  if (field.isDropdown) {
                    String? currentDropdownValue = _internalFormData[fieldKey] as String?;
                    DropdownValueModel? selectedValueModel;

                    // Garantir que items não seja nulo e tenha elementos
                    final items = field.items ?? [];
                    if (items.isEmpty) {
                      fieldWidget = CustomDropdown(
                        items: [],
                        selectedValue: null,
                        onChanged: (_) {},  // Função vazia que aceita qualquer valor
                        label: field.label,
                        dropdownId: fieldKey,
                        enableSearch: true,
                      );
                    } else {
                      if (currentDropdownValue != null) {
                        String displayLabel = currentDropdownValue;
                        var matchingItem = items.firstWhere(
                          (item) => item.value == currentDropdownValue,
                          orElse: () => items.first,
                        );
                        if (matchingItem.child is Text) {
                          displayLabel = (matchingItem.child as Text).data ?? currentDropdownValue;
                        }
                        selectedValueModel = DropdownValueModel(value: currentDropdownValue, label: displayLabel);
                      }

                      fieldWidget = CustomDropdown(
                        items: items.map((item) => DropdownValueModel(
                          value: item.value ?? '',
                          label: item.child is Text ? (item.child as Text).data ?? '' : item.child.toString(),
                        )).toList(),
                        selectedValue: selectedValueModel,
                        onChanged: (selectedModel) {
                          setState(() {
                            _internalFormData[fieldKey] = selectedModel?.value;
                          });
                          field.onChanged?.call(selectedModel?.value);
                        },
                        label: field.label,
                        dropdownId: fieldKey,
                        enableSearch: true,
                      );
                    }
                  } else if (field.isCounter) {
                    fieldWidget = CustomCounter(
                      label: field.label,
                      value: _internalFormData[fieldKey] as int? ?? field.counterValue ?? 0,
                      onChanged: (newValue) {
                        setState(() {
                          _internalFormData[fieldKey] = newValue;
                        });
                        field.onCounterChanged?.call(newValue);
                      },
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
                          value: _internalFormData[fieldKey] as bool? ?? field.switchValue ?? false,
                          onChanged: (newValue) {
                            setState(() {
                              _internalFormData[fieldKey] = newValue;
                            });
                            field.onSwitchChanged?.call(newValue);
                          },
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
                      obscureText: field.isPassword && !(_passwordVisibility[fieldKey] ?? false),
                      suffixIcon: field.isPassword
                          ? IconButton(
                              icon: Icon(
                                (_passwordVisibility[fieldKey] ?? false)
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.verdeUNICV,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisibility[fieldKey] =
                                      !(_passwordVisibility[fieldKey] ?? false);
                                });
                              },
                            )
                          : null,
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
                        final Map<String, dynamic> formDataToSave = {
                          'id':
                              widget.initialData?['id'] ??
                              DateTime.now().toString(),
                        };

                        for (var field in widget.fields) {
                          String formKey = field.label.toLowerCase().replaceAll(
                                  ' ',
                                  '_',
                                );
                          if (field.controller != null) {
                            formDataToSave[formKey] =
                                field.controller!.text;
                          } else if (field.isDropdown || field.isCounter || field.isSwitch) {
                            // Usar o valor de _internalFormData
                            formDataToSave[formKey] =
                                _internalFormData[field.label]; // Usar field.label como chave
                          }
                        }
                        widget.onSave(formDataToSave);
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
