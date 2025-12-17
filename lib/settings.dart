import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recommendation_settings.dart';
import 'notification_settings.dart';
import 'terms_conditions.dart';
import 'privacy_policy.dart';
import 'profile_page.dart';
import 'main.dart';
import 'theme_provider.dart';
import 'authentication/login.dart' show LoginPage;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _displayName = 'Pengguna';
  String _email = '';
  String? _avatarUrl;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final metaName = user.userMetadata?['full_name'] as String?;
    debugPrint('⚙️ Settings loading profile - Metadata name: $metaName');

    setState(() {
      _displayName = metaName ?? user.email?.split('@').first ?? 'Pengguna';
      _email = user.email ?? '';
      _avatarUrl = user.userMetadata?['avatar_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    const baseBottomGap = 100.0;
    final scrollBottomPadding = baseBottomGap + bottomInset;
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    final contentItems = [
      _SettingItem(
        title: 'Rekomendasi',
        icon: Icons.wb_incandescent_outlined,
        section: 'Kelola Konten',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RecommendationSettingsPage(),
            ),
          ).then((_) async {
            await supabase.auth.refreshSession();
            _loadProfile();
          });
        },
      ),
      _SettingItem(
        title: 'Notifikasi',
        icon: Icons.notifications_outlined,
        section: 'Kelola Konten',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationSettingsPage(),
            ),
          ).then((_) async {
            await supabase.auth.refreshSession();
            _loadProfile();
          });
        },
      ),
      _SettingItem(
        title: 'Syarat & Ketentuan',
        icon: Icons.description_outlined,
        section: 'Kelola Konten',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TermsConditionsPage(),
            ),
          );
        },
      ),
      _SettingItem(
        title: 'Kebijakan Privasi',
        icon: Icons.shield_outlined,
        section: 'Kelola Konten',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
          );
        },
      ),
    ];

    final optionItems = [
      _SettingItem(
        title: 'Bahasa',
        icon: Icons.language,
        section: 'Pilihan',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Indonesia',
              style: TextStyle(
                fontSize: 14, 
                color: isDark ? Colors.grey[400] : Colors.black
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
        onTap: _showLanguageComingSoon,
      ),
      
      _SettingItem(
        title: 'Mode Gelap',
        icon: isDark ? Icons.dark_mode : Icons.light_mode,
        section: 'Pilihan',
        trailing: Switch(
          value: isDark,
          onChanged: (value) async {
            await themeProvider.toggleTheme();
          },
          activeColor: const Color(0xFFE89B8E),
        ),
        onTap: () async {
          await themeProvider.toggleTheme();
        },
      ),
    ];

    final allItems = [...contentItems, ...optionItems];
    final filteredItems = _searchQuery.trim().isEmpty
        ? <_SettingItem>[]
        : allItems
              .where(
                (item) => item.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: scrollBottomPadding),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: isDark 
                      ? const Color(0xFF1E1E1E) 
                      : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // PROFILE SECTION
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                  // Force refresh auth session dan reload profile
                  await supabase.auth.refreshSession();
                  if (mounted) {
                    _loadProfile();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isDark 
                        ? null 
                        : Border.all(color: Colors.grey.shade200, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _avatarUrl != null
                            ? NetworkImage(_avatarUrl!)
                            : null,
                        child: _avatarUrl == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email.isEmpty ? 'Lengkapi email Anda' : _email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              if (_searchQuery.isEmpty) ...[
                // Kelola Konten Section
                Text(
                  'Kelola Konten',
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
                    border: isDark 
                        ? null 
                        : Border.all(color: Colors.grey.shade200, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(contentItems.length, (index) {
                      final item = contentItems[index];
                      return _buildMenuItemInContainer(
                        icon: item.icon,
                        title: item.title,
                        isFirst: index == 0,
                        isLast: index == contentItems.length - 1,
                        onTap: item.onTap,
                        isDark: isDark,
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 30),

                // Pilihan Section
                Text(
                  'Pilihan',
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
                    border: isDark 
                        ? null 
                        : Border.all(color: Colors.grey.shade200, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(optionItems.length, (index) {
                      final item = optionItems[index];
                      return _buildMenuItemInContainer(
                        icon: item.icon,
                        title: item.title,
                        isFirst: index == 0,
                        isLast: index == optionItems.length - 1,
                        trailing: item.trailing,
                        onTap: item.onTap,
                        isDark: isDark,
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 20),
              ] else ...[
                Text(
                  'Hasil Pencarian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                if (filteredItems.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isDark 
                          ? null 
                          : Border.all(color: Colors.grey.shade200, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                              ? Colors.black.withOpacity(0.3)
                              : Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Tidak ada hasil yang cocok.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isDark 
                          ? null 
                          : Border.all(color: Colors.grey.shade200, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                              ? Colors.black.withOpacity(0.3)
                              : Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(filteredItems.length, (index) {
                        final item = filteredItems[index];
                        return _buildMenuItemInContainer(
                          icon: item.icon,
                          title: item.title,
                          isFirst: index == 0,
                          isLast: index == filteredItems.length - 1,
                          trailing: item.trailing,
                          onTap: item.onTap,
                          isDark: isDark,
                        );
                      }),
                    ),
                  ),

                const SizedBox(height: 20),
              ],

              // Log Out Button
              GestureDetector(
                onTap: () async {
                  await supabase.auth.signOut();
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (_) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red, width: 1.5),
                    boxShadow: isDark 
                        ? null 
                        : [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: const Center(
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageComingSoon() {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.language,
                  size: 64,
                  color: Color(0xFFE89B8E),
                ),
                const SizedBox(height: 16),
                Text(
                  'Coming Soon!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Fitur multi-bahasa akan segera hadir.\nSaat ini hanya tersedia dalam Bahasa Indonesia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE89B8E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'OK',
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
          ),
        );
      },
    );
  }

  Widget _buildMenuItemInContainer({
    required IconData icon,
    required String title,
    required bool isFirst,
    required bool isLast,
    Widget? trailing,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white70 : Colors.black87,
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? Colors.white38 : Colors.grey,
                ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem {
  final String title;
  final IconData icon;
  final String section;
  final Widget? trailing;
  final VoidCallback onTap;

  _SettingItem({
    required this.title,
    required this.icon,
    required this.section,
    required this.onTap,
    this.trailing,
  });
}
