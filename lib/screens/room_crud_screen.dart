import 'package:flutter/material.dart';
import '../components/widgets/custom_room_card.dart';
import '../components/screens/custom_form_dialog.dart';
import '../theme/theme.dart';

class RoomCrudScreen extends StatefulWidget {
  const RoomCrudScreen({super.key});

  @override
  State<RoomCrudScreen> createState() => _RoomCrudScreenState();
}

class _RoomCrudScreenState extends State<RoomCrudScreen> {
  // Lista de salas (simulando um banco de dados)
  final List<Map<String, dynamic>> _rooms = [
    {
      'id': '1',
      'name': 'Sala 101',
      'block': 'Bloco A',
      'desks_count': 35,
      'has_tv': true,
      'has_projector': false,
    },
    {
      'id': '2',
      'name': 'Sala 202',
      'block': 'Bloco B',
      'desks_count': 40,
      'has_tv': false,
      'has_projector': true,
    },
    {
      'id': '3',
      'name': 'Laboratório 1',
      'block': 'Bloco A',
      'desks_count': 25,
      'has_tv': true,
      'has_projector': true,
    },
  ];

  // Lista de blocos para o dropdown
  final List<Map<String, dynamic>> _blocks = [
    {
      'id': '1',
      'nome_do_bloco': 'Bloco A',
      'descricao': 'Bloco de Engenharia',
      'campus': 'Principal',
    },
    {
      'id': '2',
      'nome_do_bloco': 'Bloco B',
      'descricao': 'Bloco de Computação',
      'campus': 'Principal',
    },
  ];

  void _handleDelete(Map<String, dynamic> room) {
    // Confirma antes de excluir
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text('Deseja realmente excluir a sala ${room['name']}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _rooms.removeWhere((r) => r['id'] == room['id']);
                  });
                },
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _showRoomFormDialog(Map<String, dynamic>? initialData) async {
    final nameController = TextEditingController(
      text: initialData?['name'] ?? '',
    );

    String? selectedBlock =
        initialData?['block'] ?? _blocks[0]['nome_do_bloco'];
    int desksCount = initialData?['desks_count'] ?? 30;
    bool hasTV = initialData?['has_tv'] ?? false;
    bool hasProjector = initialData?['has_projector'] ?? false;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => CustomFormDialog(
                  title: initialData != null ? 'Editar Sala' : 'Nova Sala',
                  fields: [
                    CustomFormField(
                      label: 'Nome da Sala',
                      controller: nameController,
                      icon: Icons.meeting_room,
                    ),
                    CustomFormField(
                      label: 'Bloco',
                      isDropdown: true,
                      value: selectedBlock,
                      items:
                          _blocks.map((block) {
                            return DropdownMenuItem<String>(
                              value: block['nome_do_bloco'],
                              child: Text(block['nome_do_bloco']),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBlock = value;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Quantidade de Carteiras',
                      isCounter: true,
                      counterValue: desksCount,
                      onCounterChanged: (value) {
                        setState(() {
                          desksCount = value;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Televisão',
                      isSwitch: true,
                      switchValue: hasTV,
                      onSwitchChanged: (value) {
                        setState(() {
                          hasTV = value;
                        });
                      },
                    ),
                    CustomFormField(
                      label: 'Projetor',
                      isSwitch: true,
                      switchValue: hasProjector,
                      onSwitchChanged: (value) {
                        setState(() {
                          hasProjector = value;
                        });
                      },
                    ),
                  ],
                  onSave: (data) {
                    if (nameController.text.isEmpty || selectedBlock == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha todos os campos obrigatórios',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final roomData = {
                      'id': initialData?['id'] ?? DateTime.now().toString(),
                      'name': nameController.text,
                      'block': selectedBlock,
                      'desks_count': desksCount,
                      'has_tv': hasTV,
                      'has_projector': hasProjector,
                    };

                    Navigator.pop(context, roomData);
                  },
                  onCancel: () => Navigator.pop(context),
                ),
          ),
    );

    if (result != null) {
      setState(() {
        if (initialData != null) {
          final index = _rooms.indexWhere((r) => r['id'] == result['id']);
          if (index != -1) {
            _rooms[index] = result;
          }
        } else {
          _rooms.add(result);
        }
      });
    }

    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double titleFontSize = (width * 0.08).clamp(20.0, 40.0);
    final bool isDesktop = width > 1024;

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoomFormDialog(null),
        backgroundColor: AppColors.verdeUNICV,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          width * 0.01,
          screenSize.height * 0.02,
          width * 0.01,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: Text(
                'Salas',
                style: TextStyle(
                  color: AppColors.verdeUNICV,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  _rooms.isEmpty
                      ? Center(
                        child: Text(
                          'Nenhuma sala cadastrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                      : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 3 : (width > 600 ? 2 : 1),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              isDesktop ? 1.5 : (width > 600 ? 1.3 : 1.1),
                        ),
                        itemCount: _rooms.length,
                        itemBuilder: (context, index) {
                          final room = _rooms[index];
                          return CustomRoomCard(
                            name: room['name'],
                            block: room['block'],
                            desksCount: room['desks_count'],
                            hasTV: room['has_tv'],
                            hasProjector: room['has_projector'],
                            onEdit: () => _showRoomFormDialog(room),
                            onDelete: () => _handleDelete(room),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
