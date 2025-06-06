import 'package:em_sala_mais/backend/model/enums.dart';

class ScheduleTeacherDTO {
  final int scheduleId;
  final int teacherId;
  final int groupId;
  final int subjectId;
  final DayOfWeek dayOfWeek;
  final DateTime updatedAt;

  ScheduleTeacherDTO({
    required this.scheduleId,
    required this.teacherId,
    required this.groupId,
    required this.subjectId,
    required this.dayOfWeek,
    required this.updatedAt,
  });

  factory ScheduleTeacherDTO.fromJson(Map<String, dynamic> json) {
    return ScheduleTeacherDTO(
      scheduleId: json['id_horario'],
      teacherId: json['id_professor'],
      groupId: json['id_turma'],
      subjectId: json['id_disciplina'],
      dayOfWeek: DayOfWeek.values.byName(json['dia_semana']),
      updatedAt: DateTime.parse(json['atualizado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_horario': scheduleId,
      'id_professor': teacherId,
      'id_turma': groupId,
      'id_disciplina': subjectId,
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }
}
