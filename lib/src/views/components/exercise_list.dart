import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/exercise_list_bloc.dart';
import '../../models/exercise_summary.dart';

class ExerciseList extends StatelessWidget {
  Widget buildList(AsyncSnapshot<ExerciseSummaries> snapshot) {
    final data = snapshot.data;
    return GridView.builder(
        itemCount: data.totalResults,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
            child: InkResponse(
              enableFeedback: true,
              child: Image.asset(
                'assets/images/exercise_small_${data.exercises[index].id}.jpg',
                fit: BoxFit.cover,
              ),
              onTap: () => Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(data.exercises[index].name),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ExerciseListBloc>(context);

    return StreamBuilder(
      stream: bloc.summaries,
      builder: (context, AsyncSnapshot<ExerciseSummaries> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
