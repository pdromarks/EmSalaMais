import 'package:em_sala_mais/backend/model/enums.dart';
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
  final Enum dayOfWeek;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScheduleTeacher({
    required this.id,
    required this.teacher,
    required this.group,
    required this.schedule,
    required this.subject,
    required this.dayOfWeek,
    this.createdAt,
    this.updatedAt,
  });

  @override
  factory ScheduleTeacher.fromJson(Map<String, dynamic> json) {
    print('DEBUG - JSON para ScheduleTeacher: ' + json.toString());
    return ScheduleTeacher(
      id: json['id'],
      teacher: Teacher.fromJson(json['professor']),
      group: Group.fromJson(json['turma']),
      schedule: Schedule.fromJson(json['horario']),
      subject: Subject.fromJson(json['disciplina']),
      dayOfWeek: DayOfWeek.values.byName(json['dia_semana']),
    );
  }
}
