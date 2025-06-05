import 'package:em_sala_mais/backend/model/teacher.dart';
import 'package:em_sala_mais/backend/dto/teacher_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherService {
  final supabase = Supabase.instance.client;

  Future<List<Teacher>> getTeachers() async {
    final response = await supabase.from('professor').select('*');
    return response.map((json) => Teacher.fromJson(json)).toList();
  }

  Future<Teacher> getTeacher(int id) async {
    final response = await supabase.from('professor').select('*').eq('id', id);
    return Teacher.fromJson(response.first);
  }

  Future<Teacher> createTeacher(TeacherDTO teacher) async {
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('professor').insert(teacher.toJson()).select();

      return Teacher.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar o professor: $e");
    }
  }

  Future<Teacher> updateTeacher(TeacherDTO teacher, int teacherId) async {
    final response =
        await supabase
            .from('professor')
            .update(teacher.toJson())
            .eq('id', teacherId)
            .select();
    return Teacher.fromJson(response.first);
  }

  Future<void> deleteTeacher(int id) async {
    await supabase.from('professor').delete().eq('id', id);
  }
}
