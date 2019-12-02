import 'package:gymlab/src/models/exercise.dart';
import 'package:sqflite/sqflite.dart';

import '_db_helper.dart';

class ExerciseProvider {
  ExerciseProvider._();

  static String get tableName => DbHelper.exerciseTable;
  static final ExerciseProvider db = ExerciseProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    return await initDB();
  }

  Future<Database> initDB() async {
    final dbPath = await DbHelper.dbPath;

    return await openDatabase(
      dbPath,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) {},
    );
  }

  Future<Exercise> getById(int id) async {
    final db = await database;
    final res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Exercise.fromJson(res.first) : null;
  }

  Future<List<Exercise>> getAll() async {
    final db = await database;
    final List<Map> res = await db.query(tableName);

    return res.isNotEmpty
        ? res.map((c) => Exercise.fromJson(c)).toList()
        : <Exercise>[];
  }
}
