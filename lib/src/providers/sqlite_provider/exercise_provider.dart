import 'package:sqflite/sqflite.dart';

import '_db_helper.dart';
import '../../models/exercise_summary.dart';
import '../../models/exercise_detail.dart';

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

  Future<ExerciseSummaries> getSummariesByMuscleCategory(String muscle) async {
    final db = await database;
    final exerciseMuscleTable = DbHelper.exerciseMuscleTable;
    final favoriteTable = DbHelper.favoriteTable;
    final res = await db.rawQuery('''
SELECT id, name, description, imageCount, thumbnailImageIndex, keywords, favorite
FROM $tableName

INNER JOIN $exerciseMuscleTable
ON $tableName.id = $exerciseMuscleTable.exerciseId
AND Exercise_Muscle.muscleId = ?

INNER JOIN $favoriteTable
ON $tableName.id = $favoriteTable.exerciseId
''', [muscle]);

    return ExerciseSummaries(
        exercises: res.isNotEmpty
            ? res.map((c) => ExerciseSummary.fromJson(c)).toList()
            : <ExerciseSummary>[]);
  }

  Future<ExerciseSummaries> getAllSummaries() async {
    final db = await database;
    final List<Map> res = await db.query(tableName);

    return ExerciseSummaries(
        exercises: res.isNotEmpty
            ? res.map((c) => ExerciseSummary.fromJson(c)).toList()
            : <ExerciseSummary>[]);
  }

  Future<ExerciseDetail> getDetailById(int id) async {
    final db = await database;
    final res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ExerciseDetail.fromJson(res.first) : null;
  }

  Future<void> updateFavorite(int id, bool favorite) async {
    final db = await database;

    await db.update(
      DbHelper.favoriteTable,
      {'favorite': favorite},
      where: 'exerciseId = ?',
      whereArgs: [id],
    );
  }
}
