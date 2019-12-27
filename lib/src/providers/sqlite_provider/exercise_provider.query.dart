class ExerciseQuery {
  static final String exerciseTable = 'Exercise';
  static final String exerciseMuscleTable = 'Exercise_Muscle';
  static final String exerciseEquipmentTable = 'Exercise_Equipment';
  static final String favoriteTable = 'Favorite';
  static final String statisticTable = 'Statistic';

  static const List<String> summaryColumns = [
    'id',
    'name',
    'GROUP_CONCAT(DISTINCT equipmentId) as equipments',
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
    'GROUP_CONCAT(DISTINCT equipmentId) as equipments',
    'description',
    'imageCount',
    'thumbnailImageIndex',
    "GROUP_CONCAT(DISTINCT muscleId || '|' || target) as muscles",
    'type',
    'variation',
    'keywords',
    'IFNULL(favorite, 0) as favorite',
  ];
  static const List<String> heatMapItemColumns = [
    'id',
    'name',
    'date(date) as date',
    'imageCount',
    'thumbnailImageIndex',
    'muscles',
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

  static final String selectStatisticQuery = '''
SELECT exerciseId, name as exerciseName, date(date) AS date, data FROM $statisticTable

LEFT JOIN $exerciseTable
ON $statisticTable.exerciseId = $exerciseTable.id

WHERE exerciseId = ?
AND date(date) = ?
''';

  static final String selectMuscleGroupCountQuery = '''
SELECT CountAll.muscle, muscleCount, IFNULL(primaryMuscleCount, 0) AS primaryMuscleCount FROM (
	SELECT muscleId as muscle, COUNT(muscleId) AS muscleCount
	FROM $exerciseTable

	INNER JOIN $exerciseMuscleTable
	ON $exerciseTable.id = $exerciseMuscleTable.exerciseId

	INNER JOIN $statisticTable
	ON $exerciseTable.id = $statisticTable.exerciseId

	WHERE date($statisticTable.date) BETWEEN ? AND ?

	GROUP BY muscleId
) AS CountAll

LEFT JOIN (
	SELECT muscleId as muscle, COUNT(muscleId) AS primaryMuscleCount
	FROM $exerciseTable

	INNER JOIN $exerciseMuscleTable
	ON $exerciseTable.id = $exerciseMuscleTable.exerciseId

	INNER JOIN $statisticTable
	ON $exerciseTable.id = $statisticTable.exerciseId

	WHERE date($statisticTable.date) BETWEEN ? AND ?
	AND $exerciseMuscleTable.target = 'primary'

	GROUP BY muscleId
) AS CountPrimary

ON CountAll.muscle = CountPrimary.muscle

ORDER BY primaryMuscleCount DESC
''';

  static final String selectExerciseHeatMapQuery = '''
SELECT ${heatMapItemColumns.join(', ')}
FROM $exerciseTable

LEFT JOIN (
	SELECT exerciseId, GROUP_CONCAT(DISTINCT muscleId || '|' || target) as muscles
	FROM $exerciseMuscleTable
	GROUP BY exerciseId
) AS Muscles
ON $exerciseTable.id = Muscles.exerciseId

LEFT JOIN $favoriteTable
ON $exerciseTable.id = $favoriteTable.exerciseId

LEFT JOIN $statisticTable
ON $exerciseTable.id = $statisticTable.exerciseId

WHERE date($statisticTable.date) BETWEEN ? AND ?
''';
}
