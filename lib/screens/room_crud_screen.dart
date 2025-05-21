import 'package:flutter/material.dart';
import '../widgets/custom_room_card.dart';
import 'custom_room_form_dialog.dart';

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
      builder: (context) => AlertDialog(
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

  Future<void> _handleEdit(Map<String, dynamic> room) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomRoomFormDialog(
        title: 'Editar Sala',
        initialData: room,
        blocks: _blocks,
        onSave: (data) {
          Navigator.pop(context, data);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );

    if (result != null) {
      setState(() {
        final index = _rooms.indexWhere((r) => r['id'] == result['id']);
        if (index != -1) {
          _rooms[index] = result;
        }
      });
    }
  }

  Future<void> _handleAdd() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomRoomFormDialog(
        title: 'Nova Sala',
        blocks: _blocks,
        onSave: (data) {
          Navigator.pop(context, data);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );

    if (result != null) {
      setState(() {
        _rooms.add(result);
      });
    }
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
        onPressed: _handleAdd,
        backgroundColor: const Color(0xff507E32),
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
                  color: const Color(0xff507E32),
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _rooms.isEmpty
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
                        crossAxisCount: isDesktop ? 3 : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 1.5 : 2.5,
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
                          onEdit: () => _handleEdit(room),
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
