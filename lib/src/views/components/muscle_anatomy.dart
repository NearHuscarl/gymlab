import 'package:flutter/material.dart';
import '../../models/muscle_info.dart';
import '../../helpers/enum.dart';
import '../../helpers/muscles.dart';

class MuscleAnatomy extends StatelessWidget {
  MuscleAnatomy({@required this.primary, this.secondaries = const []});

  final MuscleInfo primary;
  final Iterable<MuscleInfo> secondaries;

  String _getSuffix(MuscleInfo muscle) =>
      muscle.target == Target.primary ? '1' : '2';

  @override
  Widget build(BuildContext context) {
    const imageWidth = 120.0;
    final frontMuscles = secondaries
        .where((m) => isMuscleInFront(m.muscle) && m.muscle != Muscle.cardio)
        .toList();
    final backMuscles = secondaries
        .where((m) => !isMuscleInFront(m.muscle) && m.muscle != Muscle.cardio)
        .toList();

    if (primary.muscle != Muscle.cardio) {
      if (isMuscleInFront(primary.muscle)) {
        frontMuscles.add(primary);
      } else {
        backMuscles.add(primary);
      }
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          if (frontMuscles.isNotEmpty)
            Stack(
              children: <Widget>[
                Image.asset(
                  'assets/images/muscles/muscle_front.png',
                  filterQuality: FilterQuality.high,
                  width: imageWidth,
                ),
              ]..addAll(
                  frontMuscles.map((m) {
                    return Image.asset(
                      'assets/images/muscles/${EnumHelper.parse(m.muscle)}_${_getSuffix(m)}.png',
                      filterQuality: FilterQuality.high,
                      width: imageWidth,
                    );
                  }),
                ),
            ),
          if (backMuscles.isNotEmpty)
            Stack(
              children: <Widget>[
                Image.asset(
                  'assets/images/muscles/muscle_back.png',
                  filterQuality: FilterQuality.high,
                  width: imageWidth,
                ),
              ]..addAll(
                  backMuscles.map((m) {
                    return Image.asset(
                      'assets/images/muscles/${EnumHelper.parse(m.muscle)}_${_getSuffix(m)}.png',
                      filterQuality: FilterQuality.high,
                      width: imageWidth,
                    );
                  }),
                ),
            ),
        ],
      ),
    );
  }
}
