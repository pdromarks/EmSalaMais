import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Necessário para listEquals
import '../../theme/theme.dart';

class DropdownValueModel {
  final String value;
  final String label;

  DropdownValueModel({required this.value, required this.label});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownValueModel &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

// Gerenciador global para controlar os dropdowns abertos
class DropdownManager {
  static String? _openDropdownId;
  static VoidCallback? _closeCallback;

  static void openDropdown(String id, VoidCallback closeCallback) {
    if (_openDropdownId != null && _openDropdownId != id) {
      _closeCallback?.call();
    }
    _openDropdownId = id;
    _closeCallback = closeCallback;
  }

  static void closeDropdown() {
    _openDropdownId = null;
    _closeCallback = null;
  }
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
    _filteredItems = List<DropdownValueModel>.from(widget.items);
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
    _overlayEntry?.markNeedsBuild();
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openDropdownId != oldWidget.openDropdownId) {
      if (widget.openDropdownId != widget.dropdownId) {
        _removeOverlay();
      }
    }
    if (!listEquals(widget.items, oldWidget.items)) {
      if (_searchController.text.isNotEmpty) {
         _filterItems(_searchController.text);
      } else {
        setState(() {
          _filteredItems = List<DropdownValueModel>.from(widget.items);
        });
      }
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    // _searchController.clear(); // Manter o texto pode ser útil
    // _filteredItems = widget.items;
    DropdownManager.closeDropdown();
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      widget.onOpen?.call();
      if (_searchController.text.isNotEmpty) {
        _filterItems(_searchController.text);
      } else {
        setState(() {
            _filteredItems = List<DropdownValueModel>.from(widget.items);
        });
      }
      _addOverlay();
    }
  }

  void _addOverlay() {
    DropdownManager.openDropdown(widget.dropdownId, _removeOverlay);
    
    final overlay = Overlay.of(context);
    final renderBox = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = _createOverlayEntry(position, size);
    overlay.insert(_overlayEntry!);
    _isOpen = true;
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
                      widget.selectedValue?.label ?? "",
                      style: TextStyle(
                        fontSize: widget.fontSize ?? 16,
                        color: widget.selectedValue != null
                            ? Colors.black87
                            : Colors.transparent,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                    Icons.arrow_drop_down,
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

    // Calcula a posição do overlay
    final isOffScreen = position.dy + size.height + 250 > screenHeight;
    //final verticalOffset = isOffScreen ? -(250 + 5) : size.height + 5;

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
                      if (widget.enableSearch)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _searchController,
                            autofocus: false, // Melhor não focar automaticamente
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
                            onChanged: _filterItems,
                          ),
                        ),
                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final isSelected = widget.selectedValue?.value == item.value;
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  widget.onChanged(item);
                                  _removeOverlay();
                                },
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
                                      if (isSelected)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(
                                            Icons.check,
                                            color: AppColors.verdeUNICV,
                                            size: 20,
                                          ),
                                        ),
                                      Expanded(
                                        child: Text(
                                          item.label,
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
