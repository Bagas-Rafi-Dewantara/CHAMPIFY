import 'package:champify/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

// Import halaman
import 'homepage.dart';
import 'navbar.dart';
import 'authentication/signup.dart';
import 'authentication/login.dart';
import 'authentication/welcome_page.dart';
import 'mentoring.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ritybflofnjeerbadjfp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpdHliZmxvZm5qZWVyYmFkamZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMzg3ODYsImV4cCI6MjA3OTcxNDc4Nn0.jjs1p3QuTgH0nFEYENbD1bbB9PfoMrQdV5L5P8D0NwI',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (themeProvider.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp(
          title: 'Champify',
          debugShowCheckedModeBanner: false,

          theme: themeProvider.lightTheme.copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(
              themeProvider.lightTheme.textTheme,
            ),
          ),
          darkTheme: themeProvider.darkTheme.copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(
              themeProvider.darkTheme.textTheme,
            ),
          ),
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          // --- LOGIKA LOGIN DISINI ---
          home: StreamBuilder<AuthState>(
            stream: supabase.auth.onAuthStateChange,
            builder: (context, snapshot) {
              // 1. Tampilkan loading jika masih inisialisasi koneksi
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // 2. Cek apakah ada session user
              final session = snapshot.data?.session;

              if (session != null) {
                // User sudah login -> Masuk ke Navbar (Main App)
                return const Navbar();
              } else {
                // User belum login -> Masuk ke WelcomePage
                return const WelcomePage();
              }
            },
          ),

          // ---------------------------
          onGenerateRoute: (settings) {
            Widget buildRoute(Widget page) {
              return page;
            }

            switch (settings.name) {
              case '/login':
                return MaterialPageRoute(
                  builder: (context) => buildRoute(const LoginPage()),
                );
              case '/signup':
                return MaterialPageRoute(
                  builder: (context) => buildRoute(const SignUpFormPage()),
                );
              case '/main':
                return MaterialPageRoute(
                  builder: (context) => buildRoute(const Navbar()),
                  settings: settings,
                );
              case '/mentoring':
                return MaterialPageRoute(
                  builder: (context) => buildRoute(const ZoomMeetingScreen()),
                );
              case '/welcome_page':
                return MaterialPageRoute(
                  builder: (context) => buildRoute(const WelcomePage()),
                );
              case '/homepage':
                return MaterialPageRoute(
                  builder: (context) => buildRoute(const HomePage()),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => buildRoute(const WelcomePage()),
                );
            }
          },
        );
      },
    );
  }
}
