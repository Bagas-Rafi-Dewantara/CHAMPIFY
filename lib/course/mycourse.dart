import 'package:flutter/material.dart';
// Import file halaman detail yang baru (ASUMSI NAMA FILE: my_course_playlist_page.dart)
import 'mycourse_playlist.dart';
// import 'package:url_launcher/url_launcher.dart'; // Jika tidak dipakai, boleh dihapus

// ==========================================
// 1. KARTU MY COURSE
// ==========================================
class MyCourseCard extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const MyCourseCard({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Playlist dengan membawa SELURUH data course
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCoursePlaylistPage(
              // DIGANTI ke MyCoursePlaylistPage
              courseData: courseData, // Kirim Map data agar playlist dinamis
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 160,
        width: double.infinity,
        clipBehavior: Clip.hardEdge, // Memotong gambar bintang yang kelebihan
        decoration: BoxDecoration(
          color: const Color(0xFFFFDAB9), // Warna Peach
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // --- GAMBAR BINTANG (ASSET) SESUAI REQUEST ---
            Positioned(
              bottom: -75,
              right: 0,
              child: IgnorePointer(
                // Agar tidak menghalangi klik
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    'assets/images/star-course.png',
                    width: 350,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // --- KONTEN TEKS & TOMBOL ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200, // Batasi lebar agar tidak menabrak bintang
                    child: Text(
                      courseData['nama_course'] ?? 'Judul Course',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D2D2D),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCoursePlaylistPage(
                            courseData: courseData,
                          ), // DIGANTI ke MyCoursePlaylistPage
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
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN DETAIL PLAYLIST (LOGIC DINAMIS)
// ==========================================
class PlaylistCoursePage extends StatefulWidget {
  // Terima data lengkap agar bisa render list video dari DB
  final Map<String, dynamic> courseData;

  const PlaylistCoursePage({super.key, required this.courseData});

  @override
  State<PlaylistCoursePage> createState() => _PlaylistCoursePageState();
}

class _PlaylistCoursePageState extends State<PlaylistCoursePage> {
  int selectedTabIndex = 0; // 0 = Playlist, 1 = Quiz, 2 = Zoom

  @override
  Widget build(BuildContext context) {
    final String courseTitle = widget.courseData['nama_course'] ?? 'Course';

    return Scaffold(
      body: Stack(
        children: [
          // A. HEADER BACKGROUND IMAGE
          Container(
            height: 350,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9C88FF), Color(0xFFFF9494)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Colors.black,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // B. WHITE SHEET CONTENT
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Course Dinamis
                    Text(
                      courseTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tab Switcher
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTabItem("Playlist", 0),
                          _buildTabItem("Quiz", 1),
                          _buildTabItem("Zoom", 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Content List (DINAMIS)
                    Expanded(child: _buildContentList()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC BUILD LIST DINAMIS ---
  Widget _buildContentList() {
    if (selectedTabIndex == 0) {
      // 1. TAB PLAYLIST (Data dari Supabase)
      final List<dynamic> playlist = widget.courseData['playlist'] ?? [];

      // Sort berdasarkan nomor urut
      playlist.sort(
        (a, b) =>
            (a['nomor_playlist'] ?? 0).compareTo(b['nomor_playlist'] ?? 0),
      );

      if (playlist.isEmpty) {
        return const Center(child: Text("Belum ada materi video."));
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: playlist.length,
        itemBuilder: (context, index) {
          final video = playlist[index];
          return PlaylistItem(
            title: video['nama_playlist'] ?? "Video Materi ${index + 1}",
            duration: video['durasi_video'] ?? "00:00",
            linkVideo: video['link_video'],
          );
        },
      );
    } else if (selectedTabIndex == 1) {
      // 2. TAB QUIZ (Static untuk saat ini)
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: 3,
        itemBuilder: (context, index) {
          return QuizListItem(quizNumber: index + 1);
        },
      );
    } else {
      // 3. TAB ZOOM (Static untuk saat ini)
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: 2,
        itemBuilder: (context, index) {
          return ZoomListItem(index: index);
        },
      );
    }
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFE0E0) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFFFF9494) : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// --- WIDGET PENDUKUNG ---

class PlaylistItem extends StatelessWidget {
  final String title;
  final String duration;
  final String? linkVideo;

  const PlaylistItem({
    super.key,
    required this.title,
    required this.duration,
    this.linkVideo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Disini nanti bisa dipasang logika buka Video Player
        if (linkVideo != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Memutar: $title")));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFFF9494).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9494).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Color(0xFFFF9494),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class QuizListItem extends StatelessWidget {
  final int quizNumber;
  const QuizListItem({super.key, required this.quizNumber});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = quizNumber == 1; // Dummy logic
    final Color salmonColor = const Color(0xFFFFA08A);

    return GestureDetector(
      onTap: () {
        if (isCompleted) {
          // Navigasi ke Quiz Page (jika sudah ada)
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Selesaikan kuis sebelumnya!"),
              duration: Duration(milliseconds: 500),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isCompleted ? salmonColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: salmonColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? Colors.white : salmonColor,
                  width: 1,
                ),
              ),
              child: Icon(Icons.check, size: 12, color: salmonColor),
            ),
            const SizedBox(width: 20),
            Text(
              "Quiz $quizNumber",
              style: TextStyle(
                color: isCompleted ? Colors.white : salmonColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZoomListItem extends StatelessWidget {
  final int index;
  const ZoomListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    bool isOverdue = index == 0;
    final salmonColor = const Color(0xFFFF9494);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: salmonColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: salmonColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Discuss with mentor",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      "30 Juli 2024",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? const Color(0xFFFFF7D6)
                            : const Color.fromARGB(112, 255, 148, 148),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        isOverdue ? "Overdue" : "19.00-21.00 WIB",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isOverdue
                              ? const Color.fromARGB(255, 236, 142, 1)
                              : const Color.fromARGB(255, 169, 83, 83),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isOverdue)
            Icon(
              Icons.lock_rounded,
              color: salmonColor.withOpacity(0.5),
              size: 24,
            )
          else
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: salmonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                ),
                child: const Text(
                  "Join",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
