import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todos/helpers.dart';
import 'package:todos/todo.dart';
import 'package:todos/todo_data.dart';
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

  final persistenceRef = new TodoPersistence();
  final todoMap = <String, Todo>{};


  @override
  void initState() {
    super.initState();

    persistenceRef.getAll().then((todosFromDisk) {
      setState(() {
        for (var todo in todosFromDisk) {
          todoMap[todo.text] = todo;
        }
      });
    });
  }

  Future<Null> _createNewTodo(BuildContext context) async {
    final modalResult = await promptForUserTextInput(context);

    if (modalResult?.isNotEmpty) { // ignore: null_aware_in_condition
      setState(() {
        todoMap[modalResult] = new Todo(text: modalResult);
        persistenceRef.saveState(todoMap.values);
      });
    }
  }

  void _persistChangeToDb(Todo todo, bool isChecked) {
    setState(() {
      // only state mutation allowed in the app
      todoMap[todo.text].isDone = isChecked;
      persistenceRef.saveState(todoMap.values);
    });
  }

  Future<Null> _deleteTodoFromPersistence(Todo todo) async {
    await Clipboard.setData(new ClipboardData(text: todo.text));

    setState(() {
      // gotta delete stuff
      todoMap.remove(todo.text);
      persistenceRef.saveState(todoMap.values);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new TodoList(
        todoElements: todoMap.values.toList(),
        onTodoStateChanged: _persistChangeToDb,
        onTodoLongPress: _deleteTodoFromPersistence,
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
