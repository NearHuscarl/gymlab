import 'package:gymlab/src/helpers/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';
import '../models/muscle_info.dart';

class ExerciseListBloc {
  final _repository = ExerciseRepository();
  final _exercises = PublishSubject<ExerciseSummaries>();

  Observable<ExerciseSummaries> get summaries => _exercises.stream;

  getAll() async {
    final exercises = await _repository.getAllSummaries();
    _exercises.sink.add(exercises);
  }

  getByMuscleCategory(Muscle muscle) async {
    final exercises = await _repository.getSummaryByMuscleCategory(EnumHelper.parse(muscle));
    _exercises.sink.add(exercises);
  }

  dispose() {
    _exercises.close();
  }
}
