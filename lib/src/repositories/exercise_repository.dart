import '../models/exercise_summary.dart';
import '../providers/sqlite_provider/exercise_provider.dart';

class ExerciseRepository {
  Future<ExerciseSummary> getSummaryById(int id) => ExerciseProvider.db.getSummaryById(id);

  Future<ExerciseSummaries> getAllSummaries() => ExerciseProvider.db.getAllSummaries();
}
