import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/todo_item.dart';
import '../providers/todo_provider.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do list'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add to-do',
            onPressed: () async {
              final result = await showTodoDialog(context);
              if (result == null || !context.mounted) return;

              final repository = ref.read(todoRepositoryProvider);
              if (result.id == null) {
                await repository.add(result);
              } else {
                await repository.update(result);
              }
            },
          ),
        ],
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Unable to load to-dos: $error')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.checklist, size: 48),
                  const SizedBox(height: 12),
                  Text('No to-do items yet', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first task.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _TodoTile(item: item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showTodoDialog(context);
          if (result == null || !context.mounted) return;

          final repository = ref.read(todoRepositoryProvider);
          if (result.id == null) {
            await repository.add(result);
          } else {
            await repository.update(result);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }

}

Future<TodoItem?> showTodoDialog(BuildContext context, {TodoItem? existing}) async {
  return showDialog<TodoItem?>(
    context: context,
    builder: (_) => _TodoDialog(existing: existing),
  );
}

class _TodoDialog extends StatefulWidget {
  const _TodoDialog({this.existing});

  final TodoItem? existing;

  @override
  State<_TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<_TodoDialog> {
  late final TextEditingController _titleController;
  late bool _reminderEnabled;
  DateTime? _reminderAt;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existing?.title ?? '');
    _reminderEnabled = widget.existing?.reminderEnabled ?? false;
    _reminderAt = widget.existing?.reminderAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickReminder() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderAt ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reminderAt ?? DateTime.now()),
    );
    if (pickedTime == null || !mounted) return;

    setState(() {
      _reminderAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();

    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    if (_reminderEnabled && _reminderAt == null) return;

    final result = (widget.existing ?? TodoItem(title: title, createdAt: DateTime.now())).copyWith(
      title: title,
      reminderEnabled: _reminderEnabled,
      reminderAt: _reminderAt,
      clearReminderAt: !_reminderEnabled,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final reminderText = _reminderAt == null
        ? 'No reminder selected'
        : DateFormat('dd MMM yyyy • HH:mm').format(_reminderAt!);

    return AlertDialog(
      title: Text(widget.existing == null ? 'Add to-do' : 'Edit to-do'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Add reminder'),
              value: _reminderEnabled,
              onChanged: (value) {
                setState(() {
                  _reminderEnabled = value;
                  if (!value) {
                    _reminderAt = null;
                  }
                });
              },
            ),
            if (_reminderEnabled) ...[
              const SizedBox(height: 8),
              Text(reminderText),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickReminder,
                icon: const Icon(Icons.alarm),
                label: const Text('Pick reminder date & time'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _TodoTile extends ConsumerWidget {
  const _TodoTile({required this.item});

  final TodoItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(todoRepositoryProvider);
    final reminderText = item.reminderEnabled && item.reminderAt != null
        ? DateFormat('dd MMM yyyy • HH:mm').format(item.reminderAt!)
        : 'No reminder';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (value) {
            if (value == null) return;
            repository.toggleComplete(item, value);
          },
        ),
        title: Text(
          item.title,
          style: item.isCompleted
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(reminderText),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit task',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final result = await showTodoDialog(context, existing: item);
                if (result == null || !context.mounted) return;
                await repository.update(result);
              },
            ),
            IconButton(
              tooltip: 'Delete task',
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                if (item.id != null) {
                  repository.delete(item.id!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
