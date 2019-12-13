import 'package:rxdart/rxdart.dart';
import '../helpers/disposable.dart';

class ToggleBloc extends Disposable {
  ToggleBloc({bool initialValue}) {
    _switchValue = initialValue;
    _switch = BehaviorSubject<bool>();
  }

  bool _switchValue;
  BehaviorSubject<bool> _switch;

  Observable<bool> get stream =>
      _switch.stream.startWith(_switchValue);

  Future<void> toggle() async {
    _switchValue = !_switchValue;
    _switch.sink.add(_switchValue);
  }

  void dispose() {
    _switch.close();
  }
}
