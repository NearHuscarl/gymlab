import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';

class MealImage extends StatelessWidget {
  MealImage({
    this.title,
    this.image,
    this.imageBrightness,
    this.onTap,
    this.height = 200,
    this.displayText = false,
  });

  final String title;
  final String image;
  // if imageBrightness == dark. Use white font. else use dark font
  final Brightness imageBrightness;
  final VoidCallback onTap;
  final double height;
  final bool displayText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor =
        imageBrightness == Brightness.dark ? Colors.white : AppColors.black75;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: image,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                height: height,
                width: double.infinity,
              ),
            ),
            displayText
                ? FractionallySizedBox(
                    widthFactor: .6,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      child: Text(
                        // replace with non-breaking hyphen unicode character,
                        // text will now not break at hyphen
                        title.replaceAll('-', '\u2011'),
                        style:
                            theme.textTheme.display1.copyWith(color: fontColor),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
