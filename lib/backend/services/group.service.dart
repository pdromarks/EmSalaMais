import 'package:em_sala_mais/backend/model/group.dart';
import 'package:em_sala_mais/backend/dto/group_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupService {
  final supabase = Supabase.instance.client;

  Future<List<Group>> getGroups() async {
    final response = await supabase.from('turma').select('*');
    return response.map((json) => Group.fromJson(json)).toList();
  }

  Future<Group> getGroup(int id) async {
    final response = await supabase.from('turma').select('*').eq('id', id);
    return Group.fromJson(response.first);
  }

  Future<Group> createGroup(GroupDTO group) async {
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('turma').insert(group.toJson()).select();

      return Group.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar o grupo: $e");
    }
  }

  Future<Group> updateGroup(GroupDTO group, int groupId) async {
    final response =
        await supabase
            .from('turma')
            .update(group.toJson())
            .eq('id', groupId)
            .select();
    return Group.fromJson(response.first);
  }

  Future<void> deleteGroup(int id) async {
    await supabase.from('turma').delete().eq('id', id);
  }
}
