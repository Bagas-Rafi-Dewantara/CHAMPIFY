import 'package:flutter/material.dart';
import '../homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => isLoading = true);
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);

      final uid = supabase.auth.currentUser?.id;
      if (uid == null) throw Exception('Login gagal: user id null');

      // Optional: ambil profil pengguna
      // final profile = await supabase.from('pengguna').select().eq('id_pengguna', uid).maybeSingle();
      // debugPrint('Profile: $profile');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successful!')));
      // Pastikan route ini ada di main.dart. Jika tidak, ganti ke '/main'.
      Navigator.pushReplacementNamed(context, '/homepage');
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Auth error: ${e.message}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8C4A8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          shape: BoxShape.circle,
                          color: const Color(0xFFE8C4A8),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
                      ),
                    ),
                    const Spacer(),
                    Image.asset('assets/images/logofull.png', height: 40),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 30),
                Image.asset('assets/images/saturnlogin.png', height: 250),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: _inputDecoration('email', Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'password',
                    hintStyle: const TextStyle(color: Color(0xFFB8B8B8)),
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF9B9B9B)),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF9B9B9B)),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
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
                    fillColor: const Color(0xFFFFFFFF).withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Forgot password feature coming soon!')),
                      );
                    },
                    child: const Text(
                      'forgot password',
                      style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                  onPressed: () {
                    if (_usernameController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login successful!')),
                      );

                      Navigator.pushReplacementNamed(context, '/main');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                        ),
                      );
                    }
                  },
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF4B8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFE8A87C), letterSpacing: 1),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
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
      fillColor: const Color(0xFFFFFFFF).withValues(alpha: 0.3),
    );
  }
}