import 'package:flutter/material.dart';
import 'custom_crud_screen.dart';
import 'custom_form_dialog.dart';

class BlocoCrudScreen extends StatefulWidget {
  const BlocoCrudScreen({super.key});

  @override
  State<BlocoCrudScreen> createState() => _BlocoCrudScreenState();
}

class _BlocoCrudScreenState extends State<BlocoCrudScreen> {
  // Lista de blocos (simulando um banco de dados)
  final List<Map<String, dynamic>> _blocos = [
    {
      'id': '1',
      'nome_do_bloco': 'Bloco A',
      'descricao': 'Bloco de Engenharia',
      'localizacao': 'Setor Norte',
      'ativo': true,
    },
    {
      'id': '2',
      'nome_do_bloco': 'Bloco B',
      'descricao': 'Bloco de Computação',
      'localizacao': 'Setor Sul',
      'ativo': true,
    },
  ];

  // Definição das colunas da tabela
  final List<ColumnData> _columns = [
    ColumnData(
      label: 'Nome',
      getValue: (item) => item['nome_do_bloco'] as String,
    ),
    ColumnData(
      label: 'Descrição',
      getValue: (item) => item['descricao'] as String,
    ),
    ColumnData(
      label: 'Localização',
      getValue: (item) => item['localizacao'] as String,
    ),
    ColumnData(
      label: 'Status',
      getValue: (item) => item['ativo'] ? 'Ativo' : 'Inativo',
    ),
  ];

  Future<void> _handleEdit(Map<String, dynamic> item) async {
    final nomeController = TextEditingController(text: item['nome_do_bloco']);
    final descricaoController = TextEditingController(text: item['descrição']);
    final localizacaoController = TextEditingController(text: item['localização']);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomFormDialog(
        title: 'Editar Bloco',
        initialData: item,
        fields: [
          CustomFormField(
            label: 'Nome do Bloco',
            controller: nomeController,
            icon: Icons.apartment,
          ),
          CustomFormField(
            label: 'Descrição',
            controller: descricaoController,
            icon: Icons.description,
          ),
          CustomFormField(
            label: 'Localização',
            controller: localizacaoController,
            icon: Icons.location_on,
          ),
        ],
        onSave: (formData) {
          Navigator.pop(context, formData);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );

    if (result != null) {
      setState(() {
        final index = _blocos.indexWhere((bloco) => bloco['id'] == result['id']);
        if (index != -1) {
          _blocos[index] = result;
        }
      });
    }

    // Limpar os controllers
    nomeController.dispose();
    descricaoController.dispose();
    localizacaoController.dispose();
  }

  void _handleDelete(Map<String, dynamic> item) {
    setState(() {
      _blocos.removeWhere((bloco) => bloco['id'] == item['id']);
    });
  }

  Future<void> _handleAdd() async {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();
    final localizacaoController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomFormDialog(
        title: 'Novo Bloco',
        fields: [
          CustomFormField(
            label: 'Nome do Bloco',
            controller: nomeController,
            icon: Icons.apartment,
          ),
          CustomFormField(
            label: 'Descrição',
            controller: descricaoController,
            icon: Icons.description,
          ),
          CustomFormField(
            label: 'Localização',
            controller: localizacaoController,
            icon: Icons.location_on,
          ),
        ],
        onSave: (formData) {
          Navigator.pop(context, formData);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );

    if (result != null) {
      setState(() {
        _blocos.add(result);
      });
    }

    // Limpar os controllers
    nomeController.dispose();
    descricaoController.dispose();
    localizacaoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCrudScreen(
      title: 'Blocos',
      columns: _columns,
      items: _blocos,
      fields: const [], // Não usado aqui pois temos uma tela separada para o formulário
      onEdit: _handleEdit,
      onDelete: _handleDelete,
      onAdd: _handleAdd,
    );
  }
}
