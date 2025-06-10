import 'package:em_sala_mais/backend/model/room_allocation.dart';
import 'package:em_sala_mais/backend/dto/room_allocation_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomAllocationService {
  final supabase = Supabase.instance.client;

  static const String _selectQuery =
      '*, sala(*, bloco(*)), horario_professor_turma(*, horario(*), professor(*), turma(*, curso(*)), disciplina(*))';

  Future<List<RoomAllocation>> getRoomAllocations() async {
    final response = await supabase.from('emsalamento').select(_selectQuery);

    final allocations = <RoomAllocation>[];
    for (final json in response) {
      if (json['sala'] != null && json['horario_professor_turma'] != null) {
        allocations.add(RoomAllocation.fromJson(json));
      }
    }
    return allocations;
  }

  Future<RoomAllocation> getRoomAllocation(int id) async {
    final response = await supabase
        .from('emsalamento')
        .select(_selectQuery)
        .eq('id', id)
        .single();
    return RoomAllocation.fromJson(response);
  }

  Future<RoomAllocation> createRoomAllocation(
    RoomAllocationDTO roomAllocation,
  ) async {
    try {
      final response = await supabase
          .from('emsalamento')
          .insert(roomAllocation.toJson())
          .select(_selectQuery)
          .single();

      return RoomAllocation.fromJson(response);
    } catch (e) {
      throw Exception("Erro ao criar o alocamento: $e");
    }
  }

  Future<RoomAllocation> updateRoomAllocation(
    RoomAllocationDTO roomAllocation,
    int roomAllocationId,
  ) async {
    final response = await supabase
        .from('emsalamento')
        .update(roomAllocation.toJson())
        .eq('id', roomAllocationId)
        .select(_selectQuery)
        .single();
    return RoomAllocation.fromJson(response);
  }

  Future<void> deleteRoomAllocation(int id) async {
    await supabase.from('emsalamento').delete().eq('id', id);
  }
}
