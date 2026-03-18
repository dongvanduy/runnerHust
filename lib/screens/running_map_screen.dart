import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/run_tracking_service.dart';

class RunningMapScreen extends StatefulWidget {
  const RunningMapScreen({Key? key}) : super(key: key);

  @override
  State<RunningMapScreen> createState() => _RunningMapScreenState();
}

class _RunningMapScreenState extends State<RunningMapScreen> {
  final Color brandColor = const Color(0xFFccff00);
  final RunTrackingService _trackingService = RunTrackingService.instance;

  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _trackingService,
      builder: (context, _) {
        final List<LatLng> routePoints = _trackingService.routePoints;
        final LatLng initialTarget = routePoints.isNotEmpty
            ? routePoints.last
            : const LatLng(10.762622, 106.660172);

        final Set<Marker> markers = routePoints.isEmpty
            ? <Marker>{}
            : <Marker>{
                Marker(
                  markerId: const MarkerId('current_position'),
                  position: routePoints.last,
                ),
              };

        final Set<Polyline> polylines = routePoints.length < 2
            ? <Polyline>{}
            : <Polyline>{
                Polyline(
                  polylineId: const PolylineId('run_route'),
                  points: routePoints,
                  width: 6,
                  color: brandColor,
                ),
              };

        if (_mapController != null && routePoints.isNotEmpty) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(routePoints.last),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: initialTarget, zoom: 17),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                polylines: polylines,
                markers: markers,
                onMapCreated: (controller) => _mapController = controller,
              ),
              Container(color: Colors.white.withOpacity(0.2)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusChip(Icons.wb_sunny_outlined, '32°C'),
                          _buildStatusChip(Icons.wifi_tethering, _trackingService.gpsStatus),
                        ],
                      ),
                      Column(
                        children: [
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
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSubStat(Icons.height,
                                  '${_trackingService.formatElevationGainMeters()} m', 'Elevation Gain'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                      color: brandColor, shape: BoxShape.circle),
                                  child: const Icon(Icons.keyboard_double_arrow_right,
                                      size: 36),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: brandColor, width: 2),
                                  ),
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
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFE8F3D6), borderRadius: BorderRadius.circular(20)),
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
        Icon(icon, color: Colors.black87, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }
}
