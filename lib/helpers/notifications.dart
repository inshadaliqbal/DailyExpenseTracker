import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

Future<void> initNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');


  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> scheduleMorningAndEveningNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Configure the notification details
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'daily_reminder',
    'Daily Reminder',
    importance: Importance.max,
    priority: Priority.high,
    channelShowBadge: true,
    playSound: true,
  );


  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  // Schedule morning notification (9 AM)
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good Morning!',
    'Start your day with a fresh mindset.',
    _nextInstanceOfMorning(),
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  // Schedule evening notification (9 PM)
  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    'Good Evening!',
    'Time to wind down and relax.',
    _nextInstanceOfEvening(),
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

TZDateTime _nextInstanceOfMorning() {
  final now = TZDateTime.now(local);

  var scheduledDate = TZDateTime(local, now.year, now.month, now.day, 9);

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  return scheduledDate;
}

TZDateTime _nextInstanceOfEvening() {
  final now = TZDateTime.now(local);

  var scheduledDate = TZDateTime(local, now.year, now.month, now.day, 21);

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  return scheduledDate;
}