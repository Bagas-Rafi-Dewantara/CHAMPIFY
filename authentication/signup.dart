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
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8DC),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFC4B0A0),
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Color(0xFFE8A87C)),
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
                      const Text(
                        'Please complete \nthe field below',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 120),
                      _buildField(_fullnameController, 'Fullname'),
                      const SizedBox(height: 24),
                      _buildField(_majorController, 'Major'),
                      const SizedBox(height: 24),
                      _buildField(_universityController, 'University'),
                      const SizedBox(height: 24),
                      _buildField(_numberController, 'Number', keyboardType: TextInputType.phone),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

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
          color: Color(0xFFB8B8B8),
        ),
        prefixIcon: _getIconForField(hint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFFC4B0A0),
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFFE8A87C), // Orange theme color
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFFFFFF).withOpacity(0.3),
      ),
    );
  }

  Widget _getIconForField(String hint) {
    switch (hint) {
      case 'Fullname':
        return const Icon(Icons.person, color: Color(0xFF9B9B9B));
      case 'Major':
        return const Icon(Icons.school, color: Color(0xFF9B9B9B));
      case 'University':
        return const Icon(Icons.business, color: Color(0xFF9B9B9B));
      case 'Number':
        return const Icon(Icons.phone, color: Color(0xFF9B9B9B));
      default:
        return const Icon(Icons.person, color: Color(0xFF9B9B9B));
    }
  }

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
            icon: const Icon(Icons.arrow_forward, color: Color(0xFF9B7765)),
            onPressed: () {
              if (_fullnameController.text.isNotEmpty &&
                  _majorController.text.isNotEmpty &&
                  _universityController.text.isNotEmpty &&
                  _numberController.text.isNotEmpty) {
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