import 'package:flutter/material.dart';
import 'meal_image.dart';
import 'meal_template.dart';

const description =
    '''The vegan diet was created by a group of vegetarians who also chose not to consume dairy, eggs or any other animal products. The vegan way of life attempts to exclude all forms of animal exploitation and cruelty for ethical, environmental or health reasons.''';

const howItWorks =
    '''Veganism is the strictest form of vegetarianism.

In addition to eliminating meat, it eliminates dairy, eggs and animal-derived products, such as gelatin, honey, albumin, whey, casein and some forms of vitamin D3.''';

const weightLoss =
    '''A vegan diet seems to be very effective at helping people lose weight, often without counting calories. This may be explained by its very low fat and high fiber content, which makes you feel fuller for longer.

Vegan diets have consistently been linked to lower body weight and body mass index (DNA), compared to other diets. One study showed that a vegan diet helped participants lose 9.3 lbs (4.2 kg) more than a control diet over 18 weeks. The vegan group was allowed to eat until fullness, but the control group had to restrict calories.

However, vegan diets are not more effective for weight loss than other diets when matched for''';

const otherBenefits =
    '''Plant-based diets have been linked with a reduced risk of heart disease, type 2 diabetes and premature death.

Limiting processed meat may also reduce your risk of developing Alzheimer's disease and dying from heart disease or cancer.''';

const downside = '''Vegan diets eliminate animal foods completely, so they may be low in severaal nutrients. This includes vitamin B12, vitamin D, iodine, iron, calcium, zinc and omega-3 fatty acids.''';

class VeganMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MealTemplate(
      image: MealImage(
        title: 'Vegan',
        image: 'assets/images/meals/vegan.jpg',
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
        MealHeader('Eat'),
        MealListItem(
          title: 'Tofu, tempeh and seitan',
          text: 'These provide a versatile protein-rich alternative to meat, fish, poultry and eggs in many recipes.',
        ),
        MealListItem(
          title: 'Legumes',
          text: 'Foods such as beans, lentils and peas are excellent sources of many nutrients and beneficial plant compounds. Sprouting, fermenting and proper cooking can increase nutrient absorption.',
        ),
        MealListItem(
          title: 'Nuts and nut butter',
          text: 'Especially unblanched and unreasted varieties, which are good source of iron, fiber, magnesium zinc, selenium and vitamin E.',
        ),
        MealListItem(
          title: 'Seeds',
          text: 'Especially hemp, chia and flaxseeds, which contain a good amount of protein and beneficial omega-3 fatty acids.',
        ),
        MealListItem(
          title: 'Calcium-fortified plant milk and yoghurt',
          text: 'These help vegans achieve their recommended dietary calcium intakes. Opt for varieties also fortified with vitamins B12 and D whenever possible.',
        ),
        MealListItem(
          title: 'Algae',
          text: 'Spirulina and chlorella are good sources of complete protein. Other varieties are great sources of iodine.',
        ),
        MealListItem(
          title: 'Nutritional yeast',
          text: 'This is an easy way to increase the protein content of vegan dishes and add an interesting cheesy flavuor. Pick vitamin B12-fortified varieties whenever possible.',
        ),
        MealListItem(
          title: 'Whole grains, cereals and pseudocereals',
          text: 'These are a great source of complex carbs, fiber, iron, B-vitamins and several minerals. Spelt, teff amaranth and quinoa are especially high-protein options.',
        ),
        MealListItem(
          title: 'Sprouter and fermented plant food',
          text: 'Ezekiel, bread, tempeh, miso, natto, sauerkraut, pickles, kimchi and kombucha often contain probiotics and vitamin K2. Sprouting and fermenting can help improve mineral absorption.',
        ),
        MealListItem(
          title: 'Ftuits and vegetables',
          text: 'Both are great foods to increase your nutrient intake. Leafy greens such as bok choy, spinach, kale, watercress and mustard greens are particularly high in iron and calcium.',
        ),
        MealHeader('Avoid'),
        MealListItem(
          title: 'Meat and poultry',
          text: 'Beef, lamp, pork, veal, horse, organ meat, wild meat, chicken, turkey, goose, dick, quail, etc.',
        ),
        MealListItem(
          title: 'Fish and Seafood',
          text: 'All types of fish. anchovies, shrimp, squid, scallops, calamari, mussels, crab, lobster, etc.',
        ),
        MealListItem(
          title: 'Dairy',
          text: 'Milk, yoghurt, chesse, butter, cream, ice cream, etc.',
        ),
        MealListItem(
          title: 'Eggs',
          text: 'From chickens, quails, ostriches, fish, etc.',
        ),
        MealListItem(
          title: 'Bee products',
          text: 'Honey, bee pollen, royal jelly, etc.',
        ),
        MealListItem(
          title: 'Animal-based ingredient',
          text: 'Whey, casein, lactose, egg white albumen, gelatin, cochineal or carmine, isinglass, shellac, L-cysteine, animal-derived vitamin D3 and fish-derived omega-3 fatty acids.',
        ),
      ],
    );
  }
}
