import 'package:flutter/material.dart';

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

          // 3. Lớp trên cùng: Text
          const Center(
            child: Text(
              'Bolt Running Club',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}