import 'package:flutter/material.dart';

class RecommendationSettingsPage extends StatefulWidget {
  const RecommendationSettingsPage({Key? key}) : super(key: key);

  @override
  State<RecommendationSettingsPage> createState() =>
      _RecommendationSettingsPageState();
}

class _RecommendationSettingsPageState
    extends State<RecommendationSettingsPage> {
  // State untuk toggle switches
  bool showCourseRecommendations = true;
  bool showCompetitionRecommendations = true;
  bool showMentoringRecommendations = true;
  bool personalizedRecommendations = true;
  bool trendingContent = true;
  bool newContent = true;

  // State untuk kategori yang dipilih
  Set<String> selectedCategories = {'Matematika', 'Fisika', 'Teknologi'};

  final List<String> availableCategories = [
    'Matematika',
    'Fisika',
    'Kimia',
    'Biologi',
    'Teknologi',
    'Pemrograman',
    'Desain',
    'Bahasa',
    'Bisnis',
    'Keuangan',
  ];

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
          'Rekomendasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE89B8E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE89B8E).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFFE89B8E),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Atur preferensi konten rekomendasi sesuai minat Anda',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Tipe Konten Section
              const Text(
                'Tipe Konten',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.school_outlined,
                      title: 'Rekomendasi Kursus',
                      subtitle: 'Tampilkan kursus yang mungkin Anda suka',
                      value: showCourseRecommendations,
                      onChanged: (value) {
                        setState(() {
                          showCourseRecommendations = value;
                        });
                      },
                      isFirst: true,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.emoji_events_outlined,
                      title: 'Rekomendasi Kompetisi',
                      subtitle: 'Tampilkan kompetisi yang sesuai',
                      value: showCompetitionRecommendations,
                      onChanged: (value) {
                        setState(() {
                          showCompetitionRecommendations = value;
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.people_outline,
                      title: 'Rekomendasi Mentoring',
                      subtitle: 'Tampilkan mentor yang cocok',
                      value: showMentoringRecommendations,
                      onChanged: (value) {
                        setState(() {
                          showMentoringRecommendations = value;
                        });
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Personalisasi Section
              const Text(
                'Personalisasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.person_outline,
                      title: 'Rekomendasi Personal',
                      subtitle: 'Berdasarkan aktivitas dan preferensi Anda',
                      value: personalizedRecommendations,
                      onChanged: (value) {
                        setState(() {
                          personalizedRecommendations = value;
                        });
                      },
                      isFirst: true,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.trending_up,
                      title: 'Konten Trending',
                      subtitle: 'Tampilkan konten yang sedang populer',
                      value: trendingContent,
                      onChanged: (value) {
                        setState(() {
                          trendingContent = value;
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.new_releases_outlined,
                      title: 'Konten Terbaru',
                      subtitle: 'Tampilkan konten yang baru ditambahkan',
                      value: newContent,
                      onChanged: (value) {
                        setState(() {
                          newContent = value;
                        });
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Kategori Minat Section
              const Text(
                'Kategori Minat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Pilih kategori yang Anda minati',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: availableCategories.map((category) {
                    final isSelected = selectedCategories.contains(category);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedCategories.remove(category);
                          } else {
                            selectedCategories.add(category);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE89B8E)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE89B8E)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 30),

              // Reset Button
              GestureDetector(
                onTap: () {
                  _showResetDialog();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE89B8E),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Reset ke Pengaturan Default',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE89B8E),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Save Button
              GestureDetector(
                onTap: () {
                  _saveSettings();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE89B8E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Simpan Pengaturan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 12 : 12,
        bottom: isLast ? 12 : 12,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFE89B8E),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Reset Pengaturan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Apakah Anda yakin ingin mereset semua pengaturan rekomendasi ke default?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Reset semua ke default
                  showCourseRecommendations = true;
                  showCompetitionRecommendations = true;
                  showMentoringRecommendations = true;
                  personalizedRecommendations = true;
                  trendingContent = true;
                  newContent = true;
                  selectedCategories = {'Matematika', 'Fisika', 'Teknologi'};
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan telah direset'),
                    backgroundColor: Color(0xFFE89B8E),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: Color(0xFFE89B8E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveSettings() {
    // Di sini Anda bisa menambahkan logika untuk menyimpan pengaturan
    // Misalnya ke SharedPreferences atau database

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('Pengaturan berhasil disimpan!'),
          ],
        ),
        backgroundColor: const Color(0xFFE89B8E),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Optional: Kembali ke halaman settings setelah 1 detik
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
