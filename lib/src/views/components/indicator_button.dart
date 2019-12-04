import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'fractionally_sized_button.dart';

class IndicatorButton extends StatelessWidget {
  IndicatorButton({
    this.sizeFactor,
    this.fractionaloffsets,
    @required this.onPressed,
  });

  /// first element is width factor, second is height factor
  final List<double> sizeFactor;

  /// first element is FractionalOffset.dx, second is FractionalOffset.dy
  final List<double> fractionaloffsets;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final widthFactor = sizeFactor[0];
    final heightFactor = sizeFactor[1];
    final debugColor = false && kDebugMode;

    return FractionallySizedButton(
      heightFactor: heightFactor,
      widthFactor: widthFactor,
      alignment: FractionalOffset(fractionaloffsets[0], fractionaloffsets[1]),
      onPressed: onPressed,
      color: debugColor ? Colors.red.withOpacity(.3) : Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
    );
  }
}
