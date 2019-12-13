import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';
import '../models/muscle_info.dart';
import '../helpers/enum.dart';
import '../helpers/exercises.dart';
import '../helpers/disposable.dart';
import 'search_bloc.dart';
import 'toggle_bloc.dart';

class ExerciseOverviewBloc extends Disposable {
  ExerciseOverviewBloc() {
    _searchBloc = SearchBloc();
    _showSearchBarBloc = ToggleBloc(initialValue: false);
    _showFavoriteOnlyBloc = ToggleBloc(initialValue: false);
    _exercises = BehaviorSubject<ExerciseSummaries>();
  }

  final _repository = ExerciseRepository();

  SearchBloc _searchBloc;
  ToggleBloc _showSearchBarBloc;
  ToggleBloc _showFavoriteOnlyBloc;
  BehaviorSubject<ExerciseSummaries> _exercises;

  Observable<bool> get showFavoriteOnly => _showFavoriteOnlyBloc.stream;
  Observable<bool> get showSearchBar => _showSearchBarBloc.stream;
  Observable<ExerciseSummaries> get summaries => Observable.combineLatest3<
          ExerciseSummaries, bool, List<String>, ExerciseSummaries>(
        _exercises,
        _showFavoriteOnlyBloc.stream,
        _searchBloc.stream,
        _search,
      );

  Future<void> toggleShowSearchBar() => _showSearchBarBloc.toggle();
  Future<void> toggleShowFavoriteOnly() => _showFavoriteOnlyBloc.toggle();
  Function(String) get updateSearchTerm => _searchBloc.updateSearchTerm;

  Future<void> getAll() async {
    final exercises = await _repository.getAllSummaries();
    _exercises.sink.add(exercises);
  }

  Future<void> getByMuscleCategory(Muscle muscle) async {
    final exercises = await _repository
        .getSummariesByMuscleCategory(EnumHelper.parse(muscle));

    _exercises.sink.add(exercises);
  }

  static ExerciseSummaries _search(
    ExerciseSummaries summaries,
    bool favoriteOnly,
    List<String> searchTerms,
  ) {
    return ExerciseSummaries(
      exercises: summaries.exercises.where((e) {
        final name = e.name.toLowerCase();
        final favoriteFilter = favoriteOnly ? e.favorite : true;
        final nameFilter = filterName(searchTerms, name, e.keywords);

        return nameFilter && favoriteFilter;
      }).toList(),
    );
  }

  void dispose() {
    _showSearchBarBloc.dispose();
    _exercises.close();
    _showFavoriteOnlyBloc.dispose();
    _searchBloc.dispose();
  }
}

class OverviewState {}

class OverviewNotFound extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewError extends OverviewState {}

class OverviewPopulated extends OverviewState {
  OverviewPopulated(this.result);
  final ExerciseSummaries result;
}
