import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Wajib Import Ini

// Import halaman-halaman kamu
import 'course/courses.dart';
import 'homepage.dart';
import 'mentoring.dart';
import 'competition.dart';

// 2. Ubah main() jadi async & Inisialisasi Supabase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // URL dan Key Project kamu (Tadi sudah benar)
    url: 'https://ritybflofnjeerbadjfp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpdHliZmxvZm5qZWVyYmFkamZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMzg3ODYsImV4cCI6MjA3OTcxNDc4Nn0.jjs1p3QuTgH0nFEYENbD1bbB9PfoMrQdV5L5P8D0NwI',
  );

  runApp(const MyApp());
}

// 3. Variabel Global biar bisa dipanggil di file lain (course.dart, dll)
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const MenuUtama(),
    );
  }
}

// Menu Utama (Kode UI kamu yang baru)
class MenuUtama extends StatelessWidget {
  const MenuUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aplikasi Belajar")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Selamat Datang!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ZoomMeetingScreen(),
                  ),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CoursePage()),
                );
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
                    builder: (context) => const CompetitionListScreen(),
                  ),
                );
              },
              child: const Text("Buka Competition"),
            ),
          ],
        ),
      ),
    );
  }
}
