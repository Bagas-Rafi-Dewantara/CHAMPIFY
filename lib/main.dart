import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // 1. Jangan lupa import ini
import 'course/courses.dart';
import 'course/playlist_course.dart';

void main() {
  runApp(const MyApp());
}

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

        // 2. TAMBAHKAN BARIS AJAIB INI:
        // Ini bikin semua teks di aplikasi otomatis jadi Poppins
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const CoursePage(),
    );
  }
}

// 3. Ini Halaman Depan (Landing Page)
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

            // 4. Ini Tombol untuk pindah halaman
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
                // LOGIKA PINDAH HALAMAN (ROUTING)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CoursePage()),
                );
              },
              child: const Text("Buka Course Page"),
            ),
          ],
        ),
      ),
    );
  }
}
