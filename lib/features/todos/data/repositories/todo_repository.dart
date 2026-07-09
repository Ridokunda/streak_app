import 'package:drift/drift.dart';

import '../../../../app/database/drift_database.dart';
import '../../../notifications/data/services/reminder_notification_service.dart';
import '../models/todo_item.dart';

class TodoRepository {
  TodoRepository({AppDatabase? db, bool? syncNotifications})
      : _db = db,
        _syncNotifications = syncNotifications ?? db == null;

  final AppDatabase? _db;
  final bool _syncNotifications;

  Future<AppDatabase> get _dbInstance async => _db ?? await AppDatabase.instance();

  Stream<List<TodoItem>> watchAll() async* {
    final db = await _dbInstance;
    yield* (db.select(db.todosTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isCompleted, mode: OrderingMode.asc),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<int> add(TodoItem item) async {
    final db = await _dbInstance;
    final id = await db.into(db.todosTable).insert(
          TodosTableCompanion.insert(
            title: item.title,
            isCompleted: Value(item.isCompleted),
            reminderEnabled: Value(item.reminderEnabled),
            reminderAt: Value(item.reminderAt),
            createdAt: item.createdAt,
          ),
        );

    if (_syncNotifications) {
      await ReminderNotificationService.instance.syncTodoReminder(
        todoId: id,
        title: item.title,
        reminderEnabled: item.reminderEnabled,
        isCompleted: item.isCompleted,
        reminderAt: item.reminderAt,
      );
    }

    return id;
  }

  Future<void> update(TodoItem item) async {
    if (item.id == null) {
      return;
    }

    final db = await _dbInstance;
    await db.update(db.todosTable).replace(
          TodosTableData(
            id: item.id!,
            title: item.title,
            isCompleted: item.isCompleted,
            reminderEnabled: item.reminderEnabled,
            reminderAt: item.reminderAt,
            createdAt: item.createdAt,
          ),
        );

    if (_syncNotifications) {
      await ReminderNotificationService.instance.syncTodoReminder(
        todoId: item.id!,
        title: item.title,
        reminderEnabled: item.reminderEnabled,
        isCompleted: item.isCompleted,
        reminderAt: item.reminderAt,
      );
    }
  }

  Future<void> toggleComplete(TodoItem item, bool value) async {
    await update(item.copyWith(isCompleted: value));
  }

  Future<void> delete(int id) async {
    final db = await _dbInstance;
    await (db.delete(db.todosTable)..where((t) => t.id.equals(id))).go();

    if (_syncNotifications) {
      await ReminderNotificationService.instance.cancelTodoReminder(id);
    }
  }

  TodoItem _fromRow(TodosTableData row) {
    return TodoItem(
      id: row.id,
      title: row.title,
      createdAt: row.createdAt,
      isCompleted: row.isCompleted,
      reminderEnabled: row.reminderEnabled,
      reminderAt: row.reminderAt,
    );
  }
}
