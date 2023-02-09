import 'package:flutter/material.dart';
import 'package:health_app/screens/mainpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Journal App',
      home: MainPage("Health Journal App"),
    );
  }
}
