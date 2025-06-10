import 'package:em_sala_mais/backend/model/subject.dart';
import 'package:em_sala_mais/backend/dto/subject_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectService {
  final supabase = Supabase.instance.client;

  Future<List<Subject>> getSubjects() async {
    final response = await supabase.from('disciplina').select('*');
    return response.map((json) => Subject.fromJson(json)).toList();
  }

  Future<Subject> getSubject(int id) async {
    final response = await supabase.from('disciplina').select('*').eq('id', id);
    return Subject.fromJson(response.first);
  }

  Future<Subject> createSubject(SubjectDTO subject) async {
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('disciplina').insert(subject.toJson()).select();

      return Subject.fromJson(response.first);
    } catch (e) {
      throw Exception("Erro ao criar a disciplina: $e");
    }
  }

  Future<Subject> updateSubject(SubjectDTO subject, int subjectId) async {
    final response =
        await supabase
            .from('disciplina')
            .update(subject.toJson())
            .eq('id', subjectId)
            .select();
    return Subject.fromJson(response.first);
  }

  Future<void> deleteSubject(int id) async {
    await supabase.from('disciplina').delete().eq('id', id);
  }

  Future<List<Subject>> getSubjectsByTeacher(int teacherId) async {
    try{
    final response = await supabase
        .from('professor_disciplina')
        .select('disciplina(*)')
        .eq('id_professor', teacherId);
    return response
        .where((e) => e['disciplina'] != null)
        .map<Subject>((e) => Subject.fromJson(e['disciplina']))
        .toList();
    }catch(e){
      print(e);
      return [];
    }
  }
}
