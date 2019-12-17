import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    this.child,
    this.primary = true,
    @required this.onPressed,
  });

  final Widget child;
  final bool primary;
  final VoidCallback onPressed;

  Color get _color => primary ? Colors.pink : Colors.indigo.shade50;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: _color,
      disabledColor: _color,
      padding: primary ? EdgeInsets.symmetric(horizontal: 40, vertical: 20) : null,
      textColor: primary ? Colors.pink.shade50 : Colors.indigo,
      elevation: primary ? 3 : 1,
      onPressed: onPressed,
      child: child,
    );
  }
}
