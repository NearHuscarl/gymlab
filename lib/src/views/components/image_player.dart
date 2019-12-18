import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

/// Play a set of images repeatedly (like a gif)
class ImagePlayer extends StatefulWidget {
  ImagePlayer({
    Key key,
    @required this.images,
    this.controller,
    this.defaultIndex,
    this.onTap,
    this.tag,
    this.playInterval = const Duration(milliseconds: 1000),
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.low,
  }) : super(key: key);

  final List<ImageProvider<dynamic>> images;
  final ImageController controller;
  final int defaultIndex;
  final Duration playInterval;
  final VoidCallback onTap;
  final String tag;
  final BoxFit fit;
  final FilterQuality filterQuality;

  @override
  _ImagePlayerState createState() => _ImagePlayerState();
}

class _ImagePlayerState extends State<ImagePlayer> {
  Timer _timer;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _currentIndex = widget.defaultIndex;

    widget.controller.addListener(_updateTimer);
    _updateTimer();
  }

  void _updateTimer() {
    final controller = widget.controller;

    if (controller.isPlaying) {
      _timer = _getTimer();
    } else {
      _timer?.cancel();
    }
  }

  Timer _getTimer() {
    return Timer.periodic(widget.playInterval, (_) {
      if (_currentIndex == widget.images.length - 1) {
        setState(() => _currentIndex = 0);
      } else {
        setState(() => _currentIndex++);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // preload all other images, so when the next frame plays the first time, it
    // will not flash to white when loading
    widget.images.forEach((image) {
      precacheImage(image, context);
    });
  }

  @override
  void didUpdateWidget(ImagePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.images.first != oldWidget.images.first) {
      _init();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget displayImage = _currentIndex == widget.defaultIndex
        ? FadeInImage(
            fit: widget.fit,
            image: widget.images[_currentIndex],
            placeholder: MemoryImage(kTransparentImage),
          )
        : Image(
            fit: widget.fit,
            image: widget.images[_currentIndex],
            filterQuality: widget.filterQuality,
          );

    if (widget.tag != null) {
      displayImage = Hero(
        tag: widget.tag,
        child: Material(
          color: Colors.transparent,
          child: displayImage,
        ),
      );
    }

    return SizedBox.expand(
      child: InkWell(
        onTap: widget?.onTap,
        child: displayImage,
      ),
    );
  }
}

class ImageController extends ChangeNotifier {
  ImageController({bool autoPlay}) : isPlaying = autoPlay;

  bool isPlaying;

  void play() {
    if (isPlaying) return;
    isPlaying = true;
    notifyListeners();
  }

  void pause() {
    if (!isPlaying) return;
    isPlaying = false;
    notifyListeners();
  }

  void togglePlay() {
    isPlaying = !isPlaying;
    notifyListeners();
  }
}
