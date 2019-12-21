import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_detail.dart';
import '../helpers/disposable.dart';
import 'toggle_bloc.dart';

class ExerciseDetailBloc extends Disposable {
  ExerciseDetailBloc(this.exerciseId) {
    _showEditProgressBloc = ToggleBloc(initialValue: false);
  }

  final int exerciseId;
  final _repository = ExerciseRepository();

  final _exerciseDetail = PublishSubject<ExerciseDetail>();
  final _favorite = BehaviorSubject<bool>();
  ToggleBloc _showEditProgressBloc;

  Observable<bool> get showEditProgress => _showEditProgressBloc.stream;
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

  void closeEditProgress() {
    _showEditProgressBloc.change(false);
  }

  void toggleShowEditProgress() {
    _showEditProgressBloc.toggle();
  }

  void saveProgressData(List<List<String>> rawData, DateTime date) {
    final data = rawData
        .where((d) => d[0].isNotEmpty || d[1].isNotEmpty)
        .map((d) => {
              'weight': double.tryParse(d[0]) ?? 0,
              'rep': int.tryParse(d[1]) ?? 0,
            })
        .toList();
    _repository.updateStatistic(exerciseId, date.toIso8601String(), data);
  }

  void dispose() {
    _exerciseDetail.close();
    _showEditProgressBloc.dispose();
    _favorite.close();
  }
}
