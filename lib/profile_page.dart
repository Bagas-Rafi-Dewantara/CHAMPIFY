import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication/login.dart' show LoginPage;
import 'main.dart';
import 'navbar.dart';
import 'profile_edit_page.dart';
import 'theme_provider.dart';

const Color kProfileThemeColor = Color(0xFFE89B8E);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = true;
  String _displayName = 'Pengguna';
  String _email = '';
  String _headline = '';
  String _city = '';
  String _major = '';
  String _university = '';
  String? _avatarUrl;
  String? _phone;
  int _courseCount = 0;
  int _quizCount = 0;
  double _avgScore = 0;
  String? _error;
  List<Map<String, dynamic>> _enrolledCourses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() {
        _error = 'Kamu belum login. Silakan login untuk melihat profil.';
        _loading = false;
      });
      return;
    }

    setState(() {
      _displayName =
          user.userMetadata?['full_name'] ??
          user.email?.split('@').first ??
          'Pengguna';
      _email = user.email ?? '-';
      _headline = user.userMetadata?['headline'] ?? '';
      _city = user.userMetadata?['city'] ?? '';
      _major = user.userMetadata?['major'] ?? '';
      _university = user.userMetadata?['university'] ?? '';
      _avatarUrl = user.userMetadata?['avatar_url'];
      _phone = user.userMetadata?['phone'];
    });

    try {
      final myCourseEntries = await supabase
          .from('mycourse')
          .select('id_course')
          .eq('id_pengguna', user.id);

      final courseIds = myCourseEntries
          .map((e) => e['id_course'] as int)
          .toList();

      List<Map<String, dynamic>> courseDetails = [];
      if (courseIds.isNotEmpty) {
        courseDetails = await Future.wait(
          courseIds.map((id) async {
            final data = await supabase
                .from('course')
                .select(
                  'id_course, nama_course, link_gambar, jumlah_lesson, mentor(nama_mentor)',
                )
                .eq('id_course', id)
                .single();
            return Map<String, dynamic>.from(data);
          }),
        );
      }

      final quizScores = await supabase
          .from('quiz_score')
          .select('skor')
          .eq('id_pengguna', user.id);

      final quizValues = quizScores
          .map((e) => (e['skor'] ?? 0).toDouble())
          .toList();

      final double averageScore = quizValues.isNotEmpty
          ? quizValues.reduce((a, b) => a + b) / quizValues.length
          : 0;

      if (mounted) {
        setState(() {
          _courseCount = courseIds.length;
          _enrolledCourses = courseDetails;
          _quizCount = quizValues.length;
          _avgScore = averageScore;
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat data: $e';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profil',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh, 
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: kProfileThemeColor),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15, 
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kProfileThemeColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: kProfileThemeColor,
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Kelas Diikuti',
                    value: _courseCount.toString(),
                    icon: Icons.play_circle_fill_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Quiz Dikerjakan',
                    value: _quizCount.toString(),
                    icon: Icons.quiz_outlined,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Rata-rata Skor',
                    value: _quizCount == 0 ? '-' : _avgScore.toStringAsFixed(0),
                    icon: Icons.star_border_rounded,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Kelas yang diikuti',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            if (_enrolledCourses.isEmpty)
              _emptyState(
                icon: Icons.library_books_outlined,
                message: 'Belum ada kelas. Yuk mulai belajar!',
                isDark: isDark,
              )
            else
              Column(
                children: _enrolledCourses
                    .take(3)
                    .map((c) => _CourseTile(course: c, isDark: isDark))
                    .toList(),
              ),
            if (_enrolledCourses.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${_enrolledCourses.length - 3} kelas lainnya',
                  style: TextStyle(
                    fontSize: 13, 
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 22),
            Text(
              'Quiz & Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            _buildQuizCard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _openEditProfilePage,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: kProfileThemeColor.withOpacity(0.1),
                backgroundImage:
                    _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                child: _avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        color: kProfileThemeColor,
                        size: 28,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (_headline.isNotEmpty)
                      Text(
                        _headline,
                        style: TextStyle(
                          fontSize: 13, 
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      )
                    else
                      Text(
                        _email,
                        style: TextStyle(
                          fontSize: 13, 
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kProfileThemeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Aktif belajar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kProfileThemeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.edit_outlined, color: kProfileThemeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _goToCourses,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kProfileThemeColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: kProfileThemeColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Quiz',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _quizCount == 0
                          ? 'Belum ada quiz yang diselesaikan'
                          : '$_quizCount quiz dikerjakan • Rata-rata skor ${_avgScore.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13, 
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios, 
                size: 16, 
                color: isDark ? Colors.grey[400] : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState({
    required IconData icon, 
    required String message,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon, 
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400, 
            size: 26,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13, 
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _goToCourses() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const Navbar(initialIndex: 1, initialSelectMyCourse: true),
      ),
    );
  }

  Future<void> _openEditProfilePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileEditPage()),
    );

    if (result is Map) {
      setState(() {
        _displayName = result['name'] ?? _displayName;
        _headline = result['headline'] ?? _headline;
        _city = result['city'] ?? _city;
        _major = result['major'] ?? _major;
        _university = result['university'] ?? _university;
        _avatarUrl = result['avatar_url'] ?? _avatarUrl;
        _email = result['email'] ?? _email;
        _phone = result['phone'] ?? _phone;
      });
      await supabase.auth.refreshSession();
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kProfileThemeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kProfileThemeColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13, 
              color: isDark ? Colors.grey[400] : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isDark;

  const _CourseTile({
    required this.course,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final mentorName = course['mentor']?['nama_mentor'] ?? '-';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 52,
            height: 52,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            child: course['link_gambar'] != null
                ? Image.network(
                    course['link_gambar'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(
                          Icons.broken_image, 
                          color: isDark ? Colors.grey[600] : Colors.grey,
                        ),
                  )
                : const Icon(Icons.play_circle_fill, color: kProfileThemeColor),
          ),
        ),
        title: Text(
          course['nama_course'] ?? 'Tanpa Judul',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          'Mentor: $mentorName • ${course['jumlah_lesson'] ?? 0} lesson',
          style: TextStyle(
            fontSize: 12, 
            color: isDark ? Colors.grey[400] : Colors.grey,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? Colors.grey[400] : Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const Navbar(initialIndex: 1, initialSelectMyCourse: true),
            ),
          );
        },
      ),
    );
  }
}