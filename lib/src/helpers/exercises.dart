import 'enum.dart';
import '../models/variation.dart';

/// filter exercise by [name] and [keywords] with the given [searchTerms] which is a
/// list of words that the user typed in.
bool filterName(List<String> searchTerms, String name, List<String> keywords) {
  return searchTerms.every((term) {
    return name.contains(term) || keywords.any((kw) => kw.contains(term));
  });
}

String getGripWidthImage(
  GripWidth gripWidth, {
  bool icon = true,
}) =>
    'assets/images/variations/gripwidth_${EnumHelper.parse(gripWidth)}${icon ? '_dark' : ''}.png';

String getGripTypeImage(
  GripType gripType, {
  bool icon = true,
}) =>
    'assets/images/variations/griptype_${EnumHelper.parse(gripType)}${icon ? '_dark' : ''}.png';

String getWeightTypeImage(WeightType weightType) =>
    'assets/images/variations/weighttype_${EnumHelper.parse(weightType).toLowerCase()}_dark.png';

String getRepetitionsSpeedImage(RepetitionsSpeed speed) =>
    'assets/images/variations/repetitionsspeed_${EnumHelper.parse(speed).substring(1)}_dark.png';
