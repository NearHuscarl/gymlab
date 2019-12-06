import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/exercise_list.dart';
import '../../blocs/exercise_list_bloc.dart';
import '../../models/muscle_info.dart';
import '../../helpers/enum.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  ExerciseOverviewScreen(this.muscle);

  final Muscle muscle;

  @override
  _ExerciseOverviewScreenState createState() => _ExerciseOverviewScreenState();
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EnumHelper.parseWord(widget.muscle)),
      ),
      body: Provider<ExerciseListBloc>(
        create: (context) =>
            ExerciseListBloc()..getByMuscleCategory(widget.muscle),
        dispose: (context, bloc) => bloc.dispose(),
        child: ExerciseList(),
      ),
    );
  }
}
