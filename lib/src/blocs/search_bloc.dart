import 'package:rxdart/rxdart.dart';
import '../helpers/disposable.dart';

class SearchBloc extends Disposable {
  SearchBloc() {
    _searchTerm = BehaviorSubject<String>();
    stream = _searchTerm
        .startWith('')
        .distinct()
        .debounceTime(const Duration(milliseconds: 250))
        .switchMap((str) async* {
      yield str.trim().toLowerCase().split(' ');
    });
  }

  BehaviorSubject<String> _searchTerm;
  Observable<List<String>> stream;
  Function(String) get updateSearchTerm => _searchTerm.add;

  void dispose() {
    _searchTerm.close();
  }
}
