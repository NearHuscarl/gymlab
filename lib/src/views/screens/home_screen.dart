import 'package:flutter/material.dart';
import '../components/gym_icons.dart';
import '../components/muscle_options.dart';
import '../router.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  var titles = ['Exercises', 'Timer', 'Settings'];

  Widget _buildOptions() {
    switch (_selectedIndex) {
      case 0:
        return MuscleOptions();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
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
      bottomNavigationBar: BottomNavigationBar(
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
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
