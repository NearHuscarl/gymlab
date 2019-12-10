import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/exercise_list.dart';
import '../../blocs/exercise_list_bloc.dart';
import '../../models/muscle_info.dart';
import '../../models/exercise_summary.dart';
import '../../helpers/enum.dart';

class ExerciseOverviewScreen extends StatelessWidget {
  ExerciseOverviewScreen(this.muscle);

  final Muscle muscle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EnumHelper.parseWord(muscle)),
      ),
      body: Provider<ExerciseListBloc>(
        create: (context) => ExerciseListBloc()..getByMuscleCategory(muscle),
        dispose: (context, bloc) => bloc.dispose(),
        child: _ExerciseOverviewContent(),
      ),
    );
  }
}

class _ExerciseOverviewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ExerciseListBloc>(context);

    return StreamBuilder(
      stream: bloc.summaries,
      builder: (context, AsyncSnapshot<ExerciseSummaries> snapshot) {
        if (snapshot.hasData) {
          return ExerciseList(summary: snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
