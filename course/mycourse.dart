import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'mycourse_playlist.dart';

// ==========================================
// 1. KARTU MY COURSE
// ==========================================
class MyCourseCard extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final bool isDark;

  const MyCourseCard({
    super.key, 
    required this.courseData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCoursePlaylistPage(
              courseData: courseData,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 160,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isDark 
              ? const Color(0xFF2D2D2D) 
              : const Color(0xFFFFDAB9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Gambar bintang dengan opacity berbeda untuk dark mode
            Positioned(
              bottom: -75,
              right: 0,
              child: IgnorePointer(
                child: Opacity(
                  opacity: isDark ? 0.3 : 0.9,
                  child: Image.asset(
                    'assets/images/star-course.png',
                    width: 350,
                    height: 350,
                    fit: BoxFit.contain,
                    color: isDark ? Colors.white : null,
                    colorBlendMode: isDark ? BlendMode.modulate : null,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      courseData['nama_course'] ?? 'Judul Course',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF2D2D2D),
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
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark 
                          ? const Color(0xFFE89B8E) 
                          : const Color(0xFF8D4F40),
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
// 2. HALAMAN DETAIL PLAYLIST
// ==========================================
class PlaylistCoursePage extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const PlaylistCoursePage({super.key, required this.courseData});

  @override
  State<PlaylistCoursePage> createState() => _PlaylistCoursePageState();
}

class _PlaylistCoursePageState extends State<PlaylistCoursePage> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final String courseTitle = widget.courseData['nama_course'] ?? 'Course';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                    ? [
                        const Color(0xFF6B4F9C), 
                        const Color(0xFFE89B8E),
                      ]
                    : [
                        const Color(0xFF9C88FF), 
                        const Color(0xFFFF9494),
                      ],
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
                              color: Colors.white,
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

          // White/Dark Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseTitle,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tab Switcher
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isDark 
                            ? const Color(0xFF2D2D2D) 
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTabItem("Playlist", 0, isDark),
                          _buildTabItem("Quiz", 1, isDark),
                          _buildTabItem("Zoom", 2, isDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(child: _buildContentList(isDark)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList(bool isDark) {
    if (selectedTabIndex == 0) {
      // Playlist
      final List<dynamic> playlist = widget.courseData['playlist'] ?? [];
      playlist.sort(
        (a, b) =>
            (a['nomor_playlist'] ?? 0).compareTo(b['nomor_playlist'] ?? 0),
      );

      if (playlist.isEmpty) {
        return Center(
          child: Text(
            "Belum ada materi video.",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        );
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
            isDark: isDark,
          );
        },
      );
    } else if (selectedTabIndex == 1) {
      // Quiz
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: 3,
        itemBuilder: (context, index) {
          return QuizListItem(quizNumber: index + 1, isDark: isDark);
        },
      );
    } else {
      // Zoom
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: 2,
        itemBuilder: (context, index) {
          return ZoomListItem(index: index, isDark: isDark);
        },
      );
    }
  }

  Widget _buildTabItem(String title, int index, bool isDark) {
    bool isActive = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: isActive 
              ? (isDark ? const Color(0xFF3D3D3D) : const Color(0xFFFFE0E0))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive 
                ? const Color(0xFFFF9494) 
                : (isDark ? Colors.grey[500] : Colors.grey),
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
  final bool isDark;

  const PlaylistItem({
    super.key,
    required this.title,
    required this.duration,
    this.linkVideo,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark 
                ? Colors.grey[700]! 
                : const Color(0xFFFF9494).withOpacity(0.5),
          ),
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
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey[400] : Colors.grey,
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
  final bool isDark;
  
  const QuizListItem({
    super.key, 
    required this.quizNumber,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = quizNumber == 1;
    final Color salmonColor = const Color(0xFFFFA08A);

    return GestureDetector(
      onTap: () {
        if (!isCompleted) {
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
          color: isCompleted 
              ? salmonColor 
              : (isDark ? const Color(0xFF2D2D2D) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: salmonColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isCompleted 
                    ? Colors.white 
                    : Colors.transparent,
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
                color: isCompleted 
                    ? Colors.white 
                    : (isDark ? Colors.white : salmonColor),
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
  final bool isDark;
  
  const ZoomListItem({
    super.key, 
    required this.index,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    bool isOverdue = index == 0;
    final salmonColor = const Color(0xFFFF9494);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark 
              ? Colors.grey[700]! 
              : salmonColor.withOpacity(0.5),
          width: 1,
        ),
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
                Text(
                  "Discuss with mentor",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "30 Juli 2024",
                      style: TextStyle(
                        fontSize: 12, 
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
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