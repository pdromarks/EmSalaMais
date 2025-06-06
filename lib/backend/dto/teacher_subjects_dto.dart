class TeacherSubjectDTO {
  final int teacherId;
  final int subjectId;
  final DateTime updatedAt;

  TeacherSubjectDTO({
    required this.teacherId,
    required this.subjectId,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'professor_id': teacherId,
      'materia_id': subjectId,
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }
}
