import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blocs/exercise_list_favorite_bloc.dart';
import '../../models/exercise_summary.dart';
import '../../models/muscle_info.dart';
import '../../helpers/enum.dart';
import '../components/exercise_list.dart';
import '../components/linebreak.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: Provider<ExerciseListFavoriteBloc>(
        create: (context) => ExerciseListFavoriteBloc()..getFavorite(),
        dispose: (context, bloc) => bloc.dispose(),
        child: _FavoriteContent(),
      ),
    );
  }
}

class _FavoriteContent extends StatelessWidget {
  Widget _buildNoFavorite(ThemeData theme, MediaQueryData media) {
    final headlineTheme = theme.textTheme.headline;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/no_favorite.png',
            width: media.size.width * .6,
            alignment: Alignment.center,
          ),
          SizedBox(height: 20),
          Text('No favorite',
              style: headlineTheme.copyWith(color: Colors.black45)),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ExerciseListFavoriteBloc>(context);
    final theme = Theme.of(context);
    final headlineTheme = theme.textTheme.headline;
    final media = MediaQuery.of(context);

    return StreamBuilder(
      stream: bloc.summaries,
      builder:
          (context, AsyncSnapshot<Map<Muscle, ExerciseSummaries>> snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          final children = <Widget>[];

          snapshot.data.forEach((muscle, summaries) {
            final title = EnumHelper.parseWord(muscle);
            children.addAll([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Linebreak(),
              ),
              Text(
                title,
                style: headlineTheme,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Linebreak(),
              ),
              ExerciseList(summary: summaries),
            ]);
          });

          return ListView(children: children);
        } else if (snapshot.hasData && snapshot.data.isEmpty) {
          return _buildNoFavorite(theme, media);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
