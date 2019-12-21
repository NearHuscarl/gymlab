import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'meal_image.dart';
import '../components/exercise_list.dart';
import '../components/linebreak.dart';
import '../../helpers/app_colors.dart';

const mealPadding = 12.0;

class MealHeader extends StatelessWidget {
  MealHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 30,
            color: AppColors.black75,
            fontWeight: FontWeight.w300,
          ),
        ),
        Linebreak(padding: const EdgeInsets.only(top: 10)),
      ],
    );
  }
}

class MealSmallHeader extends StatelessWidget {
  MealSmallHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 23,
            color: AppColors.black75,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class MealParagraph extends StatelessWidget {
  MealParagraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        height: 1.45,
        color: AppColors.black75,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class MealListItem extends StatelessWidget {
  MealListItem({
    this.title,
    @required this.text,
    this.bullet = false,
  });

  final String title;
  final String text;
  final bool bullet;
  static const bulletWidget = Text('•');

  @override
  Widget build(BuildContext context) {
    const gap = 8.0;
    const bulletLeftPad = 12.0;
    final textWidth = MediaQuery.of(context).size.width -
        (mealPadding * 2 + bulletLeftPad) -
        12 -
        gap;
    final textStyle = TextStyle(
      fontSize: 20,
      height: 1.45,
      color: AppColors.black75,
      fontWeight: FontWeight.w300,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (bullet)
          Padding(
            padding: const EdgeInsets.only(left: bulletLeftPad),
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  width: 8,
                  height: 12,
                  color: Colors.transparent,
                ),
                Positioned(
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (bullet) SizedBox(width: gap),
        Container(
          width: textWidth,
          child: RichText(
            text: TextSpan(
              children: [
                if (title != null)
                  TextSpan(
                    text: title + ':',
                    style: textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                TextSpan(text: ' '),
                TextSpan(
                  text: text,
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MealTemplate extends StatelessWidget {
  MealTemplate({
    @required this.image,
    @required this.body,
  });

  final MealImage image;
  final List<Widget> body;
  String get title => image.title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimationLimiter(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: image.height,
              centerTitle: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(image.title),
                background: image,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => fadeInItem(widget),
                  children: body
                      .map((w) => Padding(
                            padding: const EdgeInsets.all(mealPadding),
                            child: w,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
