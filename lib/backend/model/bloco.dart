import 'package:em_sala_mais/backend/model/enums.dart';

class Bloco {
    final int? id;
    final String name;
    final String? description;
    final Campus campus;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Bloco({this.id,
          required this.name,
          this.description,
          this.campus = Campus.maringa,
          this.updatedAt,
          this.createdAt});

    factory Bloco.fromJson(Map<String, dynamic> json) {
      return Bloco(
        id: json['id'],
        name: json['nome'],
        description: json['descricao'],
        campus: Campus.values.byName(json['campus'])
      );
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'nome': name,
        'descricao': description,
        'campus': campus.name
    };
}