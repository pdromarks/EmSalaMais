class DefaultDto {
  final String name;
  final DateTime updatedAt;

  DefaultDto({
    required this.name,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'atualizado_em': updatedAt.toIso8601String(),
    };
  }
}
