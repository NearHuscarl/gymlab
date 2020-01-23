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
      ..setDate(MuscleStatisticsBloc.initialDateOption);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        StreamBuilder<DateOption>(
          stream: _bloc.dateOption,
          initialData: MuscleStatisticsBloc.initialDateOption,
          builder: (context, snapshot) {
            final dateOption = snapshot.data;
            final dateDropdown = Theme(
              data: theme.copyWith(
                buttonTheme: theme.buttonTheme.copyWith(alignedDropdown: true),
              ),
              child: Container(
                color: theme.accentColor.withOpacity(.15),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DateOption>(
                    value: dateOption,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.accentColor.withOpacity(.75),
                    ),
                    elevation: 6,
                    isExpanded: true,
                    style: TextStyle(color: theme.accentColor),
                    underline: Container(height: 2, color: theme.accentColor),
                    onChanged: (newValue) {
                      _bloc.setDate(newValue);
                    },
                    items: DateOption.values
                        .map<DropdownMenuItem<DateOption>>((DateOption value) {
                      return DropdownMenuItem<DateOption>(
                        value: value,
                        child: Text(dateOptionMessage[value]),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: dateDropdown,
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
