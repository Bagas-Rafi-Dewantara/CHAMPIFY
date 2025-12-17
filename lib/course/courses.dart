import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../theme_provider.dart';
import 'detail_course.dart';
import 'mycourse.dart';

class CoursePage extends StatefulWidget {
  final bool initialSelectMyCourse;
  const CoursePage({super.key, this.initialSelectMyCourse = false});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  // Tetap menggunakan boolean karena tampilan Anda saat ini hanya 2 tab
  bool isAvailableSelected = true;
  List<Map<String, dynamic>> availableCourseList = [];
  List<Map<String, dynamic>> myCourseList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectMyCourse && isAvailableSelected) {
      isAvailableSelected = false;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        final bool selectMyCourse = args['selectMyCourse'] == true;
        final dynamic initialTab = args['initialTab'];
        final bool goToMyCourse = selectMyCourse || initialTab == 'MyCourse';
        if (goToMyCourse && isAvailableSelected) {
          setState(() => isAvailableSelected = false);
        }
      }
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

  Future<void> fetchMyCourses() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

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

      for (var id in courseIds) {
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
    final currentList = isAvailableSelected ? availableCourseList : myCourseList;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Course',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
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
                            : (isDark ? const Color(0xFF1E1E1E) : Colors.transparent),
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
                            : (isDark ? const Color(0xFF1E1E1E) : Colors.transparent),
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
                                  AvailableCourseCard(
                                courseData: currentList[index],
                                isDark: isDark,
                              ),
                            )
                          : ListView.builder(
                              itemCount: currentList.length,
                              itemBuilder: (context, index) =>
                                  MyCourseCard(
                                courseData: currentList[index],
                                isDark: isDark,
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvailableCourseCard extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final bool isDark;
  const AvailableCourseCard({
    super.key,
    required this.courseData,
    required this.isDark,
  });

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
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black.withOpacity(0.3)
                  : const Color(0xFFFFE4DD),
              blurRadius: 5,
              offset: const Offset(0, 3),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "(${courseData['jumlah_lesson'] ?? 0} lessons)",
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                        fontSize: 12,
                      ),
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