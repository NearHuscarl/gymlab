import 'package:flutter/material.dart';

/// https://stackoverflow.com/a/55282550/9449426
class ReassembleListener extends StatefulWidget {
  const ReassembleListener({Key key, this.onReassemble, this.child})
      : super(key: key);

  final VoidCallback onReassemble;
  final Widget child;

  @override
  _ReassembleListenerState createState() => _ReassembleListenerState();
}

class _ReassembleListenerState extends State<ReassembleListener> {
  @override
  void reassemble() {
    super.reassemble();
    if (widget.onReassemble != null) {
      widget.onReassemble();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void dispose() {
    super.dispose();
  }

  Future<bool> handlePop() async {
    print('pop me');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handlePop,
      child: widget.child,
    );
  }
}
