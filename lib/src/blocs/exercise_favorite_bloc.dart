import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';
import '../models/muscle_info.dart';
import '../helpers/disposable.dart';
import '../helpers/exercises.dart';
import 'search_bloc.dart';
import 'toggle_bloc.dart';

class ExerciseFavoriteBloc extends Disposable {
  ExerciseFavoriteBloc() {
    _searchBloc = SearchBloc();
    _showSearchBarBloc = ToggleBloc(initialValue: false);
    _exercises = PublishSubject<ExerciseSummaries>();
  }

  final _repository = ExerciseRepository();

  SearchBloc _searchBloc;
  ToggleBloc _showSearchBarBloc;
  PublishSubject<ExerciseSummaries> _exercises;

  Observable<bool> get showSearchBar => _showSearchBarBloc.stream;
  Observable<Map<Muscle, ExerciseSummaries>> get summaries => Observable
          .combineLatest2<ExerciseSummaries, List<String>, ExerciseSummaries>(
        _exercises,
        _searchBloc.stream,
        _search,
      ).switchMap(_mapSummaryToSummaryCategory);

  static ExerciseSummaries _search(
    ExerciseSummaries summaries,
    List<String> searchTerms,
  ) {
    return ExerciseSummaries(
      exercises: summaries.exercises.where((e) {
        final name = e.name.toLowerCase();
        final nameFilter = filterName(searchTerms, name, e.keywords);

        return nameFilter;
      }).toList(),
    );
  }

  Stream<Map<Muscle, ExerciseSummaries>> _mapSummaryToSummaryCategory(
    ExerciseSummaries summaries,
  ) async* {
    final favorites = Map<Muscle, ExerciseSummaries>();
    final muscles = Map<Muscle, List<ExerciseSummary>>();

    summaries.exercises.forEach((e) {
      muscles.update(
        e.muscle,
        (l) => l..add(e),
        ifAbsent: () => [e],
      );
    });

    muscles.forEach((muscle, exercises) {
      favorites[muscle] = ExerciseSummaries(exercises: exercises);
    });

    yield favorites;
  }

  Future<void> toggleShowSearchBar() => _showSearchBarBloc.toggle();
  Function(String) get updateSearchTerm => _searchBloc.updateSearchTerm;

  Future<void> getFavorite() async {
    final summaries = await _repository.getAllFavorites();
    _exercises.sink.add(summaries);
  }

  void dispose() {
    _exercises.close();
    _searchBloc.dispose();
    _showSearchBarBloc.dispose();
  }
}
