import '../providers/sqlite_provider/exercise_provider.dart';
import '../models/exercise_summary.dart';

class ExerciseRepository {
  Future<ExerciseSummary> getSummaryById(int id) =>
      ExerciseProvider.db.getSummaryById(id);

  Future<ExerciseSummaries> getSummaryByMuscleCategory(String muscle) =>
      ExerciseProvider.db.getSummaryByMuscleCategory(muscle);

  Future<ExerciseSummaries> getAllSummaries() =>
      ExerciseProvider.db.getAllSummaries();
}
