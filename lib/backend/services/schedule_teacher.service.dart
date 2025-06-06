import 'package:em_sala_mais/backend/dto/schedule_teacher_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleTeacherService {
  final supabase = Supabase.instance.client;

  Future<List<ScheduleTeacherDTO>> getScheduleTeachers() async {
    final response = await supabase.from('horario_professor_turma').select('*');
    return response.map((json) => ScheduleTeacherDTO.fromJson(json)).toList();
  }

  Future<ScheduleTeacherDTO> getScheduleTeacher(int id) async {
    final response = await supabase
        .from('horario_professor_turma')
        .select('*, professor(*), turma(*), horario(*), disciplina(*)')
        .eq('id', id);
    return ScheduleTeacherDTO.fromJson(response.first);
  }

  Future<ScheduleTeacherDTO> createScheduleTeacher(
    ScheduleTeacherDTO scheduleTeacher,
  ) async {
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from('horario_professor_turma')
          .insert(scheduleTeacher.toJson())
          .select('*, professor(*), turma(*), horario(*), disciplina(*)');
      return ScheduleTeacherDTO.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar o horário do professor: $e");
    }
  }

  Future<ScheduleTeacherDTO> updateScheduleTeacher(
    ScheduleTeacherDTO scheduleTeacher,
    int scheduleTeacherId,
  ) async {
    final response =
        await supabase
            .from('horario_professor_turma')
            .update(scheduleTeacher.toJson())
            .eq('id', scheduleTeacherId)
            .select();
    return ScheduleTeacherDTO.fromJson(response.first);
  }

  Future<void> deleteScheduleTeacher(int id) async {
    await supabase.from('horario_professor_turma').delete().eq('id', id);
  }
}
