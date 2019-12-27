import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '_db_helper.dart';
import 'exercise_provider.query.dart';
import '../../models/exercise_summary.dart';
import '../../models/exercise_detail.dart';
import '../../models/exercise_stats.dart';
import '../../models/muscle_stats.dart';
import '../../models/exercise_heatmap.dart';

/// ```
/// 'calves|secondary,cardio|secondary,quads|primary'
/// -> [{'calves: 'secondary}, ...]
/// ```
Iterable<Map<String, String>> _parseMuscle(String muscleInfos) {
  return muscleInfos.split(',').map((m) {
    final muscleInfo = m.split('|');
    if (muscleInfo.length == 2)
      return {
        'muscle': muscleInfo[0],
        'target': muscleInfo[1],
      };
    return {};
  });
}

ExerciseSummary _parseSummary(Map<String, dynamic> m) {
  return ExerciseSummary.fromJson(
    m.map((k, v) {
      if (k == 'equipments') return MapEntry(k, v.split(','));
      return MapEntry(k, v);
    }),
  );
}

Future<ExerciseSummaries> _computeExerciseSummariesResult(
  List<Map<String, dynamic>> result,
) async {
  return ExerciseSummaries(
      exercises: result.isNotEmpty
          ? result.map((m) => _parseSummary(m)).toList()
          : <ExerciseSummary>[]);
}

ExerciseDetail _parseDetail(Map<String, dynamic> m) {
  return ExerciseDetail.fromJson(m.map((k, v) {
    if (k == 'equipments') {
      return MapEntry(k, v.split(','));
    }
    if (k == 'muscles') {
      return MapEntry(k, _parseMuscle(v));
    }
    return MapEntry(k, v);
  }));
}

Future<ExerciseDetail> _computeExerciseDetailResult(
  List<Map<String, dynamic>> result,
) async {
  return result.isNotEmpty ? _parseDetail(result.first) : null;
}

Future<ExerciseStats> _computeStatisticResult(
  List<Map<String, dynamic>> result,
) async {
  return result.isNotEmpty ? ExerciseStats.fromJson(result.first) : null;
}

ExerciseHeatMapItem _parseHeatMapItem(Map<String, dynamic> m) {
  return ExerciseHeatMapItem.fromJson(m.map((k, v) {
    if (k == 'muscles') {
      return MapEntry(k, _parseMuscle(v));
    }
    return MapEntry(k, v);
  }));
}

Future<MuscleStats> _computeMuscleGroupCountResult(
  Map<String, dynamic> result,
) async {
  return result.isNotEmpty ? MuscleStats.fromJson(result) : null;
}

Future<ExerciseHeatMap> _computeHeatMapResult(
  Map<String, dynamic> result,
) async {
  result['exercises'] =
      result['exercises'].map((m) => _parseHeatMapItem(m)).toList();
  return result.isNotEmpty ? ExerciseHeatMap.fromJson(result) : null;
}

class ExerciseProvider {
  ExerciseProvider._();

  String get tableName => ExerciseQuery.exerciseTable;
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

  Future<ExerciseSummaries> getSummariesByMuscleCategory(String muscle) async {
    final db = await database;
    final res = await db.rawQuery(
      ExerciseQuery.selectSummariesByMuscleQuery,
      [muscle],
    );

    return _computeExerciseSummariesResult(res);
  }

  Future<ExerciseSummaries> getAllFavorites() async {
    final db = await database;
    final res = await db.rawQuery(ExerciseQuery.selectFavorites);

    return compute(_computeExerciseSummariesResult, res);
  }

  Future<ExerciseSummaries> getAllSummaries() async {
    final db = await database;
    final res = await db.query(tableName);

    return compute(_computeExerciseSummariesResult, res);
  }

  Future<ExerciseDetail> getDetailById(int id) async {
    final db = await database;
    final res =
        await db.rawQuery(ExerciseQuery.selectAllByExerciseIdQuery, [id]);

    return compute(_computeExerciseDetailResult, res);
  }

  Future<void> updateFavorite(int id, bool favorite) async {
    final db = await database;

    await db.insert(
      ExerciseQuery.favoriteTable,
      {
        'exerciseId': id,
        'favorite': favorite,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ExerciseStats> getStatistic(
    int exerciseId,
    String date,
  ) async {
    final db = await database;
    final res = await db.rawQuery(
      ExerciseQuery.selectStatisticQuery,
      [exerciseId, date],
    );

    return compute(_computeStatisticResult, res);
  }

  Future<void> updateStatistic(
    int exerciseId,
    String date,
    List<Map<String, dynamic>> data,
  ) async {
    final db = await database;

    await db.insert(
      ExerciseQuery.statisticTable,
      {
        'exerciseId': exerciseId,
        'date': date,
        'data': json.encode(data),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MuscleStats> getMuscleGroupCount(
    String dateFrom,
    String dateTo,
  ) async {
    final db = await database;
    final res = await db.rawQuery(
      ExerciseQuery.selectMuscleGroupCountQuery,
      [dateFrom, dateTo, dateFrom, dateTo],
    );

    final result = Map<String, dynamic>();

    result['dateFrom'] = dateFrom;
    result['dateTo'] = dateTo;
    result['muscles'] = res;

    return compute(_computeMuscleGroupCountResult, result);
  }

  Future<ExerciseHeatMap> getExerciseHeatMapStats(
    String dateFrom,
    String dateTo,
  ) async {
    final db = await database;
    final res = await db.rawQuery(
      ExerciseQuery.selectExerciseHeatMapQuery,
      [dateFrom, dateTo],
    );

    final result = Map<String, dynamic>();

    result['dateFrom'] = dateFrom;
    result['dateTo'] = dateTo;
    result['exercises'] = res;

    return compute(_computeHeatMapResult, result);
  }
}
