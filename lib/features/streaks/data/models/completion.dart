class Completion {
  int? id;

  late int streakId;

  late DateTime completedDate;

  bool usedFreeze = false;

  Completion({
    this.id,
    required this.streakId,
    required this.completedDate,
    this.usedFreeze = false,
  });
}
