import 'package:flutter/material.dart';
import '../../components/screens/custom_crud_screen.dart';
import '../../components/screens/custom_form_dialog.dart';
import '../../components/widgets/custom_radio_button.dart';
import '../../theme/theme.dart';
import '../../backend/services/group.service.dart';
import '../../backend/services/course.service.dart';
import '../../backend/model/group.dart';
import '../../backend/model/course.dart';
import '../../backend/model/enums.dart';
import '../../backend/dto/group_dto.dart';

class GroupCrudScreen extends StatefulWidget {
  const GroupCrudScreen({super.key});

  @override
  State<GroupCrudScreen> createState() => _GroupCrudScreenState();
}

class _GroupCrudScreenState extends State<GroupCrudScreen> {
  late GroupService _groupService;
  late CourseService _courseService;
  List<GroupDTO> _actualGroups = [];
  List<Course> _actualCourses = [];
  bool _isLoading = true;

  // Controladores de estado do formulário
  final TextEditingController _turmaController = TextEditingController();
  Course? _selectedCourse;
  Semester? _selectedSemester;
  String? _selectedTurma;
  String? _selectedPeriodo;

  // Lista de turmas para o dropdown
  final List<String> _turmasOpcoes = ['A', 'B', 'C', 'D', 'E'];

  // Opções de período para o radio button
  final List<Map<String, String>> _periodos = [
    {'label': 'Matutino', 'value': 'matutino'},
    {'label': 'Vespertino', 'value': 'vespertino'},
    {'label': 'Noturno', 'value': 'noturno'},
  ];

  final List<ColumnData> _columns = [
    ColumnData(label: 'Curso', getValue: (item) => item['curso'] as String),
    ColumnData(label: 'Turma', getValue: (item) => item['turma'] as String),
    ColumnData(
      label: 'Semestre',
      getValue: (item) => item['semestre'] as String,
    ),
    ColumnData(label: 'Período', getValue: (item) => item['periodo'] as String),
  ];

  @override
  void initState() {
    super.initState();
    _groupService = GroupService();
    _courseService = CourseService();
    _fetchData();
  }

  @override
  void dispose() {
    _turmaController.dispose();
    super.dispose();
  }

  void _resetFormState() {
    setState(() {
      _selectedCourse = null;
      _selectedSemester = null;
      _selectedTurma = null;
      _selectedPeriodo = null;
      _turmaController.clear();
    });
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final groups = await _groupService.getGroups();
      final courses = await _courseService.getCourses();
      setState(() {
        _actualGroups =
            groups
                .map(
                  (g) => GroupDTO(
                    name: g.name,
                    updatedAt: g.updatedAt ?? DateTime.now(),
                    courseId: g.course.id,
                    semester: g.semester,
                    id: g.id,
                  ),
                )
                .toList();
        _actualCourses = courses;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar dados: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _groupsMapped =>
      _actualGroups
          .map(
            (g) => {
              'id': g.id,
              'turma': g.name,
              'curso':
                  _actualCourses.firstWhere((c) => c.id == g.courseId).name,
              'semestre': _semesterToLabel(g.semester),
              'periodo': _getPeriodFromSemester(g.semester),
              '_original_group_object': g,
            },
          )
          .toList();

  String _semesterToLabel(Semester s) {
    final idx = Semester.values.indexOf(s) + 1;
    return '${idx}º Semestre';
  }

  String _getPeriodFromSemester(Semester s) {
    // Mapeamento do semestre para o período
    switch (s) {
      case Semester.primeiro:
      case Semester.segundo:
        return 'Matutino';
      case Semester.terceiro:
      case Semester.quarto:
        return 'Vespertino';
      case Semester.quinto:
      case Semester.sexto:
        return 'Noturno';
      default:
        return 'Noturno';
    }
  }

  Semester _getSemesterFromPeriod(String periodo) {
    // Mapeamento do período para o semestre
    switch (periodo) {
      case 'matutino':
        return Semester.primeiro;
      case 'vespertino':
        return Semester.terceiro;
      case 'noturno':
        return Semester.quinto;
      default:
        return Semester.primeiro;
    }
  }

  Future<void> _handleAdd() async {
    _resetFormState();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => CustomFormDialog(
                  title: 'Nova Turma',
                  fields: [
                    CustomFormField(
                      label: 'Curso',
                      isDropdown: true,
                      value: _selectedCourse?.name,
                      items:
                          _actualCourses
                              .map(
                                (c) => DropdownMenuItem<String>(
                                  value: c.name,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCourse =
                              value == null
                                  ? null
                                  : _actualCourses.firstWhere(
                                    (c) => c.name == value,
                                  );
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Turma',
                      isDropdown: true,
                      value: _selectedTurma,
                      items:
                          _turmasOpcoes
                              .map(
                                (turma) => DropdownMenuItem<String>(
                                  value: turma,
                                  child: Text(turma),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTurma = value;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Semestre',
                      isDropdown: true,
                      value:
                          _selectedSemester != null
                              ? _semesterToLabel(_selectedSemester!)
                              : null,
                      items:
                          Semester.values
                              .map(
                                (s) => DropdownMenuItem<String>(
                                  value: _semesterToLabel(s),
                                  child: Text(_semesterToLabel(s)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            _selectedSemester =
                                Semester.values[int.parse(value.split('º')[0]) -
                                    1];
                          } else {
                            _selectedSemester = null;
                          }
                        });
                      },
                    ),
                  ],
                  onSave: (data) {
                    if (_selectedCourse == null ||
                        _selectedTurma == null ||
                        _selectedSemester == null ||
                        _selectedPeriodo == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha todos os campos obrigatórios!',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    final groupData = {
                      'curso': _selectedCourse,
                      'semestre': _selectedSemester,
                      'turma': _selectedTurma,
                      'periodo': _selectedPeriodo,
                    };
                    Navigator.pop(context, groupData);
                  },
                  onCancel: () => Navigator.pop(context),
                  customWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomRadioButton<String>(
                      label: 'Período',
                      value: _selectedPeriodo,
                      groupValue: _selectedPeriodo,
                      options: _periodos,
                      onChanged: (value) {
                        setState(() {
                          _selectedPeriodo = value;
                          if (value != null) {
                            _selectedSemester = _getSemesterFromPeriod(value);
                          }
                        });
                      },
                    ),
                  ),
                ),
          ),
    );

    if (result != null) {
      try {
        final GroupDTO groupDTO = GroupDTO(
          name: result['turma'] as String,
          updatedAt: DateTime.now(),
          courseId: (result['curso'] as Course).id,
          semester: result['semestre'] as Semester,
          id: null,
        );
        await _groupService.createGroup(groupDTO);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Turma adicionada com sucesso.')),
          );
        }
        _fetchData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar turma: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    final GroupDTO originalGroup = item['_original_group_object'] as GroupDTO;
    final periodoBanco = _getPeriodFromSemester(originalGroup.semester);
    print('PERIODO DO BANCO: $periodoBanco');
    setState(() {
      _selectedCourse = _actualCourses.firstWhere(
        (c) => c.id == originalGroup.courseId,
      );
      _selectedSemester = originalGroup.semester;
      _selectedTurma = originalGroup.name;
      _selectedPeriodo = periodoBanco.toLowerCase();
      _turmaController.text = originalGroup.name;
    });

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => CustomFormDialog(
                  title: 'Editar Turma',
                  fields: [
                    CustomFormField(
                      label: 'Curso',
                      isDropdown: true,
                      value: _selectedCourse?.name,
                      items:
                          _actualCourses
                              .map(
                                (c) => DropdownMenuItem<String>(
                                  value: c.name,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCourse = _actualCourses.firstWhere(
                            (c) => c.name == value,
                          );
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Turma',
                      isDropdown: true,
                      value: _selectedTurma,
                      items:
                          _turmasOpcoes
                              .map(
                                (turma) => DropdownMenuItem<String>(
                                  value: turma,
                                  child: Text(turma),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTurma = value!;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Semestre',
                      isDropdown: true,
                      value: _semesterToLabel(_selectedSemester!),
                      items:
                          Semester.values
                              .map(
                                (s) => DropdownMenuItem<String>(
                                  value: _semesterToLabel(s),
                                  child: Text(_semesterToLabel(s)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            _selectedSemester =
                                Semester.values[int.parse(value.split('º')[0]) -
                                    1];
                          }
                        });
                      },
                    ),
                  ],
                  onSave: (data) {
                    if (_selectedCourse == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecione um curso'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    final groupData = {
                      'curso': _selectedCourse,
                      'semestre': _selectedSemester,
                      'turma': _selectedTurma,
                      'periodo': _selectedPeriodo,
                    };
                    Navigator.pop(context, groupData);
                  },
                  onCancel: () => Navigator.pop(context),
                  customWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomRadioButton<String>(
                      label: 'Período',
                      value: _selectedPeriodo,
                      groupValue: _selectedPeriodo,
                      options: _periodos,
                      onChanged: (value) {
                        setState(() {
                          _selectedPeriodo = value;
                          _selectedSemester = _getSemesterFromPeriod(value!);
                        });
                      },
                    ),
                  ),
                ),
          ),
    );

    if (result != null) {
      try {
        final GroupDTO groupDTO = GroupDTO(
          name: result['turma'] as String,
          updatedAt: DateTime.now(),
          courseId: (result['curso'] as Course).id,
          semester: result['semestre'] as Semester,
          id: originalGroup.id,
        );
        await _groupService.updateGroup(groupDTO, originalGroup.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Turma atualizada com sucesso.')),
          );
        }
        _fetchData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar turma: ${e.toString()}')),
          );
        }
      }
    }
  }

  void _handleDelete(Map<String, dynamic> item) async {
    final GroupDTO groupToDelete = item['_original_group_object'] as GroupDTO;
    final String cursoNome =
        _actualCourses.firstWhere((c) => c.id == groupToDelete.courseId).name;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text(
              'Deseja realmente excluir a turma "$cursoNome - ${groupToDelete.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _groupService.deleteGroup(groupToDelete.id!);
        _fetchData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Turma excluída com sucesso.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir turma: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : CustomCrudScreen(
          title: 'Turmas',
          columns: _columns,
          items: _groupsMapped,
          fields: const [],
          onEdit: _handleEdit,
          onDelete: _handleDelete,
          onAdd: _handleAdd,
        );
  }
}
