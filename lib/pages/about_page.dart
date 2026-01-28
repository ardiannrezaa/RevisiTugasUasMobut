import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Tentang Aplikasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Aplikasi katalog sepatu berbasis Flutter.\n"
                "Fitur: Login/Register, CRUD Sepatu, CRUD Artikel, Favorit, SharedPreferences, API PHP + MySQL.",
          ),
        ),
      ],
    );
  }
}
