import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../repositories/exercise_repository.dart';
import '../helpers/dart_helper.dart';
import '../helpers/disposable.dart';
import '../models/exercise_period_stats.dart';

class StatisticsBloc extends Disposable {
  StatisticsBloc() {
    _dateRange = BehaviorSubject<List<DateTime>>();
    _state = BehaviorSubject<ExercisePeriodStats>();
  }

  static final initialDateRange = [
    DateTime.now().subtract(Duration(days: 14)),
    DateTime.now(),
  ];

  ExerciseRepository _repository = ExerciseRepository();

  BehaviorSubject<ExercisePeriodStats> _state;
  BehaviorSubject<List<DateTime>> _dateRange;

  Observable<List<DateTime>> get dateRange => _dateRange.stream;
  Observable<StatisticsState> get state => _dateRange
      .startWith(initialDateRange)
      .distinct((dateRange1, dateRange2) => listEquals(dateRange1, dateRange2))
      .switchMap(_mapInputToState);

  Function get setDate => _dateRange.sink.add;

  void dispose() {
    _dateRange.close();
    _state.close();
  }

  Stream<StatisticsState> _mapInputToState(List<DateTime> dateRange) async* {
    yield StatisticsLoading();

    try {
      final dateFrom = dateRange[0];
      final dateTo = dateRange[1];
      final stats = await _repository.getExercisePeriodStats(
        dateFrom.toIsoDate(),
        dateTo.toIsoDate(),
      );

      if (stats.exercises.isEmpty) {
        yield StatisticsNotFound();
      } else {
        yield StatisticsPopulated(stats);
      }
    } catch (e) {
      yield StatisticsError();
    }
  }
}

class StatisticsState {}

class StatisticsNotFound extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsError extends StatisticsState {}

class StatisticsPopulated extends StatisticsState {
  StatisticsPopulated(this.result);
  final ExercisePeriodStats result;
}
