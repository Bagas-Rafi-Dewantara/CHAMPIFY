import 'package:flutter/material.dart';

class SignUpFormPage extends StatefulWidget {
  const SignUpFormPage({super. key});

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
      backgroundColor: const Color(0xFFFFF8DC),
      body: SafeArea(
        child:  Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child:   Align(
                alignment: Alignment.  topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new),
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
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style:   TextStyle(
                          fontSize:   24,
                          color:   Colors.black87,
                        ),
                        children: [
                          TextSpan(text:   'Please '),
                          TextSpan(
                            text: 'complete ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB8B08D),
                            ),
                          ),
                          TextSpan(text: 'the field below'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildField(_fullnameController, 'Fullname'),
                    const SizedBox(height: 20),
                    _buildField(_majorController, 'Major'),
                    const SizedBox(height: 20),
                    _buildField(_universityController, 'University'),
                    const SizedBox(height: 20),
                    _buildField(_numberController, 'Number',
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 60),
                    const Text(
                      'Almost there ....  .',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB8B08D),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.  center,
                      children: [
                        Image.asset(
                          'assets/images/starexcited.png',
                          height: 120,
                        ),
                        const SizedBox(width: 40),
                        _buildSubmitButton(context),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black87, width: 2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.  none,
          contentPadding: 
              const EdgeInsets.symmetric(horizontal: 24, vertical:  18),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width:  60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.  circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_forward, color: Colors.black87),
        onPressed: () {
          if (_fullnameController.text. isNotEmpty &&
              _majorController.text. isNotEmpty &&
              _universityController.text.isNotEmpty &&
              _numberController.text.isNotEmpty) {
            // Langsung navigate ke login
            Navigator.pushNamed(context, '/login');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content:  Text('Please fill all fields')),
            );
          }
        },
      ),
    );
  }
}