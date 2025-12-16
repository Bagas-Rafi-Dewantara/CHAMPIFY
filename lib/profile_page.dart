import 'package:flutter/material.dart';
import 'authentication/login.dart' show LoginPage;
import 'main.dart';
import 'navbar.dart';

const Color kProfileThemeColor = Color(0xFFE89B8E);

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = true;
  String _displayName = 'Pengguna';
  String _email = '';
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
      _displayName = user.userMetadata?['full_name'] ?? user.email?.split('@').first ?? 'Pengguna';
      _email = user.email ?? '-';
    });

    try {
      // Ambil daftar course yang dimiliki
      final myCourseEntries = await supabase
          .from('mycourse')
          .select('id_course')
          .eq('id_pengguna', user.id);

      final courseIds = myCourseEntries
          .map((e) => e['id_course'] as int)
          .toList();

      // Ambil detail course (nama, mentor, gambar)
      List<Map<String, dynamic>> courseDetails = [];
      if (courseIds.isNotEmpty) {
        courseDetails = await Future.wait(courseIds.map((id) async {
          final data = await supabase
              .from('course')
              .select('id_course, nama_course, link_gambar, jumlah_lesson, mentor(nama_mentor)')
              .eq('id_course', id)
              .single();
          return Map<String, dynamic>.from(data);
        }));
      }

      // Ambil statistik quiz
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: kProfileThemeColor));
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
              style: const TextStyle(fontSize: 15, color: Colors.black87),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            _buildHeader(),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Kelas Diikuti',
                    value: _courseCount.toString(),
                    icon: Icons.play_circle_fill_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Quiz Dikerjakan',
                    value: _quizCount.toString(),
                    icon: Icons.quiz_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Rata-rata Skor',
                    value: _quizCount == 0 ? '-' : _avgScore.toStringAsFixed(0),
                    icon: Icons.star_border_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Kelas yang diikuti',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            if (_enrolledCourses.isEmpty)
              _emptyState(
                icon: Icons.library_books_outlined,
                message: 'Belum ada kelas. Yuk mulai belajar!',
              )
            else
              Column(
                children: _enrolledCourses
                    .take(3)
                    .map((c) => _CourseTile(course: c))
                    .toList(),
              ),
            if (_enrolledCourses.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${_enrolledCourses.length - 3} kelas lainnya',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 22),
            const Text(
              'Quiz & Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            _buildQuizCard(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _goToCourses,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: kProfileThemeColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Lihat Semua Course',
                      style: TextStyle(
                        color: kProfileThemeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kProfileThemeColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Refresh Data',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (supabase.auth.currentUser != null)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    await supabase.auth.signOut();
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (_) => false,
                      );
                    }
                  },
                  child: const Text(
                    'Keluar dari akun',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: kProfileThemeColor),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
            child: const Icon(Icons.verified_outlined, color: kProfileThemeColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress Quiz',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _quizCount == 0
                      ? 'Belum ada quiz yang diselesaikan'
                      : '$_quizCount quiz dikerjakan • Rata-rata skor ${_avgScore.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _emptyState({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 26),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _goToCourses() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Navbar(initialIndex: 1, initialSelectMyCourse: true),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  final Map<String, dynamic> course;

  const _CourseTile({required this.course});

  @override
  Widget build(BuildContext context) {
    final mentorName = course['mentor']?['nama_mentor'] ?? '-';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFFE4DD),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 52,
            height: 52,
            color: Colors.grey.shade200,
            child: course['link_gambar'] != null
              ? Image.network(
                course['link_gambar'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
                )
              : const Icon(Icons.play_circle_fill, color: kProfileThemeColor),
          ),
        ),
        title: Text(
          course['nama_course'] ?? 'Tanpa Judul',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          'Mentor: $mentorName • ${course['jumlah_lesson'] ?? 0} lesson',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Navigasi ke tab Course (My Course)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const Navbar(initialIndex: 1, initialSelectMyCourse: true),
            ),
          );
        },
      ),
    );
  }
}
