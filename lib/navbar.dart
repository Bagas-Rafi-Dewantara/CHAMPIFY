import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart'; 

// Import halaman
import 'homepage.dart';
import 'course/courses.dart';
import 'competition.dart';
import 'settings.dart';
import 'theme_provider.dart';

class Navbar extends StatefulWidget {
  final int initialIndex;
  final bool initialSelectMyCourse;
  const Navbar({
    super.key,
    this.initialIndex = 0,
    this.initialSelectMyCourse = false,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  bool _handledInitialArgs = false;
  bool _courseOpenMyCourse = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _courseOpenMyCourse = widget.initialSelectMyCourse;
  }

  final Color _themeColor = const Color(0xFFE89B8E);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledInitialArgs) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      final bool selectMyCourse = args['selectMyCourse'] == true;
      final dynamic initialTab = args['initialTab'];
      final bool goToMyCourse = selectMyCourse || initialTab == 'MyCourse';
      if (goToMyCourse) {
        setState(() {
          _selectedIndex = 1;
          _courseOpenMyCourse = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _courseOpenMyCourse = false);
          }
        });
      }
    }

    _handledInitialArgs = true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Stack(
        children: [
          [
            const HomePage(),
            CoursePage(initialSelectMyCourse: _courseOpenMyCourse),
            const CompetitionListScreen(),
            const SettingsPage(),
          ][_selectedIndex],

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: isDark 
                  ? []
                  : [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, -5),
                      ),
                    ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: GNav(
                  rippleColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  hoverColor: isDark ? Colors.grey[900]! : Colors.grey[100]!,
                  gap: 4,
                  activeColor: Colors.white,
                  iconSize: 27,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: _themeColor,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  tabs: const [
                    GButton(
                      icon: Icons.home_rounded, 
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.play_circle_fill_rounded,
                      text: 'Course',
                    ),
                    GButton(
                      icon: Icons.emoji_events_rounded,
                      text: 'Competition',
                    ),
                    GButton(
                      icon: Icons.settings_rounded, 
                      text: 'Settings',
                    ),
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
          ),
        ],
      ),
    );
  }
}
