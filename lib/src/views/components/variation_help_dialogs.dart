import 'package:flutter/material.dart';
import 'app_dialog.dart';
import 'linebreak.dart';
import '../../models/variation.dart';
import '../../helpers/enum.dart';
import '../../helpers/exercises.dart';

String _getGripTypeDescription(GripType gripType) {
  switch (gripType) {
    case GripType.underhand:
      return 'Underhand grip is when your palms are facing towards you as you grip the bar';
    case GripType.overhand:
      return 'Overhand grip is when your palms are facing away from you as you grip the bar';
    case GripType.neutral:
      return 'Neutral grip is when the palm of your hand are facing each other as you grip the handles';
    default:
      return '';
  }
}

Widget _getGripTypeHelp(ThemeData theme, GripType gripType) {
  final boldTheme = theme.textTheme.body2;
  final gripTypeWord = EnumHelper.parseWord(gripType);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Flexible(
        flex: 1,
        child: Image.asset(
          getGripTypeImage(gripType, icon: false),
          width: 115,
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        flex: 2,
        child: Column(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(gripTypeWord, style: boldTheme),
                ),
                Positioned(
                  right: 0,
                  top: -15,
                  child: Image.asset(
                    getGripTypeImage(gripType, icon: true),
                    height: 40,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(_getGripTypeDescription(gripType)),
          ],
        ),
      ),
    ],
  );
}

Future<dynamic> showGripTypeHelpDialog(BuildContext context) {
  final theme = Theme.of(context);

  return showAppDialog(
    context: context,
    title: 'Grip Type',
    body: Column(
      mainAxisSize: MainAxisSize.min, // To make the card compact
      children: <Widget>[
        _getGripTypeHelp(theme, GripType.underhand),
        Linebreak(),
        _getGripTypeHelp(theme, GripType.overhand),
        Linebreak(),
        _getGripTypeHelp(theme, GripType.neutral),
      ],
    ),
  );
}

String _getGripWidthDescription(GripWidth gripWidth) {
  switch (gripWidth) {
    case GripWidth.narrow:
      return 'Narrow grip is about 2 inches or so in from the shoulder width, or just beyound hip width';
    case GripWidth.normal:
      return 'Normal grip is a shoulder-width grip';
    case GripWidth.wide:
      return 'A wide grip is a grip that is wider than shoulder width. Around 6 inches wider than shoulder-width is average';
    default:
      return '';
  }
}

Widget _getGripWidthHelp(ThemeData theme, GripWidth gripWidth) {
  final boldTheme = theme.textTheme.body2;
  final gripWidthWord = EnumHelper.parseWord(gripWidth);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Flexible(
        flex: 1,
        child: Image.asset(
          getGripWidthImage(gripWidth, icon: false),
          width: 115,
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        flex: 2,
        child: Column(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(gripWidthWord, style: boldTheme),
                ),
                Positioned(
                  right: 0,
                  top: -4,
                  child: Image.asset(
                    getGripWidthImage(gripWidth, icon: true),
                    height: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(_getGripWidthDescription(gripWidth)),
          ],
        ),
      ),
    ],
  );
}

Future<dynamic> showGripWidthHelpDialog(BuildContext context) {
  final theme = Theme.of(context);

  return showAppDialog(
    context: context,
    title: 'Grip Width',
    body: Column(
      mainAxisSize: MainAxisSize.min, // To make the card compact
      children: <Widget>[
        _getGripWidthHelp(theme, GripWidth.narrow),
        Linebreak(),
        _getGripWidthHelp(theme, GripWidth.normal),
        Linebreak(),
        _getGripWidthHelp(theme, GripWidth.wide),
      ],
    ),
  );
}

String _getWeightTypeDescription(WeightType weightType) {
  switch (weightType) {
    case WeightType.barbell:
      return 'A long metal bar where disks of varying weights are attached at each end';
    case WeightType.dumbbell:
      return 'A short, weighted bar used typically in pairs for exercise or muscle-building';
    case WeightType.ezBar:
      return 'A curved variant of the barbell that is often used for various exercises';
    case WeightType.kettlebell:
      return 'A large cast-iron ball-shaped weight with a single handle';
    case WeightType.weightPlate:
      return 'Plates can be added to barbells, ez-bars and dumbbells, or used on their own';
    case WeightType.noWeight:
      return 'Using only your bodyweight';
    default:
      return '';
  }
}

Widget _getWeightTypeHelp(ThemeData theme, WeightType weightType) {
  final boldTheme = theme.textTheme.body2;
  final weightTypeWord = EnumHelper.parseWord(weightType);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(weightTypeWord, style: boldTheme),
          ),
          Positioned(
            right: 0,
            top: -4,
            child: Image.asset(
              getWeightTypeImage(weightType),
              height: 20,
            ),
          ),
        ],
      ),
      SizedBox(height: 5),
      Text(_getWeightTypeDescription(weightType)),
    ],
  );
}

Future<dynamic> showWeightTypeHelpDialog(BuildContext context) {
  final theme = Theme.of(context);

  return showAppDialog(
    context: context,
    title: 'Weight Type',
    body: Column(
      mainAxisSize: MainAxisSize.min, // To make the card compact
      children: <Widget>[
        _getWeightTypeHelp(theme, WeightType.barbell),
        Linebreak(),
        _getWeightTypeHelp(theme, WeightType.dumbbell),
        Linebreak(),
        _getWeightTypeHelp(theme, WeightType.ezBar),
        Linebreak(),
        _getWeightTypeHelp(theme, WeightType.kettlebell),
        Linebreak(),
        _getWeightTypeHelp(theme, WeightType.weightPlate),
        Linebreak(),
        _getWeightTypeHelp(theme, WeightType.noWeight),
      ],
    ),
  );
}

String _getRepetitionsSpeedDescription(RepetitionsSpeed speed) {
  switch (speed) {
    case RepetitionsSpeed.k11:
      return 'Regular tempo. [one] second lifting the weight, and [one] second lowering it';
    case RepetitionsSpeed.k22:
      return 'Extended tempo. [two] seconds lifting the weight, and [two] seconds lowering it';
    case RepetitionsSpeed.k24:
      return 'Strength building tempo. [two] seconds lifting the weight and a slower [four] seconds lowering it';
    default:
      return '';
  }
}

Widget _getRepetitionsSpeedText(ThemeData theme, RepetitionsSpeed speed) {
  final normalTheme = theme.textTheme.body1;
  final boldTheme = theme.textTheme.body2;

  return RichText(
    text: TextSpan(
      style: normalTheme,
      children: _getRepetitionsSpeedDescription(speed)
          .split(RegExp(r'(\[|\])'))
          .map((s) {
        if (s == 'one' || s == 'two' || s == 'four') {
          return TextSpan(
            text: s,
            style: boldTheme,
          );
        }
        return TextSpan(text: s);
      }).toList(),
    ),
  );
}

Widget _getRepetitionsSpeedHelp(ThemeData theme, RepetitionsSpeed speed) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Flexible(
        flex: 1,
        child: Image.asset(
          getRepetitionsSpeedImage(speed),
          height: 60,
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        flex: 2,
        child: _getRepetitionsSpeedText(theme, speed),
      ),
    ],
  );
}

Future<dynamic> showRepetitionsSpeedHelpDialog(BuildContext context) {
  final theme = Theme.of(context);

  return showAppDialog(
    context: context,
    title: 'Repetitions Speed',
    body: Column(
      mainAxisSize: MainAxisSize.min, // To make the card compact
      children: <Widget>[
        _getRepetitionsSpeedHelp(theme, RepetitionsSpeed.k11),
        Linebreak(),
        _getRepetitionsSpeedHelp(theme, RepetitionsSpeed.k22),
        Linebreak(),
        _getRepetitionsSpeedHelp(theme, RepetitionsSpeed.k24),
      ],
    ),
  );
}
