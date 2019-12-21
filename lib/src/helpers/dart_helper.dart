// https://stackoverflow.com/a/55173692/9449426
String trimLast0(double n) {
  return n.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), '');
}

extension ExtendedIterable<T> on Iterable<T> {
  /// Array grouping utility method, [by] is the sub-array length
  /// ```
  /// const inputs = <String>['20', '10', '22', '11', '25', '13'];
  ///
  /// inputs.group(2); // [[20, 10], [22, 11], [25, 13]]
  /// inputs.group(3); // [[20, 10, 22], [11, 25, 13]]
  /// inputs.group(4); // [[20, 10, 22, 11], [25, 13]]
  /// inputs.group(4, emptyValue: -1); // [[20, 10, 22, 11], [25, 13, -1, -1]]
  /// ```
  List<List<T>> group(int by, {T emptyValue}) {
    final result = <List<T>>[];
    final subArray = <T>[];

    var index = 1;
    this.forEach((i) {
      subArray.add(i);
      if (index % by == 0) {
        result.add(List<T>.from(subArray));
        subArray.clear();
      }
      if (index == this.length && subArray.isNotEmpty) {
        final lastChild = List<T>.from(subArray);
        if (emptyValue != null) {
          lastChild.addAll(
            List<T>.generate(by - subArray.length, (i) => emptyValue),
          );
        }
        result.add(lastChild);
      }
      index++;
    });

    return result;
  }
}
