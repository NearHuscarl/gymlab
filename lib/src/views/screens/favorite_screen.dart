import 'package:flutter/material.dart';

import '../../blocs/exercise_favorite_bloc.dart';
import '../../models/exercise_summary.dart';
import '../../models/muscle_info.dart';
import '../../helpers/enum.dart';
import '../components/exercise_list.dart';
import '../components/linebreak.dart';
import '../components/bloc_provider.dart';
import '../components/search_bar.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  ExerciseFavoriteBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ExerciseFavoriteBloc()..getFavorite();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  Widget _buildShowSearchBarButton() {
    return StreamBuilder(
      stream: bloc.showSearchBar,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return IconButton(
          icon: Icon(Icons.search),
          onPressed: () => bloc.toggleShowSearchBar(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
        actions: <Widget>[
          _buildShowSearchBarButton(),
        ],
      ),
      body: BlocProvider<ExerciseFavoriteBloc>(
        bloc: bloc,
        child: _FavoriteContent(),
        dispose: false,
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

  Widget _buildExerciseListByCategory(
    ThemeData theme,
    Map<Muscle, ExerciseSummaries> exercises,
  ) {
    final children = <Widget>[];
    final headlineTheme = theme.textTheme.headline;

    exercises.forEach((muscle, summaries) {
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
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ExerciseFavoriteBloc>(context);
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return StreamBuilder(
      stream: bloc.summaries,
      builder:
          (context, AsyncSnapshot<Map<Muscle, ExerciseSummaries>> snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: <Widget>[
              snapshot.data.isEmpty
                  ? _buildNoFavorite(theme, media)
                  : _buildExerciseListByCategory(theme, snapshot.data),
              StreamBuilder(
                stream: bloc.showSearchBar,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  return SearchBar(
                    expandSearchBar: snapshot.data,
                    onTextChanged: (t) => bloc.updateSearchTerm(t),
                  );
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
