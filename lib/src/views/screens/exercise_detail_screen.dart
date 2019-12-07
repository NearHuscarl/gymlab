import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blocs/exercise_detail_bloc.dart';
import '../components/exercise_detail_section.dart';

class ExerciseDetailScreen extends StatefulWidget {
  ExerciseDetailScreen(this.exerciseId);

  final int exerciseId;

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  ExerciseDetailBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ExerciseDetailBloc(widget.exerciseId)..getById();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          StreamBuilder(
            stream: bloc.favorite,
            initialData: false,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              final favorite = snapshot.data;
              // TODO: fix a bug where star the exercise here doesnt update the
              // exercise list screen when popping this screen
              return IconButton(
                icon: favorite ? Icon(Icons.star) : Icon(Icons.star_border),
                onPressed: () => bloc.updateFavorite(!favorite),
              );
            },
          )
        ],
      ),
      body: Provider<ExerciseDetailBloc>(
        create: (context) => bloc,
        child: ExerciseDetailSection(),
      ),
    );
  }
}
