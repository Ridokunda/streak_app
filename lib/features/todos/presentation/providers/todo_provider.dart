import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/todo_item.dart';
import '../../data/repositories/todo_repository.dart';

final todoRepositoryProvider = Provider((ref) => TodoRepository());

final todoListProvider = StreamProvider<List<TodoItem>>((ref) {
  return ref.watch(todoRepositoryProvider).watchAll();
});
