import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyHelper{ //to kodo sem prekopiral iz spleta :)
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    //tz.initializeTimeZones();

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings ("appicon");

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android:initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(()=>Container(color: Colors.white));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
/*    showDialog(
      //context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );*/
  Get.dialog(Text("Wellcome to flutter"));
  }
}