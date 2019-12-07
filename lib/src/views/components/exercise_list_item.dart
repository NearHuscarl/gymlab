import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'image_player.dart';
import '../../blocs/exercise_list_item_bloc.dart';
import '../../models/exercise_summary.dart';
import '../router.dart';

class ExerciseListItem extends StatefulWidget {
  ExerciseListItem(this.exercise);

  final ExerciseSummary exercise;

  @override
  _ExerciseListItemState createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<ExerciseListItem>
    with SingleTickerProviderStateMixin {
  AnimationController _playPauseController;
  ImageController _imageController;

  @override
  void initState() {
    super.initState();

    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // dont play exercise gif by default;
    _imageController = ImageController(autoPlay: false);
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _imageController.dispose();

    super.dispose();
  }

  Widget _buildFavoriteButton(ExerciseListItemBloc bloc) {
    return StreamBuilder(
      stream: bloc.favorite,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        final favorite = snapshot.data;
        final newFavorite = !favorite;
        return IconButton(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
          icon: newFavorite
              ? Icon(Icons.star_border, size: 17.5)
              : Icon(Icons.star, size: 17.5),
          onPressed: () => bloc.updateFavorite(newFavorite),
          color: Colors.black54,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        );
      },
    );
  }

  Widget _buildPlayButton(ExerciseListItemBloc bloc) {
    return IconButton(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.zero,
      icon: AnimatedIcon(
        progress: _playPauseController,
        icon: AnimatedIcons.play_pause,
      ),
      onPressed: () {
        final willPlayGif = !_imageController.isPlaying;
        if (willPlayGif) {
          _playPauseController.forward();
          _imageController.play();
        } else {
          _playPauseController.reverse();
          _imageController.pause();
        }
      },
      color: Colors.black54,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = Provider.of<ExerciseListItemBloc>(context);
    final nameTextTheme = theme.textTheme.caption;
    final exercise = widget.exercise;

    return GridTile(
      header: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildFavoriteButton(bloc),
            _buildPlayButton(bloc),
          ],
        ),
      ),
      child: ImagePlayer(
        images: List<int>.generate(exercise.imageCount, (i) => i)
            .map((index) => AssetImage(
                  'assets/images/exercise_workout_${exercise.id}_$index.jpg',
                ))
            .toList(),
        controller: _imageController,
        defaultIndex: exercise.thumbnailImageIndex,
        onTap: () => Router.exerciseDetail(context, exercise.id),
      ),
      footer: Stack(
        children: <Widget>[
          SizedBox(height: 42),
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black38,
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    exercise.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: nameTextTheme.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}