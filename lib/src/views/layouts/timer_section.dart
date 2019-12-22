import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wakelock/wakelock.dart';
import '../components/fade_in.dart';
import '../components/primary_button.dart';
import '../components/round_button.dart';
import '../components/counter.dart';
import '../../blocs/timer_bloc.dart';
import '../../helpers/local_notification.dart';

class TimerSection extends StatefulWidget {
  @override
  _TimerSectionState createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  CounterController _counter;
  TimerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _counter = CounterController();
    _counter.addListener(() {
      _bloc.setCounter(_counter.counter.toInt());
    });
    _bloc = TimerBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _counter.dispose();
    _bloc.dispose();
  }

  Widget _buildAddButton({int addAmount}) {
    return StreamBuilder<int>(
      stream: _bloc.counter,
      initialData: 0,
      builder: (context, snapshot) {
        final counter = snapshot.data;
        return StreamBuilder<TimerStatus>(
          stream: _bloc.status,
          initialData: TimerStatus.stop,
          builder: (context, snapshot) {
            final isActive = snapshot.data != TimerStatus.stop;
            return RoundButton(
              child: Text(addAmount > 0 ? '+$addAmount' : '$addAmount'),
              enable: !isActive && counter + addAmount > 0,
              onPressed: () => _counter.addCounter(addAmount.toDouble()),
              size: 50,
            );
          },
        );
      },
    );
  }

  Widget _buildTimerCounterDisplay(ThemeData theme) {
    return Container(
      // color: Colors.indigo.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildAddButton(addAmount: -5),
          Counter(
            totalTime: 30,
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
      ),
    );
  }

  Widget _buildActionButtonChild(TimerStatus timerStatus) {
    final startCallback = () {
      _counter.start();
      _bloc.setStatus(TimerStatus.running);
      Wakelock.enable();
    };
    final stopCallback = () {
      _counter.stop();
      _bloc.setStatus(TimerStatus.pause);
      Wakelock.disable();
    };
    switch (timerStatus) {
      case TimerStatus.running:
      case TimerStatus.pause:
        final isRunning = timerStatus == TimerStatus.running;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            PrimaryButton(
              child: isRunning ? Text('STOP') : Text('RESUME'),
              onPressed: isRunning ? stopCallback : startCallback,
            ),
            SizedBox(width: 20),
            PrimaryButton(
              child: Text('RESET'),
              onPressed: () {
                _counter.reset();
                _bloc.setStatus(TimerStatus.stop);
                Wakelock.disable();
              },
            ),
          ],
        );
      case TimerStatus.stop:
        return Center(
          child: PrimaryButton(
            child: Text('START'),
            onPressed: startCallback,
          ),
        );
      default:
        throw Exception(
            'if this line of code runs, the universe will collapse');
    }
  }

  Widget _buildActionButtons() {
    return FadeIn(
      duration: Duration(milliseconds: 300),
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      child: StreamBuilder<TimerStatus>(
        stream: _bloc.status,
        initialData: TimerStatus.stop,
        builder: (context, snapshot) {
          final timerStatus = snapshot.data;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildActionButtonChild(timerStatus),
          );
        },
      ),
    );
  }

  static const _counterButtonGap = 3.0;
  Widget _buildSetCounterButton(int seconds) {
    return Padding(
      padding: const EdgeInsets.all(_counterButtonGap),
      child: StreamBuilder<TimerStatus>(
        stream: _bloc.status,
        initialData: TimerStatus.stop,
        builder: (context, snapshot) {
          final isActive = snapshot.data != TimerStatus.stop;
          return PrimaryButton(
            onPressed:
                isActive ? null : () => _counter.setCounter(seconds.toDouble()),
            child: Text('$seconds\s'),
            primary: false,
          );
        },
      ),
    );
  }

  Widget _buildSetCounterButtons() {
    const paddingValue = 14.0;
    const padding = const EdgeInsets.all(paddingValue);
    final size = MediaQuery.of(context).size;
    const rowCount = 2;
    const columnCount = 3;

    final itemHeight = ((size.height - kBottomNavigationBarHeight) * (2 / 7) -
            (paddingValue * 2) -
            (rowCount * _counterButtonGap * 2)) /
        rowCount;

    final itemWidth = size.width / columnCount;
    final children = [
      _buildSetCounterButton(20),
      _buildSetCounterButton(30),
      _buildSetCounterButton(45),
      _buildSetCounterButton(60),
      _buildSetCounterButton(90),
      _buildSetCounterButton(120),
    ];

    return GridView.builder(
      itemCount: children.length,
      padding: padding,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        childAspectRatio: (itemWidth / itemHeight),
      ),
      itemBuilder: (BuildContext context, int index) {
        return AnimationConfiguration.staggeredGrid(
          position: index,
          columnCount: columnCount,
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: 75),
          child: FlipAnimation(
            child: FadeInAnimation(
              child: children[index],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: _buildTimerCounterDisplay(theme),
        ),
        Expanded(
          flex: 2,
          child: _buildActionButtons(),
        ),
        Expanded(
          flex: 2,
          child: _buildSetCounterButtons(),
        ),
      ],
    );
  }
}
