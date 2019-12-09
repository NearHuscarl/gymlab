import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  AppDialog({
    @required this.title,
    @required this.body,
  });

  final String title;
  final Widget body;

  static const headerHeight = 65.0;
  static const padding = 16.0;
  static const shapeBorder = BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7)),
  );

  Widget _dialogHeader(ThemeData theme) {
    return Positioned(
      top: 0,
      left: padding + 20,
      right: padding + 20,
      child: Container(
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: shapeBorder,
          color: theme.primaryColor,
        ),
        height: headerHeight,
        child: Text(
          title,
          style: theme.textTheme.headline.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _dialogContent(BuildContext context) {
    final headerHeightHalf = headerHeight / 2;
    return Container(
      padding: EdgeInsets.only(
        top: headerHeightHalf + padding,
        bottom: padding,
        left: padding,
        right: padding,
      ),
      margin: EdgeInsets.only(top: headerHeightHalf),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: shapeBorder,
        shadows: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _dialogContent(context),
          _dialogHeader(theme),
        ],
      ),
    );
  }
}

Future<dynamic> showAppDialog({
  BuildContext context,
  String title,
  Widget body,
}) {
  return showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    transitionBuilder: (context, animation1, animation2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation1,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation1,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
    useRootNavigator: true,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    pageBuilder: (context, animation1, animation2) {
      return SafeArea(
        child: Builder(
          builder: (BuildContext context) => AppDialog(
            title: title,
            body: body,
          ),
        ),
      );
    },
  );
}
