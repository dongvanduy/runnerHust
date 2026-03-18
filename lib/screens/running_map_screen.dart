import 'package:flutter/material.dart';

class RunningMapScreen extends StatelessWidget {
  const RunningMapScreen({Key? key}) : super(key: key);

  final Color brandColor = const Color(0xFFccff00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Lớp dưới cùng: Bản đồ (Dùng ảnh giả lập)
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80', // Ảnh bản đồ sáng màu
              fit: BoxFit.cover,
            ),
          ),

          // Lớp phủ trắng mờ nhẹ để các thông số dễ đọc hơn
          Container(
            color: Colors.white.withOpacity(0.7),
          ),

          // Chấm tròn báo vị trí hiện tại
          Center(
            child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(color: brandColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
              child: Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle))),
            ),
          ),

          // 2. Lớp UI phía trên
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Thanh trạng thái trên cùng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusChip(Icons.wb_sunny_outlined, '32°C'),
                      _buildStatusChip(Icons.wifi_tethering, 'GPS'),
                    ],
                  ),

                  // Phần điều khiển và thông số bên dưới
                  Column(
                    children: [
                      // 3 Thông số
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSubStat(Icons.directions_run, '0\'00"', 'Avg Pace'),
                          _buildSubStat(Icons.timer_outlined, '00.00', 'Duration'),
                          _buildSubStat(Icons.local_fire_department_outlined, '0 kcal', 'Calories'),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Cụm nút bấm
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Nút Resume/Tiếp tục (Màu xanh)
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(color: brandColor, shape: BoxShape.circle),
                              child: const Icon(Icons.keyboard_double_arrow_right, size: 36),
                            ),
                          ),
                          // Nút Pause (Viền xanh, nền trắng) - Bấm vào để quay lại màn hình trước
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: brandColor, width: 2)),
                              child: const Text('PAUSE', style: TextStyle(fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFE8F3D6), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSubStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black87, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }
}
