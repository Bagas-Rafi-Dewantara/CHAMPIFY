import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import pages
import 'authentication/signup.dart';
import 'authentication/login.dart';
import 'mentoring.dart';
import 'course/courses.dart';
// import 'course/playlist_course.dart'; // Un-comment jika dipakai
import 'homepage.dart';
import 'competition.dart'; 

void main() {
  runApp(const MyApp());
}

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
      // Set halaman awal ke MenuUtama
      home: const MenuUtama(),
      
      // Routes dari branch 'nat' dipindah ke sini (MaterialApp)
      routes: {
        '/signup': (context) => const SignUpFormPage(),
        '/login': (context) => const LoginPage(),
        '/mentoring': (context) => const ZoomMeetingScreen(),
        '/courses': (context) => const CoursePage(),
      },
    );
  }
}

// Menu Utama diperbaiki strukturnya (pakai Scaffold)
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
        child: SingleChildScrollView( // Biar bisa discroll kalau HP kecil
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
                  // Bisa pakai push manual atau pushNamed karena routes sudah didaftarkan
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
                    MaterialPageRoute(builder: (context) => const CompetitionListScreen()),
                  );
                },
                child: const Text("Buka Competition"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}