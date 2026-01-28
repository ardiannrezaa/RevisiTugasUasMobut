import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/api.dart';
import '../core/session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool loading = false;

  Future<void> doLogin() async {
    setState(() => loading = true);
    try {
      final res = await Api.dio.post(
        "/auth/login.php",
        data: {
          "email": emailC.text.trim(),
          "password": passC.text.trim(),
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final parsed = res.data is String ? jsonDecode(res.data) : res.data;

      if (!mounted) return;

      if (parsed["success"] == true) {
        await Session.saveLogin(
          userId: parsed["data"]["id"].toString(),
          name: parsed["data"]["name"].toString(),
          email: parsed["data"]["email"].toString(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(parsed["message"].toString())),
        );

        Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(parsed["message"].toString())),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login gagal, cek koneksi / API")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue.withOpacity(0.08),
              ),
              child: Row(
                children: [
                  Image.asset("assets/shoe_local.jpg", width: 55), // ✅ local image
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Silakan login untuk melihat katalog sepatu.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Textfield
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : doLogin,
                child: Text(loading ? "Loading..." : "LOGIN"),
              ),
            ),

            const SizedBox(height: 8),

            // ✅ opsi Register
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text("Belum punya akun? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
