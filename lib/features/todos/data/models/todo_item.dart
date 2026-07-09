class TodoItem {
  int? id;

  String title;
  bool isCompleted;
  bool reminderEnabled;
  DateTime? reminderAt;
  DateTime createdAt;

  TodoItem({
    this.id,
    required this.title,
    required this.createdAt,
    this.isCompleted = false,
    this.reminderEnabled = false,
    this.reminderAt,
  });

  TodoItem copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    bool? reminderEnabled,
    DateTime? reminderAt,
    DateTime? createdAt,
    bool clearReminderAt = false,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderAt: clearReminderAt ? null : (reminderAt ?? this.reminderAt),
    );
  }
}
