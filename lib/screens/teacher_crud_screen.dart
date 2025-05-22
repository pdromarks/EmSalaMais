import 'package:flutter/material.dart';
import '../components/screens/custom_crud_screen.dart';
import '../components/screens/custom_form_dialog.dart';
import '../components/widgets/custom_multi_select_dropdown.dart';
import '../theme/theme.dart';

class TeacherCrudScreen extends StatefulWidget {
  const TeacherCrudScreen({super.key});

  @override
  State<TeacherCrudScreen> createState() => _TeacherCrudScreenState();
}

class _TeacherCrudScreenState extends State<TeacherCrudScreen> {
  // Lista de professores (simulando um banco de dados)
  final List<Map<String, dynamic>> _professores = [
    {
      'id': '1',
      'nome': 'João Silva',
      'disciplinas': ['Metodologias Ágeis', 'Programação Web'],
    },
    {
      'id': '2',
      'nome': 'Maria Santos',
      'disciplinas': ['Java com orientação a objetos', 'Banco de Dados'],
    },
  ];

  // Lista de disciplinas disponíveis
  final List<String> _disciplinas = [
    'Metodologias Ágeis',
    'Programação Web',
    'Java com orientação a objetos',
    'Banco de Dados',
    'Engenharia de Software',
    'Arquitetura de Software',
    'Desenvolvimento Mobile',
    'Inteligência Artificial',
  ];

  // Definição das colunas da tabela
  final List<ColumnData> _columns = [
    ColumnData(label: 'Nome', getValue: (item) => item['nome'] as String),
    ColumnData(
      label: 'Disciplinas',
      getValue: (item) => (item['disciplinas'] as List<String>).join(', '),
    ),
  ];

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    final nomeController = TextEditingController(text: item['nome']);
    List<String> selectedDisciplinas = List<String>.from(item['disciplinas']);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => CustomFormDialog(
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

                    if (selectedDisciplinas.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecione pelo menos uma disciplina'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final professorData = {
                      'id': item['id'],
                      'nome': nomeController.text,
                      'disciplinas': selectedDisciplinas,
                    };

                    Navigator.pop(context, professorData);
                  },
                  onCancel: () => Navigator.pop(context),
                  customWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomMultiSelectDropdown(
                      label: 'Disciplinas',
                      options: _disciplinas,
                      selectedValues: selectedDisciplinas,
                      onChanged: (values) {
                        setState(() {
                          selectedDisciplinas = values;
                        });
                      },
                    ),
                  ),
                ),
          ),
    );

    if (result != null) {
      setState(() {
        final index = _professores.indexWhere(
          (prof) => prof['id'] == result['id'],
        );
        if (index != -1) {
          _professores[index] = result;
        }
      });
    }

    nomeController.dispose();
  }

  void _handleDelete(Map<String, dynamic> item) {
    setState(() {
      _professores.removeWhere((prof) => prof['id'] == item['id']);
    });
  }

  Future<void> _handleAdd() async {
    final nomeController = TextEditingController();
    List<String> selectedDisciplinas = [];

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => CustomFormDialog(
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

                    if (selectedDisciplinas.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecione pelo menos uma disciplina'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final professorData = {
                      'id': DateTime.now().toString(),
                      'nome': nomeController.text,
                      'disciplinas': selectedDisciplinas,
                    };

                    Navigator.pop(context, professorData);
                  },
                  onCancel: () => Navigator.pop(context),
                  customWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomMultiSelectDropdown(
                      label: 'Disciplinas',
                      options: _disciplinas,
                      selectedValues: selectedDisciplinas,
                      onChanged: (values) {
                        setState(() {
                          selectedDisciplinas = values;
                        });
                      },
                    ),
                  ),
                ),
          ),
    );

    if (result != null) {
      setState(() {
        _professores.add(result);
      });
    }

    nomeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCrudScreen(
      title: 'Professores',
      columns: _columns,
      items: _professores,
      fields: const [],
      onEdit: _handleEdit,
      onDelete: _handleDelete,
      onAdd: _handleAdd,
    );
  }
}
