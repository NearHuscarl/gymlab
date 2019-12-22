import 'package:flutter/material.dart';
import 'meal_image.dart';
import 'meal_template.dart';

const description =
    '''Intermittent fasting is an eating pattern that cycles beween periods of fasting and eating.

Rather than restricting the foods you eat, it states when you should eat them.

Therefore, it can be seen as more of an eating pattern than a diet.

The most popular ways to do intermittent fasting are:''';

const howItWorks =
    '''Intermittent fasting is commonly used for weight loss because it leads to relatively easy calorie restriction.

It can make you eat fewer calories overall, as long as you don't overcompensate by eating much more during the eating periods.''';

const weightLoss =
    '''Intermittent fasting is generally very successful for weight loss. It has been shown to cause weight loss of 3-8% over a period of 3-24 weeks, which is a lot compared to most weight loss studies.

In addition to causing less muscle loss than standard calorie restriction, it may increase your metabolic rate by 3.6-14% in the short-term''';

const otherBenefits =
    '''Intermittent fasting may reduce markers of inflammation, cholesterol levels, blood triglycerides and blood sugar levels.

Furthermore, intermittent fasting has been linked to increased levels of human growth hormone, improved insulin sensitivity, improved cellular repair and altered gene expressions.

Animal studies also suggest that it may help new brain cells grow, lengthen lifespan and protect against Alzheimer's disease and cancer.''';

const downside = '''Although intermittent fasting is safe for well-nourished and healthy people, it does not suit everyone. Some studies have shown it's not as beneficial for women as it is for men.

In addition, some people should avoid fasting.

This includes those sensitive to drops in blood sugar levels, pregnant women, breastfeeding moms, teenagers, children and people who are malnourished, underweight or nutrient deficient.''';

const eat = '''Anything you want, just don't overdo it. The focus of this diet is not what you eat - but when you eat.''';

const avoid = '''Nothing particular to avoid. Just use common sense and avoid the top, but don't go crazy on your non-fasting days.''';

class IntermittentFastingMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MealTemplate(
      image: MealImage(
        title: 'Intermittent Fasting',
        image: 'assets/images/meals/intermittentFasting.jpg',
        imageBrightness: Brightness.light,
      ),
      body: <Widget>[
        MealParagraph(description),      
        MealListItem(
          bullet: true,
          title: 'The 16/8 method',
          text: 'Involves skipping breaxtst and restricting your daily eating period to 8 hours, subsequently fasting for the remaining 16 hours of the day.',
        ),
        MealListItem(
          bullet: true,
          title: 'The eat-stop-eat method',
          text: 'Involves 24- hour fasts once or twice per week on non- consecutive days.',
        ),
        MealListItem(
          bullet: true,
          title: 'The 5:2 diet',
          text: 'On two non-consecutive days of the week, you restrict your intake to 500-600 calories. On the five remaining days, you eat like normal.',
        ),
        MealListItem(
          bullet: true,
          title: 'The warrior diet',
          text: 'Eat small amounts of raw fruits and vegetables during the day and one huge meal at night, basically fasting during the day and feasting at night within a 4-hour window.',
        ),
        MealHeader('How it works'),
        MealParagraph(howItWorks),
        MealHeader('Weight loss'),
        MealParagraph(weightLoss),
        MealHeader('Other benefits'),
        MealParagraph(otherBenefits),
        MealHeader('The downside'),
        MealParagraph(downside),
        MealHeader('Eat'),
        MealParagraph(eat),
        MealHeader('Avoid'),
        MealParagraph(avoid),
      ],
    );
  }
}
