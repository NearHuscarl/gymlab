import 'package:flutter/material.dart';
import 'meal_image.dart';
import 'meal_template.dart';

const description =
    '''The paleo diet claims that modern humans should eat the same foods that their hunter-gatherer ancestors ate — the way humans were genetically designed to eat before agriculture developed.

The theory is that most modern diseases can be linked to the Western diet and the consumption of grains, dairy and processed foods.

While it's debatable that this diet is comprised of the same foods your ancestors ate, it is linked to several impressive health benefits.''';

const howItWorks =
    '''The paleo diet emphasizes whole foods, lean protein, vegetables, fruits, nuts and seeds, while avoiding processed foods, sugar, dairy and grains.

Some more flexible versions of the paleo diet also allow for dairy like cheese and butter, as well as tubers like potatoes and sweet potatoes.''';

const weightLoss =
    '''Several studies have shown that the paleo diet can lead to significant weight loss and reduced waist size.

In studies, paleo dieters have also been shown to automatically eat much fewer carbs, more protein and 300-900 fewer calories per day.''';

const otherBenefits =
    '''The diet seems effective at reducing risk factors for heart disease, such as cholesterol, blood sugar, blood triglycerides and blood pressure.''';

const downside = '''The paleo diet eliminates whole grains, legumes and dairy.

Therefore, it unnecessarily eliminates several healthy and nutritious food groups.''';

class PaleoMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MealTemplate(
      image: MealImage(
        title: 'Paleo',
        image: 'assets/images/meals/paleo.jpg',
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
          text: 'Beef, lamb, chicken, turkey, pork, and others',
        ),
        MealListItem(
          title: 'Fish and Seafood',
          text: 'Salmon, trout, haddock, shrimp, shellfish, etc. Choose wild-caught if you can.',
        ),
        MealListItem(
          title: 'Eggs',
          text: 'Choose free-range, pastured or omega-3 enriched eggs.',
        ),
        MealListItem(
          title: 'Vegetables',
          text: 'Broccoli, kale, peppers, onions, carrots, tomatoes, etc.',
        ),
        MealListItem(
          title: 'Fruits',
          text: 'Apples, bananas, oranges, pears, avocados, strawberries, blueberries, avocados and more.',
        ),
        MealListItem(
          title: 'Tubers',
          text: 'Potatoes, sweet potatoes, yams, turnips, etc.',
        ),
        MealListItem(
          title: 'Nuts and Seeds',
          text: 'Almonds, macadamia nuts, walnuts, hazelnuts, sunflower seeds, pumpkin seeds and more',
        ),
        MealListItem(
          title: 'Healthy Fats and Oils',
          text: 'Extra virgin olive oil, coconut oil, avocado oil and others.',
        ),
        MealListItem(
          title: 'Salt and Spices',
          text: 'Sea salt, Himalayan salt, garlic, turmeric, rosemary, etc.',
        ),
        MealHeader('Avoid'),
        MealListItem(
          title: 'Sugar and High Fructose Corn Syrup',
          text: 'Soft drinks, fruit juices, table sugar, candy, pastries, ice cream and many others.',
        ),
        MealListItem(
          title: 'Grains',
          text: 'Includes bread and pasta, wheat, spelt, rye, barley, etc.',
        ),
        MealListItem(
          title: 'Legumes',
          text: 'Beans, lentils and many more.',
        ),
        MealListItem(
          title: 'Dairy',
          text: 'Avoid most dairy, especially low-fat (some versions of paleo do include full-fat dairies like butter and cheese).',
        ),
        MealListItem(
          title: 'Vegetable Oils',
          text: 'Soybean oil, sunflower oil, cottonseed oil, corn oil, grapeseed oil, safflower oil and others.',
        ),
        MealListItem(
          title: 'Trans Fats',
          text: 'Found in margarine and various processed foods. Usually referred to as "hydrogenated" or "partially hydrogenated" oils.',
        ),
        MealListItem(
          title: 'Artificial Sweeteners',
          text: 'Aspartame, Suoralose, Cyclamates, Saccharin, Acesulfame Potassium. Use natural sweeteners instead.',
        ),
        MealListItem(
          title: 'Highly Processed Foods',
          text: 'Everything labelled "diet" or "low-fat" or has many weird ingredients. Includes artificial meal replacements.',
        ),
      ],
    );
  }
}
