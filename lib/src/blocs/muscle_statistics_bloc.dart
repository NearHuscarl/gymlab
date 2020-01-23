import 'dart:math';

import 'package:rxdart/rxdart.dart';
import '../repositories/exercise_repository.dart';
import '../helpers/dart_helper.dart';
import '../helpers/disposable.dart';
import '../helpers/enum.dart';
import '../models/muscle_stats.dart';

enum MuscleFilter {
  primaryOnly,
  primaryAndSecodary,
}
enum DateOption {
  today,
  oneWeekAgo,
  oneMonthAgo,
  sixMonthsAgo,
  oneYearAgo,
}
final dateOptionMessage = {
  DateOption.today: 'Today',
  DateOption.oneWeekAgo: '1 week ago',
  DateOption.oneMonthAgo: '1 month ago',
  DateOption.sixMonthsAgo: '6 months ago',
  DateOption.oneYearAgo: '1 year ago',
};
final dateOptionTime = {
  DateOption.today: (DateTime today) => today.subtract(Duration(hours: 24)),
  DateOption.oneWeekAgo: (DateTime today) =>
      today.subtract(Duration(hours: 24 * 7)),
  DateOption.oneMonthAgo: (DateTime today) => DateTime(
      today.year, today.month - 1, today.day, today.hour, today.minute),
  DateOption.sixMonthsAgo: (DateTime today) => DateTime(
      today.year, today.month - 6, today.day, today.hour, today.minute),
  DateOption.oneYearAgo: (DateTime today) => DateTime(
      today.year, today.month - 12, today.day, today.hour, today.minute),
};

class MuscleStatisticsBloc extends Disposable {
  MuscleStatisticsBloc() {
    _dateOption = BehaviorSubject<DateOption>();
    _muscleFilter = BehaviorSubject<MuscleFilter>();
  }

  static final initialDateOption = DateOption.oneMonthAgo;
  static final initialMuscleFilter = MuscleFilter.primaryOnly;

  ExerciseRepository _repository = ExerciseRepository();

  BehaviorSubject<DateOption> _dateOption;
  BehaviorSubject<MuscleFilter> _muscleFilter;

  Observable<DateOption> get dateOption =>
      _dateOption.stream.startWith(initialDateOption);
  Observable<MuscleFilter> get muscleFilter =>
      _muscleFilter.stream.startWith(initialMuscleFilter);
  Observable<StatisticsState> get _state =>
      dateOption.distinct().switchMap(_mapInputToState);

  Observable<StatisticsState> get state =>
      Observable.combineLatest2<StatisticsState, MuscleFilter, StatisticsState>(
        _state,
        muscleFilter,
        (state, muscleFilter) {
          if (state is _StatisticsResult) {
            return StatisticsPopulated(
              _getChartData(state.result, muscleFilter),
            );
          }

          return state;
        },
      );

  Function get setDate => _dateOption.sink.add;
  Function get setPrimaryMuscleOnly => _muscleFilter.sink.add;

  void dispose() {
    _dateOption.close();
    _muscleFilter.close();
  }

  Stream<StatisticsState> _mapInputToState(DateOption dateOption) async* {
    yield StatisticsLoading();

    try {
      final dateTo = DateTime.now();
      final dateFrom = dateOptionTime[dateOption](dateTo);
      final stats = await _repository.getMuscleGroupCount(
        dateFrom.toIsoDate(),
        dateTo.toIsoDate(),
      );

      if (stats.muscles.isEmpty) {
        yield StatisticsNotFound();
      } else {
        yield _StatisticsResult(stats);
      }
    } catch (e) {
      yield StatisticsError();
    }
  }

  List<MapEntry<String, double>> _getChartData(
      MuscleStats data, MuscleFilter filter) {
    final primaryOnly = filter == MuscleFilter.primaryOnly;
    final totalExercises = primaryOnly
        ? data.totalExercisesUsingPrimaryMuscles
        : data.totalExercises;
    final entryList = data.muscles
        .map(
          (m) => MapEntry(
            EnumHelper.parseWord(m.muscle),
            (primaryOnly ? m.primaryMuscleCount : m.muscleCount) /
                totalExercises *
                100,
          ),
        )
        .toList();

    // Display the first 5 items and group the rest in Other label
    final totalMainItem = min(data.muscles.length, 5);
    final mainEntries = entryList.take(totalMainItem).toList();
    final otherEntries = entryList.sublist(totalMainItem, entryList.length);
    final otherEntriesPercentage =
        otherEntries.fold(0.0, (total, e) => total + e.value);

    if (otherEntriesPercentage > 0) {
      mainEntries.add(MapEntry('Other', otherEntriesPercentage));
    }

    return mainEntries;
  }
}

class StatisticsState {}

class StatisticsNotFound extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsError extends StatisticsState {}

class StatisticsPopulated extends StatisticsState {
  StatisticsPopulated(this.result);
  final List<MapEntry<String, double>> result;
}

class _StatisticsResult extends StatisticsState {
  _StatisticsResult(this.result);
  final MuscleStats result;
}
