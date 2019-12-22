import 'package:flutter/material.dart';
import 'meal_image.dart';
import 'meal_template.dart';

const description =
    '''An ultra low-fat diet restricts the consumption of fat to under 10% of consumed calories, Generally, a low-fat diet provides around 30% of its calories as fat.

Many studies have shown that this diet is ineffective for weight loss in the long term.

Proponents of the ultra low-fat diet claim that traditional low-fat diets are not low-fat enough and fat intakes need to stay under 10% of total calories to produce health benefits and weight loss.''';

const howItWorks =
    '''An ultra low-fat diet contains 10% or fewer calories from fat. The diet is mostly plant-based and has a limited intake of animal products. Therefore, its generally very high in carbs (80%) and low in protein (10%).''';

const weightLoss =
    '''This diet has been shown to be very successful for weight loss among obese individuals. In one study, obese individuals lost an average of 140 lbs (63 kg) on an ultra low- fat diet termed the rice diet.

Another 8-week study with a diet containing 7- 14% fat showed an average weight loss of 14.8 lbs (6.7 kg).''';

const otherBenefits =
    '''Studies have shown that ultra low-fat diets can improve several risk factors for heart disease, including high blood pressure, high cholesterol and markers of inflammation.

Surprisingly, this high-carb, low-fat diet can also lead to significant improvements in type 2 diabetics.

Furthermore, it may slow the progression of multiple sclerosis, an autoimmune disease that affects the brain, spinal cord and optic nerves in the eyes.''';

const downside = '''The fat restriction may cause problems in the long-term, as fat has many important roles in the body.

These include helping build cell membranes and hormones and helping the body absorb fat-soluble vitamins.

Moreover, an ultra low-fat diet limits the intake of many healthy foods, lacks variety and is extremely hard to stick to.''';

class UltraLowFatMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MealTemplate(
      image: MealImage(
        title: 'Ultra Low-Fat',
        image: 'assets/images/meals/ultraLowFat.jpg',
        imageBrightness: Brightness.light,
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
        MealHeader('Cooking Tips'),
        MealListItem(
          bullet: true,
          text: 'Avoid deep fried foods.',
        ),
        MealListItem(
          bullet: true,
          text: 'Trim visible fat off meats and remove the skin from poultry before cooking.',
        ),
        MealListItem(
          bullet: true,
          text: 'Bake, broil, boil, poach or roast poultry, fish and lean meats.',
        ),
        MealListItem(
          bullet: true,
          text: 'Drain and discard fat that drains out of meat as you cook it.',
        ),
        MealListItem(
          bullet: true,
          text: 'Add little or no fat to foods.',
        ),
        MealListItem(
          bullet: true,
          text: 'Use vegetable oil sprays to grease pans for cooking or baking.',
        ),
        MealListItem(
          bullet: true,
          text: 'Steam vegetables.',
        ),
        MealListItem(
          bullet: true,
          text: 'Use herbs or no-oil marinades to flavour foods.',
        ),
      ],
    );
  }
}
