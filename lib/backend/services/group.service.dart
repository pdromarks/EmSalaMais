import 'package:em_sala_mais/backend/dto/group_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupService {
  final supabase = Supabase.instance.client;

  Future<List<GroupDTO>> getGroups() async {
    final response = await supabase.from('turma').select('*, curso(*)');
    return response.map((json) => GroupDTO.fromJson(json)).toList();
  }

  Future<GroupDTO> getGroup(int id) async {
    final response = await supabase
        .from('turma')
        .select('*, curso(*)')
        .eq('id', id);
    return GroupDTO.fromJson(response.first);
  }

  Future<GroupDTO> createGroup(GroupDTO group) async {
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from('turma')
          .insert(group.toJson())
          .select('*, curso(*)');

      return GroupDTO.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar o grupo: $e");
    }
  }

  Future<GroupDTO> updateGroup(GroupDTO group, int groupId) async {
    final response =
        await supabase
            .from('turma')
            .update(group.toJson())
            .eq('id', groupId)
            .select();
    return GroupDTO.fromJson(response.first);
  }

  Future<void> deleteGroup(int id) async {
    await supabase.from('turma').delete().eq('id', id);
  }
}
