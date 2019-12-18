class ExerciseQuery {
  static final String exerciseTable = 'Exercise';
  static final String exerciseMuscleTable = 'Exercise_Muscle';
  static final String exerciseEquipmentTable = 'Exercise_Equipment';
  static final String favoriteTable = 'Favorite';
  static const List<String> summaryColumns = [
    'id',
    'name',
    'GROUP_CONCAT(equipmentId) as equipments',
    'imageCount',
    'thumbnailImageIndex',
    'keywords',
    'IFNULL(favorite, 0) as favorite',
    'muscleId AS muscle',
    'CASE WHEN variation IS NULL THEN 0 ELSE 1 END AS hasVariation',
  ];
  static const List<String> detailColumns = [
    'id',
    'name',
    'GROUP_CONCAT(equipmentId) as equipments',
    'description',
    'imageCount',
    'thumbnailImageIndex',
    "GROUP_CONCAT(muscleId || '|' || target) as muscles",
    'type',
    'variation',
    'keywords',
    'IFNULL(favorite, 0) as favorite',
  ];

  static final String selectSummariesByMuscleQuery = '''
SELECT ${summaryColumns.join(', ')}
FROM $exerciseTable

INNER JOIN $exerciseMuscleTable
ON $exerciseTable.id = $exerciseMuscleTable.exerciseId
AND $exerciseMuscleTable.muscleId = ?

LEFT JOIN $favoriteTable
ON $exerciseTable.id = $favoriteTable.exerciseId

INNER JOIN $exerciseEquipmentTable
ON $exerciseTable.id = $exerciseEquipmentTable.exerciseId
GROUP BY id
''';

  static final String selectFavorites = '''
SELECT ${summaryColumns.join(', ')}
FROM $exerciseTable

INNER JOIN $exerciseMuscleTable
ON $exerciseTable.id = $exerciseMuscleTable.exerciseId
AND $exerciseMuscleTable.target == 'primary'

LEFT JOIN $favoriteTable
ON $exerciseTable.id = $favoriteTable.exerciseId

INNER JOIN $exerciseEquipmentTable
ON $exerciseTable.id = $exerciseEquipmentTable.exerciseId

WHERE $favoriteTable.favorite = 1
GROUP BY id
''';

  static final String selectAllByExerciseIdQuery = '''
SELECT ${detailColumns.join(', ')}
FROM $exerciseTable

LEFT JOIN $favoriteTable
ON $exerciseTable.id = $favoriteTable.exerciseId

INNER JOIN $exerciseMuscleTable -- 208
ON $exerciseTable.id = $exerciseMuscleTable.exerciseId

INNER JOIN $exerciseEquipmentTable -- 311
ON $exerciseTable.id = $exerciseEquipmentTable.exerciseId

WHERE id = ?
GROUP BY id
''';

  static final String selectMusclesByExerciseIdQuery = '''
SELECT muscleId as muscle, target
FROM $exerciseTable

INNER JOIN $exerciseMuscleTable -- 208
ON $exerciseTable.id = $exerciseMuscleTable.exerciseId

WHERE id = ?
''';

  static final String selectEquipmentsByExerciseIdQuery = '''
SELECT equipmentId
FROM $exerciseTable

INNER JOIN $exerciseEquipmentTable -- 311
ON $exerciseTable.id = $exerciseEquipmentTable.exerciseId

WHERE id = ?
''';
}
