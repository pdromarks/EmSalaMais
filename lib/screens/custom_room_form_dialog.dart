import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../theme/theme.dart';

class CustomRoomFormDialog extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? initialData;
  final List<Map<String, dynamic>> blocks;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const CustomRoomFormDialog({
    super.key,
    required this.title,
    this.initialData,
    required this.blocks,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<CustomRoomFormDialog> createState() => _CustomRoomFormDialogState();
}

class _CustomRoomFormDialogState extends State<CustomRoomFormDialog> {
  late TextEditingController _nameController;
  String? _selectedBlock;
  int _desksCount = 30;
  bool _hasTV = false;
  bool _hasProjector = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?['name'] ?? '');
    _selectedBlock = widget.initialData?['block'] ?? (widget.blocks.isNotEmpty ? widget.blocks[0]['nome_do_bloco'] : null);
    _desksCount = widget.initialData?['desks_count'] ?? 30;
    _hasTV = widget.initialData?['has_tv'] ?? false;
    _hasProjector = widget.initialData?['has_projector'] ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
                // Cabeçalho
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

                // Nome da Sala
                CustomTextField(
                  label: 'Nome da Sala',
                  controller: _nameController,
                  borderColor: AppColors.verdeUNICV,
                  labelColor: AppColors.verdeUNICV,
                  fontSize: fontSize,
                  prefixIcon: Icons.meeting_room,
                  iconColor: AppColors.verdeUNICV,
                  iconSize: iconSize,
                ),
                SizedBox(height: height * 0.02),

                // Dropdown para Blocos
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.verdeUNICV, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedBlock,
                      hint: Text(
                        'Selecione um Bloco',
                        style: TextStyle(
                          fontSize: fontSize * 0.9,
                          color: AppColors.verdeUNICV.withOpacity(0.7),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.verdeUNICV,
                        size: iconSize,
                      ),
                      style: TextStyle(
                        fontSize: fontSize * 0.9,
                        color: Colors.black87,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      items: widget.blocks.map((block) {
                        return DropdownMenuItem<String>(
                          value: block['nome_do_bloco'],
                          child: Text(block['nome_do_bloco']),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedBlock = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Contador de Carteiras
                Row(
                  children: [
                    Text(
                      'Quantidade de Carteiras:',
                      style: TextStyle(
                        fontSize: fontSize * 0.9,
                        color: AppColors.verdeUNICV,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.verdeUNICV, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: fontSize * 0.9,
                              color: AppColors.verdeUNICV,
                            ),
                            onPressed: () {
                              if (_desksCount > 1) {
                                setState(() {
                                  _desksCount--;
                                });
                              }
                            },
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(
                              minWidth: fontSize * 2.5,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$_desksCount',
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: fontSize * 0.9,
                              color: AppColors.verdeUNICV,
                            ),
                            onPressed: () {
                              setState(() {
                                _desksCount++;
                              });
                            },
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),

                // Switches
                Row(
                  children: [
                    Text(
                      'Televisão:',
                      style: TextStyle(
                        fontSize: fontSize * 0.9,
                        color: AppColors.verdeUNICV,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _hasTV,
                      onChanged: (value) {
                        setState(() {
                          _hasTV = value;
                        });
                      },
                      activeColor: AppColors.verdeUNICV,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Projetor:',
                      style: TextStyle(
                        fontSize: fontSize * 0.9,
                        color: AppColors.verdeUNICV,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _hasProjector,
                      onChanged: (value) {
                        setState(() {
                          _hasProjector = value;
                        });
                      },
                      activeColor: AppColors.verdeUNICV,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),

                // Botões
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
                        if (_nameController.text.isEmpty || _selectedBlock == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Preencha todos os campos obrigatórios'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final roomData = {
                          'id': widget.initialData?['id'] ?? DateTime.now().toString(),
                          'name': _nameController.text,
                          'block': _selectedBlock,
                          'desks_count': _desksCount,
                          'has_tv': _hasTV,
                          'has_projector': _hasProjector,
                        };

                        widget.onSave(roomData);
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