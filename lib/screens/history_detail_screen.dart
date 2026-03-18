import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({Key? key}) : super(key: key);

  final Color brandColor = const Color(0xFFccff00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Lớp dưới cùng: Bản đồ (Dùng ảnh bạn vừa gửi)
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            // Thay bằng đường dẫn ảnh thật của bạn: 'assets/images/map_bg.png'
            child: Image.network(
              'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
              fit: BoxFit.cover,
            ),
          ),

          // Lớp phủ trắng mờ
          Container(color: Colors.white.withOpacity(0.5)),

          // --- PHẦN VẼ LỘ TRÌNH (GIẢ LẬP) ---
          // Trong thực tế, bạn sẽ dùng thư viện google_maps_flutter có hỗ trợ Polyline.
          // Ở đây mình dùng CustomPaint để vẽ một đường mô phỏng theo hình.
          Positioned(
            top: 250, left: 100,
            child: CustomPaint(
              size: const Size(150, 100),
              painter: RoutePainter(routeColor: brandColor),
            ),
          ),
          // Chấm điểm kết thúc
          Positioned(
            top: 310, left: 235,
            child: Container(
              width: 16, height: 16,
              decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: brandColor, width: 3)),
            ),
          ),

          // 2. Lớp UI (AppBar trong suốt + Nội dung cuộn)
          SafeArea(
            child: Column(
              children: [
                // AppBar tùy chỉnh
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, size: 28),
                        onPressed: () => Navigator.pop(context), // Quay lại màn hình trước
                      ),
                    ],
                  ),
                ),

                // Tiêu đề
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Monday Morning Run', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chức năng chỉnh sửa đang được phát triển.')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(),
                ),

                const Spacer(), // Đẩy phần thống kê xuống dưới cùng

                // 3. Khối thống kê chi tiết (BottomSheet mờ)
                _buildStatsBottomSheet(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Khối chứa các thẻ thông số ở dưới cùng
  Widget _buildStatsBottomSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        // LinearGradient làm mờ dần lên trên cho đẹp
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, Colors.white70],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Vừa đủ chiều cao
        children: [
          // Thẻ Xanh tổng quan
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(color: brandColor, borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMainStat('3,00', 'Km', 'Distance'),
                Container(width: 1, height: 40, color: Colors.black12), // Vạch chia
                _buildMainStat('15.00', '', 'Duration'),
                Container(width: 1, height: 40, color: Colors.black12),
                _buildMainStat('5\'00"', '', 'Avg Pace'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Danh sách các thẻ chi tiết màu trắng
          _buildDetailCard('Step Length', 'Distance between steps', '1,00', 'm'),
          _buildDetailCard('Calories', 'Total energy burned', '854', 'kcal'),
          _buildDetailCard('Cadence', 'Steps per minute', '212', 'spm'),
          _buildDetailCard('Elevation Gain', 'Total height that you climb', '100', 'ft'),
        ],
      ),
    );
  }

  // Widget cho Thẻ Xanh
  Widget _buildMainStat(String value, String unit, String label) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            if (unit.isNotEmpty) Text(' $unit', style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }

  // Widget cho Thẻ Trắng Chi Tiết
  Widget _buildDetailCard(String title, String subtitle, String value, String unit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Text(unit, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}

// Lớp phụ trợ để vẽ đường mô phỏng (giả lập Route trên Map)
class RoutePainter extends CustomPainter {
  final Color routeColor;
  RoutePainter({required this.routeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = routeColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(120, -20); // Đi sang phải, hơi hướng lên
    path.lineTo(150, 60);  // Rẽ phải đi xuống
    path.lineTo(120, 80);  // Rẽ vòng qua trái
    path.lineTo(20, 100);  // Rẽ trái thẳng
    path.lineTo(0, 0);     // Vòng về điểm bắt đầu

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
