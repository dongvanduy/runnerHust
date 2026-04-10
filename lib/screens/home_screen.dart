import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/run_record.dart';
import '../state/app_state.dart';
import 'history_detail_screen.dart';
import 'history_screen.dart';
import 'running_stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final Color neonGreen = const Color(0xADF8D80A); // Màu xanh nõn chuối từ thiết kế

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Consumer<AppState>(
      builder: (context, appState, _) {
        // Lấy lịch sử thật, nếu trống thì tự tạo 2 bản ghi giả để hiển thị UI cho đẹp
        List<RunRecord> lastRuns = appState.history.take(2).toList();
        if (lastRuns.isEmpty) {
          lastRuns = [
            RunRecord(
              id: 1, // Sửa thành số nguyên (bỏ dấu nháy đơn)
              title: 'Monday Morning Run',
              distanceKm: 3.00,
              durationSeconds: 900, // 15 phút
              startedAt: DateTime(2024, 7, 16),
              // Thêm các tham số bắt buộc theo model của bạn
              avgPaceMinPerKm: 5.0,
              calories: 250.0,
              elevationGainMeters: 12.0,
              routeJson: '[]', // Chuỗi JSON rỗng cho mảng tọa độ
            ),
            RunRecord(
              id: 2, // Sửa thành số nguyên
              title: 'Sunday Morning Run',
              distanceKm: 15.00,
              durationSeconds: 3600, // 60 phút
              startedAt: DateTime(2024, 7, 15),
              // Thêm các tham số bắt buộc theo model của bạn
              avgPaceMinPerKm: 4.0,
              calories: 800.0,
              elevationGainMeters: 45.0,
              routeJson: '[]',
            ),
          ];
        }
        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 28),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
              },
            ),
            title: const Text(
              'RUNIX', // Đổi tên theo ảnh mẫu
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 24, letterSpacing: 1.5),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBanner(),
                const SizedBox(height: 24),
                const Text('Your Last 2 Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                ...lastRuns.map((run) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildActivityCard(context, run),
                )).toList(),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Find The Club Near You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: Colors.black54))),
                  ],
                ),
                _buildHorizontalClubList(context),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Running Programs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: Colors.black54))),
                  ],
                ),
                _buildProgramCard(),

                const SizedBox(height: 100), // Không gian cho Bottom bar
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _buildFloatingBottomBar(context, l10n),
            ),
          ),
        );
      },
    );
  }

  // CÁC HÀM XÂY DỰNG GIAO DIỆN PHỤ...
  Widget _buildTopBanner() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1552674605-db6aea4bc094?auto=format&fit=crop&q=80'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.black.withOpacity(0.3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Running Information', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(child: Text('Half Marathon event held by Mandiri Bank Group', style: TextStyle(color: Colors.white, fontSize: 12))),
                Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)), child: const Icon(Icons.arrow_downward, color: Colors.white, size: 16))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, RunRecord run) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailScreen(run: run)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4FEF6), // Màu nền xanh nhạt giống thiết kế
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: neonGreen, shape: BoxShape.circle),
                  child: const Icon(Icons.star_border, size: 18, color: Colors.black),
                ),
                const SizedBox(width: 8),
                Text(_formatDate(run.startedAt), style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                    Text(run.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(run.formattedDuration, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                            const Text('Time', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(run.formattedPace, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
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
                    Text('${run.distanceKm.toStringAsFixed(2)} Km', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    Container(height: 4, width: 60, color: neonGreen),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalClubList(BuildContext context) {
    // 3 ảnh mô phỏng cho các câu lạc bộ
    final List<String> clubImages = [
      'https://images.unsplash.com/photo-1530549387720-1bfa36c6451e?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1502224562085-639556652f33?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1552674605-db6aea4bc094?auto=format&fit=crop&q=80'
    ];
    final List<String> clubNames = ['Tangerang Runners', 'JakBar Pacers', 'Hanoi Runners'];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 200, // Làm card rộng hơn chút cho giống ảnh
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: NetworkImage(clubImages[index]), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.4), // Phủ đen mờ để thấy chữ
              ),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.bottomLeft,
              child: Text(
                clubNames[index],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgramCard() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1530143311094-34d807799e8f?auto=format&fit=crop&q=80'), // Ảnh minh họa
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MARATHON\nTRAINING', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1)),
            const SizedBox(height: 8),
            const Text('42 KM', style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_border, color: Colors.amber, size: 20),
                  SizedBox(width: 4),
                  Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF5A5A5A),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {},
            child: Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.settings, size: 24)),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RunningStatsScreen()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(color: neonGreen, borderRadius: BorderRadius.circular(25)),
              child: const Text('START', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black)),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.music_note, size: 24)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}