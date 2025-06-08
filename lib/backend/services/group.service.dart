import 'package:em_sala_mais/backend/model/group.dart'; // Mude a importação para o MODELO
import 'package:em_sala_mais/backend/dto/group_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupService {
  final supabase = Supabase.instance.client;

  // 👇 **ALTERAÇÃO AQUI: Retorne List<Group> e use Group.fromJson**
  Future<List<Group>> getGroups() async {
    final response = await supabase.from('turma').select('*, curso(*)');
    // Use o seu MODELO para fazer o parse, não o DTO
    return response.map((json) => Group.fromJson(json)).toList();
  }

  // 👇 **ALTERAÇÃO AQUI: Retorne Group e use Group.fromJson**
  Future<Group> getGroup(int id) async {
    final response = await supabase
        .from('turma')
        .select('*, curso(*)')
        .eq('id', id);
    // Use o seu MODELO para fazer o parse, não o DTO
    return Group.fromJson(response.first);
  }

  // Métodos create, update e delete podem continuar usando DTO para enviar dados
  Future<Group> createGroup(GroupDTO group) async {
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from('turma')
          .insert(group.toJson())
          .select(
            '*, curso(*)',
          ); // Mantém o select para retornar o objeto completo

      return Group.fromJson(response.first); // Retorna o modelo completo
    } catch (e) {
      throw Exception("Erro ao criar o grupo: $e");
    }
  }

  Future<Group> updateGroup(GroupDTO group, int groupId) async {
    final response = await supabase
        .from('turma')
        .update(group.toJson())
        .eq('id', groupId)
        .select(
          '*, curso(*)',
        ); // Mantém o select para retornar o objeto completo
    return Group.fromJson(response.first); // Retorna o modelo completo
  }

  Future<void> deleteGroup(int id) async {
    await supabase.from('turma').delete().eq('id', id);
  }
}
