import 'package:em_sala_mais/backend/model/bloco.dart';

class Room {
  final int id;
  final String name;
  final int? chairsNumber;
  final bool hasTv;
  final bool hasProjector;
  final Bloco bloco;
  final DateTime? createAt;
  final DateTime? updatedAt;

  Room({
    required this.id,
    required this.name,
    this.chairsNumber,
    required this.hasTv,
    required this.hasProjector,
    required this.bloco,
    this.createAt,
    this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json['id'],
    name: json['nome'],
    chairsNumber: json['numero_cadeiras'],
    hasTv: json['tem_tv'],
    hasProjector: json['tem_projetor'],
    bloco: Bloco.fromJson(json['bloco']),
  );
}
