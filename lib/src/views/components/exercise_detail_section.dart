import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'image_player.dart';
import '../../blocs/exercise_detail_bloc.dart';
import '../../models/exercise_detail.dart';
import '../../helpers/enum.dart';

class ExerciseDetailSection extends StatefulWidget {
  @override
  _ExerciseDetailSectionState createState() => _ExerciseDetailSectionState();
}

class _ExerciseDetailSectionState extends State<ExerciseDetailSection> {
  static const initialPage = 1;
  PageController _pageController;
  // TODO: find icon for variation page
  List<IconData> _icons = [Icons.info, Icons.image, Icons.description];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _buildDescription(ThemeData theme, ExerciseDetail exercise) {
    final normalTheme = theme.textTheme.body1.copyWith(fontSize: 16);
    final boldTheme = theme.textTheme.body2.copyWith(fontSize: 16);
    final paragraph = exercise.description.split('\n');
    const textPadding = const EdgeInsets.only(top: 8.0);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              // TODO: add image of muscle atonamy
              style: normalTheme,
              children: <TextSpan>[
                TextSpan(
                  text: 'Primary Muscle: ',
                  style: boldTheme,
                ),
                TextSpan(
                  text: EnumHelper.parseWord(exercise.muscles.first.muscle),
                ),
              ],
            ),
          ),
          if (exercise.muscles.length > 1)
            Padding(
              padding: textPadding,
              child: RichText(
                text: TextSpan(style: normalTheme, children: [
                  TextSpan(
                    text: 'Secondary Muscle: ',
                    style: boldTheme,
                  ),
                  TextSpan(
                    text: exercise.muscles
                        .skip(1)
                        .map((m) => EnumHelper.parseWord(m.muscle))
                        .join(', '),
                  )
                ]),
              ),
            ),
          Padding(
            padding: textPadding,
            child: RichText(
              text: TextSpan(style: normalTheme, children: [
                TextSpan(
                  text: 'Exercise Type: ',
                  style: boldTheme,
                ),
                TextSpan(
                  text: EnumHelper.parseWord(exercise.type),
                )
              ]),
            ),
          ),
          Padding(
            padding: textPadding,
            child: Text('Description: ', style: theme.textTheme.body2),
          )
        ]..addAll(paragraph.map(
            (p) => Padding(
              padding: textPadding,
              child: Text(p),
            ),
          )),
      ),
    );
  }

  Widget _buildDetail(ThemeData theme, ExerciseDetail exercise) {
    return PageView(
      physics: BouncingScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              // TODO: add variation and helpers
              child: Text(exercise.variation.toJson().toString()),
            ),
          ],
        ),
        Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 500,
              child: _ImagePlayer(
                images: List<int>.generate(exercise.imageCount, (i) => i)
                    .map((index) => AssetImage(
                          'assets/images/exercise_workout_${exercise.id}_$index.jpg',
                        ))
                    .toList(),
                defaultIndex: exercise.thumbnailImageIndex,
              ),
            ),
          ],
        ),
        _buildDescription(theme, exercise),
      ],
    );
  }

  Widget _buildNavigationButton(int pageIndex) {
    final selected = _pageController.positions.isNotEmpty
        ? pageIndex == _pageController.page
        : pageIndex == initialPage;
    return IconButton(
      icon: Icon(_icons[pageIndex]),
      color: selected ? Colors.indigo : Colors.grey,
      onPressed: () => setState(() => _pageController.jumpToPage(pageIndex)),
      iconSize: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = Provider.of<ExerciseDetailBloc>(context);

    return StreamBuilder(
      stream: bloc.detail,
      builder: (context, AsyncSnapshot<ExerciseDetail> snapshot) {
        if (snapshot.hasData) {
          final exercise = snapshot.data;
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    exercise.name,
                    style: theme.textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: _buildDetail(theme, exercise),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildNavigationButton(0),
                    _buildNavigationButton(1),
                    _buildNavigationButton(2),
                  ],
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ImagePlayer extends StatefulWidget {
  _ImagePlayer({
    Key key,
    @required this.images,
    this.defaultIndex,
    this.playInterval = const Duration(milliseconds: 1000),
  }) : super(key: key);

  final List<ImageProvider<dynamic>> images;
  final int defaultIndex;
  final Duration playInterval;

  @override
  __ImagePlayerState createState() => __ImagePlayerState();
}

class __ImagePlayerState extends State<_ImagePlayer>
    with SingleTickerProviderStateMixin {
  ImageController _imageController;
  AnimationController _playPauseController;
  Animation<double> _opacityAnimation;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _imageController = ImageController(autoPlay: true);
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..value = 1.0;

    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: _playPauseController,
    ));

    _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: _playPauseController,
    ));
  }

  @override
  void dispose() {
    _imageController.dispose();
    _playPauseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final icon = Icon(
      _imageController.isPlaying ? Icons.play_arrow : Icons.pause,
      color: Colors.white,
      size: media.size.width / 7,
    );
    final iconShadow = Icon(
      _imageController.isPlaying ? Icons.play_arrow : Icons.pause,
      color: Colors.black,
      size: media.size.width / 7 + 2,
    );

    return Stack(
      children: <Widget>[
        ImagePlayer(
          images: widget.images,
          defaultIndex: widget.defaultIndex,
          playInterval: widget.playInterval,
          controller: _imageController,
        ),
        SizedBox.expand(
          child: InkResponse(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(() => _imageController.togglePlay());
              _playPauseController
                ..reset()
                ..forward();
            },
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // TODO: fix this ugly workaround (add boxshadow for icon)
                    iconShadow,
                    icon,
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
