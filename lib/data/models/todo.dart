import 'dart:convert';

List<Todo> todosFromMap(List<dynamic> data) =>
    List<Todo>.from(data.map((x) => Todo.fromMap(x)));

String todosToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  int id;
  String content;
  bool isCompleted;
  Todo({
    required this.id,
    required this.content,
    required this.isCompleted,
  });

  Todo copyWith({
    int? id,
    String? content,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isCompleted': isCompleted,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id']?.toInt() ?? 0,
      content: map['content'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  String toString() =>
      'Todo(id: $id, content: $content, isCompleted: $isCompleted)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo &&
        other.id == id &&
        other.content == content &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode ^ isCompleted.hashCode;
}
