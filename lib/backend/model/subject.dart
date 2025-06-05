class Subject {
  final int id;
  final String name;
  final DateTime? createAt;
  final DateTime? updatedAt;

  Subject({
    required this.id,
    required this.name,
    this.createAt,
    this.updatedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) =>
      Subject(id: json['id'], name: json['name'] ?? json['nome'] ?? '');
}
