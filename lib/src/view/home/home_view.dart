import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/preferences/preferences_datasource.dart';
import '../../viewmodel/home_viewmodel.dart';

final class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

final class _HomeViewState extends State<HomeView> {
  String _userName = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadTodos();
    });

    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final preferences = PreferencesDatasource();
    final name = await preferences.getFullName();

    if (!mounted) return;

    setState(() {
      _userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_userName.isEmpty ? 'TODOs' : 'Olá, $_userName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar tarefa',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: viewModel.search,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<TodoFilter>(
                segments: const [
                  ButtonSegment(value: TodoFilter.all, label: Text('Todos')),
                  ButtonSegment(
                    value: TodoFilter.pending,
                    label: Text('Pendentes'),
                  ),
                  ButtonSegment(
                    value: TodoFilter.completed,
                    label: Text('Concluídos'),
                  ),
                ],
                selected: {viewModel.filter},
                onSelectionChanged: (selection) {
                  viewModel.changeFilter(selection.first);
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildContent(viewModel)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HomeViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(viewModel.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: viewModel.loadTodos,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final todos = viewModel.filteredTodos;

    if (todos.isEmpty) {
      return const Center(child: Text('Nenhuma tarefa encontrada.'));
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];

        return Opacity(
          opacity: todo.completed ? 0.5 : 1,
          child: Card(
            child: CheckboxListTile(
              value: todo.completed,
              onChanged: (_) {
                viewModel.changeCompleted(todo);
              },
              title: Text(
                todo.todo,
                style: TextStyle(
                  decoration: todo.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text('ID: ${todo.id}'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        );
      },
    );
  }
}
