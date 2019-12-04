import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/exercise_overview_screen.dart';
import '../models/muscle_info.dart';

class Router {
  static void homeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  static void exerciseOverviewScreen(BuildContext context, Muscle muscle) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseOverviewScreen(muscle)),
    );
  }
}
