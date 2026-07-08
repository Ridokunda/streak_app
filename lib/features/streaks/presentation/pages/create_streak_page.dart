import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/frequency.dart';
import '../../data/models/streak.dart';
import '../providers/streak_provider.dart';

class CreateStreakPage extends ConsumerStatefulWidget {
  const CreateStreakPage({super.key});

  @override
  ConsumerState<CreateStreakPage> createState() => _CreateStreakPageState();
}

class _CreateStreakPageState extends ConsumerState<CreateStreakPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Frequency _frequency = Frequency.daily;
  final Set<int> _selectedDays = <int>{};
  static const List<String> _weekdayLabels = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_frequency == Frequency.custom && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day for custom frequency.')),
      );
      return;
    }

    final repository = ref.read(streakRepositoryProvider);
    final createdId = await repository.add(
      Streak(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        frequency: _frequency,
        scheduledDays: _frequency == Frequency.custom ? _selectedDays.toList() : const [],
        createdAt: DateTime.now(),
      ),
    );

    if (!mounted) return;
    context.go('/streaks/$createdId');
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create streak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Create a new streak',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) {
                    return 'Please enter a title';
                  }
                  if (trimmed.length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  if (trimmed.length > 50) {
                    return 'Title must be at most 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.length > 160) {
                    return 'Description must be at most 160 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Frequency>(
                initialValue: _frequency,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: Frequency.daily,
                    child: Text('Daily'),
                  ),
                  DropdownMenuItem(
                    value: Frequency.weekly,
                    child: Text('Weekly'),
                  ),
                  DropdownMenuItem(
                    value: Frequency.custom,
                    child: Text('Custom'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _frequency = value;
                      if (_frequency != Frequency.custom) {
                        _selectedDays.clear();
                      }
                    });
                  }
                },
              ),
              if (_frequency == Frequency.custom) ...[
                const SizedBox(height: 16),
                Text(
                  'Select days of the week',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(7, (index) {
                    final day = index + 1;
                    return FilterChip(
                      label: Text(_weekdayLabels[index]),
                      selected: _selectedDays.contains(day),
                      onSelected: (_) => _toggleDay(day),
                    );
                  }),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Save streak'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
