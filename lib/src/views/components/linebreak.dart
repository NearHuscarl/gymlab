import 'package:flutter/material.dart';

class Linebreak extends StatelessWidget {
  Linebreak({this.color = Colors.grey, this.height = 1});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        color: Colors.grey.shade300,
        height: height,
      ),
    );
  }
}
