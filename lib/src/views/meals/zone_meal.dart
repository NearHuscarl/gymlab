import 'package:flutter/material.dart';
import 'meal_image.dart';
import 'meal_template.dart';

const description =
    '''The zone diet is a low-glycemic load diet on which you limit carbs to 35-45% of daily calories and protein and fat to 30% each.

It recommends eating only carbs with a low glycemic load.

The glycemic load (GL) of a food is an estimate of how much a food will raise your blood glucose levels after eating it. It takes into account how many carbs are in the food and how much that amount will raise your blood glucose levels.

The Zone diet was initially developed to reduce diet-induced inflammation, cause weight loss and reduce the risk of developing chronic diseases.''';

const howItWorks =
    '''The Zone diet recommends balancing each meal with one-third protein, two-thirds colourful fruits and veggies and a dash of fat, namely monounsaturated oil such as olive oil, avocado or almonds.

It also says to limit the intake of high-GL carbs, such as bananas, rice and potatoes.''';

const weightLoss =
    '''Studies on the effects of a low-glycemic load diet on weight loss are rather inconsistent.

Some studies say the diet promotes weight loss and reduces appetite, while others only show a small weight loss, compared to other weight loss diets.''';

const otherBenefits =
    '''The greatest benefit of this diet is a reduction in risk factors for heart disease, such as reduced cholesterol and triglycerides.

One study also showed that the Zone diet may improve blood sugar control, reduce waist circumference and reduce inflammation in overweight or obese individuals with type 2 diabetes.''';

const downside = '''There are not many issues with this diet. The only thing to critizize is that im limits the consumption of some healthy carb sources, such as bananas and potatoes.''';

class ZoneMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MealTemplate(
      image: MealImage(
        title: 'Zone',
        image: 'assets/images/meals/zone.jpg',
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
        MealSmallHeader('Protein:'),
        MealListItem(
          bullet: true,
          text: 'Skinless chicken and turkey breast',
        ),
        MealListItem(
          bullet: true,
          text: 'Fish and shellfish',
        ),
        MealListItem(
          bullet: true,
          text: 'Vegetarian protein, tofu, other soy products',
        ),
        MealListItem(
          bullet: true,
          text: 'Egg whites',
        ),
        MealListItem(
          bullet: true,
          text: 'Low-fat cheeses',
        ),
        MealListItem(
          bullet: true,
          text: 'Low-fat milk and yoghurt',
        ),
        MealSmallHeader('Fat:'),
        MealListItem(
          bullet: true,
          text: 'Avocados',
        ),
        MealListItem(
          bullet: true,
          text: 'Peanut butter',
        ),
        MealListItem(
          bullet: true,
          text: 'Tahini',
        ),
        MealListItem(
          bullet: true,
          text: 'Oils such as canola oil, sesame oil, peanut oil and olive oil',
        ),
        MealListItem(
          bullet: true,
          text: 'Nuts, such as macadamia, peanuts, cashews, almonds or pistachios',
        ),
        MealSmallHeader('Garbs:'),
        MealListItem(
          bullet: true,
          text: 'Fruit such as berries, apples, oranges, plums and more',
        ),
        MealListItem(
          bullet: true,
          text: 'Vegetables such as cucumbers, peppers, spinach, tomatoes, mushrooms, yellowsquash, chickpeas and more',
        ),
        MealListItem(
          bullet: true,
          text: 'Grains, such as oatmeal and barley.',
        ),
        MealHeader('Avoid'),
        MealListItem(
          title: 'High-sugar fruits',
          text: 'Such as bananas, grapes, raisins, dried fruits and mangoes.',
        ),
        MealListItem(
          title: 'High-sugar or starchy vegetables',
          text: 'Like peas, corn, carrots and potatoes.',
        ),
        MealListItem(
          title: 'Refined and processed carbs',
          text: 'Bread, bagels, pasta, noodles and other white-flour products.',
        ),
        MealListItem(
          title: 'Other processed foods',
          text: 'Including breakfast cereals and muffins.',
        ),
        MealListItem(
          title: 'Foods with added sugar',
          text: 'Such as candy, cakes and cookies.',
        ),
        MealListItem(
          title: 'Soft drinks',
          text: 'Neither sugar-sweetened nor sugar-free drinks are recommended.',
        ),
        MealListItem(
          title: 'Coffee and tea',
          text: 'Keep these to a minimum, since water is the beverage of choice.',
        ),
      ],
    );
  }
}
