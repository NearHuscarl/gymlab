import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';

class ExerciseListBloc {
  final _repository = ExerciseRepository();
  final _exercises = PublishSubject<ExerciseSummaries>();

  Observable<ExerciseSummaries> get stream => _exercises.stream;

  getAll() async {
    final exercises = await _repository.getAllSummaries();
    _exercises.sink.add(exercises);
  }

  dispose() {
    _exercises.close();
  }
}
