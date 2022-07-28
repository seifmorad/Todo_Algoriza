import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotifyHelper{
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    //tz.initializeTimeZones();
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );


    const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('appicon');

      final InitializationSettings initializationSettings =
      InitializationSettings(
      iOS: initializationSettingsIOS,
      android:initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);

  }
  displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'You change your theme',
      'You changed your theme back !',
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }
  scheduledNotification()async{
    var tz;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'scheduled',
        'theme',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    const NotificationDetails(
    android: AndroidNotificationDetails('your channel id', 'Your channel name',
      //'your channel description',
    )
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(()=>Container(color: Colors.white,));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
  Get.dialog(Text('Welcome To App'));
  }
  
}