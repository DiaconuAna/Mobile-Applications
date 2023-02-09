import 'package:flutter/material.dart';
import 'package:movie_app/screens/mainpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      // home: HomePage("Gardening App")
      home: MainPage("MovieApp App"),
    );
  }
}
