import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/movie.dart';
import '../util/messageResponse.dart';
import '../util/text_box.dart';


class AddPage extends StatefulWidget {
  final String genre;
  AddPage(this.genre);
  @override
  State<StatefulWidget> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  late TextEditingController controllerName;
  late TextEditingController controllerDescription;
  late TextEditingController controllerDirector;
  late TextEditingController controllerYear;

  @override
  void initState() {
    controllerName = new TextEditingController();
    controllerDescription = new TextEditingController();
    controllerDirector= new TextEditingController();
    controllerYear = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add a movie")),
        body: ListView(children: [
          TextBox(controllerName, "Name"),
          TextBox(controllerDescription, "Description"),
          TextBox(controllerDirector, "Director"),
          TextBox(controllerYear, "Year"),
          ElevatedButton(
              onPressed: () {
                String name = controllerName.text;
                String description = controllerDescription.text;
                String director = controllerDirector.text;
                String year = controllerYear.text;

                String invalidMessage = "";

                if (name.isEmpty) {
                  invalidMessage += "\nEmpty name";
                }
                if (description.isEmpty) {
                  invalidMessage += "\nEmpty description";
                }
                if (director.isEmpty) {
                  invalidMessage += "\nEmpty director";
                }
                if (int.tryParse(year) == null ||
                      (int.parse(year) <= 1900)) {
                    invalidMessage += "\nInvalid year. Must be greater than 1900";
                  }

                if (invalidMessage == "") {
                  Navigator.pop(
                      context,
                      Movie(
                          name: name,
                          description: description,
                          director: director,
                          genre: widget.genre,
                          year: int.parse(year)
                          ));
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("Invalid movie"),
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
              child: Text("Add movie"))
        ]));
  }
}
