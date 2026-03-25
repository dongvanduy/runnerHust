import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class RunTrackingService extends ChangeNotifier {
  static const double _defaultWeightKg = 70;

  final loc.Location _location = loc.Location();
  final List<LatLng> _routePoints = <LatLng>[];

  StreamSubscription<geo.Position>? _positionSubscription;
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

  double get calories => _defaultWeightKg * distanceKm * 1.036;

  Future<void> startTracking() async {
    if (_isTracking) return;

    _isTracking = true;
    _gpsStatus = 'Initializing GPS...';
    _durationTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      _duration += const Duration(seconds: 1);
      notifyListeners();
    });
    notifyListeners();

    final bool ready = await _ensureLocationReady();
    if (!ready) {
      _gpsStatus = 'Permission denied';
      _durationTimer?.cancel();
      _durationTimer = null;
      _isTracking = false;
      notifyListeners();
      return;
    }

    _gpsStatus = 'GPS Active';

    final geo.LocationSettings locationSettings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
    );

    final geo.AndroidSettings androidSettings = geo.AndroidSettings(
      accuracy: geo.LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
      foregroundNotificationConfig: const geo.ForegroundNotificationConfig(
        notificationTitle: 'Run tracking is active',
        notificationText: 'Your route is being recorded in background.',
        enableWakeLock: true,
      ),
    );

    final geo.AppleSettings appleSettings = geo.AppleSettings(
      accuracy: geo.LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
      allowBackgroundLocationUpdates: true,
      showBackgroundLocationIndicator: true,
    );

    _positionSubscription = geo.Geolocator.getPositionStream(
      locationSettings: defaultTargetPlatform == TargetPlatform.android
          ? androidSettings
          : defaultTargetPlatform == TargetPlatform.iOS
              ? appleSettings
              : locationSettings,
    ).listen(_handlePositionUpdate);

    notifyListeners();
  }

  Future<void> stopAndReset() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _durationTimer?.cancel();
    _durationTimer = null;
    _isTracking = false;

    _routePoints.clear();
    _duration = Duration.zero;
    _distanceMeters = 0;
    _elevationGainMeters = 0;
    _lastPosition = null;
    _gpsStatus = 'Ready';
    notifyListeners();
  }

  geo.Position? _lastPosition;

  void _handlePositionUpdate(geo.Position position) {
    final LatLng newPoint = LatLng(position.latitude, position.longitude);

    if (_routePoints.isNotEmpty) {
      final LatLng lastPoint = _routePoints.last;
      final double segmentDistance = geo.Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );

      _distanceMeters += segmentDistance;

      final geo.Position? previousPosition = _lastPosition;
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

    loc.PermissionStatus permission = await _location.hasPermission();
    if (permission == loc.PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }

    if (permission != loc.PermissionStatus.granted &&
        permission != loc.PermissionStatus.grantedLimited) {
      return false;
    }

    geo.LocationPermission geoPermission = await geo.Geolocator.checkPermission();
    if (geoPermission == geo.LocationPermission.denied) {
      geoPermission = await geo.Geolocator.requestPermission();
    }

    return geoPermission == geo.LocationPermission.always ||
        geoPermission == geo.LocationPermission.whileInUse;
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
