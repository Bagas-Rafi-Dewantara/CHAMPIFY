import 'package:flutter/material.dart';
import '../main.dart'; // Akses supabase
import 'detail_course.dart'; // Pastikan file ini ada
import 'mycourse.dart'; // <--- IMPORT PENTING

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool isAvailableSelected = true;
  List<Map<String, dynamic>> courseList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      // PERUBAHAN ADA DI SINI:
      // '*, mentor(*)' artinya: Ambil semua kolom course, DAN gabungkan dengan tabel mentor
      final data = await supabase
          .from('course')
          .select('*, mentor(*), playlist(*), rating(*, pengguna(*))');
      setState(() {
        courseList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Course',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // --- HEADER TABS ---
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isAvailableSelected = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isAvailableSelected
                            ? const Color(0xFFC76D61)
                            : Colors.transparent,
                        border: Border.all(color: const Color(0xFFC76D61)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Available Course',
                          style: TextStyle(
                            color: isAvailableSelected
                                ? Colors.white
                                : const Color(0xFFC76D61),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isAvailableSelected = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isAvailableSelected
                            ? const Color(0xFFC76D61)
                            : Colors.transparent,
                        border: Border.all(color: const Color(0xFFC76D61)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'My Course',
                          style: TextStyle(
                            color: !isAvailableSelected
                                ? Colors.white
                                : const Color(0xFFC76D61),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- CONTENT BODY ---
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : courseList.isEmpty
                  ? const Center(child: Text("Belum ada course."))
                  : isAvailableSelected
                  ? GridView.builder(
                      itemCount: courseList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) =>
                          AvailableCourseCard(courseData: courseList[index]),
                    )
                  : ListView.builder(
                      itemCount: courseList.length,
                      itemBuilder: (context, index) =>
                          // Mengambil Widget dari mycourse.dart
                          MyCourseCard(courseData: courseList[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card untuk Available Course (Tetap di sini atau dipisah boleh)
// Card untuk Available Course
class AvailableCourseCard extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const AvailableCourseCard({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailCoursePage(courseData: courseData),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFFFE4DD),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                color: Colors.blueAccent,
                child: courseData['link_gambar'] != null
                    ? Image.network(
                        courseData['link_gambar'],
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.bar_chart, color: Colors.white),
              ),
            ),

            // Bagian Teks Judul & Lesson
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseData['nama_course'] ?? 'Tanpa Judul',
                      // Hapus maxLines dan overflow agar turun ke bawah (wrap)
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "(${courseData['jumlah_lesson'] ?? 0} lessons)",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
