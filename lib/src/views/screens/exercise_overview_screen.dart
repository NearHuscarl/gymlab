import 'package:flutter/material.dart';
import '../components/icon_buttons.dart';
import '../components/loading_indicator.dart';
import '../components/bloc_provider.dart';
import '../components/exercise_list.dart';
import '../components/search_bar.dart';
import '../components/equipment_filter.dart';
import '../components/gym_icons.dart';
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

  Widget _buildShowEquipmentFilterButton() {
    return StreamBuilder(
      stream: bloc.showSearchBar,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return IconButton(
          icon: Icon(GymIcons.machine),
          onPressed: () => bloc.toggleEquipmentFilter(),
        );
      },
    );
  }

  Widget _buildFavoriteFilterButton() {
    return StreamBuilder(
      stream: bloc.showFavoriteOnly,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        final showFavoriteOnly = snapshot.data;
        return FavoriteButton(
          favorite: showFavoriteOnly,
          onPressed: () => bloc.toggleShowFavoriteOnly(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EnumHelper.parseWord(widget.muscle)),
        actions: <Widget>[
          _buildShowSearchBarButton(),
          _buildShowEquipmentFilterButton(),
          _buildFavoriteFilterButton(),
        ],
      ),
      body: BlocProvider<ExerciseOverviewBloc>(
        bloc: bloc,
        child: _ExerciseOverviewContent(),
        dispose: false,
      ),
    );
  }
}

class _ExerciseOverviewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ExerciseOverviewBloc>(context);

    return Stack(
      children: <Widget>[
        StreamBuilder(
          stream: bloc.summaries,
          builder: (context, AsyncSnapshot<ExerciseSummaries> snapshot) {
            if (snapshot.hasData) {
              return ExerciseList(summary: snapshot.data);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: LoadingIndicator());
          },
        ),
        StreamBuilder(
          stream: bloc.showSearchBar,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return SearchBar(
              expand: snapshot.data,
              onTextChanged: (t) => bloc.updateSearchTerm(t),
            );
          },
        ),
        StreamBuilder(
          stream: bloc.showEquipmentFilter,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return EquipmentFilter(
              expand: snapshot.data,
              onFilterChanged: (f) => bloc.updateEquipmentFilter(f),
            );
          },
        ),
      ],
    );
  }
}
