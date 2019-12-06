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
    this.autoPlay = false,
    this.playInterval = const Duration(milliseconds: 1000),
  }) : super(key: key);

  final List<ImageProvider<dynamic>> images;
  final ValueNotifier controller;
  final int defaultIndex;
  final Duration playInterval;
  final VoidCallback onTap;
  final bool autoPlay;

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
    widget.controller.addListener(() {
      final playGif = widget.controller.value;
      if (playGif) {
        _timer = _getTimer();
      } else {
        _timer?.cancel();
      }
    });
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
