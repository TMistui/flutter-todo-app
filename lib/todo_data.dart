import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:todos/todo.dart';

class TodoDataStore {
  static final databaseName = join(Platform.script.toFilePath(), "/todo.db");

  final File writeOut;

  TodoDataStore() : writeOut = new File(databaseName);

  Future<Iterable<Todo>> getAll() async {
    // TODO
    return new Future.value([
      new Todo(text: "go to the store"),
      new Todo(text: "do your day job"),
      new Todo(text: "fly a car"),
    ]);
  }

}
