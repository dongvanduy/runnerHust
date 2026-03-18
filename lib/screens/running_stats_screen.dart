import 'package:flutter/material.dart';

import '../services/run_tracking_service.dart';
import 'home_screen.dart';
import 'running_map_screen.dart';

class RunningStatsScreen extends StatefulWidget {
  const RunningStatsScreen({Key? key}) : super(key: key);

  @override
  State<RunningStatsScreen> createState() => _RunningStatsScreenState();
}

class _RunningStatsScreenState extends State<RunningStatsScreen> {
  final Color brandColor = const Color(0xFFccff00);
  final RunTrackingService _trackingService = RunTrackingService.instance;

  @override
  void initState() {
    super.initState();
    _trackingService.startTracking();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _trackingService,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusChip(Icons.wb_sunny_outlined, '32°C'),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 4,
                            decoration: BoxDecoration(
                              color: brandColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 20,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _trackingService.isTracking
                                  ? brandColor
                                  : brandColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      _buildStatusChip(Icons.wifi_tethering, _trackingService.gpsStatus),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    _trackingService.formatDistanceKm(),
                    style: const TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -3,
                    ),
                  ),
                  const Text('Distance (Km)',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSubStat(Icons.directions_run,
                          _trackingService.formatAveragePace(), 'Avg Pace'),
                      _buildSubStat(Icons.timer_outlined,
                          _trackingService.formatDuration(), 'Duration'),
                      _buildSubStat(Icons.local_fire_department_outlined,
                          '${_trackingService.formatCalories()} kcal', 'Calories'),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: brandColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.pause, size: 30),
                        Column(
                          children: [
                            Text('Sweet Disposition',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('The Temper Trap',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                        Icon(Icons.skip_next, size: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RunningMapScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: brandColor, width: 2),
                          ),
                          child: const Icon(Icons.map_outlined, size: 36),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showStopDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration:
                              BoxDecoration(color: brandColor, shape: BoxShape.circle),
                          child: const Text(
                            'PAUSE',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                            ),
                          ),
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
      },
    );
  }

  void _showStopDialog(BuildContext context) {
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
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _trackingService.stopAndReset();
              if (!context.mounted) return;
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
  }

  Widget _buildStatusChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3D6),
        borderRadius: BorderRadius.circular(20),
      ),
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
        Icon(icon, color: Colors.black54, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
