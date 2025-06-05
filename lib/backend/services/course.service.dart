import 'package:em_sala_mais/backend/model/course.dart';
import 'package:em_sala_mais/backend/dto/course_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseService {
  final supabase = Supabase.instance.client;

  Future<List<Course>> getCourses() async {
    final response = await supabase.from('curso').select('*');
    return response.map((json) => Course.fromJson(json)).toList();
  }

  Future<Course> getCourse(int id) async {
    final response = await supabase.from('curso').select('*').eq('id', id);
    return Course.fromJson(response.first);
  }

  Future<Course> createCourse(CourseDTO course) async {
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('curso').insert(course.toJson()).select();

      return Course.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar o curso: $e");
    }
  }

  Future<Course> updateCourse(CourseDTO course, int courseId) async {
    final response =
        await supabase
            .from('curso')
            .update(course.toJson())
            .eq('id', courseId)
            .select();
    return Course.fromJson(response.first);
  }

  Future<void> deleteCourse(int id) async {
    await supabase.from('curso').delete().eq('id', id);
  }
}
