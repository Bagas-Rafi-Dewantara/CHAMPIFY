import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // Import package baru ini

// Import halaman (Pastikan path sesuai)
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

  // Daftar Halaman
  final List<Widget> _pages = [
    const HomePage(),
    const CoursePage(),
    const CompetitionListScreen(),
    const SettingsPage(),
  ];

  // Warna tema kamu
  final Color _themeColor = const Color(0xFFE89B8E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // Lebih membulat
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // Margin luarnya dikecilin biar bar-nya lebih lebar & muat banyak
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),

        child: Padding(
          // Padding container diperkecil
          padding: const EdgeInsets.all(5),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 4, // Jarak icon ke text didempetin dikit
            activeColor: Colors.white,
            iconSize:27,

            // INI KUNCINYA: Padding dalam tombol dikurangi drastis (tadi 20, skrg 10)
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: _themeColor,
            color: Colors.grey[500],

            tabs: const [
              GButton(icon: Icons.home_rounded, text: 'Home'),
              GButton(icon: Icons.play_circle_fill_rounded, text: 'Course'),
              GButton(
                icon: Icons.emoji_events_rounded,
                text: 'Competition', // Teks dipendekin dikit
              ),
              GButton(icon: Icons.settings_rounded, text: 'Setting'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
