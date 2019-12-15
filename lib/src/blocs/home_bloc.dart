import 'package:rxdart/rxdart.dart';
import '../helpers/disposable.dart';

enum HomePageSection {
  muscleOption,
  timer,
  statistics,
}

class HomeBloc extends Disposable {
  HomeBloc() {
    _title = BehaviorSubject<String>();
    _currentPage = BehaviorSubject<int>();
  }

  // TODO: change to 0
  static const startPage = 1;

  List<String> _titlesRaw = ['Exercises', 'Timer', 'Statistics'];
  BehaviorSubject<String> _title;
  BehaviorSubject<int> _currentPage;

  Observable<String> get title =>
      _title.stream.startWith(_titlesRaw[startPage]);
  Observable<HomePageSection> get currentPage => _currentPage.stream
      .switchMap(mapPageToSectionEnum)
      .startWith(HomePageSection.values[startPage]);

  void changePage(int pageNumber) {
    _currentPage.sink.add(pageNumber);
    _title.sink.add(_titlesRaw[pageNumber]);
  }

  Stream<HomePageSection> mapPageToSectionEnum(page) async* {
    yield HomePageSection.values[page];
  }

  void dispose() {
    _title.close();
    _currentPage.close();
  }
}
