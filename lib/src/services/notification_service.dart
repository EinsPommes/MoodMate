import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final SharedPreferences prefs;
  static const String _reminderTimeKey = 'reminder_time';
  static const String _reminderEnabledKey = 'reminder_enabled';

  NotificationService(this.prefs) {
    tz.initializeTimeZones();
  }

  Future<void> initialize() async {
    // Initialisierung für Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Initialisierung für iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  /// Aktiviert oder deaktiviert die tägliche Erinnerung
  Future<void> toggleReminder(bool enabled) async {
    await prefs.setBool(_reminderEnabledKey, enabled);
    if (enabled) {
      await _scheduleReminder();
    } else {
      await cancelReminder();
    }
  }

  /// Setzt die Erinnerungszeit und aktualisiert den Zeitplan
  Future<void> setReminderTime(DateTime time) async {
    // Speichere nur Stunde und Minute
    final timeString = '${time.hour}:${time.minute}';
    await prefs.setString(_reminderTimeKey, timeString);
    
    if (isReminderEnabled) {
      await _scheduleReminder();
    }
  }

  /// Plant die tägliche Erinnerung
  Future<void> _scheduleReminder() async {
    final timeString = prefs.getString(_reminderTimeKey) ?? '20:00';
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final androidDetails = AndroidNotificationDetails(
      'mood_reminder',
      'Stimmungs-Erinnerung',
      channelDescription: 'Tägliche Erinnerung zur Stimmungserfassung',
      importance: Importance.high,
      priority: Priority.high,
    );

    final iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      0, // ID der Benachrichtigung
      'Zeit für deine Stimmung!', // Titel
      'Wie fühlst du dich heute? Tippe hier, um es festzuhalten.', // Text
      _nextInstanceOfTime(hour, minute),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Berechnet den nächsten Zeitpunkt für die Erinnerung
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Löscht die geplante Erinnerung
  Future<void> cancelReminder() async {
    await _notifications.cancel(0);
  }

  /// Prüft, ob die Erinnerung aktiviert ist
  bool get isReminderEnabled => prefs.getBool(_reminderEnabledKey) ?? false;

  /// Gibt die aktuelle Erinnerungszeit zurück
  String get reminderTime => prefs.getString(_reminderTimeKey) ?? '20:00';
}
