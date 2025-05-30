class RoomAllocationDTO {
  final int roomId;
  final int scheduleTeacherId;
  final DateTime updatedAt;

  RoomAllocationDTO({
    required this.roomId,
    required this.scheduleTeacherId,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_sala': roomId,
      'id_horario_professor_turma': scheduleTeacherId,
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }
}

/*import 'package:em_sala_mais/backend/model/room.dart';
import 'package:em_sala_mais/backend/model/schedule_teacher.dart';

class RoomAllocation {
  final int id;
  final Room room;
  final ScheduleTeacher scheduleTeacher;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomAllocation({required this.id,
                   required this.room,
                   required this.scheduleTeacher,
                   required this.createdAt,
                   required this.updatedAt});
}
 */