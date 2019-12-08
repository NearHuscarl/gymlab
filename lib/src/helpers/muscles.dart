import '../models/muscle_info.dart';

enum BodyDirection { front, back }

bool shouldDisplay(Muscle muscle, BodyDirection bodyDirection) {
  if (muscle == Muscle.cardio) return true;

  if (isMuscleInFront(muscle)) {
    return bodyDirection == BodyDirection.front;
  }
  return bodyDirection == BodyDirection.back;
}

bool isMuscleInFront(Muscle muscle) {
  if (muscle == Muscle.cardio) throw Exception('Cardio is not a muscle');

  switch (muscle) {
    case Muscle.shoulders:
    case Muscle.biceps:
    case Muscle.chest:
    case Muscle.forearms:
    case Muscle.abs:
    case Muscle.obliques:
    case Muscle.quads:
    case Muscle.abductors:
    case Muscle.adductors:
      return true;

    default:
      return false;
  }
}