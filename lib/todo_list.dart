import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos/todo.dart';


class TodoList extends StatefulWidget {
  TodoList({
    Key key,
    @required this.todoElements
  }) : super(key: key);

  final List<Todo> todoElements;

  @override
  State createState() => new _TodoListState();
}

class _TodoListState extends State<TodoList> {

  Map<Todo, bool> _todoStates = {};

  void _toggleTodoState(Todo target, bool oldState) {
    debugPrint(
        '_TodoListState._toggleTodoState: ${_todoStates[target]} => (${!oldState})');

    setState(() => _todoStates[target] = !oldState);
  }


  @override
  void initState() {
    super.initState();

    widget.todoElements.forEach((todo) => _todoStates[todo] = false);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: new ListView.builder(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            // this lets the "child" reach into the parent
            itemCount: widget.todoElements.length,
            itemBuilder: (_, position) {
              final todo = widget.todoElements[position];
              return new TodoListItem(
                todo: todo,
                isChecked: _todoStates[todo] ?? false,
                // this is getOrDefault (java)
                onTodoClick: _toggleTodoState,
              );
            },
          ),
        )
      ],
    );
  }
}