import 'package:flutter/material.dart';
import 'dart:async'; // Dùng để tạo độ trễ (delay)
import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Thiết lập thời gian chờ 2.5 giây rồi chuyển sang màn hình Intro
    Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chữ RUNIX
            const Text(
              'RUNIX',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic, // Chữ in nghiêng
                color: Colors.black,
                letterSpacing: 2.0, // Khoảng cách giữa các chữ
              ),
            ),
            // Đường gạch chân màu xanh lá
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 6,
              width: 120, // Độ dài của đường gạch chân
              decoration: BoxDecoration(
                color: const Color(0xFFa3f42c), // Màu xanh lá neon (mã màu tham khảo từ hình)
                borderRadius: BorderRadius.circular(4), // Bo góc cho đẹp
              ),
            ),
          ],
        ),
      ),
    );
  }
}
