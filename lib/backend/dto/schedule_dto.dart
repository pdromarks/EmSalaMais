import 'package:em_sala_mais/backend/model/enums.dart';

class ScheduleDTO {
  final String scheduleStart;
  final String scheduleEnd;
  final ScheduleTime scheduleTime;
  final DateTime updatedAt;

  ScheduleDTO({
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.scheduleTime,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'horario_inicio': scheduleStart,
      'horario_fim': scheduleEnd,
      'periodo_hora': scheduleTime.name,
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }

  factory ScheduleDTO.fromJson(Map<String, dynamic> json) {
    print('DEBUG - JSON recebido para ScheduleDTO: ' + json.toString());
    return ScheduleDTO(
      scheduleStart: json['horario_inicio'],
      scheduleEnd: json['horario_fim'],
      scheduleTime: ScheduleTime.values.byName(json['periodo_hora']),
      updatedAt: DateTime.parse(
        json['atualizado_em'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
