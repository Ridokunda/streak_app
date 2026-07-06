import 'package:isar/isar.dart';

part 'completion.g.dart';

@Collection()
class Completion {
  /// Auto-generated ID
  Id id = Isar.autoIncrement;

  /// ID of the streak this completion belongs to
  @Index()
  late int streakId;

  /// Date of completion
  @Index()
  late DateTime completedDate;

  /// Whether a freeze was consumed for this day
  bool usedFreeze = false;

  Completion({
    required this.streakId,
    required this.completedDate,
    this.usedFreeze = false,
  });
}