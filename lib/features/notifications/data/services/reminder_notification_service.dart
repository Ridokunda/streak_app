import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../streaks/data/models/streak.dart';

class ReminderNotificationService {
  ReminderNotificationService._();

  static final ReminderNotificationService instance = ReminderNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

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
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> syncStreakReminders(Streak streak) async {
    if (streak.id == null) {
      return;
    }

    await initialize();
    await cancelStreakReminders(streak.id!);

    if (!streak.remindersEnabled || streak.reminderTimes.isEmpty) {
      return;
    }

    final uniqueTimes = streak.reminderTimes.toSet().toList()..sort();

    for (var index = 0; index < uniqueTimes.length && index < 100; index++) {
      final minutes = uniqueTimes[index];
      final scheduledDate = _nextOccurrence(minutes);

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
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'streak:${streak.id}',
      );
    }
  }

  Future<void> cancelStreakReminders(int streakId) async {
    await initialize();

    for (var index = 0; index < 100; index++) {
      await _plugin.cancel(id: _notificationId(streakId, index));
    }
  }

  int _notificationId(int streakId, int reminderIndex) {
    return (streakId * 100) + reminderIndex;
  }

  tz.TZDateTime _nextOccurrence(int totalMinutes) {
    final now = tz.TZDateTime.now(tz.local);
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;

    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
