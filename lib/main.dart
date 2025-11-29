import 'package:flutter/material.dart';
import 'features/profile/profile_page.dart';

void main() {
  runApp(const ChampifyApp());
}

class ChampifyApp extends StatelessWidget {
  const ChampifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChampifyProfilePage(),
    );
  }
}
