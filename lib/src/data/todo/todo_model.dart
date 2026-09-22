final class TodoModel {
  final int id;
  final String todo;
  bool completed;
  final int userId;

  TodoModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int,
      todo: map['todo'] as String,
      completed: map['completed'] == true || map['completed'] == 1,
      userId: map['userId'] as int,
    );
  }

  void markAsCompleted() {
    completed = true;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed ? 1 : 0,
      'userId': userId,
    };
  }
}
