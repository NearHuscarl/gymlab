import 'package:flutter/material.dart';
import '../components/bloc_provider.dart';
import '../components/gym_icons.dart';
import '../components/muscle_options.dart';
import '../components/timer_section.dart';
import '../router.dart';
import '../../blocs/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  Widget _buildOptions(HomeBloc bloc) {
    return StreamBuilder(
      stream: bloc.currentPage,
      initialData: HomePageSection.muscleOption,
      builder: (context, AsyncSnapshot<HomePageSection> snapshot) {
        final currentPage = snapshot.data;
        switch (currentPage) {
          case HomePageSection.muscleOption:
            return MuscleOptions();
          case HomePageSection.timer:
            return TimerSection();
          default:
            return Center(
              child: Text('Current Page: $currentPage'),
            );
        }
      },
    );
  }

  Widget _buildBottomNavBar(HomeBloc bloc) {
    return StreamBuilder(
      stream: bloc.currentPage,
      initialData: HomePageSection.muscleOption,
      builder: (context, AsyncSnapshot<HomePageSection> snapshot) {
        final currentPage = snapshot.data;
        return BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(GymIcons.dumbbell),
              title: Text('Exercises'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              title: Text('Timer'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Statistics'),
            ),
          ],
          currentIndex: currentPage.index,
          onTap: (index) => bloc.changePage(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: bloc.title,
          initialData: '',
          builder: (context, AsyncSnapshot<String> snapshot) {
            return Text(snapshot.data);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => Router.favorite(context),
          )
        ],
      ),
      body: Center(
        child: _buildOptions(bloc),
      ),
      bottomNavigationBar: _buildBottomNavBar(bloc),
    );
  }
}
