import 'muscle_info.dart';
import '../helpers/enum.dart';

class ExerciseHeatMapItem {
  ExerciseHeatMapItem({
    this.id,
    this.name,
    this.date,
    this.imageCount,
    this.thumbnailImageIndex,
    this.muscles,
    this.favorite,
  });

  final int id;
  final String name;
  final String date;
  final int imageCount;
  final int thumbnailImageIndex;
  final List<MuscleInfo> muscles;
  final bool favorite;

  factory ExerciseHeatMapItem.fromJson(Map<String, dynamic> map) {
    return ExerciseHeatMapItem(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      imageCount: map['imageCount'],
      thumbnailImageIndex: map['thumbnailImageIndex'],
      muscles: List<MuscleInfo>.from(
          map['muscles']?.map((m) => MuscleInfo.fromJson(m))),
      favorite: map['favorite'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date,
        'imageCount': imageCount,
        'thumbnailImageIndex': thumbnailImageIndex,
        'muscles': muscles,
        'favorite': favorite,
      };
}

class ExerciseHeatMap {
  ExerciseHeatMap({
    this.exercises,
    this.dateFrom,
    this.dateTo,
  });

  final List<ExerciseHeatMapItem> exercises;
  final String dateFrom;
  final String dateTo;

  factory ExerciseHeatMap.fromJson(Map<String, dynamic> map) {
    return ExerciseHeatMap(
      exercises: List<ExerciseHeatMapItem>.from(map['exercises']),
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
