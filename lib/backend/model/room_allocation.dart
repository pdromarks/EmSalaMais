import 'package:em_sala_mais/backend/model/room.dart';
import 'package:em_sala_mais/backend/model/schedule_tearcher.dart';

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
