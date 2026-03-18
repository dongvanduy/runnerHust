import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  final Color brandColor = const Color(0xFFccff00); // Xanh neon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
          onPressed: () {},
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('History', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 10),
                const Text(
                  '46,00',
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -2),
                ),
                const Text('Kilometer', style: TextStyle(fontSize: 18, color: Colors.black87)),
                const SizedBox(height: 24),

                // Hàng thông số tổng quát
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTopStat('4', 'Run'),
                    _buildTopStat('5,50', 'Average Pace'),
                    _buildTopStat('4.10.00', 'Time'),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Danh sách các chuyến chạy (Dùng Expanded để chiếm phần không gian còn lại)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildHistoryCard('Monday Morning Run', '16/7/2024', '15.00', '5\'00"', '3,00 Km'),
                const SizedBox(height: 16),
                _buildHistoryCard('Sunday Morning Run', '15/7/2024', '1:00.00', '4\'00"', '15,00 Km'),
                const SizedBox(height: 16),
                _buildHistoryCard('Saturday Morning Run', '14/7/2024', '2:06.00', '6\'00"', '21,00 Km'),
                const SizedBox(height: 16),
                _buildHistoryCard('Friday Morning Run', '13/7/2024', '49.00', '7\'00"', '7,00 Km'),
                const SizedBox(height: 30), // Padding đáy
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget hiển thị thông số tổng quát phía trên
  Widget _buildTopStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // Widget Thẻ Lịch sử chạy (Giống trang Home nhưng có nền xanh nhạt)
  Widget _buildHistoryCard(String title, String date, String time, String pace, String distance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FFF4), // Màu trắng ám xanh nhạt theo thiết kế
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: brandColor, shape: BoxShape.circle), child: const Icon(Icons.star, size: 16)),
              const SizedBox(width: 8),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(time, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                          const Text('Time', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pace, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                          const Text('Pace', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(distance, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  Container(height: 4, width: 60, color: brandColor),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}