import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';
import '../models/muscle_info.dart';

class ExerciseListFavoriteBloc {
  final _repository = ExerciseRepository();
  final _exercises = PublishSubject<ExerciseSummaries>();

  Observable<Map<Muscle, ExerciseSummaries>> get summaries =>
      _exercises.switchMap<Map<Muscle, ExerciseSummaries>>((summaries) async* {
        final favorites = Map<Muscle, ExerciseSummaries>();
        final muscles = Map<Muscle, List<ExerciseSummary>>();

        summaries.exercises.forEach((e) {
          muscles.update(
            e.muscle,
            (l) => l..add(e),
            ifAbsent: () => [e],
          );
        });

        muscles.forEach((muscle, exercises) {
          favorites[muscle] = ExerciseSummaries(exercises: exercises);
        });

        yield favorites;
      });

  Future<void> getFavorite() async {
    final summaries = await _repository.getAllFavorites();
    _exercises.sink.add(summaries);
  }

  void dispose() {
    _exercises.close();
  }
}
