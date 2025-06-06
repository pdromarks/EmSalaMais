import 'package:em_sala_mais/backend/model/enums.dart';

class Schedule {
  final int id;
  final String scheduleStart;
  final String scheduleEnd;
  final ScheduleTime scheduleTime;
  final DateTime? createAt;
  final DateTime? updatedAt;

  Schedule({
    required this.id,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.scheduleTime,
    this.createAt,
    this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json['id'],
    scheduleStart: json['horario_inicio'],
    scheduleEnd: json['horario_fim'],
    scheduleTime: ScheduleTime.values.byName(json['periodo_hora']),
  );
}
