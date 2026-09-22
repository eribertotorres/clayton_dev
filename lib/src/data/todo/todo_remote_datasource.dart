import '../../shared/app_client/app_client.dart';

sealed class ITodoRemoteDatasource {
  Future<Map<String, dynamic>> getTodos();
}

final class TodoRemoteDatasourceImpl implements ITodoRemoteDatasource {
  final AppClient client;

  TodoRemoteDatasourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> getTodos() {
    return client.get(url: '/todos');
  }
}
