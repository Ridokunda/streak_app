import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/frequency.dart';
import '../../data/models/streak.dart';
import '../providers/streak_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streaks = ref.watch(streakListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Streaks"),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final repository = ref.read(streakRepositoryProvider);

          await repository.add(
            Streak(
              title: "Read 10 Pages",
              frequency: Frequency.daily,
              createdAt: DateTime.now(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: streaks.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),

        error: (error, stackTrace) =>
            Center(child: Text(error.toString())),

        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text("No streaks yet."),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final streak = items[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(streak.title),
                  subtitle:
                      Text("🔥 ${streak.currentStreak} days"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await ref
                          .read(streakRepositoryProvider)
                          .delete(streak.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}