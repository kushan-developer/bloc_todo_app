part of 'todo_cubit.dart';

class TodosState extends Equatable {
  const TodosState(
      {this.status = Status.initial, this.todos = const [], this.error});

  @override
  List<Object> get props => [status, todos];

  // enum
  final Status status;
  final List<Todo> todos;
  final String? error;

  TodosState copyWith({Status? status, List<Todo>? todos, String? error}) {
    return TodosState(
        status: status ?? this.status,
        todos: todos ?? this.todos,
        error: error ?? this.error);
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.index,
      'todos': todos.map((x) => x.toMap()).toList(),
      'error': error,
    };
  }

  factory TodosState.fromMap(Map<String, dynamic> map) {
    return TodosState(
      status: Status.values[map['status'] ?? 0],
      todos: List<Todo>.from(map['todos'].map((x) => Todo.fromMap(x))),
      error: map['error'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TodosState.fromJson(String source) =>
      TodosState.fromMap(json.decode(source));
}
