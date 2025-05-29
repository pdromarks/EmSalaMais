import 'package:em_sala_mais/backend/model/course.dart';
import 'package:em_sala_mais/backend/model/enums.dart';

class Group {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Course course;
  final Semester semester;

  Group({required this.id,
         required this.name,
         required this.course,
         required this.semester,
         required this.createdAt,
         required this.updatedAt});
}
