import 'package:gymlab/src/models/exercise_summary.dart';
import 'package:sqflite/sqflite.dart';

import '_db_helper.dart';

class ExerciseProvider {
  ExerciseProvider._();

  static String get tableName => DbHelper.exerciseTable;
  static final ExerciseProvider db = ExerciseProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB();
    }

    return _database;
  }

  Future<Database> initDB() async {
    await DbHelper.setupDbFile();

    final dbPath = await DbHelper.getDbPath();

    return await openDatabase(
      dbPath,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) {},
    );
  }

  Future<ExerciseSummary> getSummaryById(int id) async {
    final db = await database;
    final res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ExerciseSummary.fromJson(res.first) : null;
  }

  Future<ExerciseSummaries> getAllSummaries() async {
    final db = await database;
    final List<Map> res = await db.query(tableName);

    return ExerciseSummaries(
        exercises: res.isNotEmpty
            ? res.map((c) => ExerciseSummary.fromJson(c)).toList()
            : <ExerciseSummary>[]);
  }
}
