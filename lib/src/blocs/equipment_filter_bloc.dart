import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../blocs/toggle_bloc.dart';
import '../models/exercise_summary.dart';
import '../helpers/disposable.dart';

class EquipmentFilterBloc extends Disposable {
  EquipmentFilterBloc({this.onFilterChange}) {
    _equipments = BehaviorSubject<List<Equipment>>();
    _includeBloc = ToggleBloc(initialValue: true);
  }

  final ValueChanged<EquipmentFilterData> onFilterChange;

  List<Equipment> _selectedEquipmentsRaw = [];

  ToggleBloc _includeBloc;
  BehaviorSubject<List<Equipment>> _equipments;

  Observable<List<Equipment>> get selectedEquipments =>
      _equipments.stream.startWith(_selectedEquipmentsRaw);
  Observable<bool> get include => _includeBloc.stream;

  void toggleOption(Equipment equipment, bool add) {
    if (add)
      _selectedEquipmentsRaw.add(equipment);
    else
      _selectedEquipmentsRaw.remove(equipment);
    _equipments.sink.add(_selectedEquipmentsRaw);
    _notifyChange();
  }

  void clearAll() {
    _selectedEquipmentsRaw.clear();
    _equipments.sink.add(_selectedEquipmentsRaw);
    _notifyChange();
  }

  void _notifyChange() {
    onFilterChange(EquipmentFilterData(
      include: _includeBloc.rawValue,
      equipments: _selectedEquipmentsRaw,
    ));
  }

  Future<void> toggleInclude() async {
    _includeBloc.toggle();
    _notifyChange();
  }

  void dispose() {
    _equipments.close();
    _includeBloc.dispose();
  }
}

class EquipmentFilterData {
  EquipmentFilterData({this.equipments = const [], this.include = false});

  final List<Equipment> equipments;
  final bool include;
}
