import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/run_record.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({Key? key, required this.run}) : super(key: key);

  final RunRecord run;

  static const Color brandColor = Color(0xFFFF6A00);

  @override
  Widget build(BuildContext context) {
    final List<LatLng> route = _decodeRoute(run.routeJson);
    final LatLng mapCenter = route.isNotEmpty ? route.first : const LatLng(10.762622, 106.660172);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: mapCenter, zoom: 15),
            markers: {
              if (route.isNotEmpty)
                Marker(
                  markerId: const MarkerId('start'),
                  position: route.first,
                  infoWindow: const InfoWindow(title: 'Start'),
                ),
              if (route.length > 1)
                Marker(
                  markerId: const MarkerId('finish'),
                  position: route.last,
                  infoWindow: const InfoWindow(title: 'Finish'),
                ),
            },
            polylines: {
              if (route.length > 1)
                Polyline(
                  polylineId: const PolylineId('history_route'),
                  points: route,
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
                      Text(run.title,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(
                        _formatDate(run.startedAt),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(),
                ),
                const Spacer(),
                _buildStatsBottomSheet(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBottomSheet() {
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
                _buildMainStat(run.distanceKm.toStringAsFixed(2), 'Km', 'Distance'),
                Container(width: 1, height: 40, color: Colors.black12),
                _buildMainStat(run.formattedDuration, '', 'Duration'),
                Container(width: 1, height: 40, color: Colors.black12),
                _buildMainStat(run.formattedPace, '', 'Avg Pace'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
              'Calories', 'Total energy burned', run.calories.round().toString(), 'kcal'),
          _buildDetailCard(
            'Elevation Gain',
            'Total height that you climb',
            run.elevationGainMeters.toStringAsFixed(0),
            'm',
          ),
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

  List<LatLng> _decodeRoute(String routeJson) {
    try {
      final List<dynamic> raw = jsonDecode(routeJson) as List<dynamic>;
      return raw
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> p) => LatLng(
                (p['lat'] as num).toDouble(),
                (p['lng'] as num).toDouble(),
              ))
          .toList();
    } catch (_) {
      return <LatLng>[];
    }
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
