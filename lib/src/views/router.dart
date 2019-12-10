import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/exercise_overview_screen.dart';
import 'screens/exercise_detail_screen.dart';
import 'screens/favorite_screen.dart';
import '../models/muscle_info.dart';

class Router {
  static void home(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  static void exerciseOverview(BuildContext context, Muscle muscle) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseOverviewScreen(muscle)),
    );
  }

  static void exerciseDetail(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseDetailScreen(id)),
    );
  }

  static void favorite(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoriteScreen()),
    );
  }
}
