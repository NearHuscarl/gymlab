import 'package:flutter/material.dart';
import 'bloc_provider.dart';
import 'exercise_list_item.dart';
import '../../blocs/exercise_list_item_bloc.dart';
import '../../models/exercise_summary.dart';

class ExerciseList extends StatelessWidget {
  ExerciseList({this.summary});

  final ExerciseSummaries summary;

  Widget build(BuildContext context) {
    const padding = const EdgeInsets.all(4.0);

    return GridView.builder(
      itemCount: summary.totalResults,
      padding: padding,
      // Disable scroll physics if there is parent scrollable widget (FavoriteScreen have [ListView] of [ExerciseList])
      physics: ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        final exercise = summary.exercises[index];
        return Padding(
          padding: padding,
          child: BlocProvider<ExerciseListItemBloc>(
            bloc: ExerciseListItemBloc(
              exercise.id,
              exercise.favorite,
            ),
            child: ExerciseListItem(exercise),
          ),
        );
      },
    );
  }
}
