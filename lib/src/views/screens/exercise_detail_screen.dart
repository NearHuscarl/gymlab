import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blocs/exercise_detail_bloc.dart';
import '../components/exercise_detail_section.dart';

class ExerciseDetailScreen extends StatefulWidget {
  ExerciseDetailScreen(this.exerciseId, this.exerciseName);

  final int exerciseId;
  final String exerciseName;

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
      ),
      body: Provider<ExerciseDetailBloc>(
        create: (context) =>
            ExerciseDetailBloc()..getById(widget.exerciseId),
        dispose: (context, bloc) => bloc.dispose(),
        child: ExerciseDetailSection(),
      ),
    );
  }
}
