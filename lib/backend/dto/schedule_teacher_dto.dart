class ScheduleTeacherDTO {
  final int scheduleId;
  final int teacherId;
  final int groupId;
  final int subjectId;
  final DateTime updatedAt;

  ScheduleTeacherDTO({
    required this.scheduleId,
    required this.teacherId,
    required this.groupId,
    required this.subjectId,
    required this.updatedAt,
  });

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