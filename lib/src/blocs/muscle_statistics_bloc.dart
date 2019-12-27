import 'dart:math';

import 'package:flutter/foundation.dart';
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

class MuscleStatisticsBloc extends Disposable {
  MuscleStatisticsBloc() {
    _dateRange = BehaviorSubject<List<DateTime>>();
    _muscleFilter = BehaviorSubject<MuscleFilter>();
  }

  static final initialDateRange = [
    DateTime.now().subtract(Duration(days: 14)),
    DateTime.now(),
  ];
  static final initialMuscleFilter = MuscleFilter.primaryOnly;

  ExerciseRepository _repository = ExerciseRepository();

  BehaviorSubject<List<DateTime>> _dateRange;
  BehaviorSubject<MuscleFilter> _muscleFilter;

  Observable<List<DateTime>> get dateRange =>
      _dateRange.stream.startWith(initialDateRange);
  Observable<MuscleFilter> get muscleFilter =>
      _muscleFilter.stream.startWith(initialMuscleFilter);
  Observable<StatisticsState> get _state => dateRange
      .distinct((dateRange1, dateRange2) => listEquals(dateRange1, dateRange2))
      .switchMap(_mapInputToState);

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

  Function get setDate => _dateRange.sink.add;
  Function get setPrimaryMuscleOnly => _muscleFilter.sink.add;

  void dispose() {
    _dateRange.close();
    _muscleFilter.close();
  }

  Stream<StatisticsState> _mapInputToState(List<DateTime> dateRange) async* {
    yield StatisticsLoading();

    try {
      final dateFrom = dateRange[0];
      final dateTo = dateRange[1];
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
