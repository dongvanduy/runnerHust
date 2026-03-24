import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'home_screen.dart';
import 'running_map_screen.dart';

class RunningStatsScreen extends StatefulWidget {
  const RunningStatsScreen({Key? key}) : super(key: key);

  @override
  State<RunningStatsScreen> createState() => _RunningStatsScreenState();
}

class _RunningStatsScreenState extends State<RunningStatsScreen> {
  final Color brandColor = const Color(0xFFccff00);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AppState>().startRunTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final tracking = appState.trackingService;

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
                              color: tracking.isTracking
                                  ? brandColor
                                  : brandColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      _buildStatusChip(Icons.wifi_tethering, tracking.gpsStatus),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    tracking.formatDistanceKm(),
                    style: const TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -3,
                    ),
                  ),
                  Text(l10n.t('distanceKm'),
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSubStat(
                        Icons.directions_run,
                        tracking.formatAveragePace(),
                        l10n.t('avgPace'),
                      ),
                      _buildSubStat(
                        Icons.timer_outlined,
                        tracking.formatDuration(),
                        l10n.t('duration'),
                      ),
                      _buildSubStat(
                        Icons.local_fire_department_outlined,
                        '${tracking.formatCalories()} kcal',
                        l10n.t('calories'),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                        onTap: () => _showStopDialog(context),
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration:
                              BoxDecoration(color: brandColor, shape: BoxShape.circle),
                          child: Text(
                            l10n.t('finish').toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
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
    final AppLocalizations l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.t('endRunQuestion')),
        content: Text(l10n.t('endRunDesc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.t('continueRun')),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AppState>().stopRunAndSave();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            child: Text(l10n.t('finish')),
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
