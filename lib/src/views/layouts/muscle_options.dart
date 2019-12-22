import 'package:flutter/material.dart';
import '../components/indicator_button.dart';
import '../router.dart';
import '../../models/muscle_info.dart';
import '../../helpers/muscles.dart';
import '../../helpers/enum.dart';

class MuscleOptions extends StatefulWidget {
  @override
  _MuscleOptionsState createState() => _MuscleOptionsState();
}

class _MuscleOptionsState extends State<MuscleOptions>
    with TickerProviderStateMixin {
  BodyDirection bodyDirection = BodyDirection.front;

  AnimationController _rippleController;
  AnimationController _switchController;
  Animation<double> _rippleAnimation;
  Animation<double> _switchAnimation;
  static const _switchDuration = 600;

  @override
  void initState() {
    super.initState();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _switchDuration ~/ 2),
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

  @override
  void dispose() {
    _rippleController.dispose();
    _switchController.dispose();

    super.dispose();
  }

  void _switchSide() {
    _rippleController.reset();
    _switchController.forward().then((_) {
      setState(() => bodyDirection = bodyDirection == BodyDirection.front
          ? BodyDirection.back
          : BodyDirection.front);
      _switchController.reverse();
      _rippleController.repeat();
    });
  }

  Iterable<Widget> _buildMuscleCategoryButtons() {
    final buttonMaps = {
      Muscle.cardio: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.26, .07],
          fractionaloffsets: [.95, .13],
          onPressed: () => Router.exerciseOverview(context, Muscle.cardio),
        ),
      ),
      Muscle.shoulders: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.32, .08],
          fractionaloffsets: [.05, .18],
          onPressed: () => Router.exerciseOverview(context, Muscle.shoulders),
        ),
      ),
      Muscle.chest: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.43, .07],
          fractionaloffsets: [.05, .27],
          onPressed: () => Router.exerciseOverview(context, Muscle.chest),
        ),
      ),
      Muscle.forearms: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.28, .07],
          fractionaloffsets: [.05, .365],
          onPressed: () => Router.exerciseOverview(context, Muscle.forearms),
        ),
      ),
      Muscle.obliques: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.42, .09],
          fractionaloffsets: [.06, .46],
          onPressed: () => Router.exerciseOverview(context, Muscle.obliques),
        ),
      ),
      Muscle.quads: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.42, .08],
          fractionaloffsets: [.06, .575],
          onPressed: () => Router.exerciseOverview(context, Muscle.quads),
        ),
      ),
      Muscle.biceps: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.32, .07],
          fractionaloffsets: [.95, .3],
          onPressed: () => Router.exerciseOverview(context, Muscle.biceps),
        ),
      ),
      Muscle.abs: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.48, .07],
          fractionaloffsets: [.95, .39],
          onPressed: () => Router.exerciseOverview(context, Muscle.abs),
        ),
      ),
      Muscle.abductors: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.38, .06],
          fractionaloffsets: [.95, .58],
          onPressed: () => Router.exerciseOverview(context, Muscle.abductors),
        ),
      ),
      Muscle.adductors: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.47, .075],
          fractionaloffsets: [.95, .68],
          onPressed: () => Router.exerciseOverview(context, Muscle.adductors),
        ),
      ),
      Muscle.traps: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.4, .075],
          fractionaloffsets: [.05, .19],
          onPressed: () => Router.exerciseOverview(context, Muscle.traps),
        ),
      ),
      Muscle.triceps: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.3, .07],
          fractionaloffsets: [.05, .3],
          onPressed: () => Router.exerciseOverview(context, Muscle.triceps),
        ),
      ),
      Muscle.lats: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.41, .07],
          fractionaloffsets: [.95, .29],
          onPressed: () => Router.exerciseOverview(context, Muscle.lats),
        ),
      ),
      Muscle.lowerBack: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.52, .075],
          fractionaloffsets: [.06, .415],
          onPressed: () => Router.exerciseOverview(context, Muscle.lowerBack),
        ),
      ),
      Muscle.glutes: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.44, .07],
          fractionaloffsets: [.95, .51],
          onPressed: () => Router.exerciseOverview(context, Muscle.glutes),
        ),
      ),
      Muscle.hamstrings: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.44, .075],
          fractionaloffsets: [.06, .61],
          onPressed: () => Router.exerciseOverview(context, Muscle.hamstrings),
        ),
      ),
      Muscle.calves: SizedBox.expand(
        child: IndicatorButton(
          sizeFactor: [.42, .075],
          fractionaloffsets: [.06, .78],
          onPressed: () => Router.exerciseOverview(context, Muscle.calves),
        ),
      ),
    };

    return Muscle.values
        .where((m) => shouldDisplay(m, bodyDirection))
        .map((m) => buttonMaps[m]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    final stack = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AnimatedBuilder(
          animation: _switchAnimation,
          builder: (context, child) => AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (context, child) => CustomPaint(
              // TODO: fix text clumping at top left when images dont load yet, so the container size is zero
              foregroundPainter: _Indicators(
                color: primaryColor,
                rippleAnimationValue: _rippleAnimation.value,
                switchAnimationValue: _switchAnimation.value,
                bodyDirection: bodyDirection,
              ),
              child: child,
            ),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: _switchDuration),
              crossFadeState: bodyDirection == BodyDirection.front
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              // dont change image size when loading. It looks weird
              sizeCurve: Threshold(0),
              firstChild: Image.asset('assets/images/man_front_xsmall.png'),
              secondChild: Image.asset('assets/images/man_back_xsmall.png'),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 20,
          child: FloatingActionButton(
            onPressed: _switchSide,
            child: Text('180°'),
          ),
        )
      ]..addAll(_buildMuscleCategoryButtons()),
    );

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx.abs() > 10) {
          _switchSide();
        }
      },
      child: stack,
    );
  }
}

class _Indicator {
  _Indicator({
    @required this.dot,
    List<double> p1 = const [],
    List<double> p2 = const [],
    List<double> p3 = const [],
    @required this.t,
  }) : path = []..add(p1)..add(p2)..add(p3);

  /// First element is the Offset.x factor, second is Offset.y factor
  /// Offset is the product of offset factor and container size
  final List<double> dot;
  final List<List<double>> path;

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
  final BodyDirection bodyDirection;
  final double rippleAnimationValue;
  final double switchAnimationValue;

  static final _indicator = {
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
    Muscle.forearms: _Indicator(
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

  /// Used in animation to apploy transform to all indicator positions
  List<double> translate = [0, 0];

  Offset offset(Size containerSize, List<double> offsetFactor) {
    return Offset(
      containerSize.width * (offsetFactor[0] + translate[0]),
      containerSize.height * (offsetFactor[1] + translate[1]),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    translate = [0, (-switchAnimationValue * .025)];
    final opacity = (1 - switchAnimationValue);
    final rippleColorOpacity =
        opacity != 1 ? opacity : (1 - rippleAnimationValue) * 0.75;
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

    for (var muscle in Muscle.values) {
      final indicator = _indicator[muscle];
      final textPainter = TextPainter(
        text: TextSpan(
          text: EnumHelper.parseWord(muscle),
          style: TextStyle(color: indicatorColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      if (shouldDisplay(muscle, bodyDirection)) {
        canvas.drawCircle(offset(size, indicator.dot), 3.0, dot);

        if (muscle != Muscle.cardio) {
          canvas.drawCircle(offset(size, indicator.dot), 3.0, rippleDot);
        }

        indicator.path.reduce((prevOffset, offset) {
          if (offset.length == 2) {
            canvas.drawLine(
              this.offset(size, prevOffset),
              this.offset(size, offset),
              line,
            );
          }
          return offset;
        });
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
