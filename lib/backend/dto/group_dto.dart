import 'package:em_sala_mais/backend/dto/default_dto.dart';
import 'package:em_sala_mais/backend/model/enums.dart';

class GroupDTO extends DefaultDto {
  final int courseId;
  final Semester semester;

  GroupDTO({
    required super.name,
    required super.updatedAt,
    required this.courseId,
    required this.semester,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'curso_id': courseId,
      'periodo_semestre': semester.name,
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }
}
