import 'package:flutter/material.dart';
import '../core/session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    await Future.delayed(const Duration(milliseconds: 900));
    final isLogin = await Session.isLogin();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, isLogin ? '/menu' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset('assets/logo.jpg', width: 90),
          const SizedBox(height: 12),
          const Text("Katalog Sepatu Reza", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          const CircularProgressIndicator(),
        ]),
      ),
    );
  }
}
