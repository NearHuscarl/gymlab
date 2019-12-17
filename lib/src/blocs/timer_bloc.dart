import 'package:rxdart/rxdart.dart';
import '../helpers/disposable.dart';

enum TimerStatus {
  running,
  pause,
  stop,
}

class TimerBloc extends Disposable {
  TimerBloc() {
    _timerStatus = BehaviorSubject<TimerStatus>();
    _counter = BehaviorSubject<int>();
  }

  BehaviorSubject<TimerStatus> _timerStatus;
  BehaviorSubject<int> _counter;

  Observable<TimerStatus> get status =>
      _timerStatus.stream.startWith(TimerStatus.stop);
  Observable<int> get counter =>
      _counter.stream.startWith(0);

  void setStatus(TimerStatus status) {
    _timerStatus.sink.add(status);
  }

  void setCounter(int counter) {
    _counter.sink.add(counter);
  }

  void dispose() {
    _timerStatus.close();
    _counter.close();
  }
}
