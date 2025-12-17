import 'package:champify/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import halaman
import 'navbar.dart';
import 'authentication/signup.dart';
import 'authentication/login.dart';
import 'authentication/welcome_page.dart';
import 'mentoring.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ritybflofnjeerbadjfp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpdHliZmxvZm5qZWVyYmFkamZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMzg3ODYsImV4cCI6MjA3OTcxNDc4Nn0.jjs1p3QuTgH0nFEYENbD1bbB9PfoMrQdV5L5P8D0NwI',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Champify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE89B8E)),
        useMaterial3: true,
      ),

      home: const WelcomePage(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpFormPage(),
        '/main': (context) => const Navbar(),
        '/mentoring': (context) => const ZoomMeetingScreen(),
        '/welcome_page': (context) => const WelcomePage(),
        '/homepage': (context) => const HomePage(),
      },
    );
  }
}
