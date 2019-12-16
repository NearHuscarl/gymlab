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
  }

  BehaviorSubject<TimerStatus> _timerStatus;

  Observable<TimerStatus> get status =>
      _timerStatus.stream.startWith(TimerStatus.stop);

  void setStatus(TimerStatus status) {
    _timerStatus.sink.add(status);
  }

  void dispose() {
    _timerStatus.close();
  }
}
