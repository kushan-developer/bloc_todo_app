import 'dart:convert';

import 'package:bloc_todo_app/data/models/todo.dart';

import 'package:bloc_todo_app/data/services/api_result.dart';
import 'package:bloc_todo_app/data/services/network_exceptions.dart';
import 'package:dio/dio.dart';

import 'package:bloc_todo_app/constants/constants.dart';
import 'package:bloc_todo_app/data/services/dio_client.dart';

class TodosRepository {
  late DioClient dioClient;
  late final String _baseUrl = apiBase;

  TodosRepository() {
    var dio = Dio();
    dioClient = DioClient(_baseUrl, dio);
  }

  Future<ApiResult<List<Todo>>> fetchTodos() async {
    try {
      final response = await dioClient.get("/todos");
      List<Todo> todoList = todosFromMap(response);
      return ApiResult.success(data: todoList);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Todo>> patchTodo(
      Map<String, dynamic> patchTodo, int id) async {
    try {
      final response = await dioClient.patch("/todos/$id", data: patchTodo);
      Todo updatedTodo = Todo.fromMap(response);
      return ApiResult.success(data: updatedTodo);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Todo>> addTodo(Map<String, dynamic> todoData) async {
    try {
      final response = await dioClient.post("/todos", data: todoData);
      Todo newTodo = Todo.fromMap(response);
      return ApiResult.success(data: newTodo);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<bool>> deleteTodo(int id) async {
    try {
      await dioClient.delete("/todos/$id");
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
