import 'package:gymlab/src/helpers/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';
import '../models/muscle_info.dart';

class ExerciseOverviewBloc {
  final _repository = ExerciseRepository();
  final _exercises = BehaviorSubject<ExerciseSummaries>();
  // combineLatest2 need both sources to emit first value before it can emit
  final _favorite = BehaviorSubject<bool>()
    ..sink
    ..add(false);

  Observable<bool> get favorite => _favorite;
  Observable<ExerciseSummaries> get summaries =>
      Observable.combineLatest2<ExerciseSummaries, bool, ExerciseSummaries>(
        _exercises,
        _favorite,
        (summaries, favorite) => ExerciseSummaries(
          exercises:
              summaries.exercises.where((e) => e.favorite == favorite).toList(),
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

  Future<void> updateFavorite(bool favorite) async {
    _favorite.sink.add(favorite);
  }

  void dispose() {
    _exercises.close();
    _favorite.close();
  }
}
