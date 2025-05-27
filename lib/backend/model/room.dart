import 'package:em_sala_mais/backend/model/bloco.dart';

class Room {
  final int id;
  final String name;
  final int? chairsNumber;
  final bool hasTv;
  final bool hasProjector;
  final Bloco bloco; 
  final DateTime createAt;
  final DateTime updatedAt;

  Room({required this.id,
        required this.name,
        this.chairsNumber,
        required this.hasTv,
        required this.hasProjector,
        required this.bloco,
        required this.createAt,
        required this.updatedAt});
}