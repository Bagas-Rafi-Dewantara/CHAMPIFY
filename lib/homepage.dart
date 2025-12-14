import 'package:flutter/material.dart';
import 'dart:async';
import 'mentoring.dart'; // Pastikan import ini benar

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
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
    });
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
      // HAPUS NAVBAR DARI SINI
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
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

                // 4. Courses Preview
                const Text(
                  'Courses',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildCoursesList(),
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

  // --- Widget Pecahan agar rapi ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text('Hello, ', style: TextStyle(fontSize: 24)),
                Text(
                  'Divavor Permata',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        const CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop',
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingMeeting() {
    return Container(
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
            ),
            child: const Text(
              'Join',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

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
                style: TextStyle(color: Colors.orange, fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFeatureItem(Icons.videocam, 'Zoom', const Color(0xFFE8C4A0)),
            _buildFeatureItem(
              Icons.play_circle,
              'Course',
              const Color(0xFFE8C4A0),
            ),
            _buildFeatureItem(Icons.article, 'Quiz', const Color(0xFFE8D4A0)),
            _buildFeatureItem(
              Icons.emoji_events,
              'Competition',
              const Color(0xFFE8E4A0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoursesList() {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCourseCard(
            'UI/UX Masterclass',
            '28 lessons',
            '6h 30min',
            '4.9',
            'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400&h=300&fit=crop',
            const Color(0xFFD8B4E8),
          ),
          const SizedBox(width: 16),
          _buildCourseCard(
            'Business Course',
            '28 lessons',
            '6h 10min',
            '4.8',
            'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&h=300&fit=crop',
            const Color(0xFF5B7FC4),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets (Sama seperti sebelumnya, disederhanakan) ---
  Widget _buildFeatureItem(IconData icon, String label, Color color) {
    return Column(
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
    );
  }

  Widget _buildCourseCard(
    String title,
    String lessons,
    String duration,
    String rating,
    String imageUrl,
    Color color,
  ) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 140,
              width: double.infinity,
              color: color,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  lessons,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionCarousel() {
    final List<Map<String, String>> competitions = [
      {
        'title': 'Inovatik Astratech',
        'status': 'Closed',
        'image':
            'https://images.unsplash.com/photo-1552664730-d307ca884978?w=800&h=500&fit=crop',
      },
      {
        'title': 'Essay HKI Budaya',
        'status': 'On Going',
        'image':
            'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800&h=500&fit=crop',
      },
      {
        'title': 'Design Competition',
        'status': 'Almost Over',
        'image':
            'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800&h=500&fit=crop',
      },
    ];
    return SizedBox(
      height: 320,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (p) => setState(() => _currentPage = p),
        itemCount: competitions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildCompetitionCard(
              competitions[index]['image']!,
              competitions[index]['title']!,
              competitions[index]['status']!,
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
        color: Colors.grey.shade200,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(imageUrl, fit: BoxFit.cover),
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
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
