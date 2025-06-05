class Course {
  final int id;
  final String name;
  final DateTime? createAt;
  final DateTime? updatedAt;

  Course({required this.id, required this.name, this.createAt, this.updatedAt});

  factory Course.fromJson(Map<String, dynamic> json) =>
      Course(id: json['id'], name: json['name']);
}
