import 'package:flutter/material.dart';
import 'meal_image.dart';
import 'meal_template.dart';

const description =
    '''Low-carb diets have been popular for many decades, especially for weight loss.

There are several types of low-carb diets, but all of them involve limiting carb intake to 20- 150 grams of net carbs per day.

The primary aim of the diet is to force the body to use more fats for fuel, instead of using carbs as a main source of energy.''';

const howItWorks =
    '''Low-carb diets are based on eating unlimited amounts of protein and fat, while severely limiting your carb intake.

When carb intake is very low, fatty acids are moved into the blood and transported to the liver, where some of them are turned into ketones.

The body can then use fatty acids and ketones in the absence of carbs as its primary energy source.''';

const weightLoss =
    '''Numerous studies show low-carb diets are extremely helpful for weight loss, especially in overweight and obese individuals.

Low-carb diets seem to be very effective at reducing dangerous belly fat, which can become lodged around your organs.

People on very Iow-carb diets commonly reach a state called ketosis. Many studies have found that ketogenic diets lead to more than twice the weight loss of a low-fat, calorie-restricted diet.''';

const otherBenefits =
    '''Low-carb diets tend to reduce your appetite and make you feel less hungry, leading to an automatic reduction in calorie intake.

Furthermore, low-carb diets may benefit many major disease risk factors, such as blood triglycerides, cholesterol levels,blood sugar levels, insulin levels and blood pressure.''';

const downside = '''Low-carb diets do not suit everyone. Some may feel great on them, while others will feels miserable.

In extrmely rare cases, very low-carb diets can cause a serious condition called ketoacidosis. This condition seems to be more common in lactating women and can be fatal if left untreated.

However, low-carb diets are safe for the majority of people.''';

class LowCarbMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MealTemplate(
      image: MealImage(
        title: 'Low-Carb',
        image: 'assets/images/meals/lowCarb.jpg',
        imageBrightness: Brightness.dark,
      ),
      body: <Widget>[
        MealParagraph(description),
        MealHeader('How it works'),
        MealParagraph(howItWorks),
        MealHeader('Weight loss'),
        MealParagraph(weightLoss),
        MealHeader('Other benefits'),
        MealParagraph(otherBenefits),
        MealHeader('The downside'),
        MealParagraph(downside),
        MealHeader('Eat'),
        MealListItem(
          title: 'Meat',
          text: 'Beef, lamb, pork, chicken and others. Grass-fed is best.',
        ),
        MealListItem(
          title: 'Fish',
          text: 'Salmon, trout, haddock and many others. Wild-caught fish is best.',
        ),
        MealListItem(
          title: 'Eggs',
          text: 'Omega-3 enriched or pastured eggs are best.',
        ),
        MealListItem(
          title: 'Vegetables',
          text: 'Spinach, broccoli, cauliflower, carrots and many others.',
        ),
        MealListItem(
          title: 'Fruits',
          text: 'Apples, oranges, pears, blueberries, strawberries.',
        ),
        MealListItem(
          title: 'Nuts and Seeds',
          text: 'Almonds, walnuts, sunflower seeds, etc.',
        ),
        MealListItem(
          title: 'High-Fat Dairy',
          text: 'Cheese, butter, heavy cream, yoghurt.',
        ),
        MealListItem(
          title: 'Fats and Oils',
          text: 'Coconut oil, butter, lard, olive oil and cod fish liver oil.',
        ),
        MealHeader('Avoid'),
        MealListItem(
          title: 'Sugar',
          text: 'Soft drinks, fruit juices, agave, candy, ice cream and many others.',
        ),
        MealListItem(
          title: 'Gluten Grains',
          text: 'Wheat, spelt, barley and rye. Includes bread and pasta.',
        ),
        MealListItem(
          title: 'Trans Fats',
          text: '"Hydrogenated" or "partially hydrogenated" oils.',
        ),
        MealListItem(
          title: 'High Omega-6 Seed and Vegetable Oils',
          text: 'Cottonseed, soybean, sunflower, grapeseed, corn, safflower and canola oils.',
        ),
        MealListItem(
          title: 'Artificial Sweeteners',
          text: 'Aspartame, Saccharin, Sucralose, Cyclamates and Acesulfame Potassium. Use Stevia instead.',
        ),
        MealListItem(
          title: '"Diet" and "Low-Fat" Products',
          text: 'Many dairy products, cereals, crackers, etc.',
        ),
        MealListItem(
          title: 'Highly Processed Foods',
          text: 'If it looks like it was made in a factory, do not eat it.',
        ),
      ],
    );
  }
}
