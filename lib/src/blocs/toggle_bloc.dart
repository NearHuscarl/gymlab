import 'package:rxdart/rxdart.dart';
import '../helpers/disposable.dart';

class ToggleBloc extends Disposable {
  ToggleBloc({bool initialValue}) {
    rawValue = initialValue;
    _switch = BehaviorSubject<bool>();
  }

  bool rawValue;
  BehaviorSubject<bool> _switch;

  Observable<bool> get stream =>
      _switch.stream.startWith(rawValue);

  Future<bool> toggle() async {
    rawValue = !rawValue;
    _switch.sink.add(rawValue);
    return rawValue;
  }

  Future<bool> change(bool value) async {
    rawValue = value;
    _switch.sink.add(rawValue);
    return rawValue;
  }

  void dispose() {
    _switch.close();
  }
}
