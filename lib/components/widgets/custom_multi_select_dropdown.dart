import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> selectedValues;
  final Function(List<String>) onChanged;
  final double? fontSize;

  const CustomMultiSelectDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.fontSize,
  });

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;
  List<String> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isExpanded = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions =
          widget.options
              .where(
                (option) => option.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final defaultFontSize = screenWidth * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.fontSize ?? defaultFontSize * 0.9,
            fontWeight: FontWeight.bold,
            color: AppColors.verdeUNICV,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.verdeUNICV, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Campo de busca
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          style: TextStyle(
                            fontSize: widget.fontSize ?? defaultFontSize * 0.9,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pesquisar...',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            hintStyle: TextStyle(
                              fontSize: widget.fontSize ?? defaultFontSize * 0.9,
                              color: AppColors.verdeUNICV.withOpacity(0.7),
                            ),
                          ),
                          onChanged: (value) {
                            _filterOptions(value);
                            if (!_isExpanded) {
                              setState(() {
                                _isExpanded = true;
                              });
                            }
                          },
                          onTap: () {
                            setState(() {
                              _isExpanded = true;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        icon: Icon(
                          _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: AppColors.verdeUNICV,
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de itens selecionados
              if (widget.selectedValues.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: widget.selectedValues.map((value) {
                      return Chip(
                        backgroundColor: AppColors.verdeUNICV.withOpacity(0.1),
                        label: Text(
                          value,
                          style: TextStyle(
                            fontSize: (widget.fontSize ?? defaultFontSize) * 0.8,
                            color: AppColors.verdeUNICV,
                          ),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          final newValues = List<String>.from(widget.selectedValues)
                            ..remove(value);
                          widget.onChanged(newValues);
                        },
                      );
                    }).toList(),
                  ),
                ),
              // Lista de opções
              if (_isExpanded)
                Container(
                  constraints: BoxConstraints(maxHeight: screenHeight * 0.3),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.verdeUNICV.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredOptions.length,
                    itemBuilder: (context, index) {
                      final option = _filteredOptions[index];
                      final isSelected = widget.selectedValues.contains(option);
                      return Material(
                        color: isSelected
                            ? AppColors.verdeUNICV.withOpacity(0.1)
                            : Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            final newValues = List<String>.from(widget.selectedValues);
                            if (isSelected) {
                              newValues.remove(option);
                            } else {
                              newValues.add(option);
                            }
                            widget.onChanged(newValues);
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      final newValues =
                                          List<String>.from(widget.selectedValues);
                                      if (value == true) {
                                        newValues.add(option);
                                      } else {
                                        newValues.remove(option);
                                      }
                                      widget.onChanged(newValues);
                                    },
                                    activeColor: AppColors.verdeUNICV,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: widget.fontSize ?? defaultFontSize * 0.9,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
