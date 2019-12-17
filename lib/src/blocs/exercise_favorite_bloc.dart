import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';
import '../models/muscle_info.dart';
import '../helpers/disposable.dart';
import '../helpers/exercises.dart';
import 'equipment_filter_bloc.dart';
import 'search_bloc.dart';
import 'toggle_bloc.dart';

class ExerciseFavoriteBloc extends Disposable {
  ExerciseFavoriteBloc() {
    _searchBloc = SearchBloc();
    _showSearchBarBloc = ToggleBloc(initialValue: false);
    _showEquipmentFilterBloc = ToggleBloc(initialValue: false);
    _equipmentFilter = BehaviorSubject<EquipmentFilterData>();
    _exercises = PublishSubject<ExerciseSummaries>();
  }

  final _repository = ExerciseRepository();

  SearchBloc _searchBloc;
  ToggleBloc _showSearchBarBloc;
  ToggleBloc _showEquipmentFilterBloc;
  BehaviorSubject<EquipmentFilterData> _equipmentFilter;
  PublishSubject<ExerciseSummaries> _exercises;

  Observable<bool> get showSearchBar => _showSearchBarBloc.stream;
  Observable<bool> get showEquipmentFilter => _showEquipmentFilterBloc.stream;
  Observable<EquipmentFilterData> get equipmentFilter =>
      _equipmentFilter.startWith(EquipmentFilterData());
  Observable<Map<Muscle, ExerciseSummaries>> get summaries => Observable
          .combineLatest3<ExerciseSummaries, List<String>, EquipmentFilterData, ExerciseSummaries>(
        _exercises,
        _searchBloc.stream,
        equipmentFilter,
        _search,
      ).switchMap(_mapSummaryToSummaryCategory);

  static ExerciseSummaries _search(
    ExerciseSummaries summaries,
    List<String> searchTerms,
    EquipmentFilterData equipmentData,
  ) {
    return ExerciseSummaries(
      exercises: summaries.exercises.where((e) {
        final name = e.name.toLowerCase();
        final nameFilter = filterByName(searchTerms, name, e.keywords);
        final equipmentFilter = filterByEquipment(equipmentData, e.equipments);

        return nameFilter && equipmentFilter;
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
  Future<void> toggleEquipmentFilter() async {
    _showSearchBarBloc.change(false);
    _showEquipmentFilterBloc.toggle();
  }

  Function(String) get updateSearchTerm => _searchBloc.updateSearchTerm;
  void updateEquipmentFilter(EquipmentFilterData filter) =>
      _equipmentFilter.add(filter);

  Future<void> getFavorite() async {
    final summaries = await _repository.getAllFavorites();
    _exercises.sink.add(summaries);
  }

  void dispose() {
    _showSearchBarBloc.dispose();
    _showEquipmentFilterBloc.dispose();
    _exercises.close();
    _searchBloc.dispose();
    _equipmentFilter.close();
  }
}
