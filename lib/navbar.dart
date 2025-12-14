import 'package:flutter/material.dart';

// Import halaman
import 'homepage.dart';
import 'course/courses.dart';
import 'competition.dart';
import 'settings.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  // Daftar Halaman (Search dihapus, Total 4 halaman)
  final List<Widget> _pages = [
    const HomePage(), // Index 0
    const CoursePage(), // Index 1
    const CompetitionListScreen(), // Index 2
    const SettingsPage(), // Index 3 (Halaman Settings Asli)
  ];

  void _onItemTapped(int index) {
    // LOGIKA STANDAR: Langsung ganti halaman di dalam Navbar
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Body menggunakan IndexedStack agar state halaman tersimpan
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // Navbar Custom
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F0),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 'Home', 0),
                _buildNavItem(Icons.play_circle_outline, 'Course', 1),
                _buildNavItem(Icons.emoji_events, 'Competition', 2),
                _buildNavItem(
                  Icons.settings,
                  'Setting',
                  3,
                ), // Sekarang akan membuka SettingsPage
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFE89B8E) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? const Color(0xFFE89B8E) : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
