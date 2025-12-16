import 'package:flutter/material.dart';
import 'login.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E4), // Light Hover (rgb(255, 246, 244))
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF734B41)), // Dark Active (rgb(115, 75, 65))
        title: const Text(
          'Verifikasi Email',
          style: TextStyle(
            color: Color(0xFF734B41), // Dark Active (rgb(115, 75, 65))
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar bintang di tengah
            Image.asset(
              'assets/images/starsignup.png', // Pastikan path file sesuai dengan lokasi di folder assets/images
             height: 300, // Ubah ukuran tinggi gambar untuk memperbesar
  width: 300,  
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24), // Space antara gambar dan teks
            const Text(
              'Please Kindly Verify Your Email Address',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18, 
                color: Color(0xFFB57D6D), // Dark (rgb(191, 125, 109))
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Arahkan pengguna ke halaman login setelah verifikasi selesai
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFAA791), // Normal (rgb(255, 167, 145))
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Sudah Verifikasi',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF734B41), // Dark Active (rgb(115, 75, 65))
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}