import 'dart:convert';

class RunRecord {
  const RunRecord({
    required this.id,
    required this.title,
    required this.startedAt,
    required this.durationSeconds,
    required this.distanceKm,
    required this.avgPaceMinPerKm,
    required this.calories,
    required this.elevationGainMeters,
    required this.routeJson,
  });

  final int? id;
  final String title;
  final DateTime startedAt;
  final int durationSeconds;
  final double distanceKm;
  final double avgPaceMinPerKm;
  final double calories;
  final double elevationGainMeters;
  final String routeJson;

  String get formattedDistance => distanceKm.toStringAsFixed(2);

  String get formattedDuration {
    final Duration duration = Duration(seconds: durationSeconds);
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedPace {
    if (avgPaceMinPerKm <= 0 || avgPaceMinPerKm.isInfinite) return '0\'00"';
    final int minute = avgPaceMinPerKm.floor();
    int second = ((avgPaceMinPerKm - minute) * 60).round();
    int safeMinute = minute;
    if (second == 60) {
      safeMinute += 1;
      second = 0;
    }
    return '$safeMinute\'${second.toString().padLeft(2, '0')}"';
  }


  RunRecord copyWith({
    int? id,
    String? title,
    DateTime? startedAt,
    int? durationSeconds,
    double? distanceKm,
    double? avgPaceMinPerKm,
    double? calories,
    double? elevationGainMeters,
    String? routeJson,
  }) {
    return RunRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      startedAt: startedAt ?? this.startedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceKm: distanceKm ?? this.distanceKm,
      avgPaceMinPerKm: avgPaceMinPerKm ?? this.avgPaceMinPerKm,
      calories: calories ?? this.calories,
      elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
      routeJson: routeJson ?? this.routeJson,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'started_at': startedAt.toIso8601String(),
      'duration_seconds': durationSeconds,
      'distance_km': distanceKm,
      'avg_pace_min_per_km': avgPaceMinPerKm,
      'calories': calories,
      'elevation_gain_meters': elevationGainMeters,
      'route_json': routeJson,
    };
  }

  factory RunRecord.fromMap(Map<String, dynamic> map) {
    return RunRecord(
      id: map['id'] as int?,
      title: map['title'] as String,
      startedAt: DateTime.parse(map['started_at'] as String),
      durationSeconds: map['duration_seconds'] as int,
      distanceKm: (map['distance_km'] as num).toDouble(),
      avgPaceMinPerKm: (map['avg_pace_min_per_km'] as num).toDouble(),
      calories: (map['calories'] as num).toDouble(),
      elevationGainMeters: (map['elevation_gain_meters'] as num).toDouble(),
      routeJson: map['route_json'] as String,
    );
  }

  Map<String, dynamic> toCloudJson() {
    return {
      'id': id,
      'title': title,
      'startedAt': startedAt.toIso8601String(),
      'durationSeconds': durationSeconds,
      'distanceKm': distanceKm,
      'avgPaceMinPerKm': avgPaceMinPerKm,
      'calories': calories,
      'elevationGainMeters': elevationGainMeters,
      'route': jsonDecode(routeJson),
    };
  }
}
