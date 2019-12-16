import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import '../../helpers/time.dart';
import 'gradient_text.dart';

class Counter extends StatefulWidget {
  Counter({
    this.totalTime,
    this.onTimeout,
    @required this.controller,
    this.backgroundColor,
    this.progressColor,
  });

  final double totalTime;
  final Function onTimeout;
  final CounterController controller;
  final Color backgroundColor;
  final Color progressColor;

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey();

  List<CircularStackEntry> get _chartData {
    final counter = widget.controller.counter;
    final totalTime = widget.controller.totalTime;
    return [
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            1 - (counter / totalTime),
            widget.progressColor,
            rankKey: 'time elapsed',
          ),
          CircularSegmentEntry(
            counter / totalTime,
            widget.backgroundColor,
            rankKey: 'time remaining',
          ),
        ],
        rankKey: 'counter',
      ),
    ];
  }

  String get _displayCounter =>
      formatHHMMSS(max(widget.controller.counter.toInt(), 0));

  @override
  void initState() {
    super.initState();
    widget.controller.setCounter(widget.totalTime);
    widget.controller.addListener(_handleController);
  }

  void _handleController() {
    final controller = widget.controller;

    if (controller.counter >= 0) {
      setState(() {
        _chartKey.currentState.updateData(_chartData);
      });
    } else {
      if (controller.isRunning) {
        if (widget.onTimeout != null) widget.onTimeout();
        controller.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        AnimatedCircularChart(
          key: _chartKey,
          size: const Size(245.0, 245.0),
          initialChartData: _chartData,
          holeRadius: 60,
          edgeStyle: SegmentEdgeStyle.round,
          chartType: CircularChartType.Radial,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: GradientText(
              _displayCounter,
              gradient: LinearGradient(colors: [
                Colors.pink.shade200,
                Colors.pink.shade500,
              ]),
              style: theme.textTheme.display1,
            ),
          ),
        ),
      ],
    );
  }
}

class CounterController extends ChangeNotifier {
  CounterController();

  Timer _timer;

  double _totalTime = 0;
  double get totalTime => _totalTime;

  double _counter = 0;
  double get counter => _counter;

  bool _isRunning = false;

  bool get isRunning => _isRunning;
  bool get isStop => !isRunning;

  void start() {
    if (isRunning) return;
    _isRunning = true;
    _timer = _getTimer();
  }

  void stop() {
    if (isStop) return;
    _isRunning = false;
    _timer?.cancel();
  }

  void reset() {
    _isRunning = false;
    _timer?.cancel();
    _counter = _totalTime;
    notifyListeners();
  }

  void setCounter(double value) {
    if (_totalTime == value) return;
    _totalTime = value;
    _counter = value;
    notifyListeners();
  }

  void addCounter(double value) {
    if (counter + value < 0) return;
    _totalTime += value;
    _counter += value;
    notifyListeners();
  }

  Timer _getTimer() {
    return Timer.periodic(Duration(seconds: 1), (_) {
      _counter--;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  String toString() => '${describeIdentity(this)}($isRunning)($counter)';
}
