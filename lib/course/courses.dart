import 'package:flutter/material.dart';
import '../main.dart'; // 1. IMPORT PENTING: Biar bisa akses variabel 'supabase'
import 'playlist_course.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool isAvailableSelected = true;

  // 2. Variabel untuk menampung data
  List<Map<String, dynamic>> courseList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses(); // Panggil fungsi ambil data saat halaman dibuka
  }

  // 3. Fungsi Ambil Data dari Supabase
  Future<void> fetchCourses() async {
    try {
      // Mengambil semua data dari tabel 'course'
      final data = await supabase.from('course').select();

      setState(() {
        courseList = List<Map<String, dynamic>>.from(data);
        isLoading = false; // Matikan loading kalau data sudah dapat
      });
    } catch (e) {
      print('Error fetching courses: $e');
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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

            // --- HEADER TABS (Gak berubah) ---
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
                  ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Loading State
                  : courseList.isEmpty
                  ? const Center(child: Text("Belum ada course tersedia."))
                  : isAvailableSelected
                  ? _buildAvailableCourseGrid()
                  : _buildMyCourseList(),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET 1: Tampilan Grid (Nyambung Data)
  Widget _buildAvailableCourseGrid() {
    return GridView.builder(
      itemCount: courseList.length, // Sesuai jumlah data di DB
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        // Kirim data spesifik ke kartu
        return AvailableCourseCard(courseData: courseList[index]);
      },
    );
  }

  // WIDGET 2: Tampilan List (Nyambung Data)
  Widget _buildMyCourseList() {
    // Note: Harusnya ini fetch dari tabel 'my_course', tapi sementara kita pakai data 'course' dulu ya
    return ListView.builder(
      itemCount: courseList.length,
      itemBuilder: (context, index) {
        return MyCourseCard(courseData: courseList[index]);
      },
    );
  }
}

// --- DESAIN KARTU 1: AVAILABLE COURSE (DINAMIS) ---
class AvailableCourseCard extends StatelessWidget {
  // Terima data di sini
  final Map<String, dynamic> courseData;

  const AvailableCourseCard({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.blueAccent,
                  // Tampilkan gambar kalau ada link-nya
                  child: courseData['link_gambar'] != null
                      ? Image.network(
                          courseData['link_gambar'],
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.bar_chart,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
              // ... (Mascot star tetap sama) ...
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tampilkan Judul Asli dari DB
                  Text(
                    courseData['nama_course'] ?? 'Tanpa Judul',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Tampilkan Jumlah Lesson
                  Text(
                    "(${courseData['jumlah_lesson'] ?? 0} lessons)",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4D8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 12,
                              color: Color(0xFF996457),
                            ),
                            const SizedBox(width: 4),
                            // Tampilkan Durasi
                            Text(
                              courseData['durasi_course'] ?? '0m',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF996457),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Rating (Kalau ada kolom rating, bisa diganti)
                      Row(
                        children: const [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(
                            " 4.5",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- DESAIN KARTU 2: MY COURSE (DINAMIS) ---
class MyCourseCard extends StatelessWidget {
  // Terima data di sini juga
  final Map<String, dynamic> courseData;

  const MyCourseCard({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 160,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAB9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  // Judul dari DB
                  child: Text(
                    courseData['nama_course'] ?? 'Judul Course',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D2D2D),
                      height: 1.2,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaylistCoursePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D4F40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -75,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/star-course.png',
                width: 350,
                height: 350,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


