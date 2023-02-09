import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/entity.dart';
import '../util/messageResponse.dart';
import '../util/text_box.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  late TextEditingController controllerDate;
  late TextEditingController controllerType;
  late TextEditingController controllerAddress;
  late TextEditingController controllerBedrooms;
  late TextEditingController controllerBathrooms;
  late TextEditingController controllerPrice;
  late TextEditingController controllerArea;
  late TextEditingController controllerNotes;

  @override
  void initState() {
    controllerDate = TextEditingController();
    controllerType = TextEditingController();
    controllerAddress = TextEditingController();
    controllerBedrooms = TextEditingController();
    controllerBathrooms = TextEditingController();
    controllerPrice = TextEditingController();
    controllerArea = TextEditingController();
    controllerNotes = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add a property")),
        body: ListView(children: [
          TextBox(controllerDate, "Date - YYYY-MM-DD"),
          TextBox(controllerType, "Type"),
          TextBox(controllerAddress, "Address"),
          TextBox(controllerBedrooms, "Bedrooms"),
          TextBox(controllerBathrooms, "Bathrooms"),
          TextBox(controllerPrice, "Price"),
          TextBox(controllerArea, "Area"),
          TextBox(controllerNotes, "Notes"),
          ElevatedButton(
              onPressed: () {
                String date = controllerDate.text;
                String type = controllerType.text;
                String address = controllerAddress.text;
                String bedrooms = controllerBedrooms.text;
                String bathrooms = controllerBathrooms.text;
                String area = controllerArea.text;
                String price = controllerPrice.text;
                String notes = controllerNotes.text;

                String invalidMessage = "";

                if (date.isEmpty || DateTime.tryParse(date) == null) {
                  invalidMessage += "\nEmpty date field";
                }
                if (type.isEmpty) {
                  invalidMessage += "\nEmpty type field";
                }
                if (address.isEmpty) {
                  invalidMessage += "\nEmpty address field";
                }
                if (int.tryParse(bedrooms) == null) {
                  invalidMessage += "\nEmpty bedrooms field";
                }
                if (int.tryParse(bathrooms) == null) {
                  invalidMessage += "\nEmpty bathrooms field";
                }
                if (int.tryParse(area) == null) {
                  invalidMessage += "\nEmpty area field";
                }
                if (double.tryParse(price) == null) {
                  invalidMessage += "\nEmpty price field";
                }
                
                if (notes.isEmpty) {
                  invalidMessage += "\nEmpty notes field";
                }

                if (invalidMessage == "") {
                  Navigator.pop(
                      context,
                      Property(
                          type: type,
                          date: date,
                          address: address,
                          bedrooms: int.parse(bedrooms),
                          bathrooms: int.parse(bathrooms),
                          area: int.parse(area),
                          price: double.parse(price),
                          notes: notes)
                          );
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("Invalid property entry"),
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
              child: Text("Add property"))
        ]));
  }
}
