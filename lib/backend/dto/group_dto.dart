import 'package:em_sala_mais/backend/dto/default_dto.dart';
import 'package:em_sala_mais/backend/model/enums.dart';

class GroupDTO extends DefaultDto {
  final int? id;
  final int? courseId;
  final Semester semester;

  GroupDTO({
    required super.name,
    required super.updatedAt,
    required this.courseId,
    required this.semester,
    this.id,
  });

  factory GroupDTO.fromJson(Map<String, dynamic> json) {
    print('DEBUG - JSON recebido para GroupDTO: ' + json.toString());
    return GroupDTO(
      id: json['id'],
      name: json['nome'],
      updatedAt: DateTime.parse(json['atualizado_em']),
      courseId: json['id_curso'],
      semester: Semester.values.byName(json['periodo_semestre']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = {
      'nome': name,
      'id_curso': courseId,
      'periodo_semestre': semester.name,
      'atualizado_em': updatedAt.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }
}
