import 'package:flutter/material.dart';
import '../../components/screens/custom_crud_screen.dart';
import '../../components/screens/custom_form_dialog.dart';
import '../../theme/theme.dart';
import '../../backend/services/course.service.dart';
import '../../backend/model/course.dart';
import '../../backend/dto/course_dto.dart';

class CourseCrudScreen extends StatefulWidget {
  const CourseCrudScreen({super.key});

  @override
  State<CourseCrudScreen> createState() => _CourseCrudScreenState();
}

class _CourseCrudScreenState extends State<CourseCrudScreen> {
  late CourseService _courseService;
  List<Course> _actualCourses = [];
  bool _isLoading = true;

  // Definição das colunas da tabela
  final List<ColumnData> _columns = [
    ColumnData(
      label: 'Nome do Curso',
      getValue: (item) => item['nome'] as String,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _courseService = CourseService();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final courses = await _courseService.getCourses();
      if (mounted) {
        setState(() {
          _actualCourses = courses;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar cursos: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _courseToMap(Course course) {
    return {
      'id': course.id,
      'nome': course.name,
      '_original_course_object': course,
    };
  }

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    final Course originalCourse = item['_original_course_object'] as Course;
    final nomeController = TextEditingController(text: originalCourse.name);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomFormDialog(
        title: 'Editar Curso',
        fields: [
          CustomFormField(
            label: 'Nome do Curso',
            controller: nomeController,
            icon: Icons.school,
          ),
        ],
        onSave: (data) {
          if (nomeController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preencha o nome do curso'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          final cursoData = {
            'id': originalCourse.id,
            'nome': nomeController.text,
          };
          Navigator.pop(context, cursoData);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );

    if (result != null) {
      try {
        final CourseDTO courseDTO = CourseDTO(
          name: result['nome'] as String,
          updatedAt: DateTime.now(),
        );
        await _courseService.updateCourse(courseDTO, originalCourse.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${courseDTO.name}" atualizado com sucesso.')),
          );
        }
        _fetchCourses();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar curso: ${e.toString()}')),
          );
        }
      }
    }
    nomeController.dispose();
  }

  void _handleDelete(Map<String, dynamic> item) async {
    final Course courseToDelete = item['_original_course_object'] as Course;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o curso ${courseToDelete.name}?'),
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
        await _courseService.deleteCourse(courseToDelete.id);
        _fetchCourses();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${courseToDelete.name}" excluído com sucesso.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir curso: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _handleAdd() async {
    final nomeController = TextEditingController();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomFormDialog(
        title: 'Novo Curso',
        fields: [
          CustomFormField(
            label: 'Nome do Curso',
            controller: nomeController,
            icon: Icons.school,
          ),
        ],
        onSave: (data) {
          if (nomeController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preencha o nome do curso'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          final cursoData = {
            'nome': nomeController.text,
          };
          Navigator.pop(context, cursoData);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
    if (result != null) {
      try {
        final CourseDTO courseDTO = CourseDTO(
          name: result['nome'] as String,
          updatedAt: DateTime.now(),
        );
        await _courseService.createCourse(courseDTO);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${courseDTO.name}" adicionado com sucesso.')),
          );
        }
        _fetchCourses();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar curso: ${e.toString()}')),
          );
        }
      }
    }
    nomeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : CustomCrudScreen(
            title: 'Cursos',
            columns: _columns,
            items: _actualCourses.map(_courseToMap).toList(),
            fields: const [],
            onEdit: _handleEdit,
            onDelete: _handleDelete,
            onAdd: _handleAdd,
          );
  }
}
