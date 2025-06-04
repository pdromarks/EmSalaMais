import 'package:flutter/material.dart';
import '../../components/widgets/schedule_card.dart';
import '../../theme/theme.dart';
import '../../components/screens/custom_form_dialog.dart';

class ScheduleCrudScreen extends StatefulWidget {
  const ScheduleCrudScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleCrudScreen> createState() => _ScheduleCrudScreenState();
}

class _ScheduleCrudScreenState extends State<ScheduleCrudScreen> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

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
     {
      'id': '3',
      'course': 'Engenharia Civil',
      'semester': '5º Sem',
      'period': 'Noturno',
      'className': 'C',
      'teacher': 'Professor 3',
      'subject': 'Estruturas de Concreto',
      'time': 'Terceira Aula',
      'weekday': 'Segunda'
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
    },
    {
      'id': '3',
      'course': 'Engenharia Civil',
      'semester': '5º Sem',
      'period': 'Noturno',
      'className': 'C',
      'displayName': 'Engenharia Civil - 5º Sem - Turma C'
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _handleDelete(Map<String, dynamic> schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir este horário?'),
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
    String? selectedTeacher = initialData?['teacher'] == 'Professor 1' ? '1' : (initialData?['teacher'] == 'Professor 2' ? '2' : '3');
    String? selectedSubject = initialData?['subject'] == 'Disciplina 1' ? '1' : (initialData?['subject'] == 'Disciplina 2' ? '2' : '3');
    String? selectedWeekday = initialData?['weekday'];
    String? selectedTime = initialData?['time'];
    Map<String, String>? selectedClassData;

    if (selectedClass != null) {
      selectedClassData = mockClasses.firstWhere(
        (c) => c['className'] == selectedClass,
        orElse: () => mockClasses[0], // Ensure there's always a fallback
      );
    } else if (mockClasses.isNotEmpty) {
      selectedClassData = mockClasses[0]; // Default if no initial data
      selectedClass = selectedClassData['className'];
    }


    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => CustomFormDialog(
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
                setStateDialog(() {
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
                DropdownMenuItem(value: '3', child: Text('Professor 3')),
              ],
              onChanged: (value) => setStateDialog(() => selectedTeacher = value),
            ),
            CustomFormField(
              label: 'Disciplina',
              isDropdown: true,
              value: selectedSubject,
              items: const [
                DropdownMenuItem(value: '1', child: Text('Disciplina 1')),
                DropdownMenuItem(value: '2', child: Text('Disciplina 2')),
                DropdownMenuItem(value: '3', child: Text('Estruturas de Concreto')),
              ],
              onChanged: (value) => setStateDialog(() => selectedSubject = value),
            ),
            CustomFormField(
              label: 'Dia da Semana',
              isDropdown: true,
              value: selectedWeekday,
              items: weekdays.map((day) => DropdownMenuItem<String>(
                value: day,
                child: Text(day),
              )).toList(),
              onChanged: (value) => setStateDialog(() => selectedWeekday = value),
            ),
            CustomFormField(
              label: 'Horário',
              isDropdown: true,
              value: selectedTime,
              items: timeSlots.map((time) => DropdownMenuItem<String>(
                value: time,
                child: Text(time),
              )).toList(),
              onChanged: (value) => setStateDialog(() => selectedTime = value),
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
            
            String teacherName;
            switch (selectedTeacher) {
              case '1':
                teacherName = 'Professor 1';
                break;
              case '2':
                teacherName = 'Professor 2';
                break;
              case '3':
                teacherName = 'Professor 3';
                break;
              default:
                teacherName = '';
            }

            String subjectName;
            switch (selectedSubject) {
              case '1':
                subjectName = 'Disciplina 1';
                break;
              case '2':
                subjectName = 'Disciplina 2';
                break;
              case '3':
                subjectName = 'Estruturas de Concreto';
                break;
              default:
                subjectName = '';
            }


            final scheduleData = {
              'id': initialData?['id'] ?? DateTime.now().toString(),
              'course': selectedClassData?['course'] ?? '',
              'semester': selectedClassData?['semester'] ?? '',
              'period': selectedClassData?['period'] ?? '',
              'className': selectedClass ?? '',
              'teacher': teacherName,
              'subject': subjectName,
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

  Widget _buildWeekdayColumnWithContent(BuildContext context, String weekday) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double fontSize = (width * 0.012).clamp(14.0, 20.0);

    final schedulesForDay = schedules.where((s) => s['weekday'] == weekday).toList();
    final weekdaySchedulesCards = schedulesForDay
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

    return Container(
      width: 300, // Fixed width for each weekday column
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), // Consistent margin
      decoration: BoxDecoration(
        color: Colors.white, // Background for the entire column content area
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4, // Consistent shadow
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important for Column inside scrollview
        children: [
          // Header part
          Container(
            width: double.infinity, // Take full width of the 300px container
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.verdeUNICV,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weekday,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 1.2,
                  ),
                ),
                Text(
                  '${schedulesForDay.length} horário(s)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: fontSize * 0.9,
                  ),
                ),
              ],
            ),
          ),
          // Content part (cards)
          if (weekdaySchedulesCards.isEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              constraints: const BoxConstraints(minHeight: 100), // Give some min height to empty message
              child: Text(
                'Nenhum horário cadastrado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: fontSize,
                ),
              ),
            )
          else
            // This Column will allow cards to stack vertically.
            // The outer vertical SingleChildScrollView will handle its overflow if it's too tall.
            Padding(
              padding: const EdgeInsets.all(8.0), // Padding around the cards area
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: weekdaySchedulesCards,
              ),
            ),
        ],
      ),
    );
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              width * 0.01,
              screenSize.height * 0.02,
              width * 0.01,
              screenSize.height * 0.01,
            ),
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
          Expanded(
            child: RawScrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 10,
              thumbColor: AppColors.verdeUNICV.withOpacity(0.6),
              radius: const Radius.circular(20),
              controller: _horizontalScrollController,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalScrollController,
                child: SizedBox(
                  width: weekdays.length * 320, // Largura fixa para garantir scroll
                  child: RawScrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    thickness: 10,
                    thumbColor: AppColors.verdeUNICV.withOpacity(0.6),
                    radius: const Radius.circular(20),
                    controller: _verticalScrollController,
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0), // Espaço para ambas as barras de scroll
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: weekdays.map((day) {
                            return _buildWeekdayColumnWithContent(context, day);
                          }).toList(),
                        ),
                      ),
                    ),
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