import 'package:em_sala_mais/backend/dto/default_dto.dart';
import 'package:em_sala_mais/backend/model/enums.dart';

class BlocoDTO extends DefaultDto {
  final String? description;
  final Campus campus;

  BlocoDTO({
    required super.name,
    required super.updatedAt,
    this.description,
    this.campus = Campus.maringa,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'descricao': description,
      'campus': campus.name,
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }
}
