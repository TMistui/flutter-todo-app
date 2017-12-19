import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:todos/todo.dart';

class TodoPersistence {

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/counter.txt');
  }

  Future<Null> saveState(Iterable<Todo> systemState) async {
    // write the variable as a string to the file
    print('TodoPersistence.saveState');
    await (await _getLocalFile()).writeAsString(
        '${JSON.encode(systemState.toList(growable: false))}');
  }

  Future<Iterable<Todo>> getAll() async {
    try {
      File file = await _getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      Iterable<Map<String, dynamic>> stuffFromDisk = JSON.decode(contents);

      print('stuffFromDisk: $stuffFromDisk');

      return stuffFromDisk.map((map) => Todo.fromMap(map));
    } on FileSystemException {
      return [
        new Todo(text: "loading failed"),
        new Todo(text: "go fly a kite"),
      ];
    }
  }
}
