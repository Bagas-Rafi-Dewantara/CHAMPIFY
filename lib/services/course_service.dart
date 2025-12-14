import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:champify/models/course_model.dart';

class CourseService {
  final supabase = Supabase.instance.client;

  Future<List<Course>> fetchCourses() async {
    final data = await supabase
        .from('course')
        .select()
        .order('nama_course');

    return (data as List)
        .map((course) => Course.fromMap(course))
        .toList();
  }
}
