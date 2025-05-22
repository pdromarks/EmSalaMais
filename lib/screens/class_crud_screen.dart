import 'package:flutter/material.dart';
import '../components/screens/custom_crud_screen.dart';
import '../components/screens/custom_form_dialog.dart';
import '../components/widgets/custom_radio_button.dart';
import '../theme/theme.dart';

class ClassCrudScreen extends StatefulWidget {
  const ClassCrudScreen({super.key});

  @override
  State<ClassCrudScreen> createState() => _ClassCrudScreenState();
}

class _ClassCrudScreenState extends State<ClassCrudScreen> {
  // Lista de turmas (simulando um banco de dados)
  final List<Map<String, dynamic>> _turmas = [
    {
      'id': '1',
      'curso': 'Engenharia de Software',
      'semestre': '1º Semestre',
      'periodo': 'Noturno',
      'turma': 'A',
    },
    {
      'id': '2',
      'curso': 'Ciência da Computação',
      'semestre': '2º Semestre',
      'periodo': 'Matutino',
      'turma': 'B',
    },
  ];

  // Lista de cursos para o dropdown
  final List<String> _cursos = [
    'Engenharia de Software',
    'Ciência da Computação',
    'Sistemas de Informação',
  ];

  // Lista de semestres para o dropdown
  final List<String> _semestres = [
    '1º Semestre',
    '2º Semestre',
    '3º Semestre',
    '4º Semestre',
    '5º Semestre',
    '6º Semestre',
    '7º Semestre',
    '8º Semestre',
  ];

  // Lista de turmas para o dropdown
  final List<String> _turmasOpcoes = ['A', 'B', 'C', 'D', 'E'];

  // Opções de período para o radio button
  final List<Map<String, String>> _periodos = [
    {'label': 'Matutino', 'value': 'Matutino'},
    {'label': 'Vespertino', 'value': 'Vespertino'},
    {'label': 'Noturno', 'value': 'Noturno'},
  ];

  // Definição das colunas da tabela
  final List<ColumnData> _columns = [
    ColumnData(label: 'Curso', getValue: (item) => item['curso'] as String),
    ColumnData(
      label: 'Semestre',
      getValue: (item) => item['semestre'] as String,
    ),
    ColumnData(label: 'Período', getValue: (item) => item['periodo'] as String),
    ColumnData(label: 'Turma', getValue: (item) => item['turma'] as String),
  ];

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    String selectedCurso = item['curso'];
    String selectedSemestre = item['semestre'];
    String selectedPeriodo = item['periodo'];
    String selectedTurma = item['turma'];

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
                      value: selectedCurso,
                      items:
                          _cursos.map((curso) {
                            return DropdownMenuItem<String>(
                              value: curso,
                              child: Text(curso),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCurso = value!;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Semestre',
                      isDropdown: true,
                      value: selectedSemestre,
                      items:
                          _semestres.map((semestre) {
                            return DropdownMenuItem<String>(
                              value: semestre,
                              child: Text(semestre),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSemestre = value!;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Turma',
                      isDropdown: true,
                      value: selectedTurma,
                      items:
                          _turmasOpcoes.map((turma) {
                            return DropdownMenuItem<String>(
                              value: turma,
                              child: Text(turma),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTurma = value!;
                        });
                      },
                    ),
                  ],
                  onSave: (data) {
                    if (selectedCurso.isEmpty ||
                        selectedSemestre.isEmpty ||
                        selectedPeriodo.isEmpty ||
                        selectedTurma.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, preencha todos os campos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final turmaData = {
                      'id': item['id'],
                      'curso': selectedCurso,
                      'semestre': selectedSemestre,
                      'periodo': selectedPeriodo,
                      'turma': selectedTurma,
                    };

                    Navigator.pop(context, turmaData);
                  },
                  onCancel: () => Navigator.pop(context),
                  customWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomRadioButton<String>(
                      label: 'Período',
                      value: selectedPeriodo,
                      groupValue: selectedPeriodo,
                      options: _periodos,
                      onChanged: (value) {
                        setState(() {
                          selectedPeriodo = value!;
                        });
                      },
                    ),
                  ),
                ),
          ),
    );

    if (result != null) {
      setState(() {
        final index = _turmas.indexWhere(
          (turma) => turma['id'] == result['id'],
        );
        if (index != -1) {
          _turmas[index] = result;
        }
      });
    }
  }

  void _handleDelete(Map<String, dynamic> item) {
    setState(() {
      _turmas.removeWhere((turma) => turma['id'] == item['id']);
    });
  }

  Future<void> _handleAdd() async {
    String selectedCurso = _cursos[0];
    String selectedSemestre = _semestres[0];
    String selectedPeriodo = _periodos[0]['value']!;
    String selectedTurma = _turmasOpcoes[0];

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
                      value: selectedCurso,
                      items:
                          _cursos.map((curso) {
                            return DropdownMenuItem<String>(
                              value: curso,
                              child: Text(curso),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCurso = value!;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Semestre',
                      isDropdown: true,
                      value: selectedSemestre,
                      items:
                          _semestres.map((semestre) {
                            return DropdownMenuItem<String>(
                              value: semestre,
                              child: Text(semestre),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSemestre = value!;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Turma',
                      isDropdown: true,
                      value: selectedTurma,
                      items:
                          _turmasOpcoes.map((turma) {
                            return DropdownMenuItem<String>(
                              value: turma,
                              child: Text(turma),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTurma = value!;
                        });
                      },
                    ),
                  ],
                  onSave: (data) {
                    if (selectedCurso.isEmpty ||
                        selectedSemestre.isEmpty ||
                        selectedPeriodo.isEmpty ||
                        selectedTurma.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, preencha todos os campos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final turmaData = {
                      'id': DateTime.now().toString(),
                      'curso': selectedCurso,
                      'semestre': selectedSemestre,
                      'periodo': selectedPeriodo,
                      'turma': selectedTurma,
                    };

                    Navigator.pop(context, turmaData);
                  },
                  onCancel: () => Navigator.pop(context),
                  customWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomRadioButton<String>(
                      label: 'Período',
                      value: selectedPeriodo,
                      groupValue: selectedPeriodo,
                      options: _periodos,
                      onChanged: (value) {
                        setState(() {
                          selectedPeriodo = value!;
                        });
                      },
                    ),
                  ),
                ),
          ),
    );

    if (result != null) {
      setState(() {
        _turmas.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCrudScreen(
      title: 'Turmas',
      columns: _columns,
      items: _turmas,
      fields: const [],
      onEdit: _handleEdit,
      onDelete: _handleDelete,
      onAdd: _handleAdd,
    );
  }
}
