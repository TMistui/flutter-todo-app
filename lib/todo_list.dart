import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos/todo.dart';


class TodoList extends StatefulWidget {

  TodoList({
    Key key,
    @required this.todoElements,
    this.onTodoStateChanged
  }) : super(key: key);

  final List<Todo> todoElements;
  final TodoChangedCallback onTodoStateChanged;

  @override
  State createState() => new _TodoListState();
}

class _TodoListState extends State<TodoList> {

  void _toggleTodoState(Todo target, bool oldState) {
    bool newState = !oldState;
    debugPrint('_TLS._toggleTodoState: ${target.isDone} => ($newState)');

    setState(() {
      widget?.onTodoStateChanged(target, newState);
    });
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
                isChecked: todo.isDone,
                onTodoClick: _toggleTodoState,
              );
            },
          ),
        )
      ],
    );
  }
}