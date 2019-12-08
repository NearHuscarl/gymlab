import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'image_player.dart';
import '../components/muscle_anatomy.dart';
import '../components/flex_with_gap.dart';
import '../components/linebreak.dart';
import '../../blocs/exercise_detail_bloc.dart';
import '../../models/exercise_detail.dart';
import '../../models/variation.dart';
import '../../helpers/enum.dart';

class ExerciseDetailSection extends StatefulWidget {
  @override
  _ExerciseDetailSectionState createState() => _ExerciseDetailSectionState();
}

class _ExerciseDetailSectionState extends State<ExerciseDetailSection> {
  int _selectedPage;
  PageController _pageController;
  bool hasVariationPage = false;
  // TODO: find icon for variation page
  List<IconData> _icons = [Icons.info, Icons.image, Icons.description];

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  PageController _getPageController() {
    if (_pageController == null) {
      final initialPage = hasVariationPage ? 1 : 0;
      _pageController = PageController(initialPage: initialPage);
      _selectedPage = initialPage;
    }
    return _pageController;
  }

  Widget _buildDetailPages(ThemeData theme, ExerciseDetail exercise) {
    return PageView(
      physics: BouncingScrollPhysics(),
      controller: _getPageController(),
      onPageChanged: (page) => setState(() => _selectedPage = page),
      children: <Widget>[
        if (!exercise.variation.isEmpty) _ExerciseVariation(exercise),
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
        _ExerciseDescription(exercise),
      ],
    );
  }

  Widget _buildNavigationButton(int pageIndex) {
    final effectivePageIndex = hasVariationPage ? pageIndex : pageIndex + 1;
    final selected = pageIndex == _selectedPage;
    return IconButton(
      icon: Icon(_icons[effectivePageIndex]),
      color: selected ? Colors.indigo : Colors.grey,
      onPressed: () {
        _pageController.jumpToPage(pageIndex);
        setState(() => _selectedPage = pageIndex);
      },
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
          hasVariationPage = !exercise.variation.isEmpty;
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
                  child: _buildDetailPages(theme, exercise),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildNavigationButton(0),
                    _buildNavigationButton(1),
                    if (hasVariationPage) _buildNavigationButton(2),
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

class _ExerciseDescription extends StatelessWidget {
  _ExerciseDescription(this.exercise);

  final ExerciseDetail exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalTheme = theme.textTheme.body1.copyWith(fontSize: 16);
    final boldTheme = theme.textTheme.body2.copyWith(fontSize: 16);
    final paragraph = exercise.description.split('\n');
    const textPadding = const EdgeInsets.only(top: 8.0);
    final primaryMuscle = exercise.muscles.first;
    final secondaryMuscles = exercise.muscles.skip(1).map((m) => m);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: normalTheme,
            children: <TextSpan>[
              TextSpan(
                text: 'Primary Muscle: ',
                style: boldTheme,
              ),
              TextSpan(
                text: EnumHelper.parseWord(primaryMuscle.muscle),
              ),
            ],
          ),
        ),
        if (secondaryMuscles.isNotEmpty)
          Padding(
            padding: textPadding,
            child: RichText(
              text: TextSpan(style: normalTheme, children: [
                TextSpan(
                  text: 'Secondary Muscle: ',
                  style: boldTheme,
                ),
                TextSpan(
                  text: secondaryMuscles
                      .map((m) => EnumHelper.parseWord(m.muscle))
                      .join(', '),
                )
              ]),
            ),
          ),
        Linebreak(),
        RichText(
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
        Padding(
          padding: textPadding,
          child: Text('Description: ', style: theme.textTheme.body2),
        ),
      ]
        ..addAll(paragraph.map(
          (p) => Padding(
            padding: textPadding,
            child: Text('- ' + p),
          ),
        ))
        ..add(Padding(
          padding: textPadding,
          child: MuscleAnatomy(
            primary: primaryMuscle,
            secondaries: secondaryMuscles,
          ),
        )),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content,
      ),
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

class _ExerciseVariation extends StatelessWidget {
  _ExerciseVariation(this.exercise);

  final ExerciseDetail exercise;

  Widget _getGripTypeImage(GripType gripType) => Image.asset(
        'assets/images/variations/closed_griptype_${EnumHelper.parse(gripType)}.png',
        width: 55.0,
      );

  Widget _getGripWidthImage(GripWidth gripWidth) => Image.asset(
        'assets/images/variations/closed_gripwidth_${EnumHelper.parse(gripWidth)}.png',
        width: 115.0,
      );

  Widget _getWeightTypeImage(WeightType weightType) => Image.asset(
        'assets/images/variations/closed_weighttype_${EnumHelper.parse(weightType).toLowerCase()}.png',
        width: 90.0,
      );

  Widget _getTempoImage(RepetitionsSpeed speed) => Image.asset(
        'assets/images/variations/closed_repetitionsspeed_${EnumHelper.parse(speed).substring(1)}.png',
        width: 60.0,
      );

  String _getTempoText(RepetitionsSpeed speed) {
    switch (speed) {
      case RepetitionsSpeed.k11:
        return 'Regular';
      case RepetitionsSpeed.k22:
        return 'Extended';
      case RepetitionsSpeed.k24:
        return 'Strength Building';
    }
    return ''; // shut up dart linter
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final variation = exercise.variation;
    final boldTheme = theme.textTheme.body2.copyWith(fontSize: 16);
    final captionTheme = theme.textTheme.caption.copyWith(fontSize: 10);
    const textPadding = const EdgeInsets.only(top: 8.0);
    const gap = 20.0;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: textPadding,
          child: Text('Variations', style: boldTheme.copyWith(fontSize: 17)),
        ),
        SizedBox(height: 10),
        if (variation.gripType.isNotEmpty)
          Column(
            children: <Widget>[
              Text('Grip Type', style: boldTheme.copyWith(fontSize: 14)),
              SizedBox(height: 5),
              RowWithGap(
                gap: gap,
                mainAxisAlignment: MainAxisAlignment.center,
                children: variation.gripType
                    .map((g) => Column(
                          children: <Widget>[
                            _getGripTypeImage(g),
                            Text(
                              EnumHelper.parseWord(g),
                              style: captionTheme,
                            )
                          ],
                        ))
                    .toList(),
              ),
              Linebreak(),
            ],
          ),
        if (variation.gripWidth.isNotEmpty)
          Column(
            children: <Widget>[
              Text('Grip Width', style: boldTheme.copyWith(fontSize: 14)),
              SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: RowWithGap(
                  gap: gap,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: variation.gripWidth
                      .map((g) => Column(
                            children: <Widget>[
                              _getGripWidthImage(g),
                              Text(
                                EnumHelper.parseWord(g),
                                style: captionTheme,
                              )
                            ],
                          ))
                      .toList(),
                ),
              ),
              Linebreak(),
            ],
          ),
        if (variation.weightType.isNotEmpty)
          Column(
            children: <Widget>[
              Text('Weight Type', style: boldTheme.copyWith(fontSize: 14)),
              SizedBox(height: 5),
              RowWithGap(
                gap: gap,
                mainAxisAlignment: MainAxisAlignment.center,
                children: variation.weightType
                    .map((w) => Column(
                          children: <Widget>[
                            _getWeightTypeImage(w),
                            Text(
                              EnumHelper.parseWord(w),
                              style: captionTheme,
                            )
                          ],
                        ))
                    .toList(),
              ),
              Linebreak(),
            ],
          ),
        if (variation.repetitionsSpeed.isNotEmpty)
          Column(
            children: <Widget>[
              Text('Weight Type', style: boldTheme.copyWith(fontSize: 14)),
              SizedBox(height: 5),
              RowWithGap(
                gap: gap,
                mainAxisAlignment: MainAxisAlignment.center,
                children: variation.repetitionsSpeed
                    .map((s) => SizedBox(
                          width: 90,
                          child: Column(
                            children: <Widget>[
                              _getTempoImage(s),
                              Text(
                                _getTempoText(s),
                                style: captionTheme,
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: content,
      ),
    );
  }
}
