import 'package:sqflite/sqflite.dart';

import '../../shared/database/app_database.dart';
import 'todo_model.dart';

sealed class ITodoLocalDatasource {
  Future<void> saveTodos(List<TodoModel> todos);

  Future<List<Map<String, dynamic>>> getTodos();

  Future<void> updateCompleted({required int id, required bool completed});
}

final class TodoLocalDatasourceImpl implements ITodoLocalDatasource {
  @override
  Future<void> saveTodos(List<TodoModel> todos) async {
    final database = await AppDatabase.database;

    final batch = database.batch();

    for (final todo in todos) {
      batch.insert(
        'todos',
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<Map<String, dynamic>>> getTodos() async {
    final database = await AppDatabase.database;

    return database.query('todos', orderBy: 'id ASC');
  }

  @override
  Future<void> updateCompleted({
    required int id,
    required bool completed,
  }) async {
    final database = await AppDatabase.database;

    await database.update(
      'todos',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
