import 'package:flutter/material.dart';
import '../components/screens/custom_crud_screen.dart';
import '../components/screens/custom_form_dialog.dart';
import '../theme/theme.dart';

class SubjectrCrudScreen extends StatefulWidget {
  const SubjectrCrudScreen({super.key});

  @override
  State<SubjectrCrudScreen> createState() => _SubjectrCrudScreenState();
}

class _SubjectrCrudScreenState extends State<SubjectrCrudScreen> {
  // Lista de disciplinas (simulando um banco de dados)
  final List<Map<String, dynamic>> _disciplinas = [
    {'id': '1', 'nome': 'Metodologias Ágeis'},
    {'id': '2', 'nome': 'Java com orientação a objetos'},
  ];

  // Definição das colunas da tabela
  final List<ColumnData> _columns = [
    ColumnData(
      label: 'Nome da Disciplina',
      getValue: (item) => item['nome'] as String,
    ),
  ];

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    final nomeController = TextEditingController(text: item['nome']);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => CustomFormDialog(
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
                'id': item['id'],
                'nome': nomeController.text,
              };

              Navigator.pop(context, disciplinaData);
            },
            onCancel: () => Navigator.pop(context),
          ),
    );

    if (result != null) {
      setState(() {
        final index = _disciplinas.indexWhere(
          (disc) => disc['id'] == result['id'],
        );
        if (index != -1) {
          _disciplinas[index] = result;
        }
      });
    }

    nomeController.dispose();
  }

  void _handleDelete(Map<String, dynamic> item) {
    setState(() {
      _disciplinas.removeWhere((disc) => disc['id'] == item['id']);
    });
  }

  Future<void> _handleAdd() async {
    final nomeController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => CustomFormDialog(
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
                'id': DateTime.now().toString(),
                'nome': nomeController.text,
              };

              Navigator.pop(context, disciplinaData);
            },
            onCancel: () => Navigator.pop(context),
          ),
    );

    if (result != null) {
      setState(() {
        _disciplinas.add(result);
      });
    }

    nomeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCrudScreen(
      title: 'Disciplinas',
      columns: _columns,
      items: _disciplinas,
      fields:
          const [], // Não usado aqui pois temos uma tela separada para o formulário
      onEdit: _handleEdit,
      onDelete: _handleDelete,
      onAdd: _handleAdd,
    );
  }
}
