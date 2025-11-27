import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'authentication/signup.dart';
import 'authentication/login.dart';
import 'mentoring.dart';
import 'course/courses.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Champify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),

      // Halaman pertama yang muncul
      home: const WelcomePage(),

      // Routing
      routes: {
        '/signup': (context) => const SignUpFormPage(),
        '/login': (context) => const LoginPage(),
        '/mentoring': (context) => const ZoomMeetingScreen(),
        '/courses': (context) => const CoursePage(),
      },
    );
  }
}