import 'package:flutter/material.dart';
import 'history_detail_screen.dart';
import 'history_screen.dart';
import 'running_stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Mã màu chủ đạo (Xanh lá neon)
  final Color brandColor = const Color(0xFFc4fb31);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
          },
        ),
        title: const Text(
          'BOLT',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Lớp 1: Nội dung cuộn được
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            // Thêm padding dưới cùng để nội dung không bị che bởi thanh Floating Bar
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBanner(),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Last 2 Activities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityCard(context, 'Monday Morning Run', '16/7/2024', '15.00', '5\'00"', '3,00 Km'),
                  const SizedBox(height: 16),
                  _buildActivityCard(context, 'Sunday Morning Run', '15/7/2024', '1:00:00', '4\'00"', '15,00 Km'),
                  const SizedBox(height: 24),

                  // Phần Find The Club (Tạm ẩn bớt code chi tiết để tập trung cấu trúc chính)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Find The Club Near You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HistoryScreen()),
                          );
                        },
                        child: const Text('See all', style: TextStyle(color: Colors.black54)),
                      ),
                    ],
                  ),
                  _buildHorizontalList(context), // Danh sách cuộn ngang các câu lạc bộ
                ],
              ),
            ),
          ),

          // Lớp 2: Thanh Navigation Bar nổi ở dưới cùng
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildFloatingBottomBar(context),
          ),
        ],
      ),
    );
  }

  // --- CÁC WIDGET CON (Components) ---

  // 1. Banner "Running Information"
  Widget _buildTopBanner() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1552674605-db6aea4bc094?auto=format&fit=crop&q=80'), // Ảnh minh họa từ mạng
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black.withOpacity(0.3), // Lớp phủ tối
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Running Information',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: Text(
                    'Half Marathon event held by Mandiri Bank Group',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                  child: const Icon(Icons.arrow_downward, color: Colors.white, size: 16),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // 2. Thẻ hoạt động (Activity Card)
  Widget _buildActivityCard(BuildContext context, String title, String date, String time, String pace, String distance) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryDetailScreen()),
        );
      },
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Nền trắng
        borderRadius: BorderRadius.circular(16),
        // Thêm bóng đổ nhẹ cho giống thiết kế
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: brandColor, shape: BoxShape.circle),
                child: const Icon(Icons.star, size: 16),
              ),
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
                      const SizedBox(width: 24),
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
              // Khối khoảng cách (Distance)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(distance, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  Container(height: 4, width: 60, color: brandColor), // Vạch gạch chân
                ],
              )
            ],
          )
        ],
      ),
    ),
    );
  }

  // 3. Danh sách ảnh nằm ngang (Horizontal List)
  Widget _buildHorizontalList(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng danh sách CLB đang được cập nhật.')),
              );
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1530549387720-1bfa36c6451e?auto=format&fit=crop&q=80'),
                    fit: BoxFit.cover,
                  )
              ),
            ),
          );
        },
      ),
    );
  }

  // 4. Thanh Action Bar Nổi ở đáy
  Widget _buildFloatingBottomBar(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4A4A), // Màu xám đen
        borderRadius: BorderRadius.circular(35), // Bo tròn thành hình viên thuốc
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Settings
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.history, size: 24),
            ),
          ),

          // Nút START trung tâm
          InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RunningStatsScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(color: brandColor, borderRadius: BorderRadius.circular(25)),
              child: const Text('START', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, fontStyle: FontStyle.italic)),
            ),
          ),

          // Nút Music
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng nghe nhạc đang được phát triển.')),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.music_note, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
