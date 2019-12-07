import '_camelcase_to_word.dart';

/// https://github.com/rknell/flutterEnumsToString
/// ```
/// import 'package:enum_to_string:enum_to_string.dart';
///
/// enum TestEnum { testValue1 };
///
/// convert(){
///     String result = EnumToString.parse(TestEnum.testValue1);
///     //result = 'testValue1'
///     final r = EnumToString.fromString(TestEnum.values, "testValue1");
///     // TestEnum.testValue1
/// }
/// ```
class EnumHelper {
  static String parse(enumItem) {
    if (enumItem == null) return null;
    return enumItem.toString().split('.')[1];
  }

  static String parseWord(enumItem) {
    if (enumItem == null) return null;
    final parsed = parse(enumItem);
    return camelCaseToWords(parsed);
  }

  static T fromString<T>(List<T> enumValues, String value) {
    if (value == null || enumValues == null) return null;

    return enumValues.singleWhere(
        (enumItem) =>
            EnumHelper.parse(enumItem)?.toLowerCase() == value?.toLowerCase(),
        orElse: () => null);
  }

  static List<T> fromStrings<T>(List<T> enumValues, Iterable<dynamic> values) {
    if (values == null || enumValues == null) return <T>[];

    return values
        .cast<String>()
        .map((x) => EnumHelper.fromString(enumValues, x))
        .toList();
  }
}
