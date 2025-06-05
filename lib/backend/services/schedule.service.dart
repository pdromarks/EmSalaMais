import 'package:em_sala_mais/backend/model/schedule.dart';
import 'package:em_sala_mais/backend/dto/schedule_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleService {
  final supabase = Supabase.instance.client;

  Future<List<Schedule>> getSchedules() async {
    final response = await supabase.from('horario').select('*');
    return response.map((json) => Schedule.fromJson(json)).toList();
  }

  Future<Schedule> getSchedule(int id) async {
    final response = await supabase.from('horario').select('*').eq('id', id);
    return Schedule.fromJson(response.first);
  }

  Future<Schedule> createSchedule(ScheduleDTO schedule) async {
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('horario').insert(schedule.toJson()).select();

      return Schedule.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar o horário: $e");
    }
  }

  Future<Schedule> updateSchedule(ScheduleDTO schedule, int scheduleId) async {
    final response =
        await supabase
            .from('horario')
            .update(schedule.toJson())
            .eq('id', scheduleId)
            .select();
    return Schedule.fromJson(response.first);
  }

  Future<void> deleteSchedule(int id) async {
    await supabase.from('horario').delete().eq('id', id);
  }
}
