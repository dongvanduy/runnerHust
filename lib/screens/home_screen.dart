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

  final Color brandColor = const Color(0xFFFF6A00);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final List<RunRecord> lastRuns = appState.history.take(2).toList();

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
              'RUNIX',
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
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBanner(),
                      const SizedBox(height: 24),
                      Text(
                        l10n.t('lastActivities'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      if (lastRuns.isEmpty)
                        const Text('No activities yet. Start your first run!')
                      else
                        ...lastRuns
                            .map((run) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildActivityCard(context, run),
                                ))
                            .toList(),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Find The Club Near You',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HistoryScreen(),
                                ),
                              );
                            },
                            child: const Text('See all',
                                style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                      _buildHorizontalList(context),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: _buildFloatingBottomBar(context, l10n),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBanner() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1552674605-db6aea4bc094?auto=format&fit=crop&q=80'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black.withOpacity(0.3),
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
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                  child: const Icon(Icons.arrow_downward, color: Colors.white, size: 16),
                )
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryDetailScreen(run: run)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                        const SizedBox(width: 24),
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
                    Text('${run.distanceKm.toStringAsFixed(2)} Km',
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
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1530549387720-1bfa36c6451e?auto=format&fit=crop&q=80'),
                    fit: BoxFit.cover,
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
              child: Text(
                l10n.t('start'),
                style: const TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
