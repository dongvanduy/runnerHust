import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/run_record.dart';
import '../state/app_state.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  final Color brandColor = const Color(0xFFFF6A00);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final List<RunRecord> history = appState.history;
        final double totalDistance = history.fold(
          0.0,
          (double sum, RunRecord run) => sum + run.distanceKm,
        );

        final double avgPace = history.isEmpty
            ? 0
            : history.fold(
                  0.0,
                  (double sum, RunRecord run) => sum + run.avgPaceMinPerKm,
                ) /
                history.length;

        final int totalTimeSeconds = history.fold(
          0,
          (int sum, RunRecord run) => sum + run.durationSeconds,
        );

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              PopupMenuButton<Locale>(
                onSelected: appState.setLocale,
                itemBuilder: (_) => [
                  PopupMenuItem(value: const Locale('en'), child: Text(l10n.t('english'))),
                  PopupMenuItem(
                      value: const Locale('vi'), child: Text(l10n.t('vietnamese'))),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(l10n.t('language'), style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: appState.isLoadingHistory
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.t('history'), style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 10),
                          Text(
                            totalDistance.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              letterSpacing: -2,
                            ),
                          ),
                          Text(
                            l10n.t('kilometer'),
                            style: const TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTopStat(history.length.toString(), l10n.t('run')),
                              _buildTopStat(_formatPace(avgPace), l10n.t('averagePace')),
                              _buildTopStat(_formatDuration(totalTimeSeconds), l10n.t('time')),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: appState.syncing
                                  ? null
                                  : () async {
                                      try {
                                        await appState.syncHistoryToGoogleDrive();
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(l10n.t('syncSuccess'))),
                                        );
                                      } catch (_) {
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(l10n.t('syncFailed'))),
                                        );
                                      }
                                    },
                              icon: const Icon(Icons.cloud_upload_outlined),
                              label: Text(appState.syncing
                                  ? l10n.t('syncing')
                                  : l10n.t('syncGoogleDrive')),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    Expanded(
                      child: history.isEmpty
                          ? const Center(child: Text('No run history yet.'))
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemBuilder: (context, index) =>
                                  _buildHistoryCard(context, history[index]),
                              separatorBuilder: (_, __) => const SizedBox(height: 16),
                              itemCount: history.length,
                            ),
                    )
                  ],
                ),
        );
      },
    );
  }

  Widget _buildTopStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildHistoryCard(BuildContext context, RunRecord run) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryDetailScreen(run: run)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FFF4),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                Text(_formatDate(run.startedAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                    Text(run.title,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(run.formattedDuration,
                                style: const TextStyle(
                                    color: Colors.red, fontWeight: FontWeight.w600)),
                            const Text('Time',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(run.formattedPace,
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600)),
                            const Text('Pace',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${run.formattedDistance} Km',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    Container(height: 4, width: 60, color: brandColor),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String _formatDuration(int totalSeconds) {
    final Duration duration = Duration(seconds: totalSeconds);
    return '${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  String _formatPace(double pace) {
    if (pace <= 0 || pace.isInfinite) return '0\'00"';
    final int min = pace.floor();
    final int sec = ((pace - min) * 60).round();
    return '$min\'${sec.toString().padLeft(2, '0')}"';
  }
}
