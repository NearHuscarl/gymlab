import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_detail.dart';

class ExerciseDetailBloc {
  final _repository = ExerciseRepository();
  final _exerciseDetail = PublishSubject<ExerciseDetail>();

  Observable<ExerciseDetail> get detail => _exerciseDetail.stream;

  Future<void> getById(int exerciseId) async {
    final exercises = await _repository.getDetailById(exerciseId);
    _exerciseDetail.sink.add(exercises);
  }

  void dispose() {
    _exerciseDetail.close();
  }
}
