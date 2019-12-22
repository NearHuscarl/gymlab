// https://stackoverflow.com/a/55173692/9449426
import 'package:intl/intl.dart';

String trimLast0(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}

extension ExtendedIterable<E> on Iterable<E> {
  /// Array grouping utility method, [by] is the sub-array length
  /// ```
  /// const inputs = <String>['20', '10', '22', '11', '25', '13'];
  ///
  /// inputs.group(2); // [[20, 10], [22, 11], [25, 13]]
  /// inputs.group(3); // [[20, 10, 22], [11, 25, 13]]
  /// inputs.group(4); // [[20, 10, 22, 11], [25, 13]]
  /// inputs.group(4, emptyValue: -1); // [[20, 10, 22, 11], [25, 13, -1, -1]]
  /// ```
  List<List<E>> group(int by, {E emptyValue}) {
    final result = <List<E>>[];
    final subArray = <E>[];

    var index = 1;
    this.forEach((i) {
      subArray.add(i);
      if (index % by == 0) {
        result.add(List<E>.from(subArray));
        subArray.clear();
      }
      if (index == this.length && subArray.isNotEmpty) {
        final lastChild = List<E>.from(subArray);
        if (emptyValue != null) {
          lastChild.addAll(
            List<E>.generate(by - subArray.length, (i) => emptyValue),
          );
        }
        result.add(lastChild);
      }
      index++;
    });

    return result;
  }

  /// Like Iterable<E>.map but callback have index as second argument
  Iterable<T> mapIndex<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}

extension ExtendedDateTime on DateTime {
  static final isoDateFormat = DateFormat('yyyy-MM-dd');

  /// DateTime().toIsoDate() -> '2019-12-22'
  String toIsoDate() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toDisplayDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
