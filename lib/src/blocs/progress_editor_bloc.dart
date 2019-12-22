import 'package:rxdart/rxdart.dart';
import '../repositories/exercise_repository.dart';
import '../helpers/disposable.dart';
import '../helpers/dart_helper.dart';

class ProgressEditorBloc extends Disposable {
  ProgressEditorBloc(this.exerciseId);

  final int exerciseId;
  static final initialDate = DateTime.now();

  final _repository = ExerciseRepository();

  final _date = BehaviorSubject<DateTime>();
  var _statsRaw = <WeightAndRep>[];
  final _stats = BehaviorSubject<List<WeightAndRep>>();

  Observable<DateTime> get date => _date.stream.startWith(initialDate);
  Observable<List<WeightAndRep>> get stats =>
      _stats.stream.startWith([WeightAndRep()]);

  Future<void> setDate(DateTime date) async {
    _date.sink.add(date);
    final stats = await _repository.getStatistic(
      exerciseId,
      date.toIsoDate(),
    );

    _statsRaw = stats == null
        ? [WeightAndRep()]
        : stats.data.map((i) => WeightAndRep.fromMap(i)).toList();
    _stats.sink.add(_statsRaw);
  }

  void saveData(Iterable<List<String>> data) {
    _statsRaw.clear();

    data.forEach((data) {
      final weightAndRep = WeightAndRep(
        weight: double.tryParse(data[0]) ?? -1,
        rep: int.tryParse(data[1]) ?? -1,
      );

      if (!weightAndRep.isEmpty) {
        _statsRaw.add(weightAndRep);
      }
    });
  }

  void insertNewRow() {
    _statsRaw.add(WeightAndRep());
    _stats.sink.add(_statsRaw);
  }

  void dispose() {
    _date.close();
    _stats.close();
  }
}

class WeightAndRep {
  WeightAndRep({this.weight = -1, this.rep = -1});

  final double weight;
  final int rep;

  bool get isEmpty => weight == -1 && rep == -1;

  String get weightDisplay => weight == -1 ? '' : trimLast0(weight);
  String get repDisplay => rep == -1 ? '' : rep.toString();

  static WeightAndRep fromMap(Map<String, dynamic> map) {
    return WeightAndRep(
      rep: map['rep'].toInt(),
      weight: map['weight'].toDouble(),
    );
  }
}
