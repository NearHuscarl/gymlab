import 'dart:convert';

class ExerciseSummary {
  ExerciseSummary({
    this.id,
    this.name,
    this.description,
    this.imageCount,
    this.thumbnailImageIndex,
    this.keywords,
    this.favorite,
  });

  final int id;
  final String name;
  final String description;
  final int imageCount;
  final int thumbnailImageIndex;
  final List<String> keywords;
  final bool favorite;

  factory ExerciseSummary.fromJson(Map<String, dynamic> map) {
    return ExerciseSummary(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageCount: map['imageCount'],
      thumbnailImageIndex: map['thumbnailImageIndex'],
      keywords: List<String>.from(json.decode(map['keywords']) ?? []),
      favorite: map['favorite'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageCount': imageCount,
        'thumbnailImageIndex': thumbnailImageIndex,
        'keywords': keywords,
        'favorite': favorite,
      };
}

class ExerciseSummaries {
  ExerciseSummaries({this.exercises});

  final List<ExerciseSummary> exercises;
  int get totalResults => exercises.length;
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
