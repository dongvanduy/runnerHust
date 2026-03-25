import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/run_record.dart';

class RunHistoryRepository {
  static const String _dbName = 'runner_history.db';
  static const int _dbVersion = 1;
  static const String tableName = 'run_history';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final String dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, _dbName),
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            started_at TEXT NOT NULL,
            duration_seconds INTEGER NOT NULL,
            distance_km REAL NOT NULL,
            avg_pace_min_per_km REAL NOT NULL,
            calories REAL NOT NULL,
            elevation_gain_meters REAL NOT NULL,
            route_json TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  Future<List<RunRecord>> getAllRuns() async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      tableName,
      orderBy: 'started_at DESC',
    );
    return rows.map(RunRecord.fromMap).toList();
  }

  Future<int> insertRun(RunRecord run) async {
    final Database db = await database;
    return db.insert(tableName, run.toMap()..remove('id'));
  }
}
