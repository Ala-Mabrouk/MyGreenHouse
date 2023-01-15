import 'dart:math';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notif {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');

  late final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: null);

  var scheduledNotificationDateTime =
      DateTime.now().add(const Duration(seconds: 5));
  late final NotificationDetails platformChannelSpecifics;
  late final AndroidNotificationDetails androidPlatformChannelSpecifics;

  init() {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      color: const Color(0xff2196f3),
    );

     platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
  }

  getNotification(String title, String body) async {
    init();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(50), title, body, platformChannelSpecifics);

    /*  await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics); */
  }
}
