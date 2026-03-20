import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/google_drive_sync_service.dart';
import '../data/run_history_repository.dart';
import '../models/run_record.dart';
import '../services/run_tracking_service.dart';

class AppState extends ChangeNotifier {
  AppState({
    RunHistoryRepository? historyRepository,
    GoogleDriveSyncService? cloudSyncService,
  })  : _historyRepository = historyRepository ?? RunHistoryRepository(),
        _cloudSyncService = cloudSyncService ?? GoogleDriveSyncService();

  final RunHistoryRepository _historyRepository;
  final GoogleDriveSyncService _cloudSyncService;

  final RunTrackingService trackingService = RunTrackingService();

  List<RunRecord> _history = <RunRecord>[];
  bool _isLoadingHistory = true;
  bool _syncing = false;
  Locale _locale = const Locale('en');

  List<RunRecord> get history => _history;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get syncing => _syncing;
  Locale get locale => _locale;

  Future<void> bootstrap() async {
    _history = await _historyRepository.getAllRuns();
    _isLoadingHistory = false;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  Future<void> startRunTracking() => trackingService.startTracking();

  Future<void> stopRunAndSave() async {
    final Duration duration = trackingService.duration;
    final double distance = trackingService.distanceKm;

    if (duration.inSeconds < 5 || distance <= 0) {
      await trackingService.stopAndReset();
      return;
    }

    final DateTime now = DateTime.now();
    final List<Map<String, double>> route = trackingService.routePoints
        .map((LatLng p) => <String, double>{'lat': p.latitude, 'lng': p.longitude})
        .toList();

    final RunRecord run = RunRecord(
      id: null,
      title: 'Run ${now.day}/${now.month}/${now.year}',
      startedAt: now,
      durationSeconds: duration.inSeconds,
      distanceKm: distance,
      avgPaceMinPerKm: trackingService.averagePaceMinPerKm,
      calories: trackingService.calories,
      elevationGainMeters: trackingService.elevationGainMeters,
      routeJson: jsonEncode(route),
    );

    final int id = await _historyRepository.insertRun(run);
    _history = <RunRecord>[run.copyWith(id: id), ..._history];

    await trackingService.stopAndReset();
    notifyListeners();
  }

  Future<void> syncHistoryToGoogleDrive() async {
    _syncing = true;
    notifyListeners();
    try {
      await _cloudSyncService.uploadRuns(_history);
    } finally {
      _syncing = false;
      notifyListeners();
    }
  }
}
