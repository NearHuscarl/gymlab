import 'package:quiver/core.dart';
import '../helpers/enum.dart';

enum Muscle {
  abs,
  abductors,
  adductors,
  biceps,
  cardio,
  calves,
  chest,
  forearms,
  hamstrings,
  glutes,
  lats,
  lowerBack,
  obliques,
  quads,
  traps,
  triceps,
  shoulders,
}

enum Target { primary, secondary }

class MuscleInfo {
  MuscleInfo({this.muscle, this.target});

  final Muscle muscle;
  final Target target;

  factory MuscleInfo.fromJson(Map<String, dynamic> json) => MuscleInfo(
        muscle: EnumHelper.fromString(Muscle.values, json["muscle"]),
        target: EnumHelper.fromString(Target.values, json["target"]),
      );

  Map<String, dynamic> toJson() => {
        'muscle': EnumHelper.parse(muscle),
        'target': EnumHelper.parse(target),
      };

  bool operator ==(Object other) {
    if (other is MuscleInfo) {
      return muscle == other.muscle && target == other.target;
    }
    return false;
  }

  int get hashCode => hash2(muscle, target);
}
