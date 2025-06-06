import 'package:em_sala_mais/backend/model/room.dart';
import 'package:em_sala_mais/backend/model/schedule_teacher.dart';

class RoomAllocation {
  final int id;
  final Room room;
  final ScheduleTeacher scheduleTeacher;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RoomAllocation({
    required this.id,
    required this.room,
    required this.scheduleTeacher,
    this.createdAt,
    this.updatedAt,
  });

  factory RoomAllocation.fromJson(Map<String, dynamic> json) {
    return RoomAllocation(
      id: json['id'],
      room: Room.fromJson(json['sala']),
      scheduleTeacher: ScheduleTeacher.fromJson(
        json['horario_professor_turma'],
      ),
    );
  }
}
