import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import './custom_dropdown.dart'; // Para selecionar a turma
// import './schedule_card.dart'; // Poderemos precisar de elementos visuais daqui

// Modelo para os dados da turma que serão carregados
class AllocatedClassDetails {
  final String teacher;
  final String subject;
  final String time; // Ou poderia ser um objeto TimeSlot mais complexo
  // Adicione outros campos se necessário (ex: id do horário, etc)

  AllocatedClassDetails({
    required this.teacher,
    required this.subject,
    required this.time,
  });
}

class CustomRoomAllocationCard extends StatefulWidget {
  // Dados da Sala (similares ao CustomRoomCard)
  final String roomId;
  final String roomName;
  final String roomBlock;
  final int roomDesksCount;
  final bool roomHasTV;
  final bool roomHasProjector;

  // Lista de turmas disponíveis para esta sala/horário/data (virá da tela principal)
  final List<DropdownValueModel> availableClasses;
  // Callback quando uma turma é selecionada
  final Function(String roomId, DropdownValueModel? selectedClass) onClassSelected;
  // Detalhes da turma atualmente alocada (se houver)
  final AllocatedClassDetails? allocatedClassDetails; 
  // Valor selecionado para o dropdown de turma
  final DropdownValueModel? selectedClassValue;

  const CustomRoomAllocationCard({
    Key? key,
    required this.roomId,
    required this.roomName,
    required this.roomBlock,
    required this.roomDesksCount,
    required this.roomHasTV,
    required this.roomHasProjector,
    required this.availableClasses,
    required this.onClassSelected,
    this.allocatedClassDetails,
    this.selectedClassValue,
  }) : super(key: key);

  @override
  _CustomRoomAllocationCardState createState() => _CustomRoomAllocationCardState();
}

class _CustomRoomAllocationCardState extends State<CustomRoomAllocationCard> {
  DropdownValueModel? _selectedClass;

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.selectedClassValue;
  }

  @override
  void didUpdateWidget(CustomRoomAllocationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedClassValue != oldWidget.selectedClassValue) {
      setState(() {
        _selectedClass = widget.selectedClassValue;
      });
    }
  }

  Widget _buildRoomInfo(double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.roomName,
          style: TextStyle(
            fontSize: fontSize * 1.2,
            fontWeight: FontWeight.bold,
            color: AppColors.verdeUNICV,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.apartment, size: fontSize, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(
              widget.roomBlock,
              style: TextStyle(fontSize: fontSize * 0.9, color: Colors.grey[800]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.table_restaurant_outlined, size: fontSize * 1.2, color: AppColors.verdeUNICV),
                const SizedBox(width: 4),
                Text('${widget.roomDesksCount}', style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Icon(Icons.tv, size: fontSize * 1.2, color: widget.roomHasTV ? AppColors.verdeUNICV : Colors.grey),
                    Text('TV', style: TextStyle(fontSize: fontSize * 0.7, color: widget.roomHasTV ? AppColors.verdeUNICV : Colors.grey)),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Icon(Icons.videocam, size: fontSize * 1.2, color: widget.roomHasProjector ? AppColors.verdeUNICV : Colors.grey),
                    Text('Projetor', style: TextStyle(fontSize: fontSize * 0.7, color: widget.roomHasProjector ? AppColors.verdeUNICV : Colors.grey)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAllocatedClassDetails(double fontSize, AllocatedClassDetails details) {
    return Container(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horário em destaque (similar ao ScheduleCard)
          Text(
            details.time,
            style: TextStyle(
              fontSize: fontSize * 1.1, 
              fontWeight: FontWeight.bold,
              color: AppColors.verdeUNICV,
            ),
          ),
          const SizedBox(height: 8),
          // Professor
          Row(
            children: [
              Icon(Icons.person, size: fontSize, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  details.teacher,
                  style: TextStyle(fontSize: fontSize * 0.9, color: Colors.grey[800]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Disciplina
          Row(
            children: [
              Icon(Icons.book, size: fontSize, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  details.subject,
                  style: TextStyle(fontSize: fontSize * 0.9, color: Colors.grey[800]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final bool isDesktop = width > 1024;
    final bool isTablet = width > 600 && width <= 1024;
    final double fontSize = (width * (isDesktop ? 0.012 : isTablet ? 0.016 : 0.035)).clamp(12.0, 18.0); // Ajuste de clamp para card menor

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Para o card não expandir desnecessariamente
          children: [
            _buildRoomInfo(fontSize),
            const SizedBox(height: 12),
            // Dropdown para selecionar turma
            CustomDropdown(
              label: _selectedClass == null ? 'Alocar Turma' : 'Turma Alocada',
              items: widget.availableClasses,
              selectedValue: _selectedClass, 
              onChanged: (newValue) {
                setState(() {
                  _selectedClass = newValue;
                });
                widget.onClassSelected(widget.roomId, newValue);
              },
              dropdownId: 'class_allocation_${widget.roomId}', // ID único
              fontSize: fontSize * 0.95,
              // Adicione onOpen e openDropdownId se for usar o DropdownManager global
            ),
            const SizedBox(height: 8),
            // Detalhes da turma alocada (se houver)
            if (widget.allocatedClassDetails != null)
              _buildAllocatedClassDetails(fontSize, widget.allocatedClassDetails!)
            else if (_selectedClass != null && widget.allocatedClassDetails == null)
              Container( // Espaço reservado ou indicador de carregamento se a lógica for assíncrona
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: Text(
                  'Selecione para carregar detalhes...', // Ou um CircularProgressIndicator
                  style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.85),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 