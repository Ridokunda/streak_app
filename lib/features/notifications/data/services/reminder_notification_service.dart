import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:app_settings/app_settings.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../streaks/data/models/streak.dart';

class ReminderNotificationService {
  ReminderNotificationService._();

  static final ReminderNotificationService instance =
      ReminderNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _globallyEnabled = false;
  static const int _maxStreakReminderSlots = 100;
  static const int _streakReminderHorizonDays = 14;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();
    try {
      final zoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zoneName));
    } catch (_) {
      // Fallback to UTC if a device timezone can't be resolved.
      tz.setLocalLocation(tz.UTC);
    }

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  void configureGlobalEnabled(bool enabled) {
    _globallyEnabled = enabled;
  }

  Future<bool> requestPermission() async {
    await initialize();
    final results = <bool?>[
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission(),
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true),
      await _plugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true),
    ].whereType<bool>().toList();
    return results.isEmpty || results.every((granted) => granted);
  }

  Future<bool> notificationsAllowed() async {
    await initialize();
    final android = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.checkPermissions();
    final macos = await _plugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.checkPermissions();
    return android ?? ios?.isEnabled ?? macos?.isEnabled ?? true;
  }

  Future<void> openSystemNotificationSettings() {
    return AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  Future<void> syncStreakReminders(Streak streak) async {
    if (streak.id == null) {
      return;
    }

    await initialize();
    await cancelStreakReminders(streak.id!);

    if (!_globallyEnabled ||
        !streak.remindersEnabled ||
        streak.reminderTimes.isEmpty) {
      return;
    }

    final occurrences = _buildUpcomingOccurrences(
      streak: streak,
      now: tz.TZDateTime.now(tz.local),
    );

    for (var index = 0;
        index < occurrences.length && index < _maxStreakReminderSlots;
        index++) {
      final scheduledDate = occurrences[index];

      await _plugin.zonedSchedule(
        id: _notificationId(streak.id!, index),
        title: streak.title,
        body: 'Reminder to keep your streak going.',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'streak_reminders',
            'Streak reminders',
            channelDescription: 'Reminder notifications for streaks',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
          macOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'streak:${streak.id}',
      );
    }
  }

  Future<void> cancelStreakReminders(int streakId) async {
    await initialize();

    for (var index = 0; index < _maxStreakReminderSlots; index++) {
      await _plugin.cancel(id: _notificationId(streakId, index));
    }
  }

  Future<void> clearAllStreakReminders() async {
    await initialize();
    final pending = await _plugin.pendingNotificationRequests();
    for (final notification in pending) {
      if ((notification.payload ?? '').startsWith('streak:')) {
        await _plugin.cancel(id: notification.id);
      }
    }
  }

  Future<void> clearAllNotifications() async {
    await initialize();
    await _plugin.cancelAll();
  }

  Future<void> syncTodoReminder({
    required int todoId,
    required String title,
    required bool reminderEnabled,
    required bool isCompleted,
    DateTime? reminderAt,
  }) async {
    await initialize();
    await cancelTodoReminder(todoId);

    if (!_globallyEnabled ||
        !reminderEnabled ||
        isCompleted ||
        reminderAt == null) {
      return;
    }

    final scheduledDate = tz.TZDateTime.from(reminderAt, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    if (!scheduledDate.isAfter(now)) {
      return;
    }

    await _plugin.zonedSchedule(
      id: _todoNotificationId(todoId),
      title: 'To-do reminder',
      body: title,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_reminders',
          'To-do reminders',
          channelDescription: 'Reminder notifications for to-do list entries',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'todo:$todoId',
    );
  }

  Future<void> cancelTodoReminder(int todoId) async {
    await initialize();
    await _plugin.cancel(id: _todoNotificationId(todoId));
  }

  int _notificationId(int streakId, int reminderIndex) {
    return (streakId * 100) + reminderIndex;
  }

  int _todoNotificationId(int todoId) {
    return 100000000 + todoId;
  }

  List<tz.TZDateTime> _buildUpcomingOccurrences({
    required Streak streak,
    required tz.TZDateTime now,
  }) {
    final uniqueTimes = streak.reminderTimes.toSet().toList()..sort();
    final occurrences = <tz.TZDateTime>[];

    for (var dayOffset = 0;
        dayOffset < _streakReminderHorizonDays;
        dayOffset++) {
      final date = now.add(Duration(days: dayOffset));
      if (streak.completedToday && _isSameCalendarDay(date, now)) {
        continue;
      }

      for (final minutes in uniqueTimes) {
        final hour = minutes ~/ 60;
        final minute = minutes % 60;
        final scheduled = tz.TZDateTime(
          tz.local,
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        if (!scheduled.isAfter(now)) {
          continue;
        }

        occurrences.add(scheduled);
        if (occurrences.length >= _maxStreakReminderSlots) {
          return occurrences;
        }
      }
    }

    return occurrences;
  }

  bool _isSameCalendarDay(tz.TZDateTime first, tz.TZDateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
