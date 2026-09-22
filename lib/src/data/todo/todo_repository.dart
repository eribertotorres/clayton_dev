import '../../shared/app_exceptions.dart';
import '../../shared/result/result.dart';
import 'todo_local_datasource.dart';
import 'todo_model.dart';
import 'todo_remote_datasource.dart';

sealed class ITodoRepository {
  Future<Result<List<TodoModel>>> getTodos();

  Future<Result<void>> updateCompleted({
    required int id,
    required bool completed,
  });
}

final class TodoRepositoryImpl implements ITodoRepository {
  final ITodoRemoteDatasource remoteDatasource;
  final ITodoLocalDatasource localDatasource;

  TodoRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Result<List<TodoModel>>> getTodos() async {
    try {
      final response = await remoteDatasource.getTodos();

      final todosJson = response['todos'] as List;

      final remoteTodos = todosJson
          .map((todo) => TodoModel.fromMap(Map<String, dynamic>.from(todo)))
          .toList();

      await localDatasource.saveTodos(remoteTodos);

      final localTodos = await localDatasource.getTodos();

      final todos = localTodos.map((todo) => TodoModel.fromMap(todo)).toList();

      return Success(todos);
    } on TypeError {
      return Failure(ConvertDataException());
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void>> updateCompleted({
    required int id,
    required bool completed,
  }) async {
    try {
      await localDatasource.updateCompleted(id: id, completed: completed);

      return Success(null);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
