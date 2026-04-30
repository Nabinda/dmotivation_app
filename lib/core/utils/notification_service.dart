import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz_core;

class NotificationService {
  // Singleton pattern to ensure only one instance exists
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initializes the notification plugin and timezones.
  /// Must be called in main.dart before runApp().
  Future<void> init() async {
    if (_isInitialized) return;

    // Initialize Timezones (Crucial for scheduled notifications)
    tz_data.initializeTimeZones();
    tz_core.setLocalLocation(tz_core.getLocation('Europe/London'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Initialization Settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle what happens when the user taps the notification.
        // For V1: We just want them to open the app (Dashboard).
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    _isInitialized = true;
  }

  /// The standard aesthetic for D/MOTIVATION notifications.
  /// High priority, strict, no-nonsense.
  NotificationDetails _getProtocolDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_notifications',
        'Daily Alerts',
        channelDescription: 'Daily morning and evening notifications.',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'Notification Update',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  /// Schedules the Morning Briefings for the entire week based on the user's wake time.
  /// Uses Odd IDs (1, 3, 5, 7, 9, 11, 13) for each day of the week.
  Future<void> scheduleMorningBrief(TimeOfDay wakeTime) async {
    for (int weekday = 1; weekday <= 7; weekday++) {
      final int oddId = (weekday * 2) - 1;

      await _notificationsPlugin.zonedSchedule(
        id: oddId,
        title: 'Morning Alert',
        body: 'It is time to start your day.',
        scheduledDate: _nextInstanceOfDayAndTime(weekday, wakeTime),
        notificationDetails: _getProtocolDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
    debugPrint('Morning briefs scheduled for the entire week (Odd IDs).');
  }

  /// Schedules the Evening Debriefs for the entire week based on the user's sleep time.
  /// Uses Even IDs (2, 4, 6, 8, 10, 12, 14) for each day of the week.
  Future<void> scheduleEveningDebrief(TimeOfDay sleepTime) async {
    // Schedule it 1 hour before sleep time
    TimeOfDay debriefTime = TimeOfDay(
      hour: sleepTime.hour - 1 < 0 ? 23 : sleepTime.hour - 1,
      minute: sleepTime.minute,
    );

    for (int weekday = 1; weekday <= 7; weekday++) {
      final int evenId = weekday * 2;

      await _notificationsPlugin.zonedSchedule(
        id: evenId,
        title: 'Evening Alert',
        body: 'It is time to review your day.',
        scheduledDate: _nextInstanceOfDayAndTime(weekday, debriefTime),
        notificationDetails: _getProtocolDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
    debugPrint('Evening debriefs scheduled for the entire week (Even IDs).');
  }

  /// Cancels all scheduled protocol notifications.
  /// Useful if the user toggles "Hardcore Mode" off or completes the contract.
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
    debugPrint('All scheduled notifications canceled.');
  }

  /// Helper: Calculates the next TZDateTime for a given TimeOfDay.
  tz_core.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz_core.TZDateTime now = tz_core.TZDateTime.now(tz_core.local);
    tz_core.TZDateTime scheduledDate = tz_core.TZDateTime(
      tz_core.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Helper: Calculates the next TZDateTime for a specific day of the week and time.
  tz_core.TZDateTime _nextInstanceOfDayAndTime(int weekday, TimeOfDay time) {
    tz_core.TZDateTime scheduledDate = _nextInstanceOfTime(time);

    // Increment the date until it matches the desired day of the week
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Schedules a one-off test notification 30 seconds from now.
  Future<void> scheduleTestNotification() async {
    final tz_core.TZDateTime now = tz_core.TZDateTime.now(tz_core.local);
    final tz_core.TZDateTime scheduledDate = now.add(
      const Duration(seconds: 10),
    );

    await _notificationsPlugin.zonedSchedule(
      id: 999, // Unique ID so it doesn't clash with your daily alerts
      title: 'SYSTEM TEST',
      body: 'Notification systems are fully operational. Get back to work.',
      scheduledDate: scheduledDate,
      notificationDetails: _getProtocolDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    debugPrint('Test notification scheduled for $scheduledDate');
  }
}
