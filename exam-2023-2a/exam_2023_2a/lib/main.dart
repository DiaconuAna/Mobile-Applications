import 'package:exam_2023_2a/mainpage.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gardening App',
      // home: HomePage("Gardening App")
      home: MainPage("Gardening App"),
    );
  }
}
