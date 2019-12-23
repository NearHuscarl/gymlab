import 'dart:convert';

import 'exercise_summary.dart';
import 'muscle_info.dart';
import 'variation.dart';
import '../helpers/enum.dart';

class ExerciseDetail {
  ExerciseDetail({
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
    this.favorite,
  });

  ExerciseDetail.fromSummary(ExerciseSummary summary)
      : id = summary.id,
        name = summary.name,
        description = '',
        equipments = [],
        imageCount = summary.imageCount,
        thumbnailImageIndex = summary.thumbnailImageIndex,
        muscles = [],
        type = null,
        variation = Variation(),
        keywords = summary.keywords,
        favorite = false;

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
  final bool favorite;

  factory ExerciseDetail.fromJson(Map<String, dynamic> map) {
    return ExerciseDetail(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      equipments: EnumHelper.fromStrings(Equipment.values, map['equipments']),
      imageCount: map['imageCount'],
      thumbnailImageIndex: map['thumbnailImageIndex'],
      muscles: List<MuscleInfo>.from(
          map['muscles']?.map((m) => MuscleInfo.fromJson(m))),
      type: EnumHelper.fromString(ExerciseType.values, map['type']),
      variation: Variation.fromJson(json.decode(map['variation'] ?? 'null')),
      keywords: List<String>.from(json.decode(map['keywords'] ?? '[]')),
      favorite: map['favorite'] == 1 ? true : false,
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
        'favorite': favorite,
      };
}
