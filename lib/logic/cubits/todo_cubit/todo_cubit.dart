import 'dart:convert';

import 'package:bloc_todo_app/constants/enums.dart';
import 'package:bloc_todo_app/data/services/api_result.dart';
import 'package:bloc_todo_app/data/services/network_exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:bloc_todo_app/data/models/todo.dart';
import 'package:bloc_todo_app/data/repositories/todo_repository.dart';

part 'todo_state.dart';

class TodosCubit extends HydratedCubit<TodosState> {
  final TodosRepository todosRepository;
  TodosCubit({required this.todosRepository}) : super(const TodosState());

  void fetchTodos() async {
    emit(state.copyWith(status: Status.loading));
    ApiResult<List<Todo>> todosReposnse = await todosRepository.fetchTodos();
    todosReposnse.when(success: (List<Todo> todos) {
      emit(state.copyWith(status: Status.success, todos: todos));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          status: Status.failure,
          error: NetworkExceptions.getErrorMessage(error)));
    });
  }

  void updateTodo(Map<String, dynamic> patchData, Todo todo) async {
    emit(state.copyWith(status: Status.updatePending));
    ApiResult<Todo> todoUpdateReposnse =
        await todosRepository.patchTodo(patchData, todo.id);
    todoUpdateReposnse.when(success: (Todo updatedTodo) {
      todo.content = updatedTodo.content;
      todo.isCompleted = updatedTodo.isCompleted;
      emit(state.copyWith(status: Status.updateSuccess, todos: state.todos));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          status: Status.failure,
          error: NetworkExceptions.getErrorMessage(error)));
    });
  }

  void addTodo(Map<String, dynamic> todoData, List<Todo> todos) async {
    emit(state.copyWith(status: Status.createPending));
    ApiResult<Todo> todoAddReposnse = await todosRepository.addTodo(todoData);
    todoAddReposnse.when(success: (Todo newTodo) {
      todos.add(newTodo);
      emit(state.copyWith(status: Status.createSuccess, todos: state.todos));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          status: Status.failure,
          error: NetworkExceptions.getErrorMessage(error)));
    });
  }

  void deleteTodo(Todo todo) async {
    emit(state.copyWith(status: Status.deletePending));
    ApiResult<bool> deleteTodoReposnse =
        await todosRepository.deleteTodo(todo.id);
    deleteTodoReposnse.when(success: (bool isDeleted) {
      if (isDeleted == true) {
        final updatedTodosList =
            state.todos.where((t) => t.id != todo.id).toList();
        emit(state.copyWith(
            status: Status.deleteSuccess, todos: updatedTodosList));
      }
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          status: Status.failure,
          error: NetworkExceptions.getErrorMessage(error)));
    });
  }

  @override
  TodosState? fromJson(Map<String, dynamic> json) {
    return TodosState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TodosState state) {
    return state.toMap();
  }
}
