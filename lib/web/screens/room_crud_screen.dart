import 'package:flutter/material.dart';
import '../../components/widgets/custom_room_card.dart';
import '../../components/screens/custom_form_dialog.dart';
import '../../theme/theme.dart';
import '../../backend/services/room.service.dart';
import '../../backend/model/room.dart';
import '../../backend/dto/room_dto.dart';
import '../../backend/services/bloco.service.dart';
import '../../backend/model/bloco.dart';

class RoomCrudScreen extends StatefulWidget {
  const RoomCrudScreen({super.key});

  @override
  State<RoomCrudScreen> createState() => _RoomCrudScreenState();
}

class _RoomCrudScreenState extends State<RoomCrudScreen> {
  late RoomService _roomService;
  late BlocoService _blocoService;
  List<Room> _actualRooms = [];
  List<Bloco> _actualBlocos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _roomService = RoomService();
    _blocoService = BlocoService();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final rooms = await _roomService.getRooms();
      final blocos = await _blocoService.getBlocos();
      if (mounted) {
        setState(() {
          _actualRooms = rooms;
          _actualBlocos = blocos;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar dados: ${e.toString()}')),
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

  // Helper to convert Room to Map for CustomRoomCard
  Map<String, dynamic> _roomToMap(Room room) {
    return {
      'id': room.id,
      'name': room.name,
      'block': room.bloco.name,
      'desks_count': room.chairsNumber ?? 0,
      'has_tv': room.hasTv,
      'has_projector': room.hasProjector,
      '_original_room_object': room,
    };
  }

  void _handleDelete(Map<String, dynamic> room) async {
    final Room roomToDelete = room['_original_room_object'] as Room;
    
    // Confirma antes de excluir
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir a sala ${roomToDelete.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _roomService.deleteRoom(roomToDelete.id);
        _fetchData(); // Refresh list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${roomToDelete.name}" excluído com sucesso.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir sala: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _showRoomFormDialog(Map<String, dynamic>? initialData) async {
    final Room? originalRoom = initialData?['_original_room_object'] as Room?;
    
    final nameController = TextEditingController(
      text: originalRoom?.name ?? '',
    );

    if (_actualBlocos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não é possível criar uma sala sem blocos cadastrados. Por favor, cadastre um bloco primeiro.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? selectedBlockId = originalRoom?.bloco.id.toString() ?? _actualBlocos.first.id.toString();
    int desksCount = originalRoom?.chairsNumber ?? 30;
    bool hasTV = originalRoom?.hasTv ?? false;
    bool hasProjector = originalRoom?.hasProjector ?? false;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CustomFormDialog(
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
              value: selectedBlockId,
              items: _actualBlocos.map((bloco) {
                return DropdownMenuItem<String>(
                  value: bloco.id.toString(),
                  child: Text(bloco.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBlockId = value;
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
            if (nameController.text.isEmpty || selectedBlockId == null) {
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
              'id': originalRoom?.id,
              'name': nameController.text,
              'bloco_id': int.parse(selectedBlockId!),
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
      try {
        final RoomDTO roomDTO = RoomDTO(
          name: result['name'] as String,
          blocoId: result['bloco_id'] as int,
          chairsNumber: result['desks_count'] as int,
          hasTv: result['has_tv'] as bool,
          hasProjector: result['has_projector'] as bool,
          updatedAt: DateTime.now(),
        );

        if (originalRoom != null) {
          await _roomService.updateRoom(roomDTO, originalRoom.id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('"${roomDTO.name}" atualizado com sucesso.')),
            );
          }
        } else {
          await _roomService.createRoom(roomDTO);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('"${roomDTO.name}" adicionado com sucesso.')),
            );
          }
        }
        _fetchData(); // Refresh list
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar sala: ${e.toString()}')),
          );
        }
      }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                    child: _actualRooms.isEmpty
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
                              childAspectRatio: isDesktop ? 1.5 : (width > 600 ? 1.3 : 1.1),
                            ),
                            itemCount: _actualRooms.length,
                            itemBuilder: (context, index) {
                              final room = _roomToMap(_actualRooms[index]);
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
