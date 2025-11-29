import 'package:flutter/material.dart';

class DetailCoursePage extends StatefulWidget {
  const DetailCoursePage({super.key});

  @override
  State<DetailCoursePage> createState() => _DetailCoursePageState();
}

class _DetailCoursePageState extends State<DetailCoursePage> {
  // 0 = Lessons, 1 = Reviews, 2 = Package Details
  int _selectedTabIndex = 0;

  // Warna utama
  final Color primaryColor = const Color(0xFFFF9494);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.1),
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
        title: const Text(
          "Course Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.1),
              child: IconButton(
                icon: const Icon(
                  Icons.bookmark_border,
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. HERO IMAGE & PAGINATION
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C88FF), Color(0xFFFF9494)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFAB9F),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(false),
                _buildDot(true),
                _buildDot(false),
                _buildDot(false),
              ],
            ),

            const SizedBox(height: 20),

            // 2. JUDUL & INFO
            const Text(
              "UI/UX Masterclass for\nCompetition 2025",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                const Text("4h 15min", style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 10),
                const Icon(Icons.circle, size: 4, color: Colors.grey),
                const SizedBox(width: 10),
                const Text("10 lessons", style: TextStyle(color: Colors.grey)),
                const Spacer(),
                const Icon(Icons.star, size: 18, color: Colors.amber),
                const SizedBox(width: 5),
                const Text(
                  "4.9/5",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 3. MENTOR
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=11',
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Gibran Rakabuming",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "UI/UX Designer at IKN Nusantara",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.amber, size: 24),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "+15 UI/UX",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "Competitions",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 4. DESCRIPTION
            const Text(
              "Descriptions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Lorem ipsum dolor sit amet consectetur. Fusce mauris consectetur habitasse aliquam eu ante convallis eu. Sed odio ac euismod venenatis tortor eu risus et.",
              style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 13),
            ),

            const SizedBox(height: 25),

            // 5. TABS SELECTOR (Clickable)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTabItem("Lessons", 0),
                const SizedBox(width: 30),
                _buildTabItem("Reviews", 1),
                const SizedBox(width: 30),
                _buildTabItem("Package details", 2),
              ],
            ),
            const SizedBox(height: 20),

            // 6. DYNAMIC CONTENT (Switch based on Tab)
            if (_selectedTabIndex == 0) _buildLessonsList(),
            if (_selectedTabIndex == 1) _buildReviewsList(),
            if (_selectedTabIndex == 2) _buildPackageDetails(),

            // Space for Bottom Button
            const SizedBox(height: 130),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 140,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Premium Rp 150.000",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Regular Rp 100.000",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: CONTENT PER TAB ---

  // KONTEN 1: LESSONS
  Widget _buildLessonsList() {
    return Column(
      children: const [
        LessonItem(
          title: "UI/UX Design Introduction",
          duration: "02:00",
          isLocked: false,
        ),
        LessonItem(
          title: "UI/UX Design Introduction",
          duration: "02:00",
          isLocked: true,
        ),
        LessonItem(
          title: "UI/UX Design Introduction",
          duration: "02:00",
          isLocked: true,
        ),
        LessonItem(
          title: "UI/UX Design Introduction",
          duration: "02:00",
          isLocked: true,
        ),
        LessonItem(
          title: "UI/UX Design Introduction",
          duration: "02:00",
          isLocked: false,
        ),
      ],
    );
  }

  // KONTEN 2: REVIEWS (Sesuai Gambar)
  Widget _buildReviewsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Chips Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip("All Ratings", true),
              _buildFilterChip("★ 5", false),
              _buildFilterChip("★ 4", false),
              _buildFilterChip("★ 3", false),
              _buildFilterChip("★ 2", false),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Review Items
        const ReviewItem(
          name: "Abdul Rajan",
          role: "College Student at Iso Turu Sangar",
          comment: "Keren kelasnya, mentornya keren, ak mw jg kyk mentornya",
          rating: 5,
        ),
        const ReviewItem(
          name: "Abdul Rajan",
          role: "College Student at Iso Turu Sangar",
          comment: "Keren kelasnya, mentornya keren, ak mw jg kyk mentornya",
          rating: 5,
        ),
      ],
    );
  }

  // KONTEN 3: PACKAGE DETAILS (Sesuai Gambar)
  Widget _buildPackageDetails() {
    return Column(
      children: [
        // Regular Benefits Card (Kuning)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4).withOpacity(0.5), // Kuning pudar
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Regular Benefits",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 15),
              _buildBenefitItem("Lifetime Video Access"),
              _buildBenefitItem("Quiz Features"),
              _buildBenefitItem("Final Project for Portfolio"),
              _buildBenefitItem("E-Certificate of Completion"),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Premium Benefits Card (Orange Gradient like)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFCC80).withOpacity(0.3),
                const Color(0xFFFFAB91).withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Premium Benefits",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 15),
              _buildBenefitItem("All Benefits in Regular"),
              _buildBenefitItem("Exclusive Mentoring Once a Week"),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  // --- SMALL HELPERS ---

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF00C853),
            size: 20,
          ), // Hijau Centang
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFAB91) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFAB91), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFFFFAB91),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? const Color(0xFFFF9494)
                  : const Color(0xFFFFCCB6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          if (isActive)
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9494),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFF9494) : const Color(0xFFFFE4C7),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ==========================================
// WIDGET: LESSON ITEM
// ==========================================
class LessonItem extends StatelessWidget {
  final String title;
  final String duration;
  final bool isLocked;

  const LessonItem({
    super.key,
    required this.title,
    required this.duration,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    const Color salmonColor = Color(0xFFFF9494);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: salmonColor.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0xFFFFF0EB)
                  : const Color(0xFFFF9494).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLocked ? Icons.lock_rounded : Icons.play_arrow_rounded,
              color: isLocked ? const Color(0xFFFFCCB6) : salmonColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            duration,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// WIDGET BARU: REVIEW ITEM
// ==========================================
class ReviewItem extends StatelessWidget {
  final String name;
  final String role;
  final String comment;
  final int rating;

  const ReviewItem({
    super.key,
    required this.name,
    required this.role,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=12',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_rounded,
                size: 18,
                color: index < rating
                    ? const Color(0xFFFFD54F)
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
