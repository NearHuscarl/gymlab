import 'package:flutter/material.dart';

const iconButtonFadeDuration = const Duration(milliseconds: 250);

class EditButton extends StatelessWidget {
  EditButton({
    this.onPressed,
    this.edit = false,
  });

  final VoidCallback onPressed;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedCrossFade(
        duration: iconButtonFadeDuration,
        firstChild: Icon(Icons.done),
        secondChild: Icon(Icons.edit),
        crossFadeState: edit
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
      onPressed: onPressed,
    );
  }
}

class FavoriteButton extends StatelessWidget {
  FavoriteButton({
    this.onPressed,
    this.favorite = false,
    this.color,
  });

  final VoidCallback onPressed;
  final bool favorite;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      icon: AnimatedCrossFade(
        duration: iconButtonFadeDuration,
        firstChild: Icon(Icons.star),
        secondChild: Icon(Icons.star_border),
        crossFadeState: favorite
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
      onPressed: onPressed,
    );
  }
}
