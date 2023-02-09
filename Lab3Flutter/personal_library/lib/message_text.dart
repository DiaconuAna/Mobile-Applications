import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

messageText(BuildContext context, String name){
  showDialog(context: context, 
  builder: (_) => AlertDialog(
    title: Text("Info"),
    content: Text("Book " + name),
  )
  );
}
