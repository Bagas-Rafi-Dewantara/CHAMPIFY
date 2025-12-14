import 'package:flutter/material.dart';
import 'mycourse_playlist.dart';
import 'mycourse_quiz.dart';

class PlaylistCoursePage extends StatefulWidget {
  const PlaylistCoursePage({super.key});

  @override
  State<PlaylistCoursePage> createState() => _PlaylistCoursePageState();
}

class _PlaylistCoursePageState extends State<PlaylistCoursePage> {
  // 0 = Playlist, 1 = Quiz, 2 = Zoom
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND HEADER IMAGE
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
                    // Header Buttons (Back only)
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

          // 2. WHITE SHEET CONTENT
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
                    // Title
                    const Text(
                      "UI/UX Masterclass for\nCompetition 2025",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tabs
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

                    // CONTENT LIST
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        // Logic jumlah item: Playlist(6), Quiz(3), Zoom(3)
                        itemCount: selectedTabIndex == 0 ? 6 : 3,
                        itemBuilder: (context, index) {
                          if (selectedTabIndex == 0) {
                            return const PlaylistItem();
                          } else if (selectedTabIndex == 1) {
                            return QuizListItem(quizNumber: index + 1);
                          } else {
                            // Tampilan Zoom
                            return ZoomListItem(index: index);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          // GANTI DI SINI: Pakai warna Pink Muda (Light Salmon) biar seragam
          color: isActive ? const Color(0xFFFFE0E0) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // GANTI DI SINI: Teks jadi Pink Tua (Primary Salmon)
            color: isActive ? const Color(0xFFFF9494) : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET BARU: ZOOM ITEM
// ==========================================
class ZoomListItem extends StatelessWidget {
  final int index;
  const ZoomListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // Simulasi: Item pertama (index 0) itu Overdue/Lock
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
          // 1. Icon Video
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

          // 2. Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Discuss with mentor",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      "30 Juli 2024",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 7),
                    // Badge (Overdue or Time)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? const Color(0xFFFFF7D6)
                            : const Color.fromARGB(
                                112,
                                255,
                                148,
                                148,
                              ), // Kuning vs Salmon
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

          // 3. Right Action (Lock or Join Button)
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
                  // 1. KECILIN PADDING (biar ga kembung)
                  padding: const EdgeInsets.symmetric(horizontal: 15),

                  // 2. TAMBAH INI (biar tombol nurut sama padding, ga dipaksa lebar default)
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

// ==========================================
// WIDGET HELPER LAINNYA
// ==========================================

class QuizListItem extends StatelessWidget {
  final int quizNumber;
  const QuizListItem({super.key, required this.quizNumber});

  @override
  Widget build(BuildContext context) {
    // Logic sederhana: Hanya Quiz 1 (quizNumber == 1) yang bisa diklik / aktif
    final bool isCompleted = quizNumber == 1;
    final Color salmonColor = const Color(0xFFFFA08A);

    return GestureDetector(
      onTap: () {
        // Hanya bisa diklik kalau quiznya aktif (isCompleted true di logic ini)
        if (isCompleted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyCourseQuizPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Finish the previous quiz first!"),
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

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail video (MyCoursePlaylistPage)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyCoursePlaylistPage()),
        );
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "UI/UX Design Introduction",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Text(
              "02:00",
              style: TextStyle(
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
