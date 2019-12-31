import 'enum.dart';
import '../blocs/equipment_filter_bloc.dart';
import '../models/exercise_summary.dart';
import '../models/variation.dart';
import 'logger.dart';

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

const idMissingLargeImages = {
  132,
  133,
  151,
  152,
  153,
  155,
  156,
  157,
  158,
  159,
  163,
  167,
  169,
  170,
  171,
  172,
  173,
  174,
  175,
  176,
  177,
  178,
  179,
  180,
  181,
  182,
  183,
  184,
  185,
  186,
  187,
  188,
  189,
  190,
  191,
  192,
  193,
  194,
  195,
  196,
  197,
  198,
  199,
  200,
  201,
  204,
  206,
  209,
  210,
  211,
  214,
  295,
  296,
  299,
  300,
  301,
  302,
  303,
  304,
  305,
  306,
  307,
  308,
  309,
  310,
  311,
  312,
  313,
  314,
  315,
  316,
  317,
  318,
  319,
  320,
  321,
  322,
  323,
  324,
  325,
  326,
  46,
  47,
  49,
  50,
  51,
  52,
  53,
  54,
  55,
  56,
  5,
  77,
  78,
  79,
  80,
  81,
  87,
};
String getImage(int id, int index) {
  // TODO: missing large images in some exercises (đụ má thằng Phúc)
  if (idMissingLargeImages.contains(id)) {
    L.warning('Missing image for exercise $id');
    return 'assets/images/exercise_placeholder.jpg';
  }

  // TODO: add images for custom exercises and remove this
  if (id >= 10000)
    return 'assets/images/exercise_placeholder.jpg';
  return 'assets/images/exercises/exercise_workout_$id\_$index.jpg';
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
