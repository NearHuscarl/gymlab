import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import '../components/labeled_radio.dart';
import '../components/loading_indicator.dart';
import '../components/chart_indicator.dart';
import '../../blocs/muscle_statistics_bloc.dart';
import '../../helpers/constants.dart';
import '../../helpers/dart_helper.dart';

class MuscleStatisticTab extends StatefulWidget {
  @override
  _MuscleStatisticTabState createState() => _MuscleStatisticTabState();
}

class _MuscleStatisticTabState extends State<MuscleStatisticTab> {
  MuscleStatisticsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MuscleStatisticsBloc()
      ..setDate(MuscleStatisticsBloc.initialDateRange);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Future<void> _selectDate(DateTime initialStart, DateTime initialEnd) async {
    final picked = await DateRangePicker.showDatePicker(
      context: context,
      initialFirstDate: initialStart,
      initialLastDate: initialEnd,
      firstDate: Constants.startDateLimit,
      lastDate: Constants.endDateLimit,
    );

    if (picked != null && picked.length == 2) {
      _bloc.setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        StreamBuilder<List<DateTime>>(
          stream: _bloc.dateRange,
          initialData: MuscleStatisticsBloc.initialDateRange,
          builder: (context, snapshot) {
            final dateRange = snapshot.data;
            return FlatButton(
              child: Text(
                '${dateRange[0].toDisplayDate()} → ${dateRange[1].toDisplayDate()}',
                style: TextStyle(color: theme.accentColor),
              ),
              onPressed: () => _selectDate(dateRange[0], dateRange[1]),
            );
          },
        ),
        StreamBuilder<MuscleFilter>(
          stream: _bloc.muscleFilter,
          initialData: MuscleStatisticsBloc.initialMuscleFilter,
          builder: (context, snapshot) {
            final muscleFilter = snapshot.data;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LabeledRadio(
                  label: 'Primary only',
                  value: MuscleFilter.primaryOnly,
                  groupValue: muscleFilter,
                  onChanged: (value) => _bloc.setPrimaryMuscleOnly(value),
                ),
                LabeledRadio(
                  label: 'Primary and secondary',
                  value: MuscleFilter.primaryAndSecodary,
                  groupValue: muscleFilter,
                  onChanged: (value) => _bloc.setPrimaryMuscleOnly(value),
                ),
              ],
            );
          },
        ),
        Expanded(
          child: StreamBuilder<StatisticsState>(
            stream: _bloc.state,
            initialData: StatisticsLoading(),
            builder: (context, snapshot) {
              final state = snapshot.data;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildChild(state),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChild(StatisticsState state) {
    if (state is StatisticsNotFound) {
      return _noResultWidget();
    } else if (state is StatisticsError) {
      return _errorWidget();
    } else if (state is StatisticsLoading) {
      return _loadingWidget();
    } else if (state is StatisticsPopulated) {
      return _statisticsResultWidget(state.result);
    }

    throw Exception('${state.runtimeType} is not supported');
  }

  Widget _noResultWidget() {
    return Center(
      child: Text(
        'No results found :(',
        style: Theme.of(context).textTheme.display1,
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: LoadingIndicator(),
    );
  }

  Widget _errorWidget() {
    return Center(
      child: Text(
        'Something wrong happens :|',
        style: Theme.of(context).textTheme.display1,
      ),
    );
  }

  static final _chartColors = [
    Colors.pink,
    Colors.amber,
    Colors.lightGreen,
    Colors.blueAccent,
    Colors.indigo,
    Colors.blueGrey,
  ];

  Widget _statisticsResultWidget(List<MapEntry<String, double>> chartData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 250,
          child: Text(
            'Muscle groups you worked out on the most',
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),
        PieChart(
          PieChartData(
              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                // if (pieTouchResponse.touchInput is FlLongPressEnd ||
                //     pieTouchResponse.touchInput is FlPanEnd) {
                //   touchedIndex = -1;
                // } else {
                //   touchedIndex = pieTouchResponse.touchedSectionIndex;
                // }
              }),
              borderData: FlBorderData(show: false),
              startDegreeOffset: -90,
              sectionsSpace: 5,
              sections: _showingChartSections(chartData)),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 45,
            children: chartData.mapIndex((e, i) {
              return ChartIndicator(
                color: _chartColors[i % _chartColors.length],
                text: e.key,
                isSquare: true,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingChartSections(
    List<MapEntry<String, double>> items,
  ) {
    final textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    return items.mapIndex((e, i) {
      final percentage = e.value;
      return PieChartSectionData(
        color: _chartColors[i % _chartColors.length],
        value: percentage,
        title: '${trimLast0(percentage)}%',
        titleStyle: textStyle,
        radius: 60,
      );
    }).toList();
  }
}
