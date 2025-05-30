import 'package:em_sala_mais/backend/model/subject.dart';
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

