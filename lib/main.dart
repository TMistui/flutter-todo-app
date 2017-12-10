import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todos/todo.dart';
import 'package:todos/todo_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // The application theme.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Foxy To-do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _elements = <Todo>[];

  Future<Null> _createNewTodo(BuildContext context) async {
    String modalDialogResult = await _getUserTextInput(context);

    if (modalDialogResult != null && modalDialogResult.isNotEmpty) {
      setState(() => _elements.add(new Todo(text: modalDialogResult)));
    }
  }

  Future<String> _getUserTextInput(BuildContext context) {
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
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new TodoList(
        todoElements: _elements,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _createNewTodo(context);
        },
        tooltip: 'Add New Todo',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Dataloader {

  static Database _database;

  static Future<Database> through(String path) async {
    if (_database == null) {
      _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, state INTEGER)");
        },
      );
    }
    return new Future.value(_database);
  }
}