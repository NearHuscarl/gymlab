import 'package:flutter/material.dart';

class RowWithGap extends StatelessWidget {
  RowWithGap({
    Key key,
    this.gap = 4.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.children = const <Widget>[],
  }) : super(key: key);

  final double gap;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[];

    children.asMap().forEach((i, w) {
      content.add(w);
      if (i != children.length - 1) {
        content.add(SizedBox(width: gap));
      }
    });

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: content,
    );
  }
}
