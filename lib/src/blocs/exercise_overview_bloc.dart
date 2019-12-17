import 'package:rxdart/rxdart.dart';

import '../repositories/exercise_repository.dart';
import '../models/exercise_summary.dart';
import '../models/muscle_info.dart';
import '../helpers/enum.dart';
import '../helpers/exercises.dart';
import '../helpers/disposable.dart';
import 'equipment_filter_bloc.dart';
import 'search_bloc.dart';
import 'toggle_bloc.dart';

class ExerciseOverviewBloc extends Disposable {
  ExerciseOverviewBloc() {
    _searchBloc = SearchBloc();
    _showSearchBarBloc = ToggleBloc(initialValue: false);
    _showEquipmentFilterBloc = ToggleBloc(initialValue: false);
    _showFavoriteOnlyBloc = ToggleBloc(initialValue: false);
    _equipmentFilter = BehaviorSubject<EquipmentFilterData>();
    _exercises = BehaviorSubject<ExerciseSummaries>();
  }

  final _repository = ExerciseRepository();

  ToggleBloc _showSearchBarBloc;
  ToggleBloc _showEquipmentFilterBloc;
  SearchBloc _searchBloc;
  ToggleBloc _showFavoriteOnlyBloc;
  BehaviorSubject<EquipmentFilterData> _equipmentFilter;
  BehaviorSubject<ExerciseSummaries> _exercises;

  Observable<bool> get showSearchBar => _showSearchBarBloc.stream;
  Observable<bool> get showEquipmentFilter => _showEquipmentFilterBloc.stream;
  Observable<bool> get showFavoriteOnly => _showFavoriteOnlyBloc.stream;
  Observable<EquipmentFilterData> get equipmentFilter =>
      _equipmentFilter.startWith(EquipmentFilterData());
  Observable<ExerciseSummaries> get summaries => Observable.combineLatest4<
          ExerciseSummaries,
          List<String>,
          bool,
          EquipmentFilterData,
          ExerciseSummaries>(
        _exercises,
        _searchBloc.stream,
        showFavoriteOnly,
        equipmentFilter,
        _search,
      );

  Future<void> toggleShowSearchBar() async {
    _showEquipmentFilterBloc.change(false);
    _showSearchBarBloc.toggle();
  }

  Future<void> toggleEquipmentFilter() async {
    _showSearchBarBloc.change(false);
    _showEquipmentFilterBloc.toggle();
  }

  Function(String) get updateSearchTerm => _searchBloc.updateSearchTerm;
  void toggleShowFavoriteOnly() => _showFavoriteOnlyBloc.toggle();
  void updateEquipmentFilter(EquipmentFilterData filter) =>
      _equipmentFilter.add(filter);

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
    List<String> searchTerms,
    bool favoriteOnly,
    EquipmentFilterData equipmentData,
  ) {
    return ExerciseSummaries(
      exercises: summaries.exercises.where((e) {
        final name = e.name.toLowerCase();
        final nameFilter = filterByName(searchTerms, name, e.keywords);
        final favoriteFilter = favoriteOnly ? e.favorite : true;
        final equipmentFilter = filterByEquipment(equipmentData, e.equipments);

        return nameFilter && favoriteFilter && equipmentFilter;
      }).toList(),
    );
  }

  void dispose() {
    _showSearchBarBloc.dispose();
    _showEquipmentFilterBloc.dispose();
    _exercises.close();
    _searchBloc.dispose();
    _showFavoriteOnlyBloc.dispose();
    _equipmentFilter.close();
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
