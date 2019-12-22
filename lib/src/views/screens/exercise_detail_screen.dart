import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/icon_buttons.dart';
import '../components/bloc_provider.dart';
import '../components/progress_editor.dart';
import '../layouts/exercise_detail_section.dart';
import '../../blocs/exercise_detail_bloc.dart';
import '../../blocs/progress_editor_bloc.dart';
import '../../models/exercise_summary.dart';

class ExerciseDetailScreen extends StatefulWidget {
  ExerciseDetailScreen(this.summary);

  final ExerciseSummary summary;

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  ExerciseDetailBloc _bloc;
  final GlobalKey<ProgressEditorState> _progressKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = ExerciseDetailBloc(widget.summary.id)..getById();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // dont make the widgets resize because of soft keyboard
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _bloc.showEditProgress,
            initialData: false,
            builder: (context, snapshot) {
              final showEditProgress = snapshot.data;
              return EditButton(
                edit: showEditProgress,
                onPressed: () {
                  if (showEditProgress) {
                    final state = _progressKey.currentState;

                    state.saveData();
                    _bloc.saveProgressData(
                      state.data,
                      state.date,
                    );
                  }
                  _bloc.toggleShowEditProgress();
                },
              );
            },
          ),
          StreamBuilder(
            stream: _bloc.favorite,
            initialData: false,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              final favorite = snapshot.data;
              // TODO: fix a bug where star the exercise here doesnt update the
              // exercise list screen when popping this screen
              return FavoriteButton(
                favorite: favorite,
                onPressed: () => _bloc.updateFavorite(!favorite),
              );
            },
          )
        ],
      ),
      body: BlocProvider<ExerciseDetailBloc>(
        bloc: _bloc,
        child: Stack(
          children: <Widget>[
            ExerciseDetailSection(widget.summary),
            StreamBuilder(
              stream: _bloc.showEditProgress,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                // TODO: convert other BlocProvider to Provider. Remember Provider save
                // current bloc with old states instead of recreating new bloc every time when rebuilt
                return Provider(
                  create: (context) => ProgressEditorBloc(_bloc.exerciseId),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if (details.delta.dy < -10) {
                        _bloc.closeEditProgress();
                      }
                    },
                    child: ProgressEditor(
                      key: _progressKey,
                      expand: snapshot.data,
                    ),
                  ),
                  dispose: (context, bloc) => bloc.dispose(),
                );
              },
            ),
          ],
        ),
        dispose: false,
      ),
    );
  }
}
