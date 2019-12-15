import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import '../../helpers/time.dart';

class Counter extends StatefulWidget {
  Counter({
    this.totalTime,
    this.onTimeout,
    this.controller,
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
  Timer _timer;
  double _counter;
  double _totalTime;
  bool _timeout = false;
  bool _isActive = false;
  GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey();

  List<CircularStackEntry> get _chartData => [
        CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(
              1 - (_counter / _totalTime),
              widget.progressColor,
              rankKey: 'time elapsed',
            ),
            CircularSegmentEntry(
              _counter / _totalTime,
              widget.backgroundColor,
              rankKey: 'time remaining',
            ),
          ],
          rankKey: 'counter',
        ),
      ];
  String get _displayCounter => formatHHMMSS(max(_counter.toInt(), 0));

  @override
  void initState() {
    super.initState();
    _totalTime = widget.totalTime;
    _counter = _totalTime;
    widget.controller.setCounter(_counter);
    widget.controller.addListener(_handleController);
  }

  void _handleController() {
    final controller = widget.controller;

    if (_isActive != controller.isActive) {
      if (controller.isActive) {
        _timeout = false;
        _timer = _getTimer();
      } else {
        _timer?.cancel();
      }
      _isActive = controller.isActive;
    }
    if (_totalTime != controller.counter) {
      setState(() {
        _totalTime = controller.counter ?? _totalTime;
        _counter = _totalTime;
      });
    }
  }

  Timer _getTimer() {
    return Timer.periodic(Duration(seconds: 1), (_) {
      if (_timeout) return;

      if (_counter >= 0) {
        setState(() {
          _counter--;
          _chartKey.currentState.updateData(_chartData);
        });
      } else {
        if (widget.onTimeout != null) widget.onTimeout();
        _timeout = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
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
          edgeStyle: SegmentEdgeStyle.round,
          chartType: CircularChartType.Radial,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              _displayCounter,
              style: theme.textTheme.title,
            ),
          ),
        ),
      ],
    );
  }
}

class CounterController extends ChangeNotifier {
  CounterController();

  double _counter = 0;
  double get counter => _counter;

  bool _isActive = false;
  bool get isActive => _isActive;

  void start() {
    if (isActive) return;
    _isActive = true;
    notifyListeners();
  }

  void stop() {
    if (!isActive) return;
    _isActive = false;
    notifyListeners();
  }

  void reset() {
    if (_counter == 0 && !_isActive) return;
    _counter = 0;
    _isActive = false;
    notifyListeners();
  }

  void setCounter(double value) {
    if (counter == value) return;
    _counter = value;
    notifyListeners();
  }

  void addCounter(double value) {
    if (counter + value < 0) return;
    _counter += value;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($isActive)($counter)';
}
