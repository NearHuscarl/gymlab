import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../components/bloc_provider.dart';
import '../components/image_player.dart';
import '../components/muscle_anatomy.dart';
import '../components/flex_with_gap.dart';
import '../components/linebreak.dart';
import '../components/variation_help_dialogs.dart';
import '../../blocs/exercise_detail_bloc.dart';
import '../../models/exercise_summary.dart';
import '../../models/exercise_detail.dart';
import '../../models/muscle_info.dart';
import '../../models/variation.dart';
import '../../helpers/enum.dart';
import '../../helpers/constants.dart';
import '../../helpers/exercises.dart';

class ExerciseDetailSection extends StatefulWidget {
  ExerciseDetailSection(this.summary);

  final ExerciseSummary summary;

  @override
  _ExerciseDetailSectionState createState() => _ExerciseDetailSectionState();
}

class _ExerciseDetailSectionState extends State<ExerciseDetailSection> {
  int _selectedPage;
  PageController _pageController;
  bool get hasVariationPage => widget.summary.hasVariation;
  // TODO: find icon for variation page
  List<IconData> _icons = [Icons.info, Icons.image, Icons.description];

  @override
  void initState() {
    super.initState();

    final initialPage = hasVariationPage ? 1 : 0;
    _selectedPage = initialPage;
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _buildDetailPages(
    ThemeData theme,
    ExerciseDetail exercise,
  ) {
    final widgets = [
      if (!exercise.variation.isEmpty) _ExerciseVariation(exercise),
      _ImagePlayer(
        tag: Constants.exercisePreviewTag(exercise.id),
        images: List<int>.generate(exercise.imageCount, (i) => i)
            .map((index) =>
                AssetImage(getImage(exercise.id, index)))
            .toList(),
        defaultIndex: exercise.thumbnailImageIndex,
      ),
      _ExerciseDescription(exercise),
    ];

    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: _pageController,
      onPageChanged: (page) => setState(() => _selectedPage = page),
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        final effectiveIndex = hasVariationPage ? index : index + 1;

        switch (effectiveIndex) {
          case 0:
            return _ExerciseVariation(exercise);
          case 1:
            return _ImagePlayer(
              tag: Constants.exercisePreviewTag(exercise.id),
              images: List<int>.generate(exercise.imageCount, (i) => i)
                  .map((index) =>
                      AssetImage(getImage(exercise.id, index)))
                  .toList(),
              defaultIndex: exercise.thumbnailImageIndex,
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
            );
          case 2:
            return _ExerciseDescription(exercise);
          default:
            throw Exception('No such page');
        }
      },
    );
  }

  Widget _buildNavigationButton(int pageIndex) {
    final effectivePageIndex = hasVariationPage ? pageIndex : pageIndex + 1;
    final selected = pageIndex == _selectedPage;
    return IconButton(
      icon: Icon(_icons[effectivePageIndex]),
      color: selected ? Colors.indigo : Colors.grey,
      onPressed: () {
        _pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.ease,
        );
        setState(() => _selectedPage = pageIndex);
      },
      iconSize: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = BlocProvider.of<ExerciseDetailBloc>(context);

    return LayoutBuilder(builder: (context, constraints) {
      final contentHeight = constraints.maxHeight;
      return StreamBuilder(
        stream: bloc.detail,
        initialData: ExerciseDetail.fromSummary(widget.summary),
        builder: (context, AsyncSnapshot<ExerciseDetail> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final exercise = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                constraints:
                    BoxConstraints.tightFor(height: contentHeight * .15),
                alignment: Alignment.bottomCenter,
                child: Text(
                  exercise.name,
                  style: theme.textTheme.title,
                  textAlign: TextAlign.center,
                ),
              ),
              ConstrainedBox(
                constraints:
                    BoxConstraints.tightFor(height: contentHeight * .7),
                child: _buildDetailPages(theme, exercise),
              ),
              Container(
                constraints:
                    BoxConstraints.tightFor(height: contentHeight * .15),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildNavigationButton(0),
                    _buildNavigationButton(1),
                    if (hasVariationPage) _buildNavigationButton(2),
                  ],
                ),
              ),
            ],
          );
        },
      );
    });
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
    final primaryMuscle =
        exercise.muscles.firstWhere((m) => m.target == Target.primary);
    final secondaryMuscles =
        exercise.muscles.where((m) => m != primaryMuscle).map((m) => m);

    final content = <Widget>[
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
          muscles: exercise.muscles,
        ),
      ));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: content,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePlayer extends StatefulWidget {
  _ImagePlayer(
      {Key key,
      @required this.images,
      this.defaultIndex,
      this.playInterval = const Duration(milliseconds: 1000),
      this.tag,
      this.fit = BoxFit.cover,
      this.filterQuality})
      : super(key: key);

  final List<ImageProvider<dynamic>> images;
  final int defaultIndex;
  final Duration playInterval;
  final String tag;
  final BoxFit fit;
  final FilterQuality filterQuality;

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
          tag: widget.tag,
          fit: widget.fit,
          filterQuality: widget.filterQuality,
        ),
        SizedBox.expand(
          child: InkResponse(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (widget.images.length == 1) return;
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

  Widget _getGripTypeImage(BuildContext context, GripType gripType) =>
      InkResponse(
        onTap: () => showGripTypeHelpDialog(context),
        child: Image.asset(
          getGripTypeImage(gripType),
          width: 55.0,
        ),
      );

  Widget _getGripWidthImage(BuildContext context, GripWidth gripWidth) =>
      InkResponse(
        onTap: () => showGripWidthHelpDialog(context),
        child: Image.asset(
          getGripWidthImage(gripWidth),
          width: 115.0,
        ),
      );

  Widget _getWeightTypeImage(BuildContext context, WeightType weightType) =>
      InkResponse(
        onTap: () => showWeightTypeHelpDialog(context),
        child: Image.asset(
          getWeightTypeImage(weightType),
          height: 35,
        ),
      );

  Widget _getTempoImage(BuildContext context, RepetitionsSpeed speed) =>
      InkResponse(
        onTap: () => showRepetitionsSpeedHelpDialog(context),
        child: Image.asset(
          getRepetitionsSpeedImage(speed),
          width: 60.0,
        ),
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

    final content = <Widget>[
      Padding(
        padding: textPadding,
        child: Text('Variations', style: boldTheme.copyWith(fontSize: 17)),
      ),
      SizedBox(height: 20),
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
                          _getGripTypeImage(context, g),
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
                            _getGripWidthImage(context, g),
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
            SingleChildScrollView(
              child: RowWithGap(
                gap: gap,
                mainAxisAlignment: MainAxisAlignment.center,
                children: variation.weightType
                    .map((w) => Column(
                          children: <Widget>[
                            _getWeightTypeImage(context, w),
                            Text(
                              EnumHelper.parseWord(w),
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
      if (variation.repetitionsSpeed.isNotEmpty)
        Column(
          children: <Widget>[
            Text('Repetitions Speed', style: boldTheme.copyWith(fontSize: 14)),
            SizedBox(height: 5),
            RowWithGap(
              mainAxisAlignment: MainAxisAlignment.center,
              children: variation.repetitionsSpeed
                  .map((s) => SizedBox(
                        width: 90,
                        child: Column(
                          children: <Widget>[
                            _getTempoImage(context, s),
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
    ];

    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: -50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: content,
            ),
          ),
        ),
      ),
    );
  }
}
