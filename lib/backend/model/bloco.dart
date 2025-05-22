import 'package:em_sala_mais/backend/model/enums.dart';

class Bloco {
    final int id;
    final String name;
    final String? description;
    final Campus campus;
    final DateTime createdAt;
    final DateTime updatedAt;

    Bloco({required this.id, 
          required this.name,
          this.description,
          this.campus = Campus.maringa,
          required this.updatedAt,
          required this.createdAt});
}