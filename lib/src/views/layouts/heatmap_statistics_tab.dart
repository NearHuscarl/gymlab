import 'dart:math';

import 'package:flutter/material.dart';
import '../components/heat_map.dart';
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
  HeatMapStatisticsBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = HeatMapStatisticsBloc();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  static final colors = [
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

  Widget _buildTableCalendarWithBuilders(
      Map<DateTime, List<ExerciseHeatMapItem>> events) {
    return HeatMap<ExerciseHeatMapItem>(
      onVisibleDaysChanged: (first, last, format) {
        _bloc.setVisibleDateRange(first, last);
      },
      events: events,
      onDaySelected: (date, events) => _bloc.setSelectedExercises(events),
      colorRange: (count) => colors[min(count, 10) - 1],
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
                    style: theme.textTheme.body1
                        .copyWith(fontWeight: FontWeight.w500),
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
