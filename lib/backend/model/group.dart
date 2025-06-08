import 'package:em_sala_mais/backend/model/course.dart';
import 'package:em_sala_mais/backend/model/enums.dart';

class Group {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Course course;
  final Semester semester;

  Group({
    required this.id,
    required this.name,
    required this.course,
    required this.semester,
    this.createdAt,
    this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic>? json) {
    print('DEBUG - JSON recebido para Group: ' + json.toString());
    if (json == null) {
      return Group(
        id: 0,
        name: '',
        course: Course(id: 0, name: ''),
        semester: Semester.primeiro,
      );
    }
    return Group(
      id: json['id'] ?? 0,
      name: json['nome'] ?? '',
      course:
          json['curso'] != null
              ? Course.fromJson(json['curso'])
              : Course(id: 0, name: 'Curso Inválido'),
      semester:
          json['periodo_semestre'] != null
              ? Semester.values.byName(json['periodo_semestre'])
              : Semester.primeiro,
    );
  }
}
