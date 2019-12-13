import 'dart:convert';

import 'muscle_info.dart';
import '../helpers/enum.dart';

class ExerciseSummary {
  ExerciseSummary({
    this.id,
    this.name,
    this.imageCount,
    this.thumbnailImageIndex,
    this.keywords,
    this.muscle,
    this.favorite,
    this.hasVariation,
  });

  final int id;
  final String name;
  final int imageCount;
  final int thumbnailImageIndex;
  final List<String> keywords;
  final Muscle muscle;
  final bool favorite;
  final bool hasVariation;

  String image(int index) => getImage(id, index);

  static String getImage(int id, int index) =>
      'assets/images/exercise_workout_$id\_$index.jpg';

  factory ExerciseSummary.fromJson(Map<String, dynamic> map) {
    return ExerciseSummary(
      id: map['id'],
      name: map['name'],
      imageCount: map['imageCount'],
      thumbnailImageIndex: map['thumbnailImageIndex'],
      keywords: List<String>.from(json.decode(map['keywords'] ?? '[]')),
      muscle: EnumHelper.fromString(Muscle.values, map['muscle']),
      favorite: map['favorite'] == 1 ? true : false,
      hasVariation: map['hasVariation'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageCount': imageCount,
        'thumbnailImageIndex': thumbnailImageIndex,
        'keywords': keywords,
        'muscle': muscle,
        'favorite': favorite,
        'hasVariation': hasVariation,
      };
}

class ExerciseSummaries {
  ExerciseSummaries({this.exercises = const []});

  final List<ExerciseSummary> exercises;
  int get totalResults => exercises.length;
  bool get isEmpty => exercises.isEmpty;
}

enum Equipment {
  none,
  bodyOnly,
  bands,
  foamRoll,
  barbell,
  ezBar,
  kettleBell,
  dumbbell,
  machine,
  cable,
  weightPlate,
  medicineBall,
  exerciseBall,
  bar,
  other,
}

enum ExerciseType {
  weight,
  bodyweight,
  timeBased,
  timeBasedLong,
}
