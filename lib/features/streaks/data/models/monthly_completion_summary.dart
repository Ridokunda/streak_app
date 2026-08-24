class MonthlyCompletionSummary {
  MonthlyCompletionSummary({
    required this.month,
    required this.completedDates,
    required this.missedDates,
    required this.completedCount,
    required this.missedCount,
    required this.completionRate,
  });

  final DateTime month;
  final List<DateTime> completedDates;
  final List<DateTime> missedDates;
  final int completedCount;
  final int missedCount;
  final double completionRate;
}
