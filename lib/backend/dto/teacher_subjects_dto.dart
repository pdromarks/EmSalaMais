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

/**import 'package:em_sala_mais/backend/model/subject.dart';
import 'package:em_sala_mais/backend/model/teacher.dart';

class TeacherSubject {
  final int id;
  final Teacher teacher;
  final Subject subject;
  final DateTime createdAt;
  final DateTime updatedAt;

  TeacherSubject({required this.id,
                   required this.teacher,
                   required this.subject,
                   required this.createdAt,
                   required this.updatedAt});
}

 */