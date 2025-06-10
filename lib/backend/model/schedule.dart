import 'package:em_sala_mais/backend/model/enums.dart';

class Schedule {
  final int id;
  final String scheduleStart;
  final String scheduleEnd;
  final ScheduleTime scheduleTime;
  final String periodoHora;
  final DateTime? createAt;
  final DateTime? updatedAt;

  Schedule({
    required this.id,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.scheduleTime,
    required this.periodoHora,
    this.createAt,
    this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final String periodo = json['periodo_hora'] ?? '';
    final String inicio = json['horario_inicio'] ?? '';
    ScheduleTime scheduleTime;

    // Lógica para inferir a aula (primeira/segunda) com base no período e hora de início
    if ((periodo == 'noturno' && inicio == '19:00') ||
        (periodo == 'matutino' && inicio == '07:30') ||
        (periodo == 'vespertino' && inicio == '13:30')) {
      scheduleTime = ScheduleTime.primeira;
    } else if ((periodo == 'noturno' && inicio == '20:55') ||
        (periodo == 'matutino' && inicio == '09:25') ||
        (periodo == 'vespertino' && inicio == '15:25')) {
      scheduleTime = ScheduleTime.segunda;
    } else {
      // Valor padrão para evitar quebras. Pode ser ajustado se houver mais horários.
      scheduleTime = ScheduleTime.primeira;
    }

    return Schedule(
      id: json['id'],
      scheduleStart: json['horario_inicio'],
      scheduleEnd: json['horario_fim'],
      scheduleTime: scheduleTime,
      periodoHora: periodo,
    );
  }
}
