import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  RoundButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.enable = true,
    this.size = 60,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final bool enable;
  final double size;

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton>
    with TickerProviderStateMixin {
  AnimationController _pressController;
  AnimationController _loadingController;
  Animation<double> _loadingAnimation;
  Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 500),
    );

    _loadingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: ElasticOutCurve(0.35),
      ),
    );
    _pressAnimation = Tween<double>(begin: 1, end: .75).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOut,
        reverseCurve: ElasticInCurve(0.3),
      ),
    );

    _loadingController.forward();
  }

  @override
  void didUpdateWidget(RoundButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ScaleTransition(
      scale: _pressAnimation,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: FittedBox(
          child: FloatingActionButton(
            // allow more than 1 FAB in the same screen (hero tag cannot be duplicated)
            heroTag: null,
            child: widget.child,
            mini: true,
            disabledElevation: 1,
            onPressed: widget.enable
                ? () {
                    _pressController.forward().then((_) {
                      _pressController.reverse();
                    });
                    widget.onPressed();
                  }
                : null,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );

    content = ScaleTransition(
      scale: _loadingAnimation,
      child: content,
    );

    return ScaleTransition(
      scale: _loadingAnimation,
      child: content,
    );
  }
}
