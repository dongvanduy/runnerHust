import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/run_record.dart';

class HistoryDetailScreen extends StatefulWidget {
  final RunRecord run;

  const HistoryDetailScreen({Key? key, required this.run}) : super(key: key);

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  late GoogleMapController mapController;
  final Set<Polyline> _polylines = {};

  // Màu xanh neon đặc trưng từ thiết kế
  final Color neonGreen = const Color(0xFFB5FF39);

  @override
  void initState() {
    super.initState();
    _createPolylines();
  }

  void _createPolylines() {
    // Nếu run.route có dữ liệu thật, hãy dùng nó.
    // Ở đây mình tạo một lộ trình vòng cung (giả) quanh 1 điểm trung tâm để giống ảnh thiết kế
    List<LatLng> path = [
      const LatLng(21.028511, 105.804817),
      const LatLng(21.028911, 105.804817),
      const LatLng(21.029211, 105.805817),
      const LatLng(21.028511, 105.806817),
      const LatLng(21.027511, 105.806817),
      const LatLng(21.027511, 105.805817),
      const LatLng(21.028511, 105.804817), // Quay về điểm đầu
    ];

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('run_route'),
        points: path,
        color: neonGreen, // Màu đường vẽ nõn chuối
        width: 6,
        jointType: JointType.round,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Nền xám nhạt
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.run.title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 450, // Chiều cao bao gồm Map và Banner thông số
              child: Stack(
                children: [
                  // 1. Lớp dưới cùng: Bản đồ Google Maps
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 400,
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(21.028511, 105.805817), // Tọa độ trung tâm
                        zoom: 16.0,
                      ),
                      polylines: _polylines,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        // Bạn có thể thêm marker vị trí hiện tại/kết thúc tại đây
                      },
                    ),
                  ),

                  // 2. Lớp đè lên trên: Banner thông số màu nõn chuối
                  Positioned(
                    bottom: 0,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                          color: neonGreen,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMainStat(widget.run.distanceKm.toStringAsFixed(2), 'Km', 'Distance'),
                          Container(height: 40, width: 1, color: Colors.black26), // Đường kẻ dọc
                          _buildMainStat(widget.run.formattedDuration, '', 'Duration'),
                          Container(height: 40, width: 1, color: Colors.black26),
                          _buildMainStat(widget.run.formattedPace, '”', 'Avg Pace'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // 3. Danh sách các card thông số bổ sung (Calories, Bước chân...)
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDetailCard('Step Length', 'Distance between steps', '1,00', 'm'),
                const SizedBox(height: 12),
                _buildDetailCard('Calories', 'Total energy burned', '854', 'kcal'),
                const SizedBox(height: 12),
                _buildDetailCard('Cadence', 'Steps per minute', '212', 'spm'),
                const SizedBox(height: 12),
                _buildDetailCard('Elevation Gain', 'Total height that you climb', '100', 'ft', showBar: true),
                const SizedBox(height: 40),
              ]),
            ),
          )
        ],
      ),
    );
  }

  // Widget hiển thị cột thông số trên nền xanh
  Widget _buildMainStat(String value, String unit, String label) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            if (unit.isNotEmpty) Text(' $unit', style: const TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  // Widget thẻ trắng hiển thị thông số chi tiết
  Widget _buildDetailCard(String title, String subtitle, String value, String unit, {bool showBar = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (showBar) ...[
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(2)),
                )
              ]
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(unit, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}