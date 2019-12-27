import 'package:flutter/foundation.dart';
import 'muscle_info.dart';
import '../helpers/enum.dart';

class MuscleStats {
  MuscleStats({
    this.muscles,
    this.dateFrom,
    this.dateTo,
  })  : totalExercises = muscles.fold(0, (total, e) => total + e.muscleCount),
        totalExercisesUsingPrimaryMuscles =
            muscles.fold(0, (total, e) => total + e.primaryMuscleCount);

  final List<MuscleCount> muscles;
  final String dateFrom;
  final String dateTo;
  final int totalExercises;
  final int totalExercisesUsingPrimaryMuscles;

  factory MuscleStats.fromJson(Map<String, dynamic> map) {
    return MuscleStats(
      muscles:
          (map['muscles'] as List).map((m) => MuscleCount.fromJson(m)).toList(),
      dateFrom: map['dateFrom'],
      dateTo: map['dateTo'],
    );
  }
}

class MuscleCount {
  MuscleCount({
    @required this.muscle,
    @required this.muscleCount,
    @required this.primaryMuscleCount,
  });

  final Muscle muscle;

  /// Number of exercises that using this primary muscle
  final int muscleCount;

  /// Number of exercises that using this muscle
  final int primaryMuscleCount;

  factory MuscleCount.fromJson(Map<String, dynamic> map) {
    return MuscleCount(
      muscle: EnumHelper.fromString(Muscle.values, map['muscle']),
      muscleCount: map['muscleCount'],
      primaryMuscleCount: map['primaryMuscleCount'],
    );
  }
}
