import 'package:flutter/material.dart';
import '../main.dart'; // Akses supabase
import 'detail_course.dart';
import 'mycourse.dart'; // File yang berisi MyCourseCard

class CoursePage extends StatefulWidget {
  final bool initialSelectMyCourse;
  const CoursePage({super.key, this.initialSelectMyCourse = false});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  // Tetap menggunakan boolean karena tampilan Anda saat ini hanya 2 tab
  bool isAvailableSelected = true;

  // Dua list terpisah untuk menampung data
  List<Map<String, dynamic>> availableCourseList = [];
  List<Map<String, dynamic>> myCourseList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Set tab awal dari prop jika diminta
    if (widget.initialSelectMyCourse && isAvailableSelected) {
      isAvailableSelected = false;
    }
    // Tangkap argumen navigasi jika ada (fallback)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        final bool selectMyCourse = args['selectMyCourse'] == true;
        final dynamic initialTab = args['initialTab'];
        final bool goToMyCourse = selectMyCourse || initialTab == 'MyCourse';
        if (goToMyCourse && isAvailableSelected) {
          setState(() {
            isAvailableSelected = false;
          });
        }
      }
      // Lanjutkan fetch data setelah inisialisasi state selesai
      fetchAllData();
    });
  }

  Future<void> fetchAllData() async {
    setState(() => isLoading = true);
    await Future.wait([fetchAvailableCourses(), fetchMyCourses()]);
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // 1. Fetch COURSE (Tab Available)
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

  // 2. Fetch MY COURSE (Tab My Course)
  Future<void> fetchMyCourses() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // 1. Ambil ID Course yang dimiliki pengguna
      final List<dynamic> myCourseEntries = await supabase
          .from('mycourse')
          .select('id_course')
          .eq('id_pengguna', user.id);

      final List<int> courseIds = myCourseEntries
          .map((e) => e['id_course'] as int)
          .toList();

      if (courseIds.isEmpty) {
        if (mounted) setState(() => myCourseList = []);
        return;
      }

      final List<Map<String, dynamic>> tempCourses = [];

      // 2. Loop setiap Course ID
      for (var id in courseIds) {
        // A. AMBIL DATA LENGKAP TERMASUK QUIZ & SOAL (Nested Join)
        // PERHATIKAN BAGIAN .select() DI BAWAH INI:
        final courseDataList = await supabase
            .from('course')
            .select('''
              *, 
              mentor(*), 
              playlist(*), 
              rating(*, pengguna(*)),
              zoom(*),
              quiz(
                *,
                soal_kuis(*)
              )
            ''')
            .eq('id_course', id)
            .single();

        // B. Ambil TIPE PAKET TERAKHIR
        final List<dynamic> transactionData = await supabase
            .from('transactions')
            .select('tipe_paket')
            .eq('id_pengguna', user.id)
            .eq('id_course', id)
            .order('payment_date', ascending: false)
            .limit(1);

        Map<String, dynamic> combinedData = Map.from(courseDataList);

        if (transactionData.isNotEmpty) {
          combinedData['tipe_paket_dibeli'] =
              transactionData.first['tipe_paket'] ?? 'Reguler';
        } else {
          combinedData['tipe_paket_dibeli'] = 'Reguler';
        }

        tempCourses.add(combinedData);
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
    // Tentukan list mana yang ditampilkan berdasarkan Tab
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isAvailableSelected
                                ? Icons.class_outlined
                                : Icons.shopping_bag_outlined,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isAvailableSelected
                                ? "Belum ada course tersedia."
                                : "Kamu belum membeli course apapun.",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
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
                          // MyCourseCard kini menerima data yang sudah dilengkapi dengan 'tipe_paket_dibeli'
                          MyCourseCard(courseData: currentList[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ... KARTU AVAILABLE TETAP SAMA ...
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
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, color: Colors.white),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
