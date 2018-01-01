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
      title: 'Just Do It',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new TodoHome(title: 'To Do'),
    );
  }
}

class TodoHome extends StatefulWidget {
  TodoHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoHomeState createState() => new _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {

  final _persistence = new TodoPersistence();
  final _todos = <Todo>[];


  @override
  void initState() {
    super.initState();

    _persistence.getAll().then((fromDisk) {
      setState(() => _todos.addAll(fromDisk));
    });
  }

  Future<Null> _createNewTodo(BuildContext context) async {
    final modalResult = await promptForUserTextInput(context);

    if (modalResult?.isNotEmpty) { // ignore: null_aware_in_condition
      setState(() {
        _todos.add(new Todo(text: modalResult));
        _persistence.saveState(_todos);
      });
    }
  }

  void _persistChangeToDb(Todo todo, bool isChecked) {
    setState(() {
      // only state mutation allowed in the app
      try {
        _todos
            .singleWhere((t) => t == todo)
            .isDone = isChecked;
        _persistence.saveState(_todos);
      } catch (e) {
        debugPrint("An error occured in finding a todo: $todo");
        debugPrint(e);
      }
    });
  }

  Future<Null> _deleteTodoAndPersist(BuildContext context, Todo todo) async {
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(
      content: new Text("Copy deleted text?"),
      action: new SnackBarAction(label: "Copy", onPressed: () async {
        await Clipboard.setData(new ClipboardData(text: todo.text));
      }),
    ));

    setState(() {
      // gotta delete stuff
      if (_todos.remove(todo))
        _persistence.saveState(_todos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Builder(
        // according to the documentation, this is how we get a self-reference
        // so that Scaffold.of() works in _deleteTodoAndPersist
        builder: (BuildContext innerContext) {
          return new TodoList(
            todoElements: _todos,
            onTodoStateChanged: _persistChangeToDb,
            onTodoLongPress: (todo) =>
                _deleteTodoAndPersist(innerContext, todo),
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _createNewTodo(context);
        },
        tooltip: 'Add New Todo',
        child: new Icon(Icons.add),
      ),
    );
  }
}
