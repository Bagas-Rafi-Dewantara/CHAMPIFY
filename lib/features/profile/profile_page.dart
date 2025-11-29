import 'package:flutter/material.dart';

class ChampifyProfilePage extends StatelessWidget {
  const ChampifyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color peach = Color(0xFFFFE2D7);
    const Color peachDark = Color(0xFFF9B890);

    // ==== DUMMY DATA (nanti bisa dihubungkan ke backend/model) ====
    const String name = 'Divavor Permata';
    const String headline =
        'Information System | ITS | UI / UX Designer | Front End Developer';

    const String tagline =
        'Design thinker. Competition-driven learner. Passionate about turning ideas into winning products.';

    final List<String> skills = [
      'UI/UX Design',
      'Figma',
      'Design Thinking',
      'Wireframing',
      'Prototyping',
      'Presentation',
    ];

    final List<String> interests = [
      'UI Competition',
      'Business Case',
      'Product Design',
      'Startup',
      'Hackathon',
      'Public Speaking',
    ];

    const int coursesCompleted = 4;
    const int competitionsJoined = 5;
    const int mentoringSessions = 3;

    // Progress per course (0.0 - 1.0)
    final List<Map<String, dynamic>> courseProgress = [
      {
        'title': 'UI/UX Basics',
        'progress': 0.85,
      },
      {
        'title': 'Design Thinking for Product',
        'progress': 0.6,
      },
      {
        'title': 'Presentation & Storytelling',
        'progress': 0.4,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== HEADER =====
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleIconButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () {
                        Navigator.maybePop(context);
                      },
                    ),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings_outlined,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== KARTU GRADIENT + AVATAR =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFE2D7),
                            Color(0xFFFFF1E8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '100 Connection',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: peachDark,
                              width: 6,
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const ClipOval(
                            child: Image(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 90),

              // ===== KARTU INFO PROFIL =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.04),
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003049),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      headline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _pillButton('EDIT PROFILE'),
                        const SizedBox(width: 10),
                        _pillButton('SHARE PROFILE'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ===== TAGLINE =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6F1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 22,
                        color: Color(0xFFF7A15F),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tagline,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== ABOUT (DIPINDAH KE ATAS) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionCard(
                  title: 'About',
                  child: Text(
                    'Mahasiswa Sistem Informasi yang fokus di UI/UX dan pengembangan front-end. '
                        'Aktif mengikuti kompetisi desain dan business case, serta tertarik membangun platform '
                        'yang mendukung personal branding dan kolaborasi antar mahasiswa.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== SKILLS =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionCard(
                  title: 'Skills',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills
                        .map(
                          (skill) => Chip(
                        label: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: peach,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 0,
                        ),
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== PROGRESS (SUMMARY) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionCard(
                  title: 'Progress',
                  child: Row(
                    children: [
                      _progressItem(
                        label: 'Courses\nCompleted',
                        value: coursesCompleted.toString(),
                      ),
                      _verticalDivider(),
                      _progressItem(
                        label: 'Competitions\nJoined',
                        value: competitionsJoined.toString(),
                      ),
                      _verticalDivider(),
                      _progressItem(
                        label: 'Mentoring\nSessions',
                        value: mentoringSessions.toString(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== COURSE PROGRESS BAR CHART =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionCard(
                  title: 'Course Progress',
                  child: Column(
                    children: courseProgress.map((c) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _courseProgressBar(
                          title: c['title'] as String,
                          progress: c['progress'] as double,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== INTERESTS =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionCard(
                  title: 'Interests',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests
                        .map(
                          (interest) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ HELPER WIDGETS ============

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _pillButton(String label) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2D7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _progressItem({
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003049),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.shade300,
    );
  }

  Widget _courseProgressBar({
    required String title,
    required double progress, // 0.0 - 1.0
  }) {
    final double value = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // judul course + persentase
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(value * 100).round()}%',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // bar chart sederhana
        LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            return Stack(
              children: [
                // background bar
                Container(
                  height: 10,
                  width: maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                // filled bar
                Container(
                  height: 10,
                  width: maxWidth * value,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF9B890),
                        Color(0xFFF7A15F),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
