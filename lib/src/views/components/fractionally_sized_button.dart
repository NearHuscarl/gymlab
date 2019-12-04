import 'package:flutter/material.dart';

class FractionallySizedButton extends StatelessWidget {
  FractionallySizedButton({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
    @required this.onPressed,
    this.splashColor,
    this.hoverColor,
    this.highlightColor,
    this.color,
    this.elevation,
    this.highlightElevation,
    this.focusElevation,
    this.hoverElevation,
  });

  final double widthFactor;
  final double heightFactor;
  final AlignmentGeometry alignment;
  final VoidCallback onPressed;

  final Color splashColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color color;
  final double elevation;
  final double highlightElevation;
  final double focusElevation;
  final double hoverElevation;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      widthFactor: widthFactor,
      alignment: alignment,
      child: MaterialButton(
        splashColor: splashColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        color: color,
        elevation: elevation,
        highlightElevation: highlightElevation,
        focusElevation: focusElevation,
        hoverElevation: hoverElevation,
        onPressed: onPressed,
      ),
    );
  }
}
