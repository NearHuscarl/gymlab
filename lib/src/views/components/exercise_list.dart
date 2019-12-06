import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_list_item.dart';
import '../../blocs/exercise_list_bloc.dart';
import '../../blocs/exercise_list_item_bloc.dart';
import '../../models/exercise_summary.dart';

class ExerciseList extends StatelessWidget {
  Widget _buildList(ExerciseSummaries summary) {
    const padding = const EdgeInsets.all(4.0);

    return GridView.builder(
      itemCount: summary.totalResults,
      padding: padding,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        final exercise = summary.exercises[index];
        return Padding(
          padding: padding,
          child: Provider<ExerciseListItemBloc>(
            create: (context) => ExerciseListItemBloc(
              exercise.id,
              exercise.favorite,
            ),
            dispose: (context, bloc) => bloc.dispose(),
            child: ExerciseListItem(exercise),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ExerciseListBloc>(context);

    return StreamBuilder(
      stream: bloc.summaries,
      builder: (context, AsyncSnapshot<ExerciseSummaries> snapshot) {
        if (snapshot.hasData) {
          return _buildList(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
