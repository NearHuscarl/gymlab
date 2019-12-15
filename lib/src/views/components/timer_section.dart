import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wakelock/wakelock.dart';
import 'round_button.dart';
import 'counter.dart';
import '../../helpers/local_notification.dart';

class TimerSection extends StatefulWidget {
  @override
  _TimerSectionState createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  CounterController _counter;

  @override
  void initState() {
    super.initState();
    _counter = CounterController();
  }

  @override
  void dispose() {
    super.dispose();
    _counter.dispose();
  }

  Widget _buildAddButton({int addAmount}) {
    return RoundButton(
      child: Text(addAmount > 0 ? '+$addAmount' : '$addAmount'),
      // TODO: use StreamBuilder to set onPressed to null to change disable button visual
      onPressed: () =>
          _counter.isActive ? null : _counter.addCounter(addAmount.toDouble()),
      size: 50,
    );
  }

  Widget _buildTimerCounterDisplay(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildAddButton(addAmount: -5),
        Counter(
          totalTime: 5, // TODO: change back to 60
          controller: _counter,
          backgroundColor: theme.primaryColorLight,
          progressColor: theme.primaryColor,
          onTimeout: () => showNotification(
            title: 'Time up',
            payload: 'TIME_UP',
            body: 'Get ready for your next workout!',
          ),
        ),
        _buildAddButton(addAmount: 5),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      color: Colors.indigo.shade500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('Start'),
            onPressed: () {
              _counter.start();
              Wakelock.enable();
            },
          ),
          SizedBox(width: 20),
          RaisedButton(
            child: Text('Stop'),
            onPressed: () {
              _counter.stop();
              Wakelock.disable();
            },
          ),
          SizedBox(width: 20),
          RaisedButton(
            child: Text('Reset'),
            onPressed: () {
              _counter.reset();
              Wakelock.disable();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSetCounterButton(int seconds) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: RaisedButton(
        // TODO: use StreamBuilder to set onPressed to null to change disable button visual
        onPressed: () =>
            _counter.isActive ? null : _counter.setCounter(seconds.toDouble()),
        child: Text('$seconds\s'),
      ),
    );
  }

  Widget _buildSetCounterButtons() {
    const paddingValue = 14.0;
    const padding = const EdgeInsets.all(paddingValue);
    final size = MediaQuery.of(context).size;

    final itemHeight = (size.height * .25 - kBottomNavigationBarHeight) / 2;
    final itemWidth = size.width / 3;

    return SizedBox(
      height: 40,
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemHeight),
        physics: NeverScrollableScrollPhysics(),
        padding: padding,
        shrinkWrap: true,
        children: <Widget>[
          _buildSetCounterButton(20),
          _buildSetCounterButton(30),
          _buildSetCounterButton(45),
          _buildSetCounterButton(60),
          _buildSetCounterButton(90),
          _buildSetCounterButton(120),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _buildTimerCounterDisplay(theme),
        ),
        Expanded(
          flex: 1,
          child: _buildActionButtons(),
        ),
        Expanded(
          flex: 1,
          child: _buildSetCounterButtons(),
        ),
      ],
    );
  }
}
