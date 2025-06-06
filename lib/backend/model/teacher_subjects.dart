import 'package:em_sala_mais/backend/model/subject.dart';
import 'package:em_sala_mais/backend/model/teacher.dart';

class TeacherSubject {
  final int id;
  final Teacher teacher;
  final Subject subject;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TeacherSubject({
    required this.id,
    required this.teacher,
    required this.subject,
    this.createdAt,
    this.updatedAt,
  });

  @override
  factory TeacherSubject.fromJson(Map<String, dynamic> json) {
    return TeacherSubject(
      id: json['id'],
      teacher: Teacher.fromJson(json['professor']),
      subject: Subject.fromJson(json['disciplina']),
    );
  }
}
