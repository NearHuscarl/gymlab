import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/exercise_detail_bloc.dart';
import '../../models/exercise_detail.dart';

class ExerciseDetailSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final bloc = Provider.of<ExerciseDetailBloc>(context);

   Widget _buildDetail(ExerciseDetail exercise) {
     return Column(children: <Widget>[
       Text(exercise.name),
       Text(exercise.description),
     ],);
   }

    return StreamBuilder(
      stream: bloc.detail,
      builder: (context, AsyncSnapshot<ExerciseDetail> snapshot) {
        if (snapshot.hasData) {
          return _buildDetail(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}