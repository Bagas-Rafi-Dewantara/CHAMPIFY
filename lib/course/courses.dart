import 'package:flutter/material.dart';
import '../main.dart'; // Access to supabase
import 'detail_course.dart';
import 'mycourse.dart'; // Contains MyCourseCard and PlaylistCoursePage

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool isAvailableSelected = true;

  // Separate lists for data
  List<Map<String, dynamic>> availableCourseList = [];
  List<Map<String, dynamic>> myCourseList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch both lists when the page loads
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    setState(() => isLoading = true);
    await Future.wait([fetchAvailableCourses(), fetchMyCourses()]);
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // 1. Fetch ALL courses for "Available" tab
  Future<void> fetchAvailableCourses() async {
    try {
      final data = await supabase
          .from('course')
          .select('*, mentor(*), playlist(*), rating(*, pengguna(*))');

      if (mounted) {
        setState(() {
          availableCourseList = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      debugPrint('Error fetching available courses: $e');
    }
  }

  // 2. Fetch PURCHASED courses for "My Course" tab
  Future<void> fetchMyCourses() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // A. Get user ID from 'pengguna' table based on Auth ID
      // Make sure your column name is correct (e.g., 'id_auth' or 'uid')
      final userData = await supabase
          .from('pengguna')
          .select('id_pengguna')
          .eq('id_auth', user.id)
          .single();

      final int idPengguna = userData['id_pengguna'];

      // B. Fetch transactions for this user and join with course details
      // We assume the table is named 'transaksi' and has a foreign key to 'course'
      final data = await supabase
          .from('transaksi')
          .select('course(*, mentor(*), playlist(*), rating(*, pengguna(*)))')
          .eq('id_pengguna', idPengguna);

      // C. Extract the 'course' object from the transaction result
      List<Map<String, dynamic>> tempCourses = [];
      for (var item in (data as List)) {
        if (item['course'] != null) {
          tempCourses.add(item['course']);
        }
      }

      if (mounted) {
        setState(() {
          myCourseList = tempCourses;
        });
      }
    } catch (e) {
      debugPrint('Error fetching my courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which list to show
    final currentList = isAvailableSelected
        ? availableCourseList
        : myCourseList;

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
                  : currentList.isEmpty
                  ? Center(
                      child: Text(
                        isAvailableSelected
                            ? "No available courses."
                            : "You haven't bought any courses yet.",
                      ),
                    )
                  : isAvailableSelected
                  ? GridView.builder(
                      itemCount: currentList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) =>
                          AvailableCourseCard(courseData: currentList[index]),
                    )
                  : ListView.builder(
                      itemCount: currentList.length,
                      itemBuilder: (context, index) =>
                          // Use the Widget from mycourse.dart
                          MyCourseCard(courseData: currentList[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ... Keep AvailableCourseCard as it is ...
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseData['nama_course'] ?? 'Tanpa Judul',
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
