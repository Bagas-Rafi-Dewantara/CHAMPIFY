import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart'; // <--- PENTING: Untuk akses variabel 'supabase'
import 'mentoring.dart';
import 'course/detail_course.dart';
import 'competition.dart' hide supabase;
import 'course/courses.dart';
import 'profile_page.dart';
// import 'course/mycourse_quiz.dart'; <--- SUDAH DIHAPUS

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  late Timer _timer;

  // --- STATE UNTUK DATA COURSE ---
  List<Map<String, dynamic>> _courseList = [];
  bool _isLoadingCourses = true;

  // --- STATE UNTUK DATA COMPETITION BARU ---
  List<Map<String, dynamic>> _competitionList = [];
  bool _isLoadingCompetitions = true;

  // --- STATE UNTUK DATA MEETING ---
  Map<String, dynamic>? _upcomingMeeting;
  bool _isLoadingMeeting = true;

  // --- STATE UNTUK DATA PENGGUNA (HEADER) ---
  String _userName = 'Pengguna'; // Default name
  bool _isUserLoading = true;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi fetch data saat halaman dibuka
    _fetchHomeCourses();
    _fetchHomeCompetitions();
    _fetchUpcomingMeeting();
    _fetchUserData();

    // Timer untuk Carousel
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      // Menggunakan panjang list kompetisi yang dinamis
      int totalItems = _competitionList.length;
      if (totalItems > 0) {
        if (_currentPage < totalItems - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  // --- UTILITY FUNCTION (BISA DIPANGGIL DARI DALAM CLASS) ---
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      const List<String> monthNames = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return '${date.day} ${monthNames[date.month]} ${date.year}';
    } catch (e) {
      return 'Tanggal tidak valid';
    }
  }

  // --- LOGIKA AMBIL DATA DARI SUPABASE ---
  Future<void> _fetchHomeCourses() async {
    try {
      // Ambil data course (limit 5 aja buat homepage biar ringan)
      // Include mentor, playlist, dan rating seperti di courses.dart
      final data = await supabase
          .from('course')
          .select('*, mentor(*), playlist(*), rating(*, pengguna(*))')
          .limit(5);

      if (mounted) {
        setState(() {
          _courseList = List<Map<String, dynamic>>.from(data);
          _isLoadingCourses = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching home courses: $e');
      if (mounted) {
        setState(() => _isLoadingCourses = false);
      }
    }
  }

  // --- LOGIKA BARU: AMBIL DATA COMPETITION DARI SUPABASE (PERBAIKAN FINAL) ---
  Future<void> _fetchHomeCompetitions() async {
    try {
      // PERBAIKAN: Menggunakan .or() untuk menggantikan .in_()
      // Ini memfilter data di mana status SAMA DENGAN 'ongoing' ATAU 'almost over'.
      // Pastikan nilai status di database Anda adalah TEKS lowercase: 'ongoing' dan 'almost over'
      final allActiveData = await supabase
          .from('competition')
          .select('*')
          .or(
            'status.eq.ongoing,status.eq.almost over',
          ) // <--- PERBAIKAN UTAMA DI SINI
          .order('end_date', ascending: true)
          .limit(5);

      // Filter untuk memisahkan 2 Almost Over dan 3 On Going (berdasarkan urutan tanggal)
      final List<Map<String, dynamic>> combinedData =
          List<Map<String, dynamic>>.from(allActiveData);

      // Logika untuk menentukan status tampilan
      if (mounted) {
        setState(() {
          _competitionList = combinedData.map((comp) {
            final String dbStatus = comp['status'].toString().toLowerCase();
            // Cek kolom image_url dulu, jika kosong, pakai kolom poster
            final String imageUrl = comp['image_url'] ?? comp['poster'] ?? '';

            String displayStatus;
            if (dbStatus == 'almost over') {
              displayStatus = 'Almost Over';
            } else if (dbStatus == 'ongoing') {
              displayStatus = 'On Going';
            } else {
              // Default jika ada status lain yang terambil
              displayStatus = 'On Going';
            }

            return {
              ...comp,
              'image_url_final':
                  imageUrl, // Tambahkan kunci untuk gambar yang pasti ada
              'display_status': displayStatus,
            };
          }).toList();

          _isLoadingCompetitions = false;

          // Atur ulang PageController jika list tidak kosong
          if (_competitionList.isNotEmpty) {
            _currentPage = 0; // Reset ke halaman pertama
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching home competitions: $e');
      if (mounted) {
        setState(() => _isLoadingCompetitions = false);
      }
    }
  }

  // --- LOGIKA PERBAIKAN FINAL (Mengambil Semua Data lalu Filter di Flutter) ---
  Future<void> _fetchUpcomingMeeting() async {
    try {
      // Ambil data yang tersisa (termasuk yang 2026) tanpa filter tanggal yang ketat.
      // Kita ambil semua data dan filter di sisi Flutter
      final data = await supabase
          .from('zoom')
          .select('*, mentor(*)')
          .limit(
            10,
          ); // Ambil lebih banyak data (atau semua jika tidak terlalu banyak)

      // --- TAMBAHKAN DEBUGGING INI ---
      debugPrint('Supabase data received: $data');

      if (mounted) {
        setState(() {
          if (data.isNotEmpty) {
            // 1. Filter: Hanya ambil meeting yang tanggalnya di masa depan atau hari ini
            final List<Map<String, dynamic>> futureMeetings = data.where((m) {
              try {
                // Pastikan kolom 'date' tidak null
                if (m['date'] == null) return false;

                final meetingDate = DateTime.parse(m['date']);
                // Gunakan isAfter(yesterday) untuk menyertakan hari ini (00:00:00)
                final yesterday = DateTime.now().subtract(
                  const Duration(hours: 24),
                );

                return meetingDate.isAfter(yesterday);
              } catch (e) {
                debugPrint('Error parsing date for meeting: ${m['date']}');
                return false;
              }
            }).toList();

            // 2. Sort: Urutkan berdasarkan tanggal terdekat
            if (futureMeetings.isNotEmpty) {
              futureMeetings.sort((a, b) {
                // Perbandingan tanggal wajib dilakukan di sini
                final dateA = DateTime.parse(a['date']);
                final dateB = DateTime.parse(b['date']);
                return dateA.compareTo(dateB);
              });

              _upcomingMeeting = futureMeetings.first;
            } else {
              _upcomingMeeting = null;
            }
          } else {
            _upcomingMeeting = null;
          }
          _isLoadingMeeting = false;
        });
      }
    } catch (e) {
      // Jika masih ada error di sini, kemungkinan masalah koneksi atau RLS
      debugPrint('Critical Error fetching upcoming meeting: $e');
      if (mounted) {
        setState(() => _isLoadingMeeting = false);
      }
    }
  }

  // --- LOGIKA BARU: AMBIL NAMA PENGGUNA DARI SUPABASE ---
  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    final currentUserId = user?.id;

    debugPrint('📱 Fetching user data...');

    if (user != null) {
      final metaName = user.userMetadata?['full_name'] as String?;
      debugPrint('📋 Metadata name: $metaName');

      // Gunakan metadata untuk respon cepat di header
      _userName = metaName ?? user.email?.split('@').first ?? 'Pengguna';
      _avatarUrl = user.userMetadata?['avatar_url'];

      if (mounted) {
        setState(() {
          _isUserLoading = false;
        });
      }
    }

    if (currentUserId == null) {
      if (mounted) {
        setState(() {
          _isUserLoading = false;
        });
      }
      return;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header
                _buildHeader(),
                const SizedBox(height: 30),

                // 2. Upcoming Meeting
                const Text(
                  'Upcoming Meeting',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildUpcomingMeeting(),
                const SizedBox(height: 30),

                // 3. My Feature
                _buildFeatureSection(),
                const SizedBox(height: 30),

                // 4. Courses Preview (DATA ASLI)
                const Text(
                  'Courses',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildCoursesList(), // <--- List ini sekarang dinamis
                const SizedBox(height: 30),

                // 5. Competition Carousel
                const Text(
                  'Recommended Competition',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildCompetitionCarousel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========================================
  // HEADER SECTION (SUDAH DINAMIS)
  // ========================================

  Widget _buildHeader() {
    // Tampilkan loading sebentar jika data pengguna sedang diambil
    if (_isUserLoading) {
      return const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Hello, ', style: TextStyle(fontSize: 24)),
                Text(
                  // Menggunakan state _userName yang sudah dimuat dari DB
                  _userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Let's be enthusiastic to achieve!",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
            await supabase.auth.refreshSession();
            if (mounted) {
              _fetchUserData();
            }
          },
          borderRadius: BorderRadius.circular(32),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _avatarUrl != null
                ? NetworkImage(_avatarUrl!)
                : null,
            child: _avatarUrl == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ),
      ],
    );
  }

  // ========================================
  // UPCOMING MEETING SECTION
  // ========================================

  Widget _buildUpcomingMeeting() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ZoomMeetingScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE89B8E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.videocam, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discuss with mentor',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: const [
                      Text(
                        '30 Juli 2024',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        '19.00-21.00 WIB',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ZoomMeetingScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE89B8E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Join',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // MY FEATURE SECTION
  // ========================================

  Widget _buildFeatureSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Feature',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFeatureItem(
              Icons.videocam,
              'Zoom',
              const Color(0xFFE8C4A0),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ZoomMeetingScreen(),
                  ),
                );
              },
            ),
            _buildFeatureItem(
              Icons.play_circle,
              'Course',
              const Color(0xFFE8C4A0),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CoursePage()),
                );
              },
            ),
            // --- BAGIAN QUIZ SUDAH DIHAPUS ---
            _buildFeatureItem(
              Icons.emoji_events,
              'Competition',
              const Color(0xFFE8E4A0),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompetitionListScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ========================================
  // COURSES SECTION (UPDATED)
  // ========================================

  Widget _buildCoursesList() {
    // 1. Tampilkan Loading jika data belum siap
    if (_isLoadingCourses) {
      return const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Tampilkan pesan jika data kosong
    if (_courseList.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text("Belum ada course tersedia.")),
      );
    }

    // 3. Tampilkan List Data Asli
    return SizedBox(
      height: 320, // Tinggi container disesuaikan
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _courseList.length,
        itemBuilder: (context, index) {
          final course = _courseList[index];

          // Kita kirim seluruh Map 'course' ke widget card
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 8, right: 8),
            child: _buildCourseCard(course),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> courseData) {
    // Ekstrak data dari Map (JSON Supabase)
    final String title = courseData['nama_course'] ?? 'No Title';
    final String imageUrl = courseData['link_gambar'] ?? '';
    final int lessonsCount = courseData['jumlah_lesson'] ?? 0;
    final String duration = courseData['durasi_course'] ?? '-';
    // Logic simple untuk ambil rating rata-rata
    final List ratings = courseData['rating'] ?? [];
    String ratingStr = '0.0';
    if (ratings.isNotEmpty) {
      double total = 0;
      for (var r in ratings) {
        total += (r['rating'] as num).toDouble();
      }
      ratingStr = (total / ratings.length).toStringAsFixed(1);
    }

    // Warna dummy agar UI tetap variatif (karena di DB mungkin belum ada field warna)
    final Color cardColor = const Color(0xFFD8B4E8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // --- NAVIGASI KE DETAIL DENGAN DATA ASLI ---
          Navigator.of(context).push(
            MaterialPageRoute(
              // Kirim Data Asli (courseData) ke DetailCoursePage
              builder: (_) => DetailCoursePage(courseData: courseData),
            ),
          );
        },
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with gradient overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: 240,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 240,
                          height: 160,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    width: 240,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          cardColor.withOpacity(0.3),
                          cardColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  // Heart icon
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              // Card content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$lessonsCount lessons',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Duration badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Color(0xFFFFB800),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                duration,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFFB800),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Color(0xFFFFB800),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ratingStr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // COMPETITION CAROUSEL
  // ========================================

  Widget _buildCompetitionCarousel() {
    // 1. Tampilkan Loading
    if (_isLoadingCompetitions) {
      return const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Tampilkan pesan jika data kosong
    if (_competitionList.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text("Belum ada kompetisi yang sedang berlangsung."),
        ),
      );
    }

    // 3. Tampilkan Carousel dengan data dinamis
    return SizedBox(
      height: 320,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (p) => setState(() => _currentPage = p),
        itemCount: _competitionList.length, // <--- Jumlah item dari data DB
        itemBuilder: (context, index) {
          final competition = _competitionList[index]; // Ambil data
          final String imageUrl =
              competition['image_url'] ??
              competition['poster'] ??
              ''; // Ambil link gambar dari kolom DB
          final String title = competition['title'] ?? 'No Title';
          final String status =
              competition['display_status'] ??
              'Closed'; // Status yang sudah dihitung

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
              }
              return Center(
                child: SizedBox(
                  height: Curves.easeInOut.transform(value) * 320,
                  width: Curves.easeInOut.transform(value) * 280,
                  child: child,
                ),
              );
            },
            child: Opacity(
              opacity: _currentPage == index ? 1.0 : 0.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                // Kirim data yang sudah diekstrak ke card
                child: _buildCompetitionCard(imageUrl, title, status),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompetitionCard(String imageUrl, String title, String status) {
    Color statusColor = status == 'Closed'
        ? Colors.white
        : (status == 'On Going'
              ? const Color(0xFF2D5F3F)
              : const Color(0xFF8B6914));

    Color statusBg = status == 'Closed'
        ? const Color(0xFFE89B8E)
        : (status == 'On Going'
              ? const Color(0xFFA8D5BA)
              : const Color(0xFFFFF59D));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl, // Menggunakan imageUrl dinamis
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.emoji_events, size: 60),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                title, // Menggunakan title dinamis
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status, // Menggunakan status dinamis
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
