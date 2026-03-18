import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'running_map_screen.dart'; // Import để chuyển sang màn hình Map

class RunningStatsScreen extends StatelessWidget {
  const RunningStatsScreen({Key? key}) : super(key: key);

  final Color brandColor = const Color(0xFFccff00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Thanh trạng thái (Thời tiết & GPS)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(Icons.wb_sunny_outlined, '32°C'),
                  // Icon vạch sóng ở giữa (giả lập)
                  Row(
                    children: [
                      Container(width: 20, height: 4, decoration: BoxDecoration(color: brandColor, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 4),
                      Container(width: 20, height: 4, decoration: BoxDecoration(color: brandColor.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
                    ],
                  ),
                  _buildStatusChip(Icons.wifi_tethering, 'GPS'),
                ],
              ),

              const Spacer(), // Đẩy nội dung ra giữa

              // Thông số chính
              const Text(
                '00,00',
                style: TextStyle(fontSize: 90, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -3),
              ),
              const Text('Distance (Km)', style: TextStyle(fontSize: 16, color: Colors.grey)),

              const SizedBox(height: 50),

              // 3 Thông số phụ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSubStat(Icons.directions_run, '0\'00"', 'Avg Pace'),
                  _buildSubStat(Icons.timer_outlined, '00.00', 'Duration'),
                  _buildSubStat(Icons.local_fire_department_outlined, '0 kcal', 'Calories'),
                ],
              ),

              const Spacer(),

              // Trình phát nhạc
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(color: brandColor, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.pause, size: 30),
                    Column(
                      children: const [
                        Text('Sweet Disposition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('The Temper Trap', style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                    const Icon(Icons.skip_next, size: 30),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Nút điều khiển đáy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Nút Bản đồ (Nhấn vào sẽ chuyển sang màn hình Map)
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RunningMapScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: brandColor, width: 2)),
                      child: const Icon(Icons.map_outlined, size: 36),
                    ),
                  ),
                  // Nút Tạm dừng
                  InkWell(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Kết thúc buổi chạy?'),
                          content: const Text('Bạn có muốn dừng buổi chạy và quay về trang chủ không?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Tiếp tục chạy'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                                  (route) => false,
                                );
                              },
                              child: const Text('Kết thúc'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(color: brandColor, shape: BoxShape.circle),
                      child: const Text('PAUSE', style: TextStyle(fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 18)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget tạo Chip trạng thái (Thời tiết / GPS)
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

  // Widget tạo thông số phụ
  Widget _buildSubStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black54, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
