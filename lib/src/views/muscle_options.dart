import 'package:flutter/material.dart';

enum _GymBodyDirection { front, back }

class MuscleOptions extends StatefulWidget {
  @override
  _MuscleOptionsState createState() => _MuscleOptionsState();
}

class _MuscleOptionsState extends State<MuscleOptions> {
  _GymBodyDirection bodyDirection = _GymBodyDirection.front;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.blue.withOpacity(.2),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            crossFadeState: bodyDirection == _GymBodyDirection.front
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Image.asset('assets/images/man_front_xsmall.png'),
            secondChild: Image.asset('assets/images/man_back_xsmall.png'),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 20,
          child: FloatingActionButton(
            onPressed: () => setState(() => bodyDirection =
                bodyDirection == _GymBodyDirection.front
                    ? _GymBodyDirection.back
                    : _GymBodyDirection.front),
            child: Text('180'),
          ),
        )
      ],
    );
  }
}
