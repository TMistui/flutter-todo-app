import 'package:flutter/material.dart';
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
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<Todo> _elements = <Todo>[
    new Todo(text: "don't worry"),
    new Todo(text: "be happy")
  ];

  void _createNewTodo() {
    //setState(() => _elements.insert(0, new Todo(text: "foo todo")));
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
        onPressed: _createNewTodo,
        tooltip: 'Add New Todo',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
