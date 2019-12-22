import '../providers/sqlite_provider/exercise_provider.dart';
import '../models/exercise_summary.dart';
import '../models/exercise_detail.dart';
import '../models/exercise_stats.dart';
import '../models/exercise_period_stats.dart';

class ExerciseRepository {
  Future<ExerciseSummaries> getSummariesByMuscleCategory(String muscle) =>
      ExerciseProvider.db.getSummariesByMuscleCategory(muscle);

  Future<ExerciseSummaries> getAllSummaries() =>
      ExerciseProvider.db.getAllSummaries();

  Future<ExerciseSummaries> getAllFavorites() =>
      ExerciseProvider.db.getAllFavorites();

  Future<ExerciseDetail> getDetailById(int id) =>
      ExerciseProvider.db.getDetailById(id);

  Future<void> updateFavorite(int id, bool favorite) =>
      ExerciseProvider.db.updateFavorite(id, favorite);

  Future<ExerciseStats> getStatistic(int exerciseId, String date) =>
      ExerciseProvider.db.getStatistic(exerciseId, date);

  Future<void> updateStatistic(
          int exerciseId, String date, List<Map<String, dynamic>> data) =>
      ExerciseProvider.db.updateStatistic(exerciseId, date, data);

  Future<ExercisePeriodStats> getExercisePeriodStats(
          String dateFrom, String dateTo) =>
      ExerciseProvider.db.getExercisePeriodStats(dateFrom, dateTo);
}
