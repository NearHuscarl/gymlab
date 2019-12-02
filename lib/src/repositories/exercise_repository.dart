import '../models/exercise.dart';
import '../providers/sqlite_provider/exercise_provider.dart';

class ExerciseRepository {
  Future<Exercise> getById(int id) => ExerciseProvider.db.getById(id);

  Future<List<Exercise>> getAll() => ExerciseProvider.db.getAll();
}
