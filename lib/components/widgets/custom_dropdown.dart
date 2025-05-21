import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class DropdownValueModel {
  final String value;
  final String label;

  DropdownValueModel({
    required this.value,
    required this.label,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownValueModel &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class CustomDropdown extends StatefulWidget {
  final List<DropdownValueModel> items;
  final DropdownValueModel? selectedValue;
  final ValueChanged<DropdownValueModel?> onChanged;
  final String label;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;
  final VoidCallback? onOpen;
  final String? openDropdownId;
  final String dropdownId;
  final bool enableSearch;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    required this.label,
    this.width,
    this.height,
    this.fontSize,
    this.iconSize,
    this.onOpen,
    this.openDropdownId,
    required this.dropdownId,
    this.enableSearch = false,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final _dropdownKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  List<DropdownValueModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
              item.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openDropdownId != oldWidget.openDropdownId) {
      if (widget.openDropdownId != widget.dropdownId) {
        _removeOverlay();
      }
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    _searchController.clear();
    _filteredItems = widget.items;
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      widget.onOpen?.call();
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

  OverlayEntry _createOverlayEntry(Offset position, Size size) {
    // Obtém o tamanho da tela para cálculos responsivos
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Define valores padrão baseados no tamanho da tela
    final defaultFontSize = screenWidth * 0.04;
    final defaultIconSize = screenWidth * 0.05;
    
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.3,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.enableSearch)
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: widget.fontSize ?? defaultFontSize * 0.8),
                        decoration: InputDecoration(
                          hintText: 'Pesquisar...',
                          prefixIcon: Icon(
                            Icons.search, 
                            size: widget.iconSize ?? defaultIconSize,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: AppColors.verdeUNICV),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: AppColors.verdeUNICV),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: AppColors.verdeUNICV, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.005,
                          ),
                        ),
                        onChanged: _filterItems,
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isSelected = widget.selectedValue?.value == item.value;
                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _removeOverlay();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.015,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.verdeUNICV.withOpacity(0.1) : null,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                if (isSelected)
                                  Padding(
                                    padding: EdgeInsets.only(right: screenWidth * 0.02),
                                    child: Icon(
                                      Icons.check,
                                      color: AppColors.verdeUNICV,
                                      size: widget.iconSize ?? defaultIconSize,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: widget.fontSize ?? defaultFontSize,
                                      color: isSelected
                                          ? AppColors.verdeUNICV
                                          : Colors.black87,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para cálculos responsivos
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Define valores padrão baseados no tamanho da tela
    final defaultHeight = screenHeight * 0.05;
    final defaultFontSize = screenWidth * 0.04;
    final defaultIconSize = screenWidth * 0.05;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            key: _dropdownKey,
            height: widget.height ?? defaultHeight,
            width: widget.width ?? constraints.maxWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: _toggleOverlay,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyle(
                    color: AppColors.verdeUNICV,
                    fontSize: widget.fontSize ?? defaultFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    bottom: screenHeight * 0.01,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.verdeUNICV, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.verdeUNICV, width: 2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.selectedValue?.label ?? '',
                        style: TextStyle(
                          fontSize: widget.fontSize ?? defaultFontSize,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.verdeUNICV,
                      size: widget.iconSize ?? defaultIconSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
