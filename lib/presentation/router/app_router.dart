import 'package:bloc_todo_app/constants/constants.dart';
import 'package:bloc_todo_app/data/models/todo.dart';
import 'package:bloc_todo_app/presentation/screens/todos/todo_add.dart';
import 'package:bloc_todo_app/presentation/screens/todos/todo_edit.dart';
import 'package:bloc_todo_app/presentation/screens/todos/todo_home.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => TodoHome());
      case addTodoRoute:
        return MaterialPageRoute(builder: (_) => TodoAdd());
      case editTodoRoute:
        final todo = settings.arguments as Todo;
        return MaterialPageRoute(
            builder: (_) => TodoEdit(
                  todo: todo,
                ));
      default:
        return null;
    }
  }
}
