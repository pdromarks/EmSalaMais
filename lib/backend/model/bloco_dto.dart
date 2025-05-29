import 'package:em_sala_mais/backend/model/enums.dart';

class BlocoDTO {
  final String name;
  final String? description;
  final Campus campus;

  BlocoDTO({required this.name,
          this.description,
          this.campus = Campus.maringa
          });

  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'descricao': description,
      'campus': campus.name
    };
  }
}