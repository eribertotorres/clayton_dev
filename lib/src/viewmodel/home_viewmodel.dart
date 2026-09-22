import 'package:flutter/material.dart';

import '../data/todo/todo_model.dart';
import '../data/todo/todo_repository.dart';
import '../shared/result/result.dart';

enum TodoFilter { all, completed, pending }

final class HomeViewModel extends ChangeNotifier {
  final ITodoRepository repository;

  HomeViewModel({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  List<TodoModel> _todos = [];
  TodoFilter _filter = TodoFilter.all;
  String _searchText = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TodoFilter get filter => _filter;

  List<TodoModel> get filteredTodos {
    return _todos.where((todo) {
      final matchesFilter = switch (_filter) {
        TodoFilter.all => true,
        TodoFilter.completed => todo.completed,
        TodoFilter.pending => !todo.completed,
      };

      final matchesSearch = todo.todo.toLowerCase().contains(
        _searchText.toLowerCase(),
      );

      return matchesFilter && matchesSearch;
    }).toList();
  }

  bool get allVisibleTodosCompleted {
    final todos = filteredTodos;

    if (todos.isEmpty) {
      return false;
    }

    return todos.every((todo) => todo.completed);
  }

  Future<void> loadTodos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.getTodos();

    switch (result) {
      case Success<List<TodoModel>>():
        _todos = result.data;
        _isLoading = false;
        notifyListeners();

      case Failure<List<TodoModel>>():
        _todos = [];
        _isLoading = false;
        _errorMessage = 'Não foi possível carregar as tarefas.';
        notifyListeners();
    }
  }

  void changeFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void search(String value) {
    _searchText = value;
    notifyListeners();
  }

  Future<void> changeCompleted(TodoModel todo) async {
    final newValue = !todo.completed;

    final result = await repository.updateCompleted(
      id: todo.id,
      completed: newValue,
    );

    switch (result) {
      case Success<void>():
        todo.completed = newValue;
        notifyListeners();

      case Failure<void>():
        _errorMessage = 'Não foi possível atualizar a tarefa.';
        notifyListeners();
    }
  }
}
