import 'package:flutter/material.dart';
import '../components/gym_icons.dart';

class SearchBar extends StatefulWidget {
  SearchBar({this.expandSearchBar, this.onTextChanged});

  final bool expandSearchBar;
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

    if (widget.expandSearchBar != oldWidget.expandSearchBar) {
      if (widget.expandSearchBar) {
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
    final media = MediaQuery.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: media.size.width,
        color: Colors.pink.withOpacity(.75),
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
            // TODO: add equipment filter
            // IconButton(
            //   icon: Icon(GymIcons.equipment),
            //   color: Colors.white,
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
