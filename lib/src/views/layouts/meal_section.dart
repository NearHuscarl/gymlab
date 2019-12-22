import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../meals/meal_image.dart';
import '../meals/paleo_meal.dart';
import '../meals/zone_meal.dart';
import '../meals/vegan_meal.dart';
import '../meals/lowCarb_meal.dart';
import '../meals/dukan_meal.dart';
import '../meals/ultraLowFat_meal.dart';
import '../meals/atkins_meal.dart';
import '../meals/intermittentFasting_meal.dart';
import '../router.dart';
import '../meals/meals.dart';

class MealSection extends StatelessWidget {
  Widget _getPage(String mealId) {
    switch (mealId) {
      case 'paleo':
        return PaleoMeal();
      case 'vegan':
        return VeganMeal();
      case 'lowCarb':
        return LowCarbMeal();
      case 'dukan':
        return DukanMeal();
      case 'ultraLowFat':
        return UltraLowFatMeal();
      case 'atkins':
        return AtkinsMeal();
      case 'zone':
        return ZoneMeal();
      case 'intermittentFasting':
        return IntermittentFastingMeal();
      default:
        return throw Exception('Meal id not exist: $mealId');
    }
  }

  Widget _buildMealItem(BuildContext context, int index) {
    final id = meals[index]['id'];
    final name = meals[index]['name'];
    final brightness = meals[index]['brightness'] as Brightness;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: MealImage(
        title: name,
        image: 'assets/images/meals/$id.jpg',
        imageBrightness: brightness,
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
