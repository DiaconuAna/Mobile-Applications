import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/entry.dart';
import '../util/messageResponse.dart';
import '../util/text_box.dart';

class AddPage extends StatefulWidget {
  final String date;
  AddPage(this.date);
  @override
  State<StatefulWidget> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  late TextEditingController controllerType;
  late TextEditingController controllerDuration;
  late TextEditingController controllerDistance;
  late TextEditingController controllerCalories;
  late TextEditingController controllerRate;

  @override
  void initState() {
    controllerType = TextEditingController();
    controllerDuration = TextEditingController();
    controllerDistance = TextEditingController();
    controllerCalories = TextEditingController();
    controllerRate = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add an entry")),
        body: ListView(children: [
          TextBox(controllerType, "Type"),
          TextBox(controllerDistance, "Distance"),
          TextBox(controllerDuration, "Duration"),
          TextBox(controllerCalories, "Calories"),
          TextBox(controllerRate, "Rate"),
          ElevatedButton(
              onPressed: () {
                String type = controllerType.text;
                String distance = controllerDistance.text;
                String duration = controllerDuration.text;
                String calories = controllerCalories.text;
                String rate = controllerRate.text;

                String invalidMessage = "";

                if (type.isEmpty) {
                  invalidMessage += "\nEmpty type";
                }
                if (int.tryParse(distance) == null ||
                    (int.parse(distance) < 0)) {
                  invalidMessage +=
                      "\nInvalid distance. Expected an integer greater than zero";
                }
                if (int.tryParse(duration) == null) {
                  invalidMessage += "\nInvalid duration. Expected an integer";
                }
                if (int.tryParse(calories) == null) {
                  invalidMessage += "\nInvalid calory count. Expected an integer";
                }
                if (int.tryParse(rate) == null) {
                  invalidMessage += "\nInvalid rate. Expected an integer";
                }

                if (invalidMessage == "") {
                  Navigator.pop(
                      context,
                      Entry(
                          type: type,
                          date: widget.date,
                          distance: int.parse(distance),
                          duration: int.parse(duration),
                          calories: int.parse(calories),
                          rate: int.parse(rate) 
                          ) 
                          
                          );
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("Invalid Entry"),
                            content: Text(invalidMessage),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Try again",
                                  style: TextStyle(color: Colors.purple),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Abort",
                                      style: TextStyle(color: Colors.indigo)))
                            ],
                          ));
                }
              },
              child: Text("Add Entry"))
        ]));
  }
}
