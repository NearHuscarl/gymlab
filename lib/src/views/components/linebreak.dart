import 'package:flutter/material.dart';

// TODO: use CustomPainter to optimize rendering
class Linebreak extends StatelessWidget {
  Linebreak({
    this.color = Colors.grey,
    this.height = 1,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
  });

  final Color color;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        color: Colors.grey.shade300,
        height: height,
      ),
    );
  }
}
