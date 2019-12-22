import 'package:gymlab/src/models/exercise_summary.dart';

class ExercisePeriodStats {
  ExercisePeriodStats({
    this.exercises,
    this.dateFrom,
    this.dateTo,
  });

  final List<ExerciseSummary> exercises;
  final String dateFrom;
  final String dateTo;

  factory ExercisePeriodStats.fromJson(Map<String, dynamic> map) {
    return ExercisePeriodStats(
      exercises: List<ExerciseSummary>.from(map['exercises']),
      dateFrom: map['dateFrom'],
      dateTo: map['dateTo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'dateFrom': dateFrom,
        'dateTo': dateTo,
      };
}
