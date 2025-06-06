import 'package:flutter/material.dart';
import '../../components/screens/custom_crud_screen.dart';
import '../../components/screens/custom_form_dialog.dart';
import '../../components/widgets/custom_multi_select_dropdown.dart';
import '../../theme/theme.dart';
import '../../backend/services/teacher.service.dart';
import '../../backend/services/subject.service.dart';
import '../../backend/model/teacher.dart';
import '../../backend/model/subject.dart';
import '../../backend/dto/teacher_dto.dart';

class TeacherCrudScreen extends StatefulWidget {
  const TeacherCrudScreen({super.key});

  @override
  State<TeacherCrudScreen> createState() => _TeacherCrudScreenState();
}

class _TeacherCrudScreenState extends State<TeacherCrudScreen> {
  late TeacherService _teacherService;
  late SubjectService _subjectService;
  List<Teacher> _actualTeachers = [];
  List<Subject> _actualSubjects = [];
  List<Map<String, dynamic>> _teachersMapped = [];
  bool _isLoading = true;

  final List<ColumnData> _columns = [
    ColumnData(label: 'Nome', getValue: (item) => item['nome'] as String),
    ColumnData(
      label: 'Disciplinas',
      getValue: (item) => (item['disciplinas'] as List<String>).join(', '),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _teacherService = TeacherService();
    _subjectService = SubjectService();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final teachers = await _teacherService.getTeachers();
      final subjects = await _subjectService.getSubjects();
      // Buscar disciplinas associadas a cada professor
      List<Map<String, dynamic>> mapped = [];
      for (final teacher in teachers) {
        // Buscar disciplinas desse professor
        final response = await _subjectService.supabase
          .from('professor_disciplina')
          .select('disciplina(*)')
          .eq('id_professor', teacher.id);
        final List<String> subjectNames = response
          .map<String>((e) => e['disciplina']?['nome'] ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
        mapped.add({
          'id': teacher.id,
          'nome': teacher.name,
          'disciplinas': subjectNames,
          '_original_teacher_object': teacher,
        });
      }
      setState(() {
        _actualTeachers = teachers;
        _actualSubjects = subjects;
        _teachersMapped = mapped;
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

  Map<String, dynamic> _teacherToMap(Teacher teacher) {
    // Aqui você precisará buscar as disciplinas do professor (relacionamento N:N)
    // Para simplificação, vamos supor que você tem um método para buscar as disciplinas de cada professor
    // Aqui, vamos apenas retornar uma lista vazia temporariamente
    // O ideal é criar um método no backend para retornar os professores já com suas disciplinas
    return {
      'id': teacher.id,
      'nome': teacher.name,
      'disciplinas': [], // Preencher depois com as disciplinas reais
      '_original_teacher_object': teacher,
    };
  }

  Future<void> _handleAdd() async {
    final nomeController = TextEditingController();
    List<Subject> selectedSubjects = [];

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CustomFormDialog(
          title: 'Novo Professor',
          fields: [
            CustomFormField(
              label: 'Nome do Professor',
              controller: nomeController,
              icon: Icons.person,
            ),
          ],
          onSave: (data) {
            if (nomeController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preencha o nome do professor'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            if (selectedSubjects.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selecione pelo menos uma disciplina'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            final teacherData = {
              'nome': nomeController.text,
              'disciplinas': selectedSubjects,
            };
            Navigator.pop(context, teacherData);
          },
          onCancel: () => Navigator.pop(context),
          customWidget: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CustomMultiSelectDropdown(
              label: 'Disciplinas',
              options: _actualSubjects.map((s) => s.name).toList(),
              selectedValues: selectedSubjects.map((s) => s.name).toList(),
              onChanged: (values) {
                setState(() {
                  selectedSubjects = _actualSubjects.where((s) => values.contains(s.name)).toList();
                });
              },
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      try {
        final TeacherDTO teacherDTO = TeacherDTO(
          name: result['nome'] as String,
          updatedAt: DateTime.now(),
          subjectsIds: (result['disciplinas'] as List<Subject>).map((s) => s.id).toList(),
        );
        await _teacherService.createTeacher(teacherDTO);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${teacherDTO.name}" adicionado com sucesso.')),
          );
        }
        _fetchData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar professor: ${e.toString()}')),
          );
        }
      }
    }
    nomeController.dispose();
  }

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    final Teacher originalTeacher = item['_original_teacher_object'] as Teacher;
    final nomeController = TextEditingController(text: originalTeacher.name);
    // Buscar disciplinas já vinculadas ao professor
    List<Subject> selectedSubjects = [];
    try {
      final response = await _subjectService.supabase
        .from('professor_disciplina')
        .select('disciplina(*)')
        .eq('id_professor', originalTeacher.id);
      selectedSubjects = response
        .where((e) => e['disciplina'] != null)
        .map<Subject>((e) => Subject.fromJson(e['disciplina']))
        .toList();
    } catch (_) {}

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CustomFormDialog(
          title: 'Editar Professor',
          fields: [
            CustomFormField(
              label: 'Nome do Professor',
              controller: nomeController,
              icon: Icons.person,
            ),
          ],
          onSave: (data) {
            if (nomeController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preencha o nome do professor'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            if (selectedSubjects.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selecione pelo menos uma disciplina'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            final teacherData = {
              'id': originalTeacher.id,
              'nome': nomeController.text,
              'disciplinas': selectedSubjects,
            };
            Navigator.pop(context, teacherData);
          },
          onCancel: () => Navigator.pop(context),
          customWidget: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CustomMultiSelectDropdown(
              label: 'Disciplinas',
              options: _actualSubjects.map((s) => s.name).toList(),
              selectedValues: selectedSubjects.map((s) => s.name).toList(),
              onChanged: (values) {
                setState(() {
                  selectedSubjects = _actualSubjects.where((s) => values.contains(s.name)).toList();
                });
              },
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      try {
        final TeacherDTO teacherDTO = TeacherDTO(
          name: result['nome'] as String,
          updatedAt: DateTime.now(),
          subjectsIds: (result['disciplinas'] as List<Subject>).map((s) => s.id).toList(),
        );
        await _teacherService.updateTeacher(teacherDTO, originalTeacher.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${teacherDTO.name}" atualizado com sucesso.')),
          );
        }
        _fetchData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar professor: ${e.toString()}')),
          );
        }
      }
    }
    nomeController.dispose();
  }

  void _handleDelete(Map<String, dynamic> item) async {
    final Teacher teacherToDelete = item['_original_teacher_object'] as Teacher;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o professor ${teacherToDelete.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _teacherService.deleteTeacher(teacherToDelete.id);
        _fetchData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${teacherToDelete.name}" excluído com sucesso.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir professor: ${e.toString()}')),
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
            title: 'Professores',
            columns: _columns,
            items: _teachersMapped,
            fields: const [],
            onEdit: _handleEdit,
            onDelete: _handleDelete,
            onAdd: _handleAdd,
          );
  }
}
