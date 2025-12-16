import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'theme_provider.dart';

class RecommendationSettingsPage extends StatefulWidget {
  const RecommendationSettingsPage({super.key});

  @override
  State<RecommendationSettingsPage> createState() =>
      _RecommendationSettingsPageState();
}

class _RecommendationSettingsPageState
    extends State<RecommendationSettingsPage> {
  bool _loading = true;
  bool _saving = false;

  bool showCourseRecommendations = true;
  bool showCompetitionRecommendations = true;
  bool showMentoringRecommendations = true;
  bool personalizedRecommendations = true;
  bool trendingContent = true;
  bool newContent = true;

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
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    final meta = user.userMetadata ?? {};
    final existing = meta['recommendation_settings'];

    if (existing is Map) {
      setState(() {
        showCourseRecommendations = existing['show_course'] as bool? ?? true;
        showCompetitionRecommendations =
            existing['show_competition'] as bool? ?? true;
        showMentoringRecommendations =
            existing['show_mentoring'] as bool? ?? true;
        personalizedRecommendations = existing['personalized'] as bool? ?? true;
        trendingContent = existing['trending'] as bool? ?? true;
        newContent = existing['new_content'] as bool? ?? true;
        final categories = existing['categories'];
        if (categories is List) {
          selectedCategories = categories.whereType<String>().toSet();
        }
      });
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rekomendasi',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: _loading ? const NeverScrollableScrollPhysics() : null,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_loading)
                const LinearProgressIndicator(
                  color: Color(0xFFE89B8E),
                  minHeight: 2,
                ),
              if (_loading) const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE89B8E).withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE89B8E).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFFE89B8E), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Atur preferensi konten rekomendasi sesuai minat Anda',
                        style: TextStyle(
                          fontSize: 14, 
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Tipe Konten',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.school_outlined,
                      title: 'Rekomendasi Kursus',
                      subtitle: 'Tampilkan kursus yang mungkin Anda suka',
                      value: showCourseRecommendations,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() => showCourseRecommendations = value);
                      },
                      isFirst: true,
                    ),
                    Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : null),
                    _buildToggleItem(
                      icon: Icons.emoji_events_outlined,
                      title: 'Rekomendasi Kompetisi',
                      subtitle: 'Tampilkan kompetisi yang sesuai',
                      value: showCompetitionRecommendations,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() => showCompetitionRecommendations = value);
                      },
                    ),
                    Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : null),
                    _buildToggleItem(
                      icon: Icons.people_outline,
                      title: 'Rekomendasi Mentoring',
                      subtitle: 'Tampilkan mentor yang cocok',
                      value: showMentoringRecommendations,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() => showMentoringRecommendations = value);
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Personalisasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.person_outline,
                      title: 'Rekomendasi Personal',
                      subtitle: 'Berdasarkan aktivitas dan preferensi Anda',
                      value: personalizedRecommendations,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() => personalizedRecommendations = value);
                      },
                      isFirst: true,
                    ),
                    Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : null),
                    _buildToggleItem(
                      icon: Icons.trending_up,
                      title: 'Konten Trending',
                      subtitle: 'Tampilkan konten yang sedang populer',
                      value: trendingContent,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() => trendingContent = value);
                      },
                    ),
                    Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : null),
                    _buildToggleItem(
                      icon: Icons.new_releases_outlined,
                      title: 'Konten Terbaru',
                      subtitle: 'Tampilkan konten yang baru ditambahkan',
                      value: newContent,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() => newContent = value);
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Kategori Minat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Pilih kategori yang Anda minati',
                style: TextStyle(
                  fontSize: 14, 
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
                              : (isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5)),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE89B8E)
                                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
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
                                    : (isDark ? Colors.white : Colors.black87),
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

              GestureDetector(
                onTap: () {
                  if (_saving) return;
                  _showResetDialog(isDark);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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

              GestureDetector(
                onTap: () {
                  if (_saving) return;
                  _saveSettings();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE89B8E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
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
    required bool isDark,
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
          Icon(icon, color: isDark ? Colors.white70 : Colors.black87, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13, 
                    color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFFE89B8E),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  void _showResetDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Reset Pengaturan',
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin mereset semua pengaturan rekomendasi ke default?',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[300] : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal', 
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
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

  Future<void> _saveSettings() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login untuk menyimpan pengaturan'),
          backgroundColor: Color(0xFFE89B8E),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final payload = {
      'show_course': showCourseRecommendations,
      'show_competition': showCompetitionRecommendations,
      'show_mentoring': showMentoringRecommendations,
      'personalized': personalizedRecommendations,
      'trending': trendingContent,
      'new_content': newContent,
      'categories': selectedCategories.toList(),
    };

    final updatedMeta = {
      ...(user.userMetadata ?? {}),
      'recommendation_settings': payload,
    };

    try {
      await supabase.auth.updateUser(UserAttributes(data: updatedMeta));
      await supabase.auth.refreshSession();

      if (!mounted) return;

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pop(context, payload);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}