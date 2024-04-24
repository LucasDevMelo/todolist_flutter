 import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  List<Todo> _tasks = [];

  List<Todo> get tasks => _tasks;

  set tasks(List<Todo> value) {
    _tasks = value;
    notifyListeners();
  }

  void addTask(Todo task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(int index, Todo newTask) {
    _tasks[index] = newTask;
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

@immutable
class Todo {
  final String title;
  final String description;
  final DateTime dateTime;
  final bool isCompleted;

  Todo({
    required this.title,
    required this.description,
    required this.dateTime,
    this.isCompleted = false,
  });
}