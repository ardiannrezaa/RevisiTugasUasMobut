import 'package:flutter/material.dart';
import '../core/session.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> user = {"name": "", "email": ""};

  Future<void> load() async {
    user = await Session.getUser();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nama: ${user["name"]}", style: const TextStyle(fontSize: 16)),
          Text("Email: ${user["email"]}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await Session.logout();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logout berhasil")),
                );
                Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              },
              child: const Text("LOGOUT"),
            ),
          ),
        ],
      ),
    );
  }
}
