import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_switch.dart';
import '../../theme/theme.dart';

class CustomField {
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final bool isPassword;

  CustomField({
    required this.label,
    required this.controller,
    this.icon,
    this.isPassword = false,
  });
}

class ColumnData {
  final String label;
  final String Function(Map<String, dynamic>) getValue;

  ColumnData({
    required this.label,
    required this.getValue,
  });
}

class CustomCrudScreen extends StatefulWidget {
  final String title;
  final List<CustomField> fields;
  final List<ColumnData> columns;
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;
  final VoidCallback onAdd;
  final String addButtonText;

  const CustomCrudScreen({
    super.key,
    required this.title,
    required this.fields,
    required this.columns,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    this.addButtonText = 'Adicionar',
  });

  @override
  State<CustomCrudScreen> createState() => _CustomCrudScreenState();
}

class _CustomCrudScreenState extends State<CustomCrudScreen> {
  ScrollController verticalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final bool isDesktop = width > 1024;
    final double fontSize = (width * 0.04).clamp(14.0, 20.0);
    final double titleFontSize = (width * 0.08).clamp(20.0, 40.0);

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAdd,
        backgroundColor: AppColors.verdeUNICV,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          width * 0.01,
          height * 0.02,
          width * 0.01,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: AppColors.verdeUNICV,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Scrollbar(
                    controller: verticalScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dataTableTheme: DataTableThemeData(
                            headingTextStyle: TextStyle(
                              color: AppColors.verdeUNICV,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize * 0.9,
                            ),
                            dataTextStyle: TextStyle(
                              fontSize: fontSize * 0.8,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Reserva 90px para a coluna de ações
                            final double availableWidth = constraints.maxWidth - 90;
                            final double columnWidth = availableWidth / widget.columns.length;
                            
                            return DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                AppColors.verdeUNICV.withOpacity(0.1),
                              ),
                              dataRowHeight: 48,
                              headingRowHeight: 48,
                              horizontalMargin: 8,
                              columnSpacing: 4,
                              columns: [
                                ...widget.columns.map(
                                  (col) => DataColumn(
                                    label: Container(
                                      width: columnWidth,
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        col.label,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: SizedBox(
                                    width: 80, // 90 - 8 (padding)
                                    child: Text('Ações'),
                                  ),
                                ),
                              ],
                              rows: widget.items.map((item) {
                                return DataRow(
                                  cells: [
                                    ...widget.columns.map(
                                      (col) => DataCell(
                                        Container(
                                          width: columnWidth,
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          child: Text(
                                            col.getValue(item),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: 82,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              visualDensity: VisualDensity.compact,
                                              icon: const Icon(Icons.edit, size: 20),
                                              color: AppColors.verdeUNICV,
                                              onPressed: () => widget.onEdit(item),
                                              constraints: const BoxConstraints(
                                                minWidth: 36,
                                                minHeight: 36,
                                              ),
                                            ),
                                            IconButton(
                                              visualDensity: VisualDensity.compact,
                                              icon: const Icon(Icons.delete, size: 20),
                                              color: Colors.red,
                                              onPressed: () => _showDeleteDialog(item),
                                              constraints: const BoxConstraints(
                                                minWidth: 36,
                                                minHeight: 36,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(Map<String, dynamic> item) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Deseja realmente excluir este item?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete(item);
              },
            ),
          ],
        );
      },
    );
  }
}
