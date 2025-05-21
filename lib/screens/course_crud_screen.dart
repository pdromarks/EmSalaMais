import 'package:flutter/material.dart';
import '../components/screens/custom_crud_screen.dart';
import '../components/screens/custom_form_dialog.dart';
import '../theme/theme.dart';

class CourseCrudScreen extends StatefulWidget {
  const CourseCrudScreen({super.key});

  @override
  State<CourseCrudScreen> createState() => _CourseCrudScreenState();
}

class _CourseCrudScreenState extends State<CourseCrudScreen> {
  // Lista de cursos (simulando um banco de dados)
  final List<Map<String, dynamic>> _cursos = [
    {'id': '1', 'nome': 'Engenharia de Software'},
    {'id': '2', 'nome': 'Ciência da Computação'},
  ];

  // Definição das colunas da tabela
  final List<ColumnData> _columns = [
    ColumnData(
      label: 'Nome do Curso',
      getValue: (item) => item['nome'] as String,
    ),
  ];

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    final nomeController = TextEditingController(text: item['nome']);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => CustomFormDialog(
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

              final cursoData = {'id': item['id'], 'nome': nomeController.text};

              Navigator.pop(context, cursoData);
            },
            onCancel: () => Navigator.pop(context),
          ),
    );

    if (result != null) {
      setState(() {
        final index = _cursos.indexWhere(
          (curso) => curso['id'] == result['id'],
        );
        if (index != -1) {
          _cursos[index] = result;
        }
      });
    }

    nomeController.dispose();
  }

  void _handleDelete(Map<String, dynamic> item) {
    setState(() {
      _cursos.removeWhere((curso) => curso['id'] == item['id']);
    });
  }

  Future<void> _handleAdd() async {
    final nomeController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => CustomFormDialog(
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
                'id': DateTime.now().toString(),
                'nome': nomeController.text,
              };

              Navigator.pop(context, cursoData);
            },
            onCancel: () => Navigator.pop(context),
          ),
    );

    if (result != null) {
      setState(() {
        _cursos.add(result);
      });
    }

    nomeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCrudScreen(
      title: 'Cursos',
      columns: _columns,
      items: _cursos,
      fields:
          const [], // Não usado aqui pois temos uma tela separada para o formulário
      onEdit: _handleEdit,
      onDelete: _handleDelete,
      onAdd: _handleAdd,
    );
  }
}
