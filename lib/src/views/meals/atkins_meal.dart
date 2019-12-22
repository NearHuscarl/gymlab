import 'package:flutter/material.dart';
import 'meal_image.dart';
import 'meal_template.dart';

const description =
    '''The Atkins diet is the most well-known low-carb weight loss diet.

Its proponents state that you can lose weight by eating as much protein and fat as you like, as long as you avoid carbs.

The main reason why low-carb diets are so effective for weight loss is that they reduce your appetite.

This causes you to eat fewer calories without having to think about it.''';

const howItWorks =
    '''The Atkins diet is split into four phases. It starts with an induction phase, during which you eat under 20 grams of carbs per day for two weeks.

The other phases involve slowly reintroducing healthy carbs back into your diet as you approach your goal weight.''';

const weightLoss =
    '''The Atkins diet has been studied extensively and shown to lead to faster weight loss than low-fat dots.

Other studies have shown that Iow-carb diets are very helpful for weight loss. They are especially successful in reducing belly fat, the most dangerous fat that lodges itself in the abdominal cavity.''';

const otherBenefits =
    '''Numerous studies show low-carb diets, like the Atkins diet, may reduce many risk factors for disease, including blood triglycerides, cholesterol, blood sugar, insulin and blood pressure.

Compared to other weight loss diets, low-carb diets also show greater improvements in blood sugar, HDL cholesterol, triglycerides and other health markers.''';

const downside = '''Same as with other very low-carb diets, the Atkins diet is safe and healthy for most people but may cause problems in rare cases.''';

class AtkinsMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MealTemplate(
      image: MealImage(
        title: 'Atkins',
        image: 'assets/images/meals/atkins.jpg',
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
          title: 'Meats',
          text: 'Beef, pork, Iamb, chicken, bacon and others.',
        ),
        MealListItem(
          title: 'Fish and Seafood',
          text: 'Salmon, trout, sardines, etc.',
        ),
        MealListItem(
          title: 'Eggs',
          text: 'The healthiest eggs are Omega-3 enriched or pastured.',
        ),
        MealListItem(
          title: 'Low-garb vegetables',
          text: 'Kale, spinach, broccoli, asparagus and others.',
        ),
        MealListItem(
          title: 'Full-fat dairy',
          text: 'Butter, cheese, cream, full-fat yoghurt.',
        ),
        MealListItem(
          title: 'Nuts and Seeds',
          text: 'Almonds, macadamia nuts, walnuts, sunflower seeds, etc.',
        ),
        MealListItem(
          title: 'Healthy Fats',
          text: 'Extra virgin olive oil, coconut oil, avocados and avocado oil.',
        ),
        MealHeader('Avoid'),
        MealListItem(
          title: 'Sugar',
          text: 'Soft drinks, fruit juices, cakes, candy, ice cream, etc.',
        ),
        MealListItem(
          title: 'Grains',
          text: 'Wheat, spelt, rye, barley, rice.',
        ),
        MealListItem(
          title: 'Vegetable oils',
          text: '"Soybean oil, corn oil, cottonseed oil, canola oil and a few others.',
        ),
        MealListItem(
          title: 'Trans fats',
          text: 'Usually found in processed foods with the word "hydrogenated" on the ingredients list.',
        ),
        MealListItem(
          title: '"Diet" and "low-fat" foods',
          text: 'Aspartame, Saccharin, Sucralose, Cyclamates and Acesulfame Potassium. Use Stevia instead.',
        ),
        MealListItem(
          title: '"Diet" and "Low-Fat" Products',
          text: 'These are usually very high in sugar.',
        ),
        MealListItem(
          title: 'High-carb vegetables',
          text: 'Carrots, turnips, etc.',
        ),
        MealListItem(
          title: 'High-carb fruits',
          text: 'Bananas, apples, oranges, pears, grapes.',
        ),
        MealListItem(
          title: 'Starches',
          text: 'Potatoes, sweet potatoes.',
        ),
        MealListItem(
          title: 'Legumes',
          text: 'Lentils, beans, chickpeas, etc.',
        ),
      ],
    );
  }
}
