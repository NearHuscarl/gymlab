import 'package:flutter/material.dart';
import 'src/views/screens/home_screen.dart';
import 'src/z_rxdart_example/github_api.dart';
import 'src/z_rxdart_example/search_widget.dart';

void main() {
  runApp(GymLabApp());
}

class GymLabApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxDart Github Search',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.indigo,
      ),
      home: HomeScreen(),
    );
    // return RxDartExample(api: GithubApi());
  }
}

class RxDartExample extends StatefulWidget {
  RxDartExample({Key key, this.api}) : super(key: key);

  final GithubApi api;

  @override
  _RxDartExampleState createState() => _RxDartExampleState();
}

class _RxDartExampleState extends State<RxDartExample> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxDart Github Search',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: SearchScreen(api: widget.api),
    );
  }
}
