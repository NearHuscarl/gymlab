import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../router.dart';
import '../layouts/muscle_options.dart';
import '../layouts/timer_section.dart';
import '../layouts/statistic_section.dart';
import '../layouts/meal_section.dart';
import '../components/gym_icons.dart';
import '../../blocs/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _buildOptions() {
    return StreamBuilder(
      stream: _bloc.currentPage,
      initialData: HomePageSection.muscleOption,
      builder: (context, AsyncSnapshot<HomePageSection> snapshot) {
        final currentPage = snapshot.data;
        Widget child;
        switch (currentPage) {
          case HomePageSection.muscleOption:
            child = MuscleOptions();
            break;
          case HomePageSection.timer:
            child = TimerSection();
            break;
          case HomePageSection.statistics:
            child = StatisticSection();
            break;
          case HomePageSection.meal:
            child = MealSection();
            break;
          default:
            child = Center(
              child: Text('Current Page: $currentPage'),
            );
            break;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: child,
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return StreamBuilder(
      stream: _bloc.currentPage,
      initialData: HomePageSection.muscleOption,
      builder: (context, AsyncSnapshot<HomePageSection> snapshot) {
        final currentPage = snapshot.data;
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
              icon: Icon(FontAwesomeIcons.chartArea),
              title: Text('Statistics'),
            ),
            BottomNavigationBarItem(
              icon: Icon(GymIcons.meal),
              title: Text('Meals'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
          currentIndex: currentPage.index,
          onTap: (index) => _bloc.changePage(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: _bloc.title,
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
        child: _buildOptions(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}
