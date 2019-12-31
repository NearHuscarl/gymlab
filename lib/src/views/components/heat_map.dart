import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

typedef HeatMapColorGetter = Color Function(int);

class HeatMap<T> extends StatefulWidget {
  HeatMap({
    @required this.events,
    @required this.colorRange,
    this.onVisibleDaysChanged,
    this.onDaySelected,
  });

  final Map<DateTime, List<T>> events;
  final HeatMapColorGetter colorRange;
  final OnVisibleDaysChanged onVisibleDaysChanged;
  final OnDaySelected onDaySelected;

  @override
  _HeatMapState<T> createState() => _HeatMapState<T>();
}

class _HeatMapState<T> extends State<HeatMap<T>>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

  Widget build(BuildContext context) {
    return TableCalendar(
      onVisibleDaysChanged: widget?.onVisibleDaysChanged,
      calendarController: _calendarController,
      events: widget.events,
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
        widget?.onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: widget.colorRange(events.length),
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
}
