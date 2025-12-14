//nat mengerjakan

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8C4A8),
      body: SafeArea(
        child: SingleChildScrollView(
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Back Button and Logo
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration:  BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          shape: BoxShape.circle,
                          color: const Color(0xFFE8C4A8),
                        ),
                        child:  const Icon(
                          Icons. arrow_back_ios_new,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/logofull.png',
                      height: 35,
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
                const SizedBox(height: 40),
                // Planet Character - DIPERBESAR
                Image.asset(
                  'assets/images/saturnlogin.png',
                  height: 280,
                ),
                const SizedBox(height: 50),
                // Username Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'username',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors. black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8C4A8),
                        borderRadius: BorderRadius. circular(28),
                        border: Border. all(color: Colors.black87, width: 2),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Color(0xFF9CA3AF),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets. symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Password Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'password',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors. black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8C4A8),
                        borderRadius: BorderRadius.circular(28),
                        border: Border. all(color: Colors.black87, width: 2),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: ! _isPasswordVisible,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.key_outlined,
                            color: Color(0xFF9CA3AF),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border:  InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Forgot password feature coming soon!'),
                        ),
                      );
                    },
                    child: const Text(
                      'forgot password',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Login Button
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

                      Navigator.pushReplacementNamed(context, '/homepage');
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE8A87C),
                        letterSpacing: 1,
                      ),
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
}