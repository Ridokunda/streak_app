import '../../../../core/enums/frequency.dart';

class Streak {
  int? id;

  late String title;

  String? description;

  late Frequency frequency;

  List<int> scheduledDays = [];

  bool remindersEnabled = false;

  List<int> reminderTimes = [];

  late DateTime createdAt;

  DateTime? lastCompleted;
  bool completedToday = false;

  DateTime? lastFreezeUsed;

  int currentStreak = 0;

  int longestStreak = 0;

  int freezeCount = 0;

  int completedSinceFreeze = 0;

  bool archived = false;

  Streak({
    this.id,
    required this.title,
    required this.frequency,
    required this.createdAt,
    this.description,
    this.scheduledDays = const [],
    this.remindersEnabled = false,
    this.reminderTimes = const [],
    this.lastCompleted,
    this.completedToday = false,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.freezeCount = 0,
    this.completedSinceFreeze = 0,
    this.archived = false,
    this.lastFreezeUsed,
  });
}
