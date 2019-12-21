import 'dart:convert';

class ExerciseStats {
  ExerciseStats({
    this.exerciseId,
    this.exerciseName,
    this.date,
    this.data,
  });

  final int exerciseId;
  final String exerciseName;
  final String date;
  final List<Map<String, double>> data;

  factory ExerciseStats.fromJson(Map<String, dynamic> map) {
    // https://github.com/dart-lang/json_serializable/issues/351#issuecomment-431590383
    final data = json.decode(map['data']).map<Map<String, double>>((e) {
      final result = Map<String, double>();
      e.forEach((k, v) {
        result[k] = v.toDouble();
      });
      return result;
    }).toList();

    return ExerciseStats(
      exerciseId: map['exerciseId'],
      exerciseName: map['exerciseName'],
      date: map['date'],
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'date': date,
        'data': data,
      };
}

class ExerciseStatsResult {
  ExerciseStatsResult({this.result = const []});

  final List<ExerciseStats> result;
  int get totalResults => result.length;
}
