import 'package:flutter/material.dart';
import 'package:recipe_app/screens/mainpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      home: MainPage("Recipe App"),
    );
  }
}
