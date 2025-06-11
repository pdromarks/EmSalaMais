import 'package:em_sala_mais/backend/dto/mobile_user_dto.dart';
import 'package:em_sala_mais/backend/dto/mobile_user_create_dto.dart';
import 'package:em_sala_mais/backend/services/user.service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MobileUserService {
  final supabase = Supabase.instance.client;
  final userService = UserService();

  Future<List<MobileUserDTO>> getMobileUsers() async {
    final response = await supabase
        .from('usuario_mobile')
        .select('*, turma(*)');
    return response.map((json) => MobileUserDTO.fromJson(json)).toList();
  }

  Future<MobileUserDTO> getMobileUser(int id) async {
    final response = await supabase
        .from('usuario_mobile')
        .select('*, turma(*)')
        .eq('id', id);
    return MobileUserDTO.fromJson(response.first);
  }

  Future<MobileUserDTO> createMobileUser(MobileUserCreateDTO mobileUser) async {
    try {
      final user = await userService.signUpUser(
        mobileUser.password,
        mobileUser.email,
      );
      if (user == null) {
        throw Exception("Erro ao criar o usuário");
      }
      final List<Map<String, dynamic>> response = await supabase
          .from('usuario_mobile')
          .insert({'id_usuario': user.user?.id, 'id_turma': mobileUser.idGroup})
          .select('*, turma(*)');

      return MobileUserDTO.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar a sala: $e");
    }
  }

  Future<void> deleteMobileUser(int id) async {
    await supabase.from('usuario_mobile').delete().eq('id', id);
  }
}
