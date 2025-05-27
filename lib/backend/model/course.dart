class Course {
  final int id;
  final String name;
  final DateTime createAt;
  final DateTime updatedAt;

  Course({
    required this.id, 
    required this.name, 
    required this.createAt,
    required this.updatedAt
  });
}