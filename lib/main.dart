import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import halaman-halaman
import 'authentication/signup.dart';
import 'authentication/login.dart';
import 'mentoring.dart';
import 'course/courses.dart';
import 'homepage.dart';
import 'competition.dart';
import 'settings.dart';

// 1. Setup Main jadi Async untuk inisialisasi Supabase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ritybflofnjeerbadjfp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpdHliZmxvZm5qZWVyYmFkamZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMzg3ODYsImV4cCI6MjA3OTcxNDc4Nn0.jjs1p3QuTgH0nFEYENbD1bbB9PfoMrQdV5L5P8D0NwI',
  );

  runApp(const MyApp());
}

// 2. Variabel Global Supabase
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Champify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      // Halaman awal ke MenuUtama
      home: const MenuUtama(),

      // Routes
      routes: {
        '/signup': (context) => const SignUpFormPage(),
        '/login': (context) => const LoginPage(),
        '/mentoring': (context) => const ZoomMeetingScreen(),
        '/courses': (context) => const CoursePage(),
      },
    );
  }
}

// 3. Menu Utama
class MenuUtama extends StatelessWidget {
  const MenuUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Debugging / Navigasi"),
        backgroundColor: Colors.brown[100],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Pilih Halaman:"),
              const SizedBox(height: 20),

              // Tombol ke Homepage
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text("Buka Homepage"),
              ),

              const SizedBox(height: 15),

              // Tombol ke Mentoring
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89B8E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/mentoring');
                },
                child: const Text("Buka Mentoring"),
              ),

              const SizedBox(height: 15),

              // Tombol ke Course Page
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/courses');
                },
                child: const Text("Buka Course Page"),
              ),

              const SizedBox(height: 15),

              // Tombol ke Competition
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CompetitionListScreen()),
                  );
                },
                child: const Text("Buka Competition"),
              ),
              
              const SizedBox(height: 15),
              
              // ← TOMBOL BARU: KE SETTINGS
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89B8E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                child: const Text("Buka Settings"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}