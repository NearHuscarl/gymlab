import 'package:flutter/material.dart';
import 'muscle_stastictics_tab.dart';
import 'heatmap_statistics_tab.dart';

final tabs = [
  MuscleStatisticTab(),
  HeatMapStatisticTab(),
];

class StatisticSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(height: 50),
            child: TabBar(
              tabs: [
                Tab(text: "Muscle Group"),
                Tab(text: "Activity"),
              ],
              indicatorColor: theme.primaryColor,
              labelColor: theme.primaryColor,
            ),
          ),
          Expanded(
            child: TabBarView(children: tabs),
          )
        ],
      ),
    );
  }
}
