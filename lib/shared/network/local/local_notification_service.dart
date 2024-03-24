import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNoticficationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //solve error backgroundholder
  static onTap(NotificationResponse notificationResponse) {}

  //initialzation
  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //Schduled Notification
  static showSchduledNotification() async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'id 2',
        'Schduled notification',
        // to show pop notification
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    //time zone initial
    tz.initializeTimeZones();
    //get my time zone location
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    // zonedSchedule
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'Schduled notification',
      'Schduled notification body',
      tz.TZDateTime(
        tz.local,
        // my location
        2024,
        // year
        3,
        //month
        23,
        // day
        15,
        //hour
        2,
        //minute
        15, //second
      ),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  //cancel notification
  static cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

/*
1. Setup (platorms,initial)
2. Basic Notification
3. Repeated Notification
4. Scheduled Notification
*/

//to now what time now in my city (just test)
returnCommonDate() {
  tz.initializeTimeZones();
  final egyptTimeZone = tz.getLocation('Africa/Cairo'); // static way يدويه
  final now = tz.TZDateTime.now(egyptTimeZone);
  print("=========================this is egypt time $now");
}
