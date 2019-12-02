import 'dart:convert';

import 'package:gymlab/src/helpers/enum.dart';

import 'muscle_info.dart';
import 'variation.dart';

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

class Exercise {
  Exercise({
    this.id,
    this.name,
    this.description,
    this.equipments,
    this.imageCount,
    this.thumbnailImageIndex,
    this.muscles,
    this.type,
    this.variation,
    this.keywords,
  });

  final int id;
  final String name;
  final String description;
  final List<Equipment> equipments;
  final int imageCount;
  final int thumbnailImageIndex;
  final List<MuscleInfo> muscles;
  final ExerciseType type;
  final Variation variation;
  final List<String> keywords;

  factory Exercise.fromJson(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      equipments: EnumHelper.fromStrings(
          Equipment.values, map['equipments']),
      imageCount: map['imageCount'],
      thumbnailImageIndex: map['thumbnailImageIndex'],
      muscles: List<MuscleInfo>.from(
          map['muscles']?.map((m) => MuscleInfo.fromJson(m)) ?? []),
      type: EnumHelper.fromString(ExerciseType.values, map['type']),
      variation: Variation.fromJson(json.decode(map['variation'])),
      keywords: List<String>.from(json.decode(map['keywords']) ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'equipments':
            List<dynamic>.from(equipments.map((x) => EnumHelper.parse(x))),
        'imageCount': imageCount,
        'thumbnailImageIndex': thumbnailImageIndex,
        'muscles': List<dynamic>.from(muscles.map((x) => x.toJson())),
        'type': EnumHelper.parse(type),
        'variation': variation.toJson(),
        'keywords': keywords,
      };
}
