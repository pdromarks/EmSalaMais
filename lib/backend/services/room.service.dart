import 'package:em_sala_mais/backend/model/room.dart';
import 'package:em_sala_mais/backend/dto/room_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomService {
  final supabase = Supabase.instance.client;

  Future<List<Room>> getRooms() async {
    final response = await supabase.from('sala').select('*');
    return response.map((json) => Room.fromJson(json)).toList();
  }

  Future<Room> getRoom(int id) async {
    final response = await supabase.from('sala').select('*').eq('id', id);
    return Room.fromJson(response.first);
  }

  Future<Room> createRoom(RoomDTO room) async {
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('sala').insert(room.toJson()).select();

      return Room.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar a sala: $e");
    }
  }

  Future<Room> updateRoom(RoomDTO room, int roomId) async {
    final response =
        await supabase
            .from('sala')
            .update(room.toJson())
            .eq('id', roomId)
            .select();
    return Room.fromJson(response.first);
  }

  Future<void> deleteRoom(int id) async {
    await supabase.from('sala').delete().eq('id', id);
  }
}
