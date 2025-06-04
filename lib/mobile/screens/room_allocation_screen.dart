import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/widgets/custom_dropdown.dart';

class RoomAllocationScreen extends StatefulWidget {
  const RoomAllocationScreen({super.key});

  @override
  State<RoomAllocationScreen> createState() => _RoomAllocationScreenState();
}

class _RoomAllocationScreenState extends State<RoomAllocationScreen> {
  String _currentDayOfWeek = '';
  DropdownValueModel? _selectedTurma;
  String? _openDropdownId;

  final List<DropdownValueModel> _turmas = [
    DropdownValueModel(value: 'T1', label: 'Turma A'),
    DropdownValueModel(value: 'T2', label: 'Turma B'),
    DropdownValueModel(value: 'T3', label: 'Turma C - Manhã'),
    DropdownValueModel(value: 'T4', label: 'Turma D - Tarde'),
  ];

  @override
  void initState() {
    super.initState();
    _setCurrentDayOfWeek();
  }

  void _setCurrentDayOfWeek() {
    final now = DateTime.now();
    final weekday = now.weekday;
    setState(() {
      _currentDayOfWeek = _getWeekdayInPortuguese(weekday);
    });
  }

  String _getWeekdayInPortuguese(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Segunda-feira';
      case DateTime.tuesday:
        return 'Terça-feira';
      case DateTime.wednesday:
        return 'Quarta-feira';
      case DateTime.thursday:
        return 'Quinta-feira';
      case DateTime.friday:
        return 'Sexta-feira';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return '';
    }
  }

  void _handleDropdownOpen(String dropdownId) {
    setState(() {
      if (_openDropdownId == dropdownId) {
        _openDropdownId = null;
      } else {
        _openDropdownId = dropdownId;
      }
    });
  }

  Widget _buildAllocationCard(String subject, String room, String teacher, String time) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Disciplina: $subject',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(Icons.room_outlined, color: Colors.grey, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  'Sala: $room',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.grey, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  'Professor: $teacher',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  'Horário: $time',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    
    final double horizontalPadding = width * 0.08;
    final double verticalSpacing = height * 0.02;
    final double inputFontSize = (width * 0.04).clamp(14.0, 18.0);
    final double titleFontSize = (width * 0.05).clamp(18.0, 24.0);
    final double dayFontSize = (width * 0.08).clamp(24.0, 32.0);

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _currentDayOfWeek,
              style: TextStyle(
                fontSize: dayFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeUNICV,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: verticalSpacing * 1.5),
            CustomDropdown(
              label: 'Selecionar Turma',
              items: _turmas,
              selectedValue: _selectedTurma,
              onChanged: (value) {
                setState(() {
                  _selectedTurma = value;
                  _openDropdownId = null;
                  print('Turma selecionada: ${_selectedTurma?.label}');
                });
              },
              width: width * 0.84,
              fontSize: inputFontSize,
              dropdownId: 'turma_selector',
              onOpen: () => _handleDropdownOpen('turma_selector'),
              openDropdownId: _openDropdownId,
            ),
            SizedBox(height: verticalSpacing * 2),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '1ª Aula',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.verdeUNICV,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            _buildAllocationCard(
              _selectedTurma != null ? 'Mat. Discreta (${_selectedTurma!.label})' : 'Mat. Discreta',
              'Sala 202',
              'Prof. Dr. Carlos Andrade',
              '08:00 - 09:40',
            ),
            SizedBox(height: verticalSpacing * 2),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '2ª Aula',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.verdeUNICV,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            _buildAllocationCard(
              _selectedTurma != null ? 'Proj. Interdisciplinar (${_selectedTurma!.label})' : 'Proj. Interdisciplinar',
              'Lab. Robótica',
              'Profa. Dra. Ana Beatriz',
              '10:00 - 11:40',
            ),
          ],
        ),
      ),
    );
  }
}
