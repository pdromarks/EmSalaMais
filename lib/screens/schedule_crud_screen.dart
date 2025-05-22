import 'package:flutter/material.dart';
import '../components/schedule_card.dart';
import '../components/weekday_column.dart';
import '../theme/theme.dart';
import '../components/screens/custom_form_dialog.dart';

class ScheduleCrudScreen extends StatefulWidget {
  const ScheduleCrudScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleCrudScreen> createState() => _ScheduleCrudScreenState();
}

class _ScheduleCrudScreenState extends State<ScheduleCrudScreen> {
  final List<String> weekdays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  final List<String> timeSlots = [
    'Primeira Aula',
    'Segunda Aula',
    'Terceira Aula',
    'Quarta Aula'
  ];

  // Dados mockados para exemplo
  final List<Map<String, dynamic>> schedules = [
    {
      'id': '1',
      'course': 'Engenharia de Software',
      'semester': '1º Sem',
      'period': 'Noturno',
      'className': 'A',
      'teacher': 'Professor 1',
      'subject': 'Disciplina 1',
      'time': 'Primeira Aula',
      'weekday': 'Segunda'
    },
    {
      'id': '2',
      'course': 'Ciência da Computação',
      'semester': '2º Sem',
      'period': 'Matutino',
      'className': 'B',
      'teacher': 'Professor 2',
      'subject': 'Disciplina 2',
      'time': 'Segunda Aula',
      'weekday': 'Terça'
    },
  ];

  // Dados mockados para exemplo
  final List<Map<String, String>> mockClasses = [
    {
      'id': '1',
      'course': 'Engenharia de Software',
      'semester': '1º Sem',
      'period': 'Noturno',
      'className': 'A',
      'displayName': 'Engenharia de Software - 1º Sem - Turma A'
    },
    {
      'id': '2',
      'course': 'Ciência da Computação',
      'semester': '2º Sem',
      'period': 'Matutino',
      'className': 'B',
      'displayName': 'Ciência da Computação - 2º Sem - Turma B'
    }
  ];

  void _handleDelete(Map<String, dynamic> schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir este horário?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                schedules.removeWhere((s) => s['id'] == schedule['id']);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFormDialog([Map<String, dynamic>? initialData]) async {
    String? selectedClass = initialData?['className'];
    String? selectedTeacher = initialData?['teacher'] == 'Professor 1' ? '1' : '2';
    String? selectedSubject = initialData?['subject'] == 'Disciplina 1' ? '1' : '2';
    String? selectedWeekday = initialData?['weekday'];
    String? selectedTime = initialData?['time'];
    Map<String, String>? selectedClassData;

    if (selectedClass != null) {
      selectedClassData = mockClasses.firstWhere(
        (c) => c['className'] == selectedClass,
        orElse: () => mockClasses[0],
      );
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CustomFormDialog(
          title: initialData != null ? 'Editar Horário' : 'Novo Horário',
          fields: [
            CustomFormField(
              label: 'Turma',
              isDropdown: true,
              value: selectedClass,
              items: mockClasses.map((c) => DropdownMenuItem<String>(
                value: c['className'],
                child: Text(c['displayName'] ?? ''),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                  selectedClassData = mockClasses.firstWhere(
                    (c) => c['className'] == value,
                    orElse: () => mockClasses[0],
                  );
                });
              },
            ),
            CustomFormField(
              label: 'Professor',
              isDropdown: true,
              value: selectedTeacher,
              items: const [
                DropdownMenuItem(value: '1', child: Text('Professor 1')),
                DropdownMenuItem(value: '2', child: Text('Professor 2')),
              ],
              onChanged: (value) => setState(() => selectedTeacher = value),
            ),
            CustomFormField(
              label: 'Disciplina',
              isDropdown: true,
              value: selectedSubject,
              items: const [
                DropdownMenuItem(value: '1', child: Text('Disciplina 1')),
                DropdownMenuItem(value: '2', child: Text('Disciplina 2')),
              ],
              onChanged: (value) => setState(() => selectedSubject = value),
            ),
            CustomFormField(
              label: 'Dia da Semana',
              isDropdown: true,
              value: selectedWeekday,
              items: weekdays.map((day) => DropdownMenuItem<String>(
                value: day,
                child: Text(day),
              )).toList(),
              onChanged: (value) => setState(() => selectedWeekday = value),
            ),
            CustomFormField(
              label: 'Horário',
              isDropdown: true,
              value: selectedTime,
              items: timeSlots.map((time) => DropdownMenuItem<String>(
                value: time,
                child: Text(time),
              )).toList(),
              onChanged: (value) => setState(() => selectedTime = value),
            ),
          ],
          onSave: (data) {
            if (selectedClass == null ||
                selectedTeacher == null ||
                selectedSubject == null ||
                selectedWeekday == null ||
                selectedTime == null ||
                selectedClassData == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, preencha todos os campos'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final scheduleData = {
              'id': initialData?['id'] ?? DateTime.now().toString(),
              'course': selectedClassData?['course'] ?? '',
              'semester': selectedClassData?['semester'] ?? '',
              'period': selectedClassData?['period'] ?? '',
              'className': selectedClass ?? '',
              'teacher': selectedTeacher == '1' ? 'Professor 1' : 'Professor 2',
              'subject': selectedSubject == '1' ? 'Disciplina 1' : 'Disciplina 2',
              'time': selectedTime ?? '',
              'weekday': selectedWeekday ?? '',
            };

            Navigator.pop(context, scheduleData);
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (initialData != null) {
          final index = schedules.indexWhere((s) => s['id'] == result['id']);
          if (index != -1) {
            schedules[index] = result;
          }
        } else {
          schedules.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double titleFontSize = (width * 0.08).clamp(20.0, 40.0);

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: AppColors.verdeUNICV,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          width * 0.01,
          screenSize.height * 0.02,
          width * 0.01,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: Text(
                'Horários',
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
              child: Row(
                children: weekdays.map((weekday) {
                  final weekdaySchedules = schedules
                      .where((schedule) => schedule['weekday'] == weekday)
                      .map((schedule) => ScheduleCard(
                            course: schedule['course'],
                            semester: schedule['semester'],
                            period: schedule['period'],
                            className: schedule['className'],
                            teacher: schedule['teacher'],
                            subject: schedule['subject'],
                            time: schedule['time'],
                            onEdit: () => _showFormDialog(schedule),
                            onDelete: () => _handleDelete(schedule),
                          ))
                      .toList();

                  return Expanded(
                    child: WeekdayColumn(
                      weekday: weekday,
                      scheduleCards: weekdaySchedules,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 