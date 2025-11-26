import 'package:flutter/material.dart';
import 'playlist_course.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool isAvailableSelected = true; // Default tab kiri aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pastikan background putih bersih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Course',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // --- HEADER TABS ---
            Row(
              children: [
                // Tab Available
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isAvailableSelected = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isAvailableSelected
                            ? const Color(0xFFC76D61)
                            : Colors.transparent,
                        border: Border.all(color: const Color(0xFFC76D61)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Available Course',
                          style: TextStyle(
                            color: isAvailableSelected
                                ? Colors.white
                                : const Color(0xFFC76D61),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Tab My Course
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isAvailableSelected = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isAvailableSelected
                            ? const Color(0xFFC76D61)
                            : Colors.transparent,
                        border: Border.all(color: const Color(0xFFC76D61)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'My Course',
                          style: TextStyle(
                            color: !isAvailableSelected
                                ? Colors.white
                                : const Color(0xFFC76D61),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- LOGIC GANTI KONTEN ---
            // Di sini kuncinya: Jika isAvailableSelected == true, tampilkan Grid.
            // Jika false, tampilkan List (desain lama).
            Expanded(
              child: isAvailableSelected
                  ? _buildAvailableCourseGrid() // Tampilan Baru (Grid)
                  : _buildMyCourseList(), // Tampilan Lama (List)
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET 1: Tampilan Available Course (Sesuai Gambar Grid)
  Widget _buildAvailableCourseGrid() {
    return GridView.builder(
      itemCount: 4, // Contoh ada 4 course
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 Kolom
        crossAxisSpacing: 15, // Jarak antar kolom
        mainAxisSpacing: 15, // Jarak antar baris
        childAspectRatio:
            0.75, // Perbandingan lebar:tinggi kartu (biar agak tinggi)
      ),
      itemBuilder: (context, index) {
        return const AvailableCourseCard();
      },
    );
  }

  // WIDGET 2: Tampilan My Course (Desain Lama)
  Widget _buildMyCourseList() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return const MyCourseCard();
      },
    );
  }
}

// --- DESAIN KARTU 1: AVAILABLE COURSE (KOTAK PUTIH KECIL) ---
class AvailableCourseCard extends StatelessWidget {
  const AvailableCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFE4DD),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BAGIAN GAMBAR (Tetap di atas)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.blueAccent,
                  child: const Icon(
                    Icons.bar_chart,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: -75,
                right: 0,
                // Wajib pakai IgnorePointer biar tombol di bawahnya bisa diklik
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/star-course.png',
                    width: 350,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // -------------------------
            ],
          ),

          // 2. BAGIAN KONTEN (Dibungkus Expanded)
          // Expanded bikin kolom ini tingginya "mentok" sampai bawah kartu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "UI/UX Masterclass for Competition 2025",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "(28 lessons)",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),

                  // 3. INI KUNCINYA: Spacer()
                  // Spacer bakal "makan" semua ruang kosong di tengah,
                  // sehingga widget di bawahnya (Row) kedorong mentok ke bawah.
                  const Spacer(),

                  // Row Waktu & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Chip Waktu
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4D8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 12,
                              color: Color(0xFF996457),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "6h 10min",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF996457),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Rating
                      Row(
                        children: const [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(
                            " 4.6",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- DESAIN KARTU 2: MY COURSE (KARTU ORANGE BESAR) ---
// Ini desain lama kamu, saya rename jadi MyCourseCard biar gak bingung
// GANTI SELURUH CLASS MyCourseCard DENGAN INI:

class MyCourseCard extends StatelessWidget {
  const MyCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 160,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAB9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // LAPISAN 1: TULISAN & TOMBOL
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 200,
                  child: Text(
                    'UI/UX Masterclass for Competition 2025',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D2D2D),
                      height: 1.2,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Logic pindah halaman
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaylistCoursePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D4F40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LAPISAN 2: GAMBAR MASCOT
          Positioned(
            bottom: -75,
            right: 0,
            // --- INI PERBAIKANNYA (Wajib Ada!) ---
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/star-course.png',
                width: 350,
                height: 350,
                fit: BoxFit.contain,
              ),
            ),
            // -------------------------------------
          ),
        ],
      ),
    );
  }
}
