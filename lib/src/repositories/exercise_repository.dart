import '../providers/sqlite_provider/exercise_provider.dart';
import '../models/exercise_summary.dart';
import '../models/exercise_detail.dart';

class ExerciseRepository {
  Future<ExerciseSummary> getSummaryById(int id) =>
      ExerciseProvider.db.getSummaryById(id);

  Future<ExerciseSummaries> getSummariesByMuscleCategory(String muscle) =>
      ExerciseProvider.db.getSummariesByMuscleCategory(muscle);

  Future<ExerciseSummaries> getAllSummaries() =>
      ExerciseProvider.db.getAllSummaries();

  Future<ExerciseDetail> getDetailById(int id) =>
      ExerciseProvider.db.getDetailById(id);

  Future<void> updateFavorite(int id, bool favorite) =>
      ExerciseProvider.db.updateFavorite(id, favorite);
}
