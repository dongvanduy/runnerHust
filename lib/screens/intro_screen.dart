import 'package:flutter/material.dart';
import 'home_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dùng Stack để xếp chồng các lớp UI lên nhau
      body: Stack(
        fit: StackFit.expand, // Mở rộng toàn màn hình
        children: [
          // 1. Lớp dưới cùng: Ảnh nền
          Image.asset(
            'assets/images/intro_bg.jpg', // Đường dẫn tới ảnh của bạn
            fit: BoxFit.cover, // Cắt cúp ảnh cho vừa khít màn hình
          ),

          // 2. Lớp giữa: Lớp phủ màu đen với độ trong suốt (opacity)
          // Giúp chữ màu trắng ở trên không bị chìm vào ảnh nền
          Container(
            color: Colors.black.withOpacity(0.4), // Độ mờ 40%
          ),

          // 3. Lớp trên cùng: Text + CTA
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bolt Running Club',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFccff00),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    'BẮT ĐẦU',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
