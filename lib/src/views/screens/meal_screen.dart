import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gymlab/src/views/meals/meal_image.dart';
import '../meals/paleo_meal.dart';
import '../meals/zone_meal.dart';
import '../router.dart';
import 'meals.dart';

class MealScreen extends StatelessWidget {
  Widget _getPage(String mealId) {
    switch (mealId) {
      case 'paleo':
        return PaleoMeal();
      case 'zone':
        return ZoneMeal();
      default:
        return PaleoMeal();
    }
  }

  Widget _buildMealItem(BuildContext context, int index) {
    final id = meals[index]['id'];
    final name = meals[index]['name'];

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: MealImage(
        title: name,
        image: 'assets/images/meals/$id.jpg',
        imageBrightness: Brightness.dark,
        displayText: true,
        onTap: () => Router.goTo(context, _getPage(id)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(6.0),
          itemCount: meals.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                verticalOffset: 30.0,
                child: FadeInAnimation(
                  child: _buildMealItem(context, index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
