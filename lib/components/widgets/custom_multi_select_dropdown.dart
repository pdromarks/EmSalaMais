import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Necessário para listEquals
import '../../theme/theme.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<String> options;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;
  final String label;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;

  const CustomMultiSelectDropdown({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    required this.label,
    this.width,
    this.height,
    this.fontSize,
    this.iconSize,
  });

  @override
  State<CustomMultiSelectDropdown> createState() => _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final _dropdownKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredOptions = [];
  List<String> _localSelectedValues = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = List<String>.from(widget.options);
    _localSelectedValues = List<String>.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(CustomMultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsOverlayRebuild = false;

    if (!listEquals(widget.options, oldWidget.options)) {
      if (_searchController.text.isNotEmpty) {
        // _filterOptions chamará setState e markNeedsBuild
        _filterOptions(_searchController.text); 
      } else {
        setState(() {
          _filteredOptions = List<String>.from(widget.options);
        });
        needsOverlayRebuild = true;
      }
    }

    // Verifica se widget.selectedValues foi alterado externamente
    if (!listEquals(widget.selectedValues, oldWidget.selectedValues) &&
        !listEquals(widget.selectedValues, _localSelectedValues)) {
      setState(() {
        _localSelectedValues = List<String>.from(widget.selectedValues);
      });
      needsOverlayRebuild = true;
    }

    if (needsOverlayRebuild) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((option) =>
              option.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    // Não limpe o searchController aqui se quiser manter o texto da pesquisa
    // _searchController.clear(); 
    // _filteredOptions = widget.options; // Resetar aqui pode ser indesejado se o overlay for reaberto logo
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      // Garante que _filteredOptions esteja atualizado com base na pesquisa atual ou nas opções completas
      if (_searchController.text.isNotEmpty) {
        _filterOptions(_searchController.text);
      } else {
         // Precisa de setState aqui se _filteredOptions pudesse estar desatualizado
        setState(() {
            _filteredOptions = List<String>.from(widget.options);
        });
      }
      _addOverlay();
    }
  }

  void _addOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = _createOverlayEntry(position, size);
    overlay.insert(_overlayEntry!);
    _isOpen = true;
  }

  void _toggleOption(String option) {
    setState(() {
      if (_localSelectedValues.contains(option)) {
        _localSelectedValues.remove(option);
      } else {
        _localSelectedValues.add(option);
      }
      widget.onChanged(List<String>.from(_localSelectedValues)); // Envia uma cópia
    });
    _overlayEntry?.markNeedsBuild(); // Essencial para atualizar a UI do overlay
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _dropdownKey,
        width: widget.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggleOverlay,
            borderRadius: BorderRadius.circular(20),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: TextStyle(
                  color: AppColors.verdeUNICV,
                  fontSize: widget.fontSize ?? 16,
                  fontWeight: FontWeight.w700,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.only(
                  left: 16, 
                  right: 0,
                  top: 8,
                  bottom: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.verdeUNICV, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.verdeUNICV, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.verdeUNICV, width: 2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _localSelectedValues.isEmpty
                          ? ""
                          : _localSelectedValues.join(', '),
                      style: TextStyle(
                        fontSize: widget.fontSize ?? 16,
                        color: _localSelectedValues.isNotEmpty
                            ? Colors.black87
                            : Colors.transparent,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                    _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: AppColors.verdeUNICV,
                    size: widget.iconSize ?? 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry(Offset position, Size size) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    final isOffScreen = position.dy + size.height + 250 > screenHeight;
    final verticalOffset = isOffScreen ? -(250 + 5) : size.height + 5;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeOverlay,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + (isOffScreen ? -5.0 : 0.0) + (isOffScreen ? 0 : size.height), // Ajuste para posicionar corretamente
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, isOffScreen ? -(250 + 5 - size.height) : 5 ), // Ajuste no offset
              showWhenUnlinked: false,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.verdeUNICV,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _searchController,
                          autofocus: false, // Geralmente melhor não focar automaticamente
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Pesquisar...',
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 20,
                              color: AppColors.verdeUNICV,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: AppColors.verdeUNICV,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: AppColors.verdeUNICV,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: AppColors.verdeUNICV,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onChanged: _filterOptions,
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _filteredOptions.length,
                          itemBuilder: (context, index) {
                            final option = _filteredOptions[index];
                            final isSelected = _localSelectedValues.contains(option);
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _toggleOption(option),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.verdeUNICV.withOpacity(0.1)
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: Icon(
                                          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                          color: AppColors.verdeUNICV,
                                          size: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: const TextStyle(
                                            fontSize: 14,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
} 