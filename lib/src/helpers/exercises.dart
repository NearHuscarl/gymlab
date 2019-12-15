import 'enum.dart';
import '../blocs/equipment_filter_bloc.dart';
import '../models/exercise_summary.dart';
import '../models/variation.dart';

/// filter exercise by [name] and [keywords] with the given [searchTerms] which is a
/// list of words that the user typed in.
bool filterByName(
    List<String> searchTerms, String name, List<String> keywords) {
  return searchTerms.every((term) {
    return name.contains(term) || keywords.any((kw) => kw.contains(term));
  });
}

bool filterByEquipment(EquipmentFilterData filter, List<Equipment> equipments) {
  if (filter.equipments.isEmpty) return true;

  if (filter.include) {
    return equipments.any((e) {
      return filter.equipments.any((fe) => fe == e);
    });
  } else {
    return equipments.every((e) {
      return filter.equipments.every((fe) => fe != e);
    });
  }
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
