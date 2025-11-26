import 'package:flutter/material.dart';

class PlaylistCoursePage extends StatefulWidget {
  const PlaylistCoursePage({super.key});

  @override
  State<PlaylistCoursePage> createState() => _PlaylistCoursePageState();
}

class _PlaylistCoursePageState extends State<PlaylistCoursePage> {
  // Biar nanti bisa ganti tab, kita siapin variable-nya
  int selectedTabIndex = 0; // 0 = Playlist, 1 = Quiz, 2 = Project

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
              // Ganti gradient ini dengan Image.asset kamu nanti
              // image: DecorationImage(image: AssetImage('assets/images/header_bg.png'), fit: BoxFit.cover),
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
                    // Header Buttons (Back & Bookmark)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tombol Back
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
                        // Tombol Bookmark
                        CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: IconButton(
                            icon: const Icon(
                              Icons.bookmark_border,
                              size: 20,
                              color: Colors.black,
                            ),
                            onPressed: () {},
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
          // Menggunakan DraggableScrollableSheet atau sekedar Container dengan Margin top
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.75, // Tinggi putih 75% layar
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

                    // Tabs (Playlist, Quiz, Project)
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
                          _buildTabItem("Project", 2),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LIST VIDEO (Scrollable)
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          bottom: 100,
                        ), // Padding bawah biar ga ketutup tombol
                        itemCount: 6, // Contoh ada 6 video
                        itemBuilder: (context, index) {
                          return const PlaylistItem();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. FLOATING BUTTON "Start Learning"
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9494), // Warna Salmon/Pink
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 5,
                shadowColor: const Color(0xFFFF9494).withOpacity(0.5),
              ),
              child: const Text(
                'Start Learning',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Tab
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
          color: isActive
              ? const Color(0xFFFFE4C7)
              : Colors.transparent, // Kuning muda kalau aktif
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFF8D4F40) : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// Widget Helper untuk Item Video Playlist
class PlaylistItem extends StatelessWidget {
  const PlaylistItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFFF9494).withOpacity(0.5),
        ), // Border tipis merah muda
      ),
      child: Row(
        children: [
          // Icon Play Bulat
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
          // Judul Video
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "UI/UX Design Introduction",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
          // Durasi
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
    );
  }
}
