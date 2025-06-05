import 'package:flutter/material.dart';
import '../../components/screens/custom_crud_screen.dart';
import '../../components/screens/custom_form_dialog.dart';
import '../../theme/theme.dart';
import '../../backend/services/subject.service.dart';
import '../../backend/model/subject.dart';
import '../../backend/dto/subject_dto.dart';

class SubjectCrudScreen extends StatefulWidget {
  const SubjectCrudScreen({super.key});

  @override
  State<SubjectCrudScreen> createState() => _SubjectCrudScreenState();
}

class _SubjectCrudScreenState extends State<SubjectCrudScreen> {
  late SubjectService _subjectService;
  List<Subject> _actualSubjects = [];
  bool _isLoading = true;

  // Definição das colunas da tabela
  final List<ColumnData> _columns = [
    ColumnData(
      label: 'Nome da Disciplina',
      getValue: (item) => item['nome'] as String,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _subjectService = SubjectService();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final subjects = await _subjectService.getSubjects();
      if (mounted) {
        setState(() {
          _actualSubjects = subjects;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar disciplinas: ${e.toString()}')),
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

  Map<String, dynamic> _subjectToMap(Subject subject) {
    return {
      'id': subject.id,
      'nome': subject.name,
      '_original_subject_object': subject,
    };
  }

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    final Subject originalSubject = item['_original_subject_object'] as Subject;
    final nomeController = TextEditingController(text: originalSubject.name);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomFormDialog(
        title: 'Editar Disciplina',
        fields: [
          CustomFormField(
            label: 'Nome da Disciplina',
            controller: nomeController,
            icon: Icons.book,
          ),
        ],
        onSave: (data) {
          if (nomeController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preencha o nome da disciplina'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          final disciplinaData = {
            'id': originalSubject.id,
            'nome': nomeController.text,
          };
          Navigator.pop(context, disciplinaData);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );

    if (result != null) {
      try {
        final SubjectDTO subjectDTO = SubjectDTO(
          name: result['nome'] as String,
          updatedAt: DateTime.now(),
        );
        await _subjectService.updateSubject(subjectDTO, originalSubject.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${subjectDTO.name}" atualizado com sucesso.')),
          );
        }
        _fetchSubjects();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar disciplina: ${e.toString()}')),
          );
        }
      }
    }
    nomeController.dispose();
  }

  void _handleDelete(Map<String, dynamic> item) async {
    final Subject subjectToDelete = item['_original_subject_object'] as Subject;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir a disciplina ${subjectToDelete.name}?'),
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
        await _subjectService.deleteSubject(subjectToDelete.id);
        _fetchSubjects();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${subjectToDelete.name}" excluído com sucesso.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir disciplina: ${e.toString()}')),
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
        title: 'Nova Disciplina',
        fields: [
          CustomFormField(
            label: 'Nome da Disciplina',
            controller: nomeController,
            icon: Icons.book,
          ),
        ],
        onSave: (data) {
          if (nomeController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preencha o nome da disciplina'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          final disciplinaData = {
            'nome': nomeController.text,
          };
          Navigator.pop(context, disciplinaData);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
    if (result != null) {
      try {
        final SubjectDTO subjectDTO = SubjectDTO(
          name: result['nome'] as String,
          updatedAt: DateTime.now(),
        );
        await _subjectService.createSubject(subjectDTO);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${subjectDTO.name}" adicionado com sucesso.')),
          );
        }
        _fetchSubjects();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar disciplina: ${e.toString()}')),
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
            title: 'Disciplinas',
            columns: _columns,
            items: _actualSubjects.map(_subjectToMap).toList(),
            fields: const [],
            onEdit: _handleEdit,
            onDelete: _handleDelete,
            onAdd: _handleAdd,
          );
  }
}
