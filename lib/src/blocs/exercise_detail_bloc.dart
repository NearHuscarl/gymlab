import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_detail.dart';
import '../helpers/disposable.dart';

class ExerciseDetailBloc extends Disposable {
  ExerciseDetailBloc(this.exerciseId);

  // TODO: convert to stream and use stream transform or something
  final int exerciseId;

  final _repository = ExerciseRepository();
  final _exerciseDetail = PublishSubject<ExerciseDetail>();
  final _favorite = BehaviorSubject<bool>();

  Observable<bool> get favorite => _favorite.startWith(false);
  Observable<ExerciseDetail> get detail => _exerciseDetail.stream;

  Future<void> getById() async {
    final exercise = await _repository.getDetailById(exerciseId);
    _favorite.sink.add(exercise.favorite);
    _exerciseDetail.sink.add(exercise);
  }

  Future<void> updateFavorite(bool favorite) async {
    await _repository.updateFavorite(exerciseId, favorite);
    _favorite.sink.add(favorite);
  }

  void dispose() {
    _exerciseDetail.close();
    _favorite.close();
  }
}
