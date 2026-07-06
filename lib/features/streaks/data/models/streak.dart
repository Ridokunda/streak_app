import '../../../../core/enums/frequency.dart';
import 'package:isar/isar.dart';

part 'streak.g.dart';

@Collection()
class Streak {
  /// Auto-generated Isar ID
  Id id = Isar.autoIncrement;

  /// Name of the streak
  @Index(caseSensitive: false)
  late String title;

  /// Optional description
  String? description;

  /// How often the streak occurs
  @Enumerated(EnumType.name)
  late Frequency frequency;

  /// Days on which the streak should be completed.
  ///
  /// Monday = 1
  /// Tuesday = 2
  /// Wednesday = 3
  /// Thursday = 4
  /// Friday = 5
  /// Saturday = 6
  /// Sunday = 7
  List<int> scheduledDays = [];

  /// Reminder time
  int reminderHour = 20;

  int reminderMinute = 0;

  /// Date the streak was created
  late DateTime createdAt;

  /// Last successful completion
  DateTime? lastCompleted;

  DateTime? lastFreezeUsed;

  /// Current streak length
  int currentStreak = 0;

  /// Best streak ever achieved
  int longestStreak = 0;

  /// Available freezes
  int freezeCount = 0;

  /// Successful completions since last earned freeze
  int completedSinceFreeze = 0;

  /// Hide streak instead of deleting
  bool archived = false;

  // ----------------------------
  // Constructor
  // ----------------------------

  Streak({
    required this.title,
    required this.frequency,
    required this.createdAt,
    this.description,
    this.scheduledDays = const [],
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.lastCompleted,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.freezeCount = 0,
    this.completedSinceFreeze = 0,
    this.archived = false,
    this.lastFreezeUsed,
  });
}