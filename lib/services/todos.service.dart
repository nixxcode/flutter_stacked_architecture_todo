import 'dart:math';

import 'package:flutter_stacked_architecture_todo/constants/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import '../models/todos.model.dart';

class TodosService with ListenableServiceMixin {
  final _todos = ReactiveValue<List<Todo>>(
    Hive.box(HIVE_BOX_NAME).get(HIVE_KEY_NAME, defaultValue: []).cast<Todo>(),
  );
  final _random = Random();

  List<Todo> get todos => _todos.value;

  TodosService() {
    listenToReactiveValues([_todos]);
  }

  String _randomId() {
    return String.fromCharCodes(
      List.generate(10, (_) => _random.nextInt(33) + 80),
    );
  }

  void _saveToHive() =>
      Hive.box(HIVE_BOX_NAME).put(HIVE_KEY_NAME, _todos.value);

  int _getIndexOfId(String id) {
    return _todos.value.indexWhere((todo) => todo.id == id);
  }

  void newTodo() {
    _todos.value.insert(0, Todo(id: _randomId()));
    _saveToHive();
    notifyListeners();
  }

  bool removeTodo(String id) {
    final index = _getIndexOfId(id);
    if (index != -1) {
      _todos.value.removeAt(index);
      _saveToHive();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  bool toggleStatus(String id) {
    final index = _getIndexOfId(id);
    if (index != -1) {
      _todos.value[index].completed = !_todos.value[index].completed;
      _saveToHive();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  bool updateTodoContent(String id, String text) {
    final index = _getIndexOfId(id);
    if (index != -1) {
      _todos.value[index].content = text;
      _saveToHive();
      return true;
    } else {
      return false;
    }
  }
}
