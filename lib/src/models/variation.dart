import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';
import '../helpers/enum.dart';

enum GripType {
  /// Underhand grip is when your palms are facing towards you as you grip the
  /// bar
  underhand,

  /// Overhand grip is when your palms are facing away from you as you grip the
  /// bar
  overhand,

  /// Neutral grip is when the palm of your hand are facing each other as you
  /// grip the handles
  neutral,
}
enum GripWidth {
  /// Narrow grip is about 2 inches or so in from the shoulder width, or just
  /// beyound hip width
  narrow,

  /// Normal grip is a shoulder-width grip
  normal,

  /// A wide grip is a grip that is wider than shoulder width. Around 6 inches
  /// wider than shoulder-width is average
  wide,
}
enum WeightType {
  /// A long metal bar where disks of varying weights are attached at each end
  barbell,

  /// A short, weighted bar used typically in pairs for exercise or muscle-building
  dumbbell,

  /// A curved variant of the barbell that is often used for various exercises
  ezBar,

  /// A large cast-iron ball-shaped weight with a single handle
  kettlebell,

  /// Using only your bodyweight
  noWeight,

  /// Plates can be added to barbells, ez-bars and dumbbells, or used on their own
  weightPlate,
}
enum RepetitionsSpeed {
  /// Regular tempo. 1 second lifting the weight, and one second lowering it
  k11,

  /// Extended tempo. 2 seconds lifting the weight, and two seconds lowering it
  k22,

  /// Strength building tempo. 2 seconds lifting the weight and a slower four
  /// seconds lowering it
  k24,
}

class Variation {
  Variation({
    this.gripType = const [],
    this.gripWidth = const [],
    this.weightType = const [],
    this.repetitionsSpeed = const [],
  });

  final List<GripType> gripType;
  final List<GripWidth> gripWidth;
  final List<WeightType> weightType;
  final List<RepetitionsSpeed> repetitionsSpeed;

  factory Variation.fromJson(Map<String, dynamic> json) => json == null
      ? Variation()
      : Variation(
          gripType: EnumHelper.fromStrings(GripType.values, json['gripType']),
          gripWidth:
              EnumHelper.fromStrings(GripWidth.values, json['gripWidth']),
          weightType:
              EnumHelper.fromStrings(WeightType.values, json['weightType']),
          repetitionsSpeed: EnumHelper.fromStrings(RepetitionsSpeed.values,
              json['repetitionsSpeed']?.map((x) => 'k$x')),
        );

  Map<String, dynamic> toJson() => {
        'gripType': List<String>.from(gripType.map((x) => EnumHelper.parse(x))),
        'gripWidth':
            List<String>.from(gripWidth.map((x) => EnumHelper.parse(x))),
        'weightType':
            List<String>.from(weightType.map((x) => EnumHelper.parse(x))),
        'repetitionsSpeed':
            List<String>.from(repetitionsSpeed.map((x) => EnumHelper.parse(x))),
      };

  bool get isEmpty =>
      this.gripType.isEmpty &&
      this.gripWidth.isEmpty &&
      this.weightType.isEmpty &&
      this.repetitionsSpeed.isEmpty;

  bool operator ==(Object other) {
    if (other is Variation) {
      return listEquals(gripType, other.gripType) &&
          listEquals(gripWidth, other.gripWidth) &&
          listEquals(weightType, other.weightType) &&
          listEquals(repetitionsSpeed, other.repetitionsSpeed);
    }
    return false;
  }

  int get hashCode => hash4(gripType, gripWidth, weightType, repetitionsSpeed);
}
