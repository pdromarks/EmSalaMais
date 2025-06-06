import 'package:em_sala_mais/backend/dto/default_dto.dart';

class TeacherDTO extends DefaultDto {
  final List<int> subjectsIds;

  TeacherDTO({
    required super.name,
    required super.updatedAt,
    required this.subjectsIds,
  });
}
