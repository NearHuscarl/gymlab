import 'dart:ui';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  SearchBar({this.expand, this.onTextChanged});

  final bool expand;
  final ValueChanged<String> onTextChanged;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _slideAnimation;
  AnimationController _controller;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(.6875, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expand != oldWidget.expand) {
      if (widget.expand) {
        _controller.forward();
        FocusScope.of(context).requestFocus(_focusNode);
      } else {
        _controller.reverse();
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Container(
      color: theme.primaryColor.withOpacity(.75),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search exercise...',
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: widget.onTextChanged,
              focusNode: _focusNode,
            ),
          ),
        ],
      ),
    );

    return SlideTransition(
      position: _slideAnimation,
      child: Stack(
        children: <Widget>[
          Container(height: 50),
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
