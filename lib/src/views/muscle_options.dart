import 'package:flutter/material.dart';
import '../models/muscle_info.dart';
import '../helpers/enum.dart';

enum _BodyDirection { front, back }

class MuscleOptions extends StatefulWidget {
  @override
  _MuscleOptionsState createState() => _MuscleOptionsState();
}

class _MuscleOptionsState extends State<MuscleOptions>
    with TickerProviderStateMixin {
  _BodyDirection bodyDirection = _BodyDirection.front;

  AnimationController _rippleController;
  AnimationController _switchController;
  Animation<double> _rippleAnimation;
  Animation<double> _switchAnimation;

  @override
  void initState() {
    super.initState();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rippleAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _rippleController,
      // delay ripple effect for 3s
      curve: Interval(0, .33333333, curve: Curves.easeOut),
    ));
    _switchAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _switchController,
      curve: Curves.easeOut,
    ));

    _rippleController.repeat();
  }

  void _handleSwitchSide() {
    _switchController.forward().then((_) {
      setState(() => bodyDirection = bodyDirection == _BodyDirection.front
          ? _BodyDirection.back
          : _BodyDirection.front);
      return _switchController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: _switchAnimation,
          builder: (context, child) => AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (context, child) => CustomPaint(
              foregroundPainter: _Indicators(
                color: primaryColor,
                rippleAnimationValue: _rippleAnimation.value,
                switchAnimationValue: _switchAnimation.value,
                bodyDirection: bodyDirection,
              ),
              child: child,
            ),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 600),
              crossFadeState: bodyDirection == _BodyDirection.front
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Image.asset('assets/images/man_front_xsmall.png'),
              secondChild: Image.asset('assets/images/man_back_xsmall.png'),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 20,
          child: FloatingActionButton(
            onPressed: _handleSwitchSide,
            child: Text('180'),
          ),
        )
      ],
    );
  }
}

class _Indicator {
  const _Indicator({
    @required this.dot,
    @required this.p1,
    @required this.p2,
    this.p3,
    @required this.t,
  });

  /// First element is the ratio of parent container's width. Second is height
  final List<double> dot;
  final List<double> p1;
  final List<double> p2;
  final List<double> p3;

  /// Text!
  final List<double> t;
}

class _Indicators extends CustomPainter {
  _Indicators({
    this.color,
    this.bodyDirection,
    this.rippleAnimationValue,
    this.switchAnimationValue,
  });

  final Color color;
  final _BodyDirection bodyDirection;
  final double rippleAnimationValue;
  final double switchAnimationValue;

  final _indicator = {
    Muscle.cardio: _Indicator(
        dot: [.75, .15], p1: [.94, .15], p2: [.75, .15], t: [.83, .155]),
    Muscle.shoulders: _Indicator(
        dot: [.32, .225],
        p1: [.06, .19],
        p2: [.32, .19],
        p3: [.32, .225],
        t: [.07, .195]),
    Muscle.biceps: _Indicator(
        dot: [.69, .31], p1: [.94, .31], p2: [.69, .31], t: [.825, .315]),
    Muscle.chest: _Indicator(
        dot: [.42, .28], p1: [.06, .28], p2: [.42, .28], t: [.07, .285]),
    Muscle.forearm: _Indicator(
        dot: [.27, .37], p1: [.06, .37], p2: [.27, .37], t: [.07, .375]),
    Muscle.abs: _Indicator(
        dot: [.53, .38],
        p1: [.94, .4],
        p2: [.53, .4],
        p3: [.53, .38],
        t: [.87, .405]),
    Muscle.obliques: _Indicator(
        dot: [.42, .42],
        p1: [.06, .47],
        p2: [.42, .47],
        p3: [.42, .42],
        t: [.07, .475]),
    Muscle.quads: _Indicator(
        dot: [.41, .57], p1: [.06, .57], p2: [.41, .57], t: [.07, .575]),
    Muscle.abductors: _Indicator(
        dot: [.63, .58], p1: [.94, .58], p2: [.63, .58], t: [.775, .585]),
    Muscle.adductors: _Indicator(
        dot: [.53, .62],
        p1: [.94, .67],
        p2: [.53, .67],
        p3: [.53, .62],
        t: [.775, .675]),
    Muscle.traps: _Indicator(
        dot: [.39, .21], p1: [.06, .21], p2: [.39, .21], t: [.07, .215]),
    Muscle.triceps: _Indicator(
        dot: [.28, .31], p1: [.06, .31], p2: [.28, .31], t: [.07, .315]),
    Muscle.lats:
        _Indicator(dot: [.6, .3], p1: [.94, .3], p2: [.6, .3], t: [.86, .305]),
    Muscle.lowerBack: _Indicator(
        dot: [.51, .42], p1: [.06, .42], p2: [.51, .42], t: [.07, .425]),
    Muscle.glutes: _Indicator(
        dot: [.57, .51], p1: [.94, .51], p2: [.57, .51], t: [.83, .515]),
    Muscle.hamstrings: _Indicator(
        dot: [.43, .6], p1: [.06, .6], p2: [.43, .6], t: [.07, .605]),
    Muscle.calves: _Indicator(
        dot: [.41, .76], p1: [.06, .76], p2: [.41, .76], t: [.07, .765]),
  };

  bool _shouldDisplayIndicator(Muscle muscle) {
    if (muscle == Muscle.cardio) return true;

    switch (muscle) {
      case Muscle.shoulders:
      case Muscle.biceps:
      case Muscle.chest:
      case Muscle.forearm:
      case Muscle.abs:
      case Muscle.obliques:
      case Muscle.quads:
      case Muscle.abductors:
      case Muscle.adductors:
        return bodyDirection == _BodyDirection.front;

      default:
        return bodyDirection == _BodyDirection.back;
    }
  }

  /// Used in animation to transform position of all indicators
  List<double> translate = [0, 0];

  Offset offset(Size containerSize, List<double> position) {
    return Offset(
      containerSize.width * (position[0] + translate[0]),
      containerSize.height * (position[1] + translate[1]),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = (1 - switchAnimationValue);
    translate = [0, (-switchAnimationValue * .025)];
    final rippleColorOpacity = (1 - rippleAnimationValue) * 0.75;
    final rippleSize = 8.0 + rippleAnimationValue * 12.0;
    final indicatorColor = color.withOpacity(opacity);

    final dot = Paint()
      ..color = indicatorColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final rippleDot = Paint()
      ..color = indicatorColor.withOpacity(rippleColorOpacity)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = rippleSize;

    final line = Paint()
      ..color = indicatorColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // canvas.drawLine(center, cardioOffset(size), nipple);
    for (var muscle in Muscle.values) {
      final indicator = _indicator[muscle];
      final textPainter = TextPainter(
        text: TextSpan(
          text: EnumHelper.parseWord(muscle),
          style: TextStyle(color: indicatorColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      if (_shouldDisplayIndicator(muscle)) {
        canvas.drawCircle(offset(size, indicator.dot), 3.0, dot);

        if (muscle != Muscle.cardio) {
          canvas.drawCircle(offset(size, indicator.dot), 3.0, rippleDot);
        }
        canvas.drawLine(
          offset(size, indicator.p1),
          offset(size, indicator.p2),
          line,
        );
        if (indicator.p3 != null) {
          canvas.drawLine(
            offset(size, indicator.p2),
            offset(size, indicator.p3),
            line,
          );
        }
        textPainter.paint(canvas, offset(size, indicator.t));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    final oldIndicator = old as _Indicators;
    return rippleAnimationValue != oldIndicator.rippleAnimationValue ||
        switchAnimationValue != oldIndicator.switchAnimationValue;
  }
}
