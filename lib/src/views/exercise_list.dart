import 'package:flutter/material.dart';
import 'package:gymlab/src/blocs/exercise_bloc.dart';
import 'package:gymlab/src/models/exercise.dart';

class ExerciseList extends StatelessWidget {
  Widget buildList(AsyncSnapshot<List<Exercise>> snapshot) {
    final exercises = snapshot.data;
    return GridView.builder(
        itemCount: exercises.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
            child: InkResponse(
              enableFeedback: true,
              child: Image.asset(
                'assets/images/exercise_small_${exercises[index].id}.jpg',
                fit: BoxFit.cover,
              ),
              onTap: () => Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(exercises[index].name),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: exerciseBloc.stream,
      builder: (context, AsyncSnapshot<List<Exercise>> snapshot) {
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
