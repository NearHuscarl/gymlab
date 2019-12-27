import 'package:rxdart/rxdart.dart';
import '../repositories/exercise_repository.dart';
import '../models/exercise_heatmap.dart';
import '../helpers/disposable.dart';
import '../helpers/dart_helper.dart';

class HeatMapStatisticsBloc extends Disposable {
  HeatMapStatisticsBloc() {
    _visibleDateRange = BehaviorSubject<List<DateTime>>();
    _selectedExercises = BehaviorSubject<List<ExerciseHeatMapItem>>();
  }

  static const calendarTotalVisbleDays = 5 * 7;
  static final initialVisibleDateRange = [
    DateTime.now().subtract(Duration(days: calendarTotalVisbleDays)),
    DateTime.now().add(Duration(days: calendarTotalVisbleDays)),
  ];

  ExerciseRepository _repository = ExerciseRepository();

  BehaviorSubject<List<DateTime>> _visibleDateRange;
  BehaviorSubject<List<ExerciseHeatMapItem>> _selectedExercises;

  Observable<List<ExerciseHeatMapItem>> get selectedExercises =>
      _selectedExercises.stream;
  Observable<HeatMapState> get state => _visibleDateRange
      .startWith(initialVisibleDateRange)
      .distinct()
      .switchMap(_mapInputToState);

  void setVisibleDateRange(DateTime from, DateTime to) {
    return _visibleDateRange.sink.add([from, to]);
  }

  void setSelectedExercises(List<ExerciseHeatMapItem> exercises) {
    _selectedExercises.sink.add(exercises);
  }

  void dispose() {
    _visibleDateRange.close();
    _selectedExercises.close();
  }

  Stream<HeatMapState> _mapInputToState(
      List<DateTime> visibleDateRange) async* {
    try {
      final dateFrom = visibleDateRange[0];
      final dateTo = visibleDateRange[1];
      final result = await _repository.getExerciseHeatMapStats(
        dateFrom.toIsoDate(),
        dateTo.toIsoDate(),
      );
      final events = Map<DateTime, List<ExerciseHeatMapItem>>();

      result.exercises.forEach((e) {
        events.update(
          DateTime.parse(e.date),
          (l) => l..add(e),
          ifAbsent: () => [e],
        );
      });

      yield HeatMapPopulated(events);
    } catch (e) {
      yield HeatMapError();
    }
  }
}

class HeatMapState {}

class HeatMapError extends HeatMapState {}

class HeatMapPopulated extends HeatMapState {
  HeatMapPopulated(this.result);
  final Map<DateTime, List<ExerciseHeatMapItem>> result;
}
