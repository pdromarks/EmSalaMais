import 'package:flutter/material.dart';
import '../../components/screens/custom_crud_screen.dart';
import '../../components/screens/custom_form_dialog.dart';
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
  List<Group> _actualGroups = [];
  List<Course> _actualCourses = [];
  bool _isLoading = true;

  final List<ColumnData> _columns = [
    ColumnData(label: 'Curso', getValue: (item) => item['curso'] as String),
    ColumnData(label: 'Semestre', getValue: (item) => item['semestre'] as String),
    ColumnData(label: 'Período', getValue: (item) => item['periodo'] as String),
  ];

  @override
  void initState() {
    super.initState();
    _groupService = GroupService();
    _courseService = CourseService();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() { _isLoading = true; });
    try {
      final groups = await _groupService.getGroups();
      final courses = await _courseService.getCourses();
      setState(() {
        _actualGroups = groups;
        _actualCourses = courses;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar dados: ${e.toString()}')),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  List<Map<String, dynamic>> get _groupsMapped => _actualGroups.map((g) => {
    'id': g.id,
    'curso': g.course.name,
    'semestre': _semesterToLabel(g.semester),
    'periodo': _periodToLabel(g.semester),
    '_original_group_object': g,
  }).toList();

  String _semesterToLabel(Semester s) {
    final idx = Semester.values.indexOf(s) + 1;
    return '${idx}º Semestre';
  }

  String _periodToLabel(Semester s) {
    // Ajuste conforme seu modelo, se necessário
    return '';
  }

  Future<void> _handleAdd() async {
    Course? selectedCourse = _actualCourses.isNotEmpty ? _actualCourses.first : null;
    Semester selectedSemester = Semester.primeiro;
    ScheduleTime selectedPeriod = ScheduleTime.noturno;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CustomFormDialog(
          title: 'Nova Turma',
          fields: [
            CustomFormField(
              label: 'Curso',
              isDropdown: true,
              value: selectedCourse?.name,
              items: _actualCourses.map((c) => DropdownMenuItem<String>(
                value: c.name,
                child: Text(c.name),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = _actualCourses.firstWhere((c) => c.name == value);
                });
              },
            ),
            CustomFormField(
              label: 'Semestre',
              isDropdown: true,
              value: _semesterToLabel(selectedSemester),
              items: Semester.values.map((s) => DropdownMenuItem<String>(
                value: _semesterToLabel(s),
                child: Text(_semesterToLabel(s)),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedSemester = Semester.values[int.parse(value.split('º')[0]) - 1];
                  }
                });
              },
            ),
            CustomFormField(
              label: 'Período',
              isDropdown: true,
              value: selectedPeriod.name,
              items: ScheduleTime.values.map((e) => DropdownMenuItem<String>(
                value: e.name,
                child: Text(e.name[0].toUpperCase() + e.name.substring(1)),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedPeriod = ScheduleTime.values.firstWhere((e) => e.name == value);
                  }
                });
              },
            ),
          ],
          onSave: (data) {
            if (selectedCourse == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecione um curso'), backgroundColor: Colors.red),
              );
              return;
            }
            final groupData = {
              'curso': selectedCourse,
              'semestre': selectedSemester,
              'periodo': selectedPeriod,
            };
            Navigator.pop(context, groupData);
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );

    if (result != null) {
      try {
        final GroupDTO groupDTO = GroupDTO(
          name: '', // Ajuste se necessário
          updatedAt: DateTime.now(),
          courseId: (result['curso'] as Course).id,
          semester: result['semestre'] as Semester,
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
    final Group originalGroup = item['_original_group_object'] as Group;
    Course? selectedCourse = _actualCourses.firstWhere((c) => c.id == originalGroup.course.id);
    Semester selectedSemester = originalGroup.semester;
    ScheduleTime selectedPeriod = ScheduleTime.noturno;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CustomFormDialog(
          title: 'Editar Turma',
          fields: [
            CustomFormField(
              label: 'Curso',
              isDropdown: true,
              value: selectedCourse?.name,
              items: _actualCourses.map((c) => DropdownMenuItem<String>(
                value: c.name,
                child: Text(c.name),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = _actualCourses.firstWhere((c) => c.name == value);
                });
              },
            ),
            CustomFormField(
              label: 'Semestre',
              isDropdown: true,
              value: _semesterToLabel(selectedSemester),
              items: Semester.values.map((s) => DropdownMenuItem<String>(
                value: _semesterToLabel(s),
                child: Text(_semesterToLabel(s)),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedSemester = Semester.values[int.parse(value.split('º')[0]) - 1];
                  }
                });
              },
            ),
            CustomFormField(
              label: 'Período',
              isDropdown: true,
              value: selectedPeriod.name,
              items: ScheduleTime.values.map((e) => DropdownMenuItem<String>(
                value: e.name,
                child: Text(e.name[0].toUpperCase() + e.name.substring(1)),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedPeriod = ScheduleTime.values.firstWhere((e) => e.name == value);
                  }
                });
              },
            ),
          ],
          onSave: (data) {
            if (selectedCourse == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecione um curso'), backgroundColor: Colors.red),
              );
              return;
            }
            final groupData = {
              'curso': selectedCourse,
              'semestre': selectedSemester,
              'periodo': selectedPeriod,
            };
            Navigator.pop(context, groupData);
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );

    if (result != null) {
      try {
        final GroupDTO groupDTO = GroupDTO(
          name: '', // Ajuste se necessário
          updatedAt: DateTime.now(),
          courseId: (result['curso'] as Course).id,
          semester: result['semestre'] as Semester,
        );
        await _groupService.updateGroup(groupDTO, originalGroup.id);
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
    final Group groupToDelete = item['_original_group_object'] as Group;
    try {
      await _groupService.deleteGroup(groupToDelete.id);
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
