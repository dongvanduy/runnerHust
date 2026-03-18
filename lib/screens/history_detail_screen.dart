import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({Key? key}) : super(key: key);

  static const Color brandColor = Color(0xFFccff00);
  static const double runnerWeightKg = 70;
  static const Duration runDuration = Duration(minutes: 15, seconds: 42);

  static const List<LatLng> historyRoute = [
    LatLng(10.762622, 106.660172),
    LatLng(10.763245, 106.661344),
    LatLng(10.763710, 106.662110),
    LatLng(10.764100, 106.663300),
    LatLng(10.763470, 106.664050),
    LatLng(10.762840, 106.663120),
    LatLng(10.762622, 106.660172),
  ];

  static const List<double> elevationSamples = [
    6.0,
    8.8,
    9.4,
    12.3,
    10.1,
    11.7,
    7.5,
  ];

  @override
  Widget build(BuildContext context) {
    final double distanceKm = _calculateDistanceKm(historyRoute);
    final double avgPace = _calculateAveragePace(runDuration, distanceKm);
    final double calories = _calculateCalories(distanceKm, runnerWeightKg);
    final double elevationGain = _calculateElevationGain(elevationSamples);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: historyRoute.first,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('start'),
                position: historyRoute.first,
                infoWindow: const InfoWindow(title: 'Start'),
              ),
              Marker(
                markerId: const MarkerId('finish'),
                position: historyRoute.last,
                infoWindow: const InfoWindow(title: 'Finish'),
              ),
            },
            polylines: {
              const Polyline(
                polylineId: PolylineId('history_route'),
                points: historyRoute,
                width: 6,
                color: brandColor,
              ),
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),
          Container(color: Colors.white.withOpacity(0.35)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Monday Morning Run',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Chức năng chỉnh sửa đang được phát triển.')),
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
                const Spacer(),
                _buildStatsBottomSheet(
                  distanceKm: distanceKm,
                  duration: runDuration,
                  avgPaceMinPerKm: avgPace,
                  calories: calories,
                  elevationGainMeters: elevationGain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBottomSheet({
    required double distanceKm,
    required Duration duration,
    required double avgPaceMinPerKm,
    required double calories,
    required double elevationGainMeters,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, Colors.white70],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration:
                BoxDecoration(color: brandColor, borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMainStat(distanceKm.toStringAsFixed(2), 'Km', 'Distance'),
                Container(width: 1, height: 40, color: Colors.black12),
                _buildMainStat(_formatDuration(duration), '', 'Duration'),
                Container(width: 1, height: 40, color: Colors.black12),
                _buildMainStat(_formatPace(avgPaceMinPerKm), '', 'Avg Pace'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailCard('Calories', 'Total energy burned',
              calories.round().toString(), 'kcal'),
          _buildDetailCard('Elevation Gain', 'Total height that you climb',
              elevationGainMeters.toStringAsFixed(0), 'm'),
        ],
      ),
    );
  }

  Widget _buildMainStat(String value, String unit, String label) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            if (unit.isNotEmpty) Text(' $unit', style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }

  Widget _buildDetailCard(String title, String subtitle, String value, String unit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Text(unit, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  double _calculateDistanceKm(List<LatLng> points) {
    if (points.length < 2) return 0;

    double totalMeters = 0;
    for (int i = 1; i < points.length; i++) {
      totalMeters += Geolocator.distanceBetween(
        points[i - 1].latitude,
        points[i - 1].longitude,
        points[i].latitude,
        points[i].longitude,
      );
    }

    return totalMeters / 1000;
  }

  double _calculateAveragePace(Duration duration, double distanceKm) {
    if (distanceKm == 0) return 0;
    return (duration.inSeconds / 60) / distanceKm;
  }

  double _calculateCalories(double distanceKm, double weightKg) {
    return weightKg * distanceKm * 1.036;
  }

  double _calculateElevationGain(List<double> elevations) {
    if (elevations.length < 2) return 0;

    double gain = 0;
    for (int i = 1; i < elevations.length; i++) {
      final double delta = elevations[i] - elevations[i - 1];
      if (delta > 0) {
        gain += delta;
      }
    }
    return gain;
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatPace(double pace) {
    if (pace == 0 || pace.isInfinite) return '0\'00"';
    final int minutes = pace.floor();
    int seconds = ((pace - minutes) * 60).round();
    int safeMinutes = minutes;
    if (seconds == 60) {
      safeMinutes += 1;
      seconds = 0;
    }
    return '$safeMinutes\'${seconds.toString().padLeft(2, '0')}"';
  }
}
