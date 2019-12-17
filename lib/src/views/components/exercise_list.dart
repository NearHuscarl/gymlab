import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'bloc_provider.dart';
import 'exercise_list_item.dart';
import '../../blocs/exercise_list_item_bloc.dart';
import '../../models/exercise_summary.dart';

class ExerciseList extends StatelessWidget {
  ExerciseList({this.summary});

  final ExerciseSummaries summary;

  Widget build(BuildContext context) {
    const padding = const EdgeInsets.all(4.0);
    const columnCount = 2;

    return AnimationLimiter(
      child: GridView.builder(
        itemCount: summary.totalResults,
        padding: padding,
        // Disable scroll physics if there is parent scrollable widget (FavoriteScreen have [ListView] of [ExerciseList])
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount),
        itemBuilder: (BuildContext context, int index) {
          final exercise = summary.exercises[index];
          final child = Padding(
            padding: padding,
            child: BlocProvider<ExerciseListItemBloc>(
              bloc: ExerciseListItemBloc(
                exercise.id,
                exercise.favorite,
              ),
              child: ExerciseListItem(exercise),
            ),
          );

          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: columnCount,
            duration: const Duration(milliseconds: 500),
            delay: Duration(milliseconds: 75),
            child: SlideAnimation(
              verticalOffset: 75.0,
              child: FadeInAnimation(
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
