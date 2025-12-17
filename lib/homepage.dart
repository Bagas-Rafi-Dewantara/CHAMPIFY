import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'dart:async';
import '../main.dart'; 
import 'mentoring.dart';
import 'course/detail_course.dart';
import 'competition.dart' hide supabase;
import 'course/courses.dart';
import 'profile_page.dart';
import 'theme_provider.dart'; 


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  late Timer _timer;
  bool _userIsInteracting = false;

  List<Map<String, dynamic>> _courseList = [];
  bool _isLoadingCourses = true;

  List<Map<String, dynamic>> _competitionList = [];
  bool _isLoadingCompetitions = true;

  Map<String, dynamic>? _upcomingMeeting;
  bool _isLoadingMeeting = true;

  String _userName = 'Pengguna';
  bool _isUserLoading = true;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _fetchHomeCourses();
    _fetchHomeCompetitions();
    _fetchUpcomingMeeting();
    _fetchUserData();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      int totalItems = _competitionList.length;
      if (totalItems > 0 && !_userIsInteracting) {
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

  Future<void> _fetchHomeCourses() async {
    try {
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

Future<void> _fetchHomeCompetitions() async {
  try {
    // Ambil 5 kompetisi terbaru yang statusnya ongoing atau almost over
    final allActiveData = await supabase
        .from('competition')
        .select('*')
        .or('status.eq.ongoing,status.eq.almost over')
        .order('end_date', ascending: true)
        .limit(5); // Limit 5 untuk recommended

    final List<Map<String, dynamic>> combinedData =
        List<Map<String, dynamic>>.from(allActiveData);

    if (mounted) {
      setState(() {
        _competitionList = combinedData.map((comp) {
          final String dbStatus = comp['status'].toString().toLowerCase();
          final String imageUrl = comp['image_url'] ?? comp['poster'] ?? '';

          String displayStatus;
          if (dbStatus == 'almost over') {
            displayStatus = 'Almost Over';
          } else if (dbStatus == 'ongoing') {
            displayStatus = 'On Going';
          } else {
            displayStatus = 'On Going';
          }

          return {
            ...comp,
            'image_url_final': imageUrl,
            'display_status': displayStatus,
          };
        }).toList();

        _isLoadingCompetitions = false;

        if (_competitionList.isNotEmpty) {
          _currentPage = 0;
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

  Future<void> _fetchUpcomingMeeting() async {
    try {
      final data = await supabase
          .from('zoom')
          .select('*, mentor(*)')
          .limit(10);

      debugPrint('Supabase data received: $data');

      if (mounted) {
        setState(() {
          if (data.isNotEmpty) {
            final List<Map<String, dynamic>> futureMeetings = data.where((m) {
              try {
                if (m['date'] == null) return false;

                final meetingDate = DateTime.parse(m['date']);
                final yesterday = DateTime.now().subtract(
                  const Duration(hours: 24),
                );

                return meetingDate.isAfter(yesterday);
              } catch (e) {
                debugPrint('Error parsing date for meeting: ${m['date']}');
                return false;
              }
            }).toList();

            if (futureMeetings.isNotEmpty) {
              futureMeetings.sort((a, b) {
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
      debugPrint('Critical Error fetching upcoming meeting: $e');
      if (mounted) {
        setState(() => _isLoadingMeeting = false);
      }
    }
  }

  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    final currentUserId = user?.id;

    debugPrint('📱 Fetching user data...');

    if (user != null) {
      final metaName = user.userMetadata?['full_name'] as String?;
      debugPrint('📋 Metadata name: $metaName');

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
    // GET DARK MODE STATE
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDark),
                const SizedBox(height: 30),

                Text(
                  'Upcoming Meeting',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                _buildUpcomingMeeting(isDark),
                const SizedBox(height: 30),

                _buildFeatureSection(isDark),
                const SizedBox(height: 30),

                Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCoursesList(isDark),
                const SizedBox(height: 30),

                Text(
                  'Recommended Competition',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCompetitionCarousel(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
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
=======
  Widget _buildHeader(bool isDark) {
  if (_isUserLoading) {
    return const SizedBox(
      height: 60,
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
>>>>>>> 2cbcfadfc20c300cf43cc2eea3c9eccf34757c1a
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
              Text(
                'Hello, ', 
                style: TextStyle(
                  fontSize: 24,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                _userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Let's be enthusiastic to achieve!",
            style: TextStyle(
              fontSize: 14, 
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        ],
      ),
      // ✅ INI JUGA PERLU DIGANTI (InkWell + CircleAvatar)
      InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
          await supabase.auth.refreshSession();
          _fetchUserData();
        },
        borderRadius: BorderRadius.circular(32),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: isDark ? Colors.grey[800] : Colors.grey.shade300,
          child: _avatarUrl != null && _avatarUrl!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    _avatarUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person, 
                        color: Colors.white,
                        size: 28,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                        ),
                      );
                    },
                  ),
                )
              : const Icon(
                  Icons.person, 
                  color: Colors.white,
                  size: 28,
                ),
        ),
      ),
    ],
  );
}

  Widget _buildUpcomingMeeting(bool isDark) {
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
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
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
                  Text(
                    'Discuss with mentor',
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: [
                      Text(
                        '30 Juli 2024',
                        style: TextStyle(
                          fontSize: 11, 
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                      Text(
                        '19.00-21.00 WIB',
                        style: TextStyle(
                          fontSize: 11, 
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
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

  Widget _buildFeatureSection(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Feature',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
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

  Widget _buildCoursesList(bool isDark) {
    if (_isLoadingCourses) {
      return const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_courseList.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "Belum ada course tersedia.",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _courseList.length,
        itemBuilder: (context, index) {
          final course = _courseList[index];

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 8, right: 8),
            child: _buildCourseCard(course, isDark),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> courseData, bool isDark) {
    final String title = courseData['nama_course'] ?? 'No Title';
    final String imageUrl = courseData['link_gambar'] ?? '';
    final int lessonsCount = courseData['jumlah_lesson'] ?? 0;
    final String duration = courseData['durasi_course'] ?? '-';
    
    final List ratings = courseData['rating'] ?? [];
    String ratingStr = '0.0';
    if (ratings.isNotEmpty) {
      double total = 0;
      for (var r in ratings) {
        total += (r['rating'] as num).toDouble();
      }
      ratingStr = (total / ratings.length).toStringAsFixed(1);
    }

    final Color cardColor = const Color(0xFFD8B4E8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetailCoursePage(courseData: courseData),
            ),
          );
        },
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 4),
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
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark 
                            ? Colors.grey[800]
                            : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: isDark ? Colors.grey[400] : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$lessonsCount lessons',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
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

Widget _buildCompetitionCarousel(bool isDark) {
    if (_isLoadingCompetitions) {
      return const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_competitionList.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "Belum ada kompetisi yang sedang berlangsung.",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        ),
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
      child: GestureDetector(
        onPanDown: (_) {
          setState(() {
            _userIsInteracting = true;
          });
        },
        onPanEnd: (_) {
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                _userIsInteracting = false;
              });
            }
          });
        },
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (p) => setState(() => _currentPage = p),
          itemCount: _competitionList.length,
          itemBuilder: (context, index) {
            final competition = _competitionList[index];
            final String imageUrl =
                competition['image_url'] ??
                competition['poster'] ??
                '';
            final String title = competition['title'] ?? 'No Title';
            final String status =
                competition['display_status'] ??
                'Closed';

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
                  child: GestureDetector(
                    onTap: () {
                      final competitionData = Competition.fromJson(competition);
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompetitionDetailScreen(
                            competition: competitionData,
                            isSaved: false,
                            onSaveToggle: () {},
                          ),
                        ),
                      );
                    },
                    child: _buildCompetitionCard(imageUrl, title, status),
                  ),
                ),
              ),
            );
          },
        ),
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
    // ✅ LAYER 1: SHADOW DI SINI (PALING LUAR)
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
          spreadRadius: 2,
        ),
      ],
    ),
    // ✅ LAYER 2: CLIP ROUNDED CORNER DI DALAM
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        // ✅ LAYER 3: BACKGROUND COLOR (FALLBACK)
        color: Colors.grey.shade300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
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
                title,
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
                  status,
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
    ),
  );
}
}
