import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'verification_page.dart'; // Pastikan import ini benar sesuai struktur foldermu

final supabase = Supabase.instance.client;

class Signup2Screen extends StatefulWidget {
  const Signup2Screen({
    super.key,
    required this.fullName,
    required this.major,
    required this.university,
    required this.phoneNumber,
  });

  final String fullName;
  final String major;
  final String university;
  final String phoneNumber;

  @override
  State<Signup2Screen> createState() => _Signup2ScreenState();
}

class _Signup2ScreenState extends State<Signup2Screen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _handleSignup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();
    final username = usernameController.text.trim();

    // --- 1. VALIDASI INPUT ---
    if (!isEmailValid(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email tidak valid!')));
      return;
    }

    if (email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty ||
        username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password tidak cocok!')));
      return;
    }

    setState(() => isLoading = true);

    try {
      // --- 2. PROSES SIGN UP (CLEAN CODE) ---
      // Kita kirim data profil lewat 'data' (metadata).
      // Trigger di Supabase akan otomatis menangkap ini dan memasukkannya ke tabel 'pengguna'.
      final res = await supabase.auth.signUp(
        email: email, 
        password: password,
        data: {
          'username': username,
          'full_name': widget.fullName.trim(),
          'major': widget.major.trim(),
          'university': widget.university.trim(),
          'phone_number': widget.phoneNumber.trim(),
        },
      );

      final user = res.user;

      if (user == null) {
        throw Exception('Signup gagal: Cek koneksi atau email mungkin sudah terdaftar.');
      }

      // --- 3. NAVIGASI KE HALAMAN VERIFIKASI (KODE KAMU) ---
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifikasi emailmu terlebih dahulu!')),
      );

      // Pindah ke halaman VerificationPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VerificationPage()),
      );

    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Auth error: ${e.message}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D5C4),
      body: Stack(
        children: [
          // Yellow decoration
          Positioned(
            top: 200,
            right: -30,
            child: Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFF88).withOpacity(0.7),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // Header dengan back button dan logo
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF9B7765),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Color(0xFF9B7765)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const Spacer(),
                      Image.asset('assets/images/logofull.png',
                          height: 35, fit: BoxFit.contain),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Text "One Step Closer"
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'One',
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B8B9E)),
                      ),
                      SizedBox(height: 0),
                      Text(
                        'Step',
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B8B9E)),
                      ),
                      SizedBox(height: 0),
                      Text(
                        'Closer',
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B8B9E)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Input Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: _inputDecoration('Username', Icons.person),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        decoration: _inputDecoration('Email', Icons.email),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: !showPassword,
                        decoration: _passwordInputDecoration(
                          'Password',
                          showPassword,
                          () => setState(() => showPassword = !showPassword),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: !showConfirmPassword,
                        decoration: _passwordInputDecoration(
                          'Confirm Password',
                          showConfirmPassword,
                          () => setState(
                              () => showConfirmPassword = !showConfirmPassword),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Next Button
                Padding(
                  padding: const EdgeInsets.only(right: 30, bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: const Color(0xFFC4B0A0), width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.arrow_forward,
                                color: Color(0xFF9B7765)),
                        onPressed: isLoading ? null : _handleSignup,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB8B8B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF9B9B9B)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFC4B0A0), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFC4B0A0), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFFFFFFFF).withOpacity(0.3),
    );
  }

  InputDecoration _passwordInputDecoration(
      String hint, bool show, VoidCallback toggle) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB8B8B8)),
      prefixIcon: const Icon(Icons.lock, color: Color(0xFF9B9B9B)),
      suffixIcon: IconButton(
        icon: Icon(show ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF9B9B9B)),
        onPressed: toggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFC4B0A0), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFC4B0A0), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFFFFFFFF).withOpacity(0.3),
    );
  }
}