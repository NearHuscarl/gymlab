import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/exercise_list.dart';
import '../../blocs/exercise_overview_bloc.dart';
import '../../models/muscle_info.dart';
import '../../models/exercise_summary.dart';
import '../../helpers/enum.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  ExerciseOverviewScreen(this.muscle);

  final Muscle muscle;

  @override
  _ExerciseOverviewScreenState createState() => _ExerciseOverviewScreenState();
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen> {
  ExerciseOverviewBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ExerciseOverviewBloc()..getByMuscleCategory(widget.muscle);
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
        title: Text(EnumHelper.parseWord(widget.muscle)),
        actions: <Widget>[
          StreamBuilder(
            stream: bloc.favorite,
            initialData: false,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              final favorite = snapshot.data;
              return IconButton(
                icon: favorite ? Icon(Icons.star) : Icon(Icons.star_border),
                onPressed: () => bloc.updateFavorite(!favorite),
              );
            },
          )
        ],
      ),
      body: Provider<ExerciseOverviewBloc>(
        create: (context) => bloc,
        child: _ExerciseOverviewContent(),
      ),
    );
  }
}

class _ExerciseOverviewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ExerciseOverviewBloc>(context);

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
