class Teacher {
  final int id;
  final String name;
  final DateTime? createAt;
  final DateTime? updatedAt;

  Teacher({
    required this.id,
    required this.name,
    this.createAt,
    this.updatedAt,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      Teacher(id: json['id'], name: json['nome']);
}
