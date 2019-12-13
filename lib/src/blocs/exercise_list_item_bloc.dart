import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../helpers/disposable.dart';

typedef PlayCallback = void Function(bool);

class ExerciseListItemBloc extends Disposable {
  ExerciseListItemBloc(this.exerciseId, this.initialFavorite);

  // TODO: convert to stream and use stream transform or something
  final int exerciseId;
  final bool initialFavorite;

  final _repository = ExerciseRepository();
  final _favorite = BehaviorSubject<bool>();

  Observable<bool> get favorite => _favorite.startWith(initialFavorite);

  Future<void> updateFavorite(bool favorite) async {
    await _repository.updateFavorite(exerciseId, favorite);
    _favorite.sink.add(favorite);
  }

  void dispose() {
    _favorite.close();
  }
}
