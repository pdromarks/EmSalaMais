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

  String _getScheduleTimeValueForDB(ScheduleTime time) {
    switch (time) {
      case ScheduleTime.primeira:
        return 'PRIMEIRA_AULA';
      case ScheduleTime.segunda:
        return 'SEGUNDA_AULA';
      default:
        // Assume um padrão para outros valores, se houver
        return time.name.toUpperCase() + '_AULA';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'horario_inicio': scheduleStart,
      'horario_fim': scheduleEnd,
      'periodo_hora': _getScheduleTimeValueForDB(scheduleTime),
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }

  factory ScheduleDTO.fromJson(Map<String, dynamic> json) {
    String periodoHoraFromDB = (json['periodo_hora'] as String);
    String enumName = periodoHoraFromDB.replaceAll('_AULA', '').toLowerCase();

    return ScheduleDTO(
      scheduleStart: json['horario_inicio'],
      scheduleEnd: json['horario_fim'],
      scheduleTime: ScheduleTime.values.byName(enumName),
      updatedAt: DateTime.parse(
        json['atualizado_em'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
