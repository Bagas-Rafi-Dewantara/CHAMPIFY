import 'package:flutter/material.dart';
import 'signup2.dart';

class SignUpFormPage extends StatefulWidget {
  const SignUpFormPage({super.key});

  @override
  State<SignUpFormPage> createState() => _SignUpFormPageState();
}

class _SignUpFormPageState extends State<SignUpFormPage> {
  final _fullnameController = TextEditingController();
  final _majorController = TextEditingController();
  final _universityController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _majorController.dispose();
    _universityController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC), // Warna latar belakang
      body: SafeArea(
        child: Column(
          children: [
            // Back Button di kanan atas
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFC4B0A0), // Border warna krem
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, color: Color(0xFFE8A87C)), // Icon warna lebih gelap
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Tulisan "Please complete the field below" dalam dua baris
                    const Text(
                      'Please complete \nthe field below',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black87,
                        height: 1.5, // Menambah jarak di antara baris teks
                      ),
                    ),
                    const SizedBox(height: 120), // Tambahkan jarak agar field turun ke bawah
                    _buildField(_fullnameController, 'Fullname'),
                    const SizedBox(height: 24), // Tambahkan jarak antar field
                    _buildField(_majorController, 'Major'),
                    const SizedBox(height: 24), // Tambahkan jarak antar field
                    _buildField(_universityController, 'University'),
                    const SizedBox(height: 24), // Tambahkan jarak antar field
                    _buildField(_numberController, 'Number', keyboardType: TextInputType.phone),
                    const SizedBox(height: 80), // Tambahkan jarak sebelum tombol submit
                  ],
                ),
              ),
            ),
            // Tombol Submit di bawah
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  /// Fungsi untuk membangun TextField
  Widget _buildField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFB8B8B8), // Warna placeholder abu-abu terang
        ),
        prefixIcon: _getIconForField(hint), // Icon di sebelah kiri
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corner field
          borderSide: const BorderSide(
            color: Color(0xFFC4B0A0), // Border warna krem
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFFC4B0A0),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFFFFFF).withOpacity(0.3), // Warna background field
      ),
    );
  }

  /// Icon untuk setiap text field berdasarkan hint
  Widget _getIconForField(String hint) {
    switch (hint) {
      case 'Fullname':
        return const Icon(Icons.person, color: Color(0xFF9B9B9B)); // Icon person
      case 'Major':
        return const Icon(Icons.school, color: Color(0xFF9B9B9B)); // Icon school
      case 'University':
        return const Icon(Icons.business, color: Color(0xFF9B9B9B)); // Icon business
      case 'Number':
        return const Icon(Icons.phone, color: Color(0xFF9B9B9B)); // Icon phone
      default:
        return const Icon(Icons.person, color: Color(0xFF9B9B9B));
    }
  }

  /// Tombol Submit di kanan bawah
  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 40),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFC4B0A0), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Color(0xFF9B7765)), // Arrow warna coklat gelap
            onPressed: () {
              // Validasi apakah semua field terisi
              if (_fullnameController.text.isNotEmpty &&
                  _majorController.text.isNotEmpty &&
                  _universityController.text.isNotEmpty &&
                  _numberController.text.isNotEmpty) {
                // Navigasi ke halaman Signup2 jika semua field valid
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Signup2Screen(
                      fullName: _fullnameController.text,
                      major: _majorController.text,
                      university: _universityController.text,
                      phoneNumber: _numberController.text,
                    ),
                  ),
                );
              } else {
                // Tampilkan pesan jika ada field kosong
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}