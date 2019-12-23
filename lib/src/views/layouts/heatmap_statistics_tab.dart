import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../blocs/heatmap_statistics_bloc.dart';
import '../../models/exercise_heatmap.dart';
import '../../helpers/dart_helper.dart';
import '../../helpers/enum.dart';
import '../../helpers/exercises.dart';

class HeatMapStatisticTab extends StatefulWidget {
  @override
  _HeatMapStatisticTabState createState() => _HeatMapStatisticTabState();
}

class _HeatMapStatisticTabState extends State<HeatMapStatisticTab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  HeatMapStatisticsBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = HeatMapStatisticsBloc();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        StreamBuilder<HeatMapState>(
          stream: _bloc.state,
          builder: (context, snapshot) {
            final state = snapshot.data;

            if (state is HeatMapPopulated) {
              return _buildTableCalendarWithBuilders(state.result);
            } else if (state is HeatMapError) {
              return _errorWidget();
            }
            return SizedBox.shrink();
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: _buildEventList(theme),
        ),
      ],
    );
  }

  Widget _buildTableCalendarWithBuilders(
      Map<DateTime, List<ExerciseHeatMapItem>> events) {
    return TableCalendar(
      onVisibleDaysChanged: (first, last, format) {
        _bloc.setVisibleDateRange(first, last);
      },
      calendarController: _calendarController,
      events: events,
      availableCalendarFormats: const {
        // Idk why but the labels do not match, I have to set it like this to
        // match with the format layouts, maybe a library bug
        CalendarFormat.month: 'Week',
        CalendarFormat.twoWeeks: 'Month',
        CalendarFormat.week: '2 weeks',
      },
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        weekendStyle: TextStyle(color: Colors.pink[800]),
        holidayStyle: TextStyle(color: Colors.pink[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.pink[600]),
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
        formatButtonDecoration: BoxDecoration(
          color: Colors.pink[400],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              alignment: Alignment.center,
              color: Colors.pink.shade400,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            alignment: Alignment.center,
            color: Colors.amber.shade400,
            child: Text(
              '${date.day}',
              style: TextStyle(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned.fill(
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _bloc.setSelectedExercises(List<ExerciseHeatMapItem>.from(events));
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    final eventLengthFactor = min(events.length, 10);
    final colors = [
      Colors.indigo.shade50,
      Colors.indigo.shade100,
      Colors.indigo.shade200,
      Colors.indigo.shade300,
      Colors.indigo.shade400,
      Colors.indigo.shade500,
      Colors.indigo.shade600,
      Colors.indigo.shade700,
      Colors.indigo.shade800,
      Colors.indigo.shade900,
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: colors[eventLengthFactor],
        border: Border.all(
          color: Colors.amber.shade700,
          width: 3,
          style: _calendarController.isToday(date)
              ? BorderStyle.solid
              : BorderStyle.none,
        ),
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(color: Colors.white, fontSize: 12.0),
        ),
      ),
    );
  }

  Widget _buildEventList(ThemeData theme) {
    return StreamBuilder<List<ExerciseHeatMapItem>>(
        stream: _bloc.selectedExercises,
        initialData: [],
        builder: (context, snapshot) {
          final exercises = snapshot.data;
          return ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: exercises.mapIndex((exercise, i) {
                return ListTile(
                  leading: Image.asset(getImage(exercise.id, 0)),
                  title: Text(
                    exercise.name,
                    style: theme.textTheme.body1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    exercise.muscles
                        .map((m) => EnumHelper.parseWord(m.muscle))
                        .join(', '),
                    style: theme.textTheme.caption,
                  ),
                  trailing: Icon(
                    exercise.favorite ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onTap: () => print('${exercise.name} tapped!'),
                );
              }),
            ).toList(),
          );
        });
  }

  Widget _errorWidget() {
    return Center(
      child: Text('Something went wrong :('),
    );
  }
}
