import 'package:gymlab/src/helpers/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';
import '../models/muscle_info.dart';

class ExerciseOverviewBloc {
  final _repository = ExerciseRepository();
  final _exercises = BehaviorSubject<ExerciseSummaries>();
  // combineLatest2 need both sources to emit first value before it can emit
  final _showFavoriteOnly = BehaviorSubject<bool>()
    ..sink
    ..add(false);

  Observable<bool> get showFavoriteOnly => _showFavoriteOnly;
  Observable<ExerciseSummaries> get summaries =>
      Observable.combineLatest2<ExerciseSummaries, bool, ExerciseSummaries>(
        _exercises,
        _showFavoriteOnly,
        (summaries, favoriteOnly) => ExerciseSummaries(
          exercises: summaries.exercises
              .where((e) => favoriteOnly ? e.favorite : true)
              .toList(),
        ),
      );

  Future<void> getAll() async {
    final exercises = await _repository.getAllSummaries();
    _exercises.sink.add(exercises);
  }

  Future<void> getByMuscleCategory(Muscle muscle) async {
    final exercises = await _repository
        .getSummariesByMuscleCategory(EnumHelper.parse(muscle));

    _exercises.sink.add(exercises);
  }

  Future<void> updateShowFavoriteOnly(bool favorite) async {
    _showFavoriteOnly.sink.add(favorite);
  }

  void dispose() {
    _exercises.close();
    _showFavoriteOnly.close();
  }
}
