import 'package:flutter_test/flutter_test.dart';
import 'package:gymlab/src/models/exercise_detail.dart';
import 'package:gymlab/src/models/exercise_summary.dart';

import 'package:gymlab/src/models/muscle_info.dart';
import 'package:gymlab/src/models/variation.dart';

void main() {
  test('Test Exercise.fromJson()', () {
    const description =
        "Start in a dead hang with shoulders touching your ears.\nPull yourself up as your hands rotate and when the pull reaches the peak, push your head up and over the rings, while also raising your toes up and push your body up like a normal dip. Complete the muscle up with your elbows in full lock out.";
    final exercise = ExerciseDetail.fromJson({
      "id": 208,
      "name": "Ring Muscleup",
      "description": description,
      "equipments": ["bodyOnly"],
      "imageCount": 3,
      "thumbnailImageIndex": 2,
      "muscles": [
        {"muscle": "lats", "target": "primary"},
        {"muscle": "biceps", "target": "secondary"},
        {"muscle": "triceps", "target": "secondary"}
      ],
      "type": "bodyWeight",
      "variation": {
        "gripType": ["overhand"]
      },
      "keywords": ["ups", "muscle-ups", "rings"]
    });

    expect(exercise.id, 208);
    expect(exercise.name, "Ring Muscleup");
    expect(exercise.description, description);
    expect(exercise.equipments, [Equipment.bodyOnly]);
    expect(exercise.imageCount, 3);
    expect(exercise.thumbnailImageIndex, 2);
    expect(exercise.muscles, [
      MuscleInfo(muscle: Muscle.lats, target: Target.primary),
      MuscleInfo(muscle: Muscle.biceps, target: Target.secondary),
      MuscleInfo(muscle: Muscle.triceps, target: Target.secondary),
    ]);
    expect(exercise.type, ExerciseType.bodyweight);
    expect(exercise.variation, Variation(gripType: [GripType.overhand]));
    expect(exercise.keywords, ["ups", "muscle-ups", "rings"]);
  });

  test('Test Exercise.toJson()', () {
    const description =
        "Start in a dead hang with shoulders touching your ears.\nPull yourself up as your hands rotate and when the pull reaches the peak, push your head up and over the rings, while also raising your toes up and push your body up like a normal dip. Complete the muscle up with your elbows in full lock out.";
    final exercise = ExerciseDetail(
      id: 208,
      name: "Ring Muscleup",
      description: description,
      equipments: [Equipment.bodyOnly],
      imageCount: 3,
      thumbnailImageIndex: 2,
      muscles: [
        MuscleInfo(muscle: Muscle.lats, target: Target.primary),
        MuscleInfo(muscle: Muscle.biceps, target: Target.secondary),
        MuscleInfo(muscle: Muscle.triceps, target: Target.secondary),
      ],
      type: ExerciseType.bodyweight,
      variation: Variation(gripType: [GripType.overhand]),
      keywords: ["ups", "muscle-ups", "rings"],
    );
    final exerciseMap = exercise.toJson();

    expect(exerciseMap['id'], 208);
    expect(exerciseMap['name'], "Ring Muscleup");
    expect(exerciseMap['description'], description);
    expect(exerciseMap['equipments'], ['bodyOnly']);
    expect(exerciseMap['imageCount'], 3);
    expect(exerciseMap['thumbnailImageIndex'], 2);
    expect(exerciseMap['muscles'], [
      {"muscle": "lats", "target": "primary"},
      {"muscle": "biceps", "target": "secondary"},
      {"muscle": "triceps", "target": "secondary"}
    ]);
    expect(exerciseMap['type'], 'bodyweight');
    expect(exerciseMap['variation'], {
      'gripType': ['overhand'],
      'gripWidth': [],
      'weightType': [],
      'repetitionsSpeed': [],
    });
    expect(exerciseMap['keywords'], ["ups", "muscle-ups", "rings"]);
  });
}
