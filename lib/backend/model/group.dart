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

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json['id'],
    name: json['nome'],
    course: Course.fromJson(json['curso']),
    semester: Semester.values.byName(json['periodo_semestre']),
  );
}
