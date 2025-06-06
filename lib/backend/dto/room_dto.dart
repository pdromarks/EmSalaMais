import 'package:em_sala_mais/backend/dto/default_dto.dart';

class RoomDTO extends DefaultDto {
  final int? chairsNumber;
  final bool hasTv;
  final bool hasProjector;
  final int blocoId;

  RoomDTO({
    required super.name,
    required super.updatedAt,
    this.chairsNumber,
    this.hasTv = false,
    this.hasProjector = false,
    required this.blocoId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'bloco_id': blocoId,
      'tem_tv': hasTv,
      'tem_projetor': hasProjector,
      'numero_cadeiras': chairsNumber,
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }
}
