import 'package:em_sala_mais/backend/model/group.dart';
import 'package:em_sala_mais/backend/model/schedule.dart';
import 'package:em_sala_mais/backend/model/subject.dart';
import 'package:em_sala_mais/backend/model/teacher.dart';

class ScheduleTeacher {
  final int id;
  final Teacher teacher;
  final Group group;
  final Schedule schedule;
  final Subject subject;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleTeacher({required this.id,
                   required this.teacher,
                   required this.group,
                   required this.schedule,
                   required this.subject,
                   required this.createdAt,
                   required this.updatedAt});
}
