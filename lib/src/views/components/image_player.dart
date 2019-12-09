import 'dart:async';

import 'package:flutter/material.dart';

/// Play a set of images repeatedly (like a gif)
class ImagePlayer extends StatefulWidget {
  ImagePlayer({
    Key key,
    @required this.images,
    this.controller,
    this.defaultIndex,
    this.onTap,
    this.playInterval = const Duration(milliseconds: 1000),
  }) : super(key: key);

  final List<ImageProvider<dynamic>> images;
  final ImageController controller;
  final int defaultIndex;
  final Duration playInterval;
  final VoidCallback onTap;

  @override
  _ImagePlayerState createState() => _ImagePlayerState();
}

class _ImagePlayerState extends State<ImagePlayer> {
  Timer _timer;
  int _currentIndex;

  @override
  void initState() {
    super.initState();

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
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final prevIndex =
        _currentIndex > 0 ? _currentIndex - 1 : widget.images.length - 1;

    return Stack(
      children: <Widget>[
        // fix the current image (topmost of this stack), if not loaded yet,
        // will flash blank content for the first time, put the previous image
        // below to remove the blank space and make the animation smoother
        Ink.image(
          fit: BoxFit.cover,
          image: widget.images[prevIndex],
        ),
        Ink.image(
          fit: BoxFit.cover,
          image: widget.images[_currentIndex],
          child: InkWell(
            onTap: widget?.onTap,
          ),
        ),
      ],
    );
  }
}

class ImageController extends ValueNotifier<bool> {
  ImageController({bool autoPlay}) : super(autoPlay);

  bool get isPlaying => value;

  void play() {
    value = true;
  }

  void pause() {
    value = false;
  }

  void togglePlay() {
    value = !value;
  }
}
