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
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _contentScrollController = ScrollController();
  bool _isSyncing = false; // Flag para evitar loops de sincronização

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

  @override
  void initState() {
    super.initState();
    _headerScrollController.addListener(_syncContentScroll);
    _contentScrollController.addListener(_syncHeaderScroll);
  }

  @override
  void dispose() {
    _headerScrollController.removeListener(_syncContentScroll);
    _contentScrollController.removeListener(_syncHeaderScroll);
    _headerScrollController.dispose();
    _contentScrollController.dispose();
    super.dispose();
  }

  void _syncHeaderScroll() {
    if (_isSyncing) return;
    _isSyncing = true;
    if (_headerScrollController.hasClients && _contentScrollController.hasClients) {
      if (_headerScrollController.offset != _contentScrollController.offset) {
        _contentScrollController.jumpTo(_headerScrollController.offset);
      }
    }
    Future.delayed(const Duration(milliseconds: 50), () => _isSyncing = false); // Pequeno delay para evitar chamadas rápidas
  }

  void _syncContentScroll() {
    if (_isSyncing) return;
    _isSyncing = true;
    if (_contentScrollController.hasClients && _headerScrollController.hasClients) {
      if (_contentScrollController.offset != _headerScrollController.offset) {
        _headerScrollController.jumpTo(_contentScrollController.offset);
      }
    }
    Future.delayed(const Duration(milliseconds: 50), () => _isSyncing = false);
  }

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

  Widget _buildFixedHeadersRow(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double fontSize = (width * 0.012).clamp(14.0, 20.0); // Consistente com WeekdayColumn original

    return Row(
      children: weekdays.map((weekday) {
        final schedulesForDay = schedules.where((s) => s['weekday'] == weekday).toList();
        return Container(
          width: 300, // Largura fixa para cada coluna de cabeçalho
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), // Margem para simular o card
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.verdeUNICV,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), // Apenas cantos superiores arredondados
             boxShadow: [ // Sombra sutil para o cabeçalho
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
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
        );
      }).toList(),
    );
  }

  Widget _buildScrollableContentRow(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double fontSize = (width * 0.012).clamp(14.0, 20.0); // Consistente

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinha colunas pelo topo
      children: weekdays.map((weekday) {
        final weekdaySchedulesCards = schedules
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

        return Container(
          width: 300, // Largura fixa para cada coluna de conteúdo
          margin: const EdgeInsets.symmetric(horizontal: 4), // Apenas margem horizontal
          decoration: BoxDecoration(
             color: Colors.white, // Fundo branco para a área dos cards
             borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)), // Cantos inferiores arredondados
             boxShadow: [ // Sombra correspondente ao cabeçalho
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1), // Sombra para baixo
              ),
            ],
          ),
          child: weekdaySchedulesCards.isEmpty
              ? Container( // Container para centralizar e dar padding à mensagem
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: Text(
                    'Nenhum horário cadastrado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: fontSize,
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min, // Para que a coluna não tente ser infinita
                  children: weekdaySchedulesCards,
                ),
        );
      }).toList(),
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
              screenSize.height * 0.01, // Padding menor abaixo do título
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
          // Cabeçalhos Fixos (horizontalmente roláveis)
          SingleChildScrollView(
            controller: _headerScrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(), // Para melhor sensação com sincronização
            child: _buildFixedHeadersRow(context),
          ),
          // Conteúdo Rolável (Vertical e Horizontal Sincronizado)
            Expanded(
            child: SingleChildScrollView( // Rolagem Vertical Principal
              physics: const ClampingScrollPhysics(),
              child: SingleChildScrollView( // Rolagem Horizontal do Conteúdo
                controller: _contentScrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: _buildScrollableContentRow(context),
                ),
              ),
            ),
          ],
      ),
    );
  }
} 