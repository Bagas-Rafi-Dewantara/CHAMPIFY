import 'package:flutter/material.dart';

class MyCoursePlaylistPage extends StatefulWidget {
  const MyCoursePlaylistPage({super.key});

  @override
  State<MyCoursePlaylistPage> createState() => _MyCoursePlaylistPageState();
}

class _MyCoursePlaylistPageState extends State<MyCoursePlaylistPage> {
  // Simulasi progress video
  double _currentSliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. VIDEO PLAYER SECTION (Top - FIXED)
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                // Background Gradient
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9C88FF), Color(0xFFFF9494)],
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/header_bg.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),

                // Overlay Controls
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Playback Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFAB9F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Slider
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14,
                                ),
                                activeTrackColor: const Color(0xFFFF9494),
                                inactiveTrackColor: Colors.white.withOpacity(
                                  0.5,
                                ),
                                thumbColor: Colors.white,
                              ),
                              child: Slider(
                                value: _currentSliderValue,
                                max: 120,
                                onChanged: (value) {
                                  setState(() {
                                    _currentSliderValue = value;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.volume_up,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "00:50 / 02:00",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 15),
                                    Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                      size: 22,
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
              ],
            ),
          ),

          // 2. CONTENT SECTION (Bottom)
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === BAGIAN INI DIAM (FIXED) ===
                  // Karena dia di luar ListView/Expanded
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "UI/UX Design Introduction\npart 1",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE69E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Lesson 1",
                          style: TextStyle(
                            color: Color(0xFFC48B4A),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // === BAGIAN INI SCROLLABLE ===
                  // Header "Jump to..." masuk ke dalam ListView di bawah
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 20),
                      children: [
                        // Header "Jump to Another Lesson" (Sekarang ikut scroll)
                        const Text(
                          "Jump to Another Lesson",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // List Lessons
                        ...List.generate(10, (index) {
                          return LessonTile(isActive: index == 0);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Helper
class LessonTile extends StatelessWidget {
  final bool isActive;
  const LessonTile({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    const Color salmonColor = Color(0xFFFF9494);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: isActive ? salmonColor : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isActive
            ? null
            : Border.all(color: salmonColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: isActive
                  ? null
                  : Border.all(color: salmonColor, width: 1.5),
            ),
            child: Icon(Icons.play_arrow_rounded, color: salmonColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              "UI/UX Design Introduction",
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "02:00",
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
