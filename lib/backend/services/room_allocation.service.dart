import 'package:em_sala_mais/backend/model/room_allocation.dart';
import 'package:em_sala_mais/backend/dto/room_allocation_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomAllocationService {
  final supabase = Supabase.instance.client;

  Future<List<RoomAllocation>> getRoomAllocations() async {
    final response = await supabase.from('emsalamento').select('*');
    return response.map((json) => RoomAllocation.fromJson(json)).toList();
  }

  Future<RoomAllocation> getRoomAllocation(int id) async {
    final response = await supabase
        .from('emsalamento')
        .select('*, horario_professor_turma(*)')
        .eq('id', id);
    return RoomAllocation.fromJson(response.first);
  }

  Future<RoomAllocation> createRoomAllocation(
    RoomAllocationDTO roomAllocation,
  ) async {
    try {
      final List<Map<String, dynamic>> response =
          await supabase
              .from('emsalamento')
              .insert(roomAllocation.toJson())
              .select();

      return RoomAllocation.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar o grupo: $e");
    }
  }

  Future<RoomAllocation> updateRoomAllocation(
    RoomAllocationDTO roomAllocation,
    int roomAllocationId,
  ) async {
    final response =
        await supabase
            .from('emsalamento')
            .update(roomAllocation.toJson())
            .eq('id', roomAllocationId)
            .select();
    return RoomAllocation.fromJson(response.first);
  }

  Future<void> deleteRoomAllocation(int id) async {
    await supabase.from('emsalamento').delete().eq('id', id);
  }
}
