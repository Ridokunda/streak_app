import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:app_settings/app_settings.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../app/database/drift_database.dart';
import '../../../settings/data/repositories/settings_repository.dart';
import '../../../streaks/data/models/streak.dart';
import '../../../streaks/data/repositories/streak_repository.dart';

@pragma('vm:entry-point')
Future<void> onReminderNotificationResponse(
    NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await ReminderNotificationService.instance
        .handleNotificationResponse(response);
  } catch (error, stackTrace) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'reminder notification action',
    ));
  }
}

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
  static const String completeStreakAction = 'complete_streak';
  static const String _streakCategory = 'streak_reminder';

  Future<void> initialize({bool requestPermissions = true}) async {
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

    final darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: requestPermissions,
      requestBadgePermission: requestPermissions,
      requestSoundPermission: requestPermissions,
      notificationCategories: [
        DarwinNotificationCategory(
          _streakCategory,
          actions: [
            DarwinNotificationAction.plain(
              completeStreakAction,
              'Mark completed',
            ),
          ],
        ),
      ],
    );
    final settings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onReminderNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onReminderNotificationResponse,
    );
    _initialized = true;
  }

  Future<void> handleNotificationResponse(
    NotificationResponse response, {
    AppDatabase? database,
  }) async {
    if (response.notificationResponseType !=
            NotificationResponseType.selectedNotificationAction ||
        response.actionId != completeStreakAction) {
      return;
    }
    final match = RegExp(r'^streak:(\d+)$').firstMatch(response.payload ?? '');
    final streakId = match == null ? null : int.tryParse(match.group(1)!);
    if (streakId == null || streakId <= 0) {
      return;
    }

    final db = database ?? await AppDatabase.instance();
    final repository = StreakRepository(db: db, syncNotifications: false);
    final streak = await repository.getById(streakId);
    if (streak == null || streak.archived) {
      return;
    }

    // Use the same completion rules and achievement updates as the app. Repeated
    // taps are safe, and the completion applies to the day the action is tapped.
    await repository.markCompleted(streakId);
    final updatedStreak = await repository.getById(streakId);
    if (updatedStreak == null) {
      return;
    }

    // Background engines have their own service instance, so load the persisted
    // preference before replacing reminders for this streak.
    final settings = await SettingsRepository(db: db).getSettings();
    configureGlobalEnabled(settings.notificationsEnabled);
    await initialize(requestPermissions: false);
    await syncStreakReminders(updatedStreak);
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
            actions: [
              AndroidNotificationAction(
                completeStreakAction,
                'Mark completed',
                showsUserInterface: false,
                cancelNotification: true,
              ),
            ],
          ),
          iOS: DarwinNotificationDetails(categoryIdentifier: _streakCategory),
          macOS: DarwinNotificationDetails(categoryIdentifier: _streakCategory),
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
