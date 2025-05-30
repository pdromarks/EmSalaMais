import 'package:em_sala_mais/backend/model/bloco.dart';
import 'package:em_sala_mais/backend/dto/bloco_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlocoService {

  final supabase = Supabase.instance.client;

  Future<List<Bloco>> getBlocos() async {
    final response = await supabase.from('bloco').select('*');
    return response.map((json) => Bloco.fromJson(json)).toList();
  }

  Future<Bloco> getBloco(int id) async {
    final response = await supabase.from('bloco').select('*').eq('id', id);
    return Bloco.fromJson(response.first);
  }

  Future<Bloco> createBloco(BlocoDTO bloco) async {
    try {
      final List<Map<String, dynamic>> response = await supabase.from('bloco').insert(bloco.toJson()).select();
      
      return Bloco.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar o bloco: $e");
    }
  }
  
  Future<Bloco> updateBloco(BlocoDTO bloco, int blocoId) async {
    final response = await supabase.from('bloco').update(bloco.toJson()).eq('id', blocoId).select();
    return Bloco.fromJson(response.first);
  }

  Future<void> deleteBloco(int id) async {
    await supabase.from('bloco').delete().eq('id', id);
  }
}