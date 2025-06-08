import 'package:flutter/material.dart';
import '../../components/widgets/schedule_card.dart';
import '../../theme/theme.dart';
import '../../components/screens/custom_form_dialog.dart';
import '../../backend/services/schedule.service.dart';
import '../../backend/services/schedule_teacher.service.dart';
import '../../backend/services/group.service.dart';
import '../../backend/services/teacher.service.dart';
import '../../backend/services/subject.service.dart';
import '../../backend/model/schedule.dart';
import '../../backend/model/schedule_teacher.dart';
import '../../backend/model/group.dart';
import '../../backend/model/teacher.dart';
import '../../backend/model/subject.dart';
import '../../backend/dto/schedule_dto.dart';
import '../../backend/dto/schedule_teacher_dto.dart';
import '../../backend/model/enums.dart';
import '../../backend/model/course.dart';

class ScheduleCrudScreen extends StatefulWidget {
  const ScheduleCrudScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleCrudScreen> createState() => _ScheduleCrudScreenState();
}

class _ScheduleCrudScreenState extends State<ScheduleCrudScreen> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  // Serviços
  late final ScheduleService _scheduleService;
  late final ScheduleTeacherService _scheduleTeacherService;
  late final GroupService _groupService;
  late final TeacherService _teacherService;
  late final SubjectService _subjectService;

  // Estado
  List<ScheduleTeacher> _schedules = [];
  List<Group> _groups = [];
  List<Teacher> _teachers = [];
  List<Subject> _subjectsForDropdown = [];
  bool _isLoading = true;

  final List<String> weekdays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  final List<String> timeSlots = ['Primeira Aula', 'Segunda Aula'];

  final Map<String, String> timeSlotToEnumName = {
    'Primeira Aula': '1',
    'Segunda Aula': '2',
  };

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _fetchData();
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _initializeServices() {
    _scheduleService = ScheduleService();
    _scheduleTeacherService = ScheduleTeacherService();
    _groupService = GroupService();
    _teacherService = TeacherService();
    _subjectService = SubjectService();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final schedules = await _scheduleTeacherService.getScheduleTeachers();
      final groups = await _groupService.getGroups();
      final teachers = await _teacherService.getTeachers();
      final subjects = await _subjectService.getSubjects();

      setState(() {
        _groups = groups;
        _teachers = teachers;
        _subjectsForDropdown = subjects;

        _schedules =
            schedules.map((dto) {
              final teacher = teachers.firstWhere(
                (t) => t.id == dto.teacherId,
                orElse: () => Teacher(id: 0, name: ''),
              );

              final group = groups.firstWhere(
                (g) => g.id == dto.groupId,
                orElse:
                    () => Group(
                      id: 0,
                      name: '',
                      course: Course(id: 0, name: ''),
                      semester: Semester.primeiro,
                    ),
              );

              final subject = subjects.firstWhere(
                (s) => s.id == dto.subjectId,
                orElse: () => Subject(id: 0, name: ''),
              );

              return ScheduleTeacher(
                id: 0, // ID será definido pelo backend
                teacher: teacher,
                group: group,
                schedule: Schedule(
                  id: dto.scheduleId ?? 0,
                  scheduleStart: '',
                  scheduleEnd: '',
                  scheduleTime: ScheduleTime.primeira,
                ),
                subject: subject,
                dayOfWeek: dto.dayOfWeek,
              );
            }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, String> _getHorarios(String aulaLabel, String periodo) {
    final periodoLower = periodo.toLowerCase();

    // Validação do período
    if (!['noturno', 'matutino', 'vespertino'].contains(periodoLower)) {
      throw Exception('Período inválido: $periodo');
    }

    // Validação da aula
    if (!timeSlots.contains(aulaLabel)) {
      throw Exception('Aula inválida: $aulaLabel');
    }

    // Mapeamento de horários
    final horarios = {
      'noturno': {
        'Primeira Aula': {'inicio': '19:00', 'fim': '20:40'},
        'Segunda Aula': {'inicio': '20:55', 'fim': '22:30'},
      },
      'matutino': {
        'Primeira Aula': {'inicio': '07:30', 'fim': '09:10'},
        'Segunda Aula': {'inicio': '09:25', 'fim': '11:05'},
      },
      'vespertino': {
        'Primeira Aula': {'inicio': '13:30', 'fim': '15:10'},
        'Segunda Aula': {'inicio': '15:25', 'fim': '17:05'},
      },
    };

    return horarios[periodoLower]![aulaLabel]!;
  }

  Future<void> _handleDelete(ScheduleTeacher schedule) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir este horário?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _scheduleTeacherService.deleteScheduleTeacher(
                      schedule.id,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Horário excluído com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    _fetchData();
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao excluir horário: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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

  Future<void> _fetchSubjectsForTeacher(int teacherId) async {
    try {
      final subjects = await _subjectService.getSubjects();
      setState(() {
        _subjectsForDropdown =
            subjects.where((s) => s.id == teacherId).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar disciplinas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showFormDialog([ScheduleTeacher? initialData]) async {
    int? selectedGroupId = initialData?.group.id;
    int? selectedTeacherId = initialData?.teacher.id;
    int? selectedSubjectId = initialData?.subject.id;
    DayOfWeek? selectedWeekday = initialData?.dayOfWeek as DayOfWeek?;
    String? selectedTime = initialData?.schedule.scheduleTime.name;

    if (selectedTeacherId != null) {
      await _fetchSubjectsForTeacher(selectedTeacherId);
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => CustomFormDialog(
                  title:
                      initialData != null ? 'Editar Horário' : 'Novo Horário',
                  fields: [
                    CustomFormField(
                      label: 'Turma',
                      isDropdown: true,
                      value: selectedGroupId?.toString(),
                      items:
                          _groups
                              .map(
                                (group) => DropdownMenuItem<String>(
                                  value: group.id.toString(),
                                  child: Text(
                                    '${group.course.name} - ${_formatSemester(group.semester)} - Turma ${group.name}',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedGroupId = int.parse(value!);
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Professor',
                      isDropdown: true,
                      value: selectedTeacherId?.toString(),
                      items:
                          _teachers
                              .map(
                                (teacher) => DropdownMenuItem<String>(
                                  value: teacher.id.toString(),
                                  child: Text(teacher.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) async {
                        setStateDialog(() {
                          selectedTeacherId = int.parse(value!);
                          _subjectsForDropdown = [];
                          selectedSubjectId = null;
                        });
                        print('Professor selecionado: $selectedTeacherId');
                        final subjects = await _subjectService
                            .getSubjectsByTeacher(selectedTeacherId!);
                        setStateDialog(() {
                          _subjectsForDropdown = subjects;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Disciplina',
                      isDropdown: true,
                      value: selectedSubjectId?.toString(),
                      items:
                          _subjectsForDropdown
                              .map(
                                (subject) => DropdownMenuItem<String>(
                                  value: subject.id.toString(),
                                  child: Text(subject.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedSubjectId = int.parse(value!);
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Dia da Semana',
                      isDropdown: true,
                      value: selectedWeekday?.name,
                      items:
                          DayOfWeek.values
                              .map(
                                (day) => DropdownMenuItem<String>(
                                  value: day.name,
                                  child: Text(day.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedWeekday = DayOfWeek.values.byName(value!);
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Horário',
                      isDropdown: true,
                      value: selectedTime,
                      items:
                          timeSlots
                              .map(
                                (time) => DropdownMenuItem<String>(
                                  value: time,
                                  child: Text(time),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedTime = value;
                        });
                      },
                    ),
                  ],
                  onSave: (data) async {
                    if (selectedGroupId == null ||
                        selectedTeacherId == null ||
                        selectedSubjectId == null ||
                        selectedWeekday == null ||
                        selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, preencha todos os campos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      final selectedGroup = _groups.firstWhere(
                        (g) => g.id == selectedGroupId,
                      );
                      final horarios = _getHorarios(
                        selectedTime!,
                        _getPeriodFromSemester(selectedGroup.semester),
                      );

                      // Criação direta do ScheduleTeacherDTO, sem criar Schedule
                      final scheduleTeacherDTO = ScheduleTeacherDTO(
                        scheduleId: null, // ou algum valor padrão se necessário
                        teacherId: selectedTeacherId!,
                        groupId: selectedGroupId!,
                        subjectId: selectedSubjectId!,
                        dayOfWeek: selectedWeekday!,
                        updatedAt: DateTime.now(),
                      );

                      if (initialData != null) {
                        await _scheduleTeacherService.updateScheduleTeacher(
                          scheduleTeacherDTO,
                          initialData.id,
                        );
                      } else {
                        await _scheduleTeacherService.createScheduleTeacher(
                          scheduleTeacherDTO,
                        );
                      }

                      Navigator.pop(context, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            initialData != null
                                ? 'Horário atualizado com sucesso'
                                : 'Horário criado com sucesso',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _fetchData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao salvar horário: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  onCancel: () => Navigator.pop(context),
                ),
          ),
    );
  }

  Widget _buildWeekdayColumnWithContent(BuildContext context, String weekday) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double fontSize = (width * 0.012).clamp(14.0, 20.0);

    final schedulesForDay =
        _schedules.where((s) => s.dayOfWeek.name == weekday).toList();
    final weekdaySchedulesCards =
        schedulesForDay
            .map(
              (schedule) => ScheduleCard(
                course: schedule.group.course.name,
                semester: '${schedule.group.semester}º Sem',
                period: schedule.group.semester.name,
                className: schedule.group.name,
                teacher: schedule.teacher.name,
                subject: schedule.subject.name,
                time: schedule.schedule.scheduleTime.name,
                onEdit: () => _showFormDialog(schedule),
                onDelete: () => _handleDelete(schedule),
              ),
            )
            .toList();

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.verdeUNICV,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
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
          if (weekdaySchedulesCards.isEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              constraints: const BoxConstraints(minHeight: 100),
              child: Text(
                'Nenhum horário cadastrado',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: fontSize),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: weekdaySchedulesCards,
              ),
            ),
        ],
      ),
    );
  }

  // Função auxiliar para formatar semestre
  String _formatSemester(Semester s) {
    final idx = Semester.values.indexOf(s) + 1;
    return '${idx}º Sem';
  }

  String _getPeriodFromSemester(Semester s) {
    // Implemente a lógica para mapear o semestre para o período correto
    // Este é um exemplo básico e pode ser melhorado com uma lógica mais robusta
    switch (s) {
      case Semester.primeiro:
        return 'matutino';
      case Semester.segundo:
        return 'vespertino';
      case Semester.terceiro:
        return 'vespertino';
      case Semester.quarto:
        return 'vespertino';
      case Semester.quinto:
        return 'vespertino';
      case Semester.sexto:
        return 'vespertino';
      case Semester.setimo:
        return 'vespertino';
      case Semester.oitavo:
        return 'vespertino';
      case Semester.nono:
        return 'vespertino';
      case Semester.decimo:
        return 'vespertino';
      default:
        throw Exception('Semestre inválido: $s');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double titleFontSize = (width * 0.08).clamp(20.0, 40.0);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                  width: weekdays.length * 320,
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
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          right: 16.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              weekdays.map((day) {
                                return _buildWeekdayColumnWithContent(
                                  context,
                                  day,
                                );
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
