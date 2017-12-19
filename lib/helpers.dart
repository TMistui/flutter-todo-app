import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<String> promptForUserTextInput(BuildContext context) {
  var textController = new TextEditingController();
  return showDialog(
      context: context, child: new SimpleDialog(
    contentPadding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    children: <Widget>[
      new Text("Got something new to do?",
        style: new TextStyle(fontSize: Theme
            .of(context)
            .primaryTextTheme
            .title
            .fontSize),
      ),
      new TextField(
        decoration: new InputDecoration(
          hintText: "text goes here, dummy",
        ),
        controller: textController,
      ),
      new MaterialButton(
        onPressed: () => Navigator.pop(context, textController.text ?? ""),
        child: new Text("Create",
          style: new TextStyle(color: Theme
              .of(context)
              .primaryColor),
        ),
      ),
    ],
  ));
}