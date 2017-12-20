import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


typedef void TodoChangedCallback(Todo todo, bool checkState);
typedef void TodoLongTouchedCallback(Todo todo);

class Todo {
  Todo({this.text, this.isDone: false});

  final String text;
  bool isDone;

  @override String toString() => "Todo[$text: ${isDone ? 'done' : 'not done'}]";

  static fromMap(Map<String, dynamic> map) {
    return new Todo(text: map["text"], isDone: map["done"]);
  }

  toJson() => toMap();

  toMap() =>
      {
        "text": text,
        "done": isDone
      };
}

class TodoListItem extends StatelessWidget {

  TodoListItem({
    @required Todo todo,
    @required this.isChecked,
    @required this.onTodoTap,
    @required this.onTodoLongPress})
      : todo = todo,
        super(key: new ObjectKey(todo));

  final Todo todo;
  final bool isChecked;
  final TodoChangedCallback onTodoTap;
  final TodoLongTouchedCallback onTodoLongPress;

  Color _getColor(BuildContext context) {
    return isChecked ? Colors.black54 : Theme
        .of(context)
        .primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    return new TextStyle(
        color: Colors.black54,
        decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        onTap: () => onTodoTap(this.todo, isChecked),
        onLongPress: () => onTodoLongPress(this.todo),
        leading: new CircleAvatar(
          backgroundColor: _getColor(context),
          child: new Text(todo.text[0]),
        ),
        title: new Text(todo.text,
          style: _getTextStyle(context),
        )
    );
  }
}