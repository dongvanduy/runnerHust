import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RunTrackingService extends ChangeNotifier {
  RunTrackingService._();

  static final RunTrackingService instance = RunTrackingService._();

  static const double _defaultWeightKg = 70;

  final Location _location = Location();
  final List<LatLng> _routePoints = <LatLng>[];

  StreamSubscription<Position>? _positionSubscription;
  Timer? _durationTimer;

  Duration _duration = Duration.zero;
  double _distanceMeters = 0;
  double _elevationGainMeters = 0;
  bool _isTracking = false;
  String _gpsStatus = 'Initializing';

  List<LatLng> get routePoints => List<LatLng>.unmodifiable(_routePoints);
  Duration get duration => _duration;
  double get distanceKm => _distanceMeters / 1000;
  double get elevationGainMeters => _elevationGainMeters;
  bool get isTracking => _isTracking;
  String get gpsStatus => _gpsStatus;

  double get averagePaceMinPerKm {
    if (_distanceMeters <= 0) return 0;
    return (_duration.inSeconds / 60) / distanceKm;
  }

  double get calories {
    // Running calories ước tính: kcal ≈ kg * km * 1.036
    return _defaultWeightKg * distanceKm * 1.036;
  }

  Future<void> startTracking() async {
    if (_isTracking) return;

    final bool ready = await _ensureLocationReady();
    if (!ready) {
      _gpsStatus = 'Permission denied';
      notifyListeners();
      return;
    }

    _gpsStatus = 'GPS Active';
    _isTracking = true;

    _durationTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      _duration += const Duration(seconds: 1);
      notifyListeners();
    });

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3,
      ),
    ).listen(_handlePositionUpdate);

    notifyListeners();
  }

  Future<void> pauseTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _durationTimer?.cancel();
    _durationTimer = null;
    _isTracking = false;
    _gpsStatus = 'Paused';
    notifyListeners();
  }

  Future<void> stopAndReset() async {
    await pauseTracking();
    _routePoints.clear();
    _duration = Duration.zero;
    _distanceMeters = 0;
    _elevationGainMeters = 0;
    _lastPosition = null;
    _gpsStatus = 'Ready';
    notifyListeners();
  }

  Position? _lastPosition;

  void _handlePositionUpdate(Position position) {
    final LatLng newPoint = LatLng(position.latitude, position.longitude);

    if (_routePoints.isNotEmpty) {
      final LatLng lastPoint = _routePoints.last;
      final double segmentDistance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );

      _distanceMeters += segmentDistance;

      final Position? previousPosition = _lastPosition;
      if (previousPosition != null) {
        final double gain = position.altitude - previousPosition.altitude;
        if (gain > 0) {
          _elevationGainMeters += gain;
        }
      }
    }

    _lastPosition = position;
    _routePoints.add(newPoint);
    notifyListeners();
  }

  Future<bool> _ensureLocationReady() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.grantedLimited) {
      return false;
    }

    LocationPermission geoPermission = await Geolocator.checkPermission();
    if (geoPermission == LocationPermission.denied) {
      geoPermission = await Geolocator.requestPermission();
    }

    return geoPermission == LocationPermission.always ||
        geoPermission == LocationPermission.whileInUse;
  }

  String formatDuration() {
    final int hours = _duration.inHours;
    final int minutes = _duration.inMinutes.remainder(60);
    final int seconds = _duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String formatDistanceKm() => distanceKm.toStringAsFixed(2);

  String formatAveragePace() {
    if (averagePaceMinPerKm == 0 || averagePaceMinPerKm.isInfinite) {
      return '0\'00"';
    }

    final int minutes = averagePaceMinPerKm.floor();
    int seconds = ((averagePaceMinPerKm - minutes) * 60).round();
    int safeMinutes = minutes;
    if (seconds == 60) {
      safeMinutes += 1;
      seconds = 0;
    }
    return '$safeMinutes\'${seconds.toString().padLeft(2, '0')}"';
  }

  String formatCalories() => calories.round().toString();

  String formatElevationGainMeters() => elevationGainMeters.toStringAsFixed(0);
}
