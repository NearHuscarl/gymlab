import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise.dart';

class ExerciseBloc {
  final _repository = ExerciseRepository();
  final _exercises = PublishSubject<List<Exercise>>();

  Observable<List<Exercise>> get stream => _exercises.stream;

  getAll() async {
    final exercises = await _repository.getAll();
    _exercises.sink.add(exercises);
  }

  dispose() {
    _exercises.close();
  }
}

final exerciseBloc = ExerciseBloc();
