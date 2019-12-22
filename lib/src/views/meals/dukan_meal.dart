import 'package:flutter/material.dart';
import 'meal_image.dart';
import 'meal_template.dart';

const description =
    '''The Dukan diet is a high-protein, low-carb weight loss diet.

It's a low-calorie diet and can be split into four phases - tow weight loss phases and two maintenance phases.

How long you stay in each phase depends on how much weight you need to lose. Each phase has its own dietary pattern.''';

const howItWorks =
    '''The weight loss phases are primarily based on eating unlimited high-protein foods and mandatory oat bran.

The other phases involve adding non-starchy vegetables at first, then some cards and fat. Later on, there will be fewer and fewer "pure protein days" to maintain your new weight.''';

const weightLoss =
    '''One study showed that women following the Dukan diet ate about 1,000 calories and 100 grams of protein per day and lost an average of33 lbs (15 kg) in 8-10 weeks,

Also, many other studies have shown that high- protein, low-carb diets can have major weight loss benefits.

These include a higher metabolic rate, a decrease in the hunger hormone ghrelin and an increase in the fullness hormones GLP-1, PYY and CDC.''';

const otherBenefits =
    '''There are no recorded benefits of the Dukan diet in the scientific literature.''';

const downside = '''There is very little quality research available on the Dukan diet.

The Dukan diet limits both fat and carbs — strategy not based on science. On the contrary, consuming fat as part of a high- protein diet seems to increase metabolic rate, compared with both low-carb and low-fat diets.

Also, fast weight loss achieved by severe calorie restriction tends to cause significant muscle loss along with the fat loss,

The loss of muscle mass and severe calorie restriction may also cause the body to conserve energy, making it very easy to regain the weight after losing it.''';  

class DukanMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MealTemplate(
      image: MealImage(
        title: 'Dukan',
        image: 'assets/images/meals/dukan.jpg',
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
      ],
    );
  }
}
