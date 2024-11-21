import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  static var onSelectNotification = false;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static void initialize() {
    // initializationSettings  for Android
    InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async {
        print(payload);
        Utils().customPrint("onSelectNotification");
        if (payload.isNotEmpty) {
          if (payload.compareTo("freshChat") == 0) {
            onSelectNotification = true;
          }
          Utils().customPrint("Router Value1234 $payload");
        }
      },
    );
  }

  static onSelectNotificationLunchT() async {
    final notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      Utils().customPrint(notificationAppLaunchDetails);
      Utils().customPrint(
          "getNotificationAppLaunchDetails=============${notificationAppLaunchDetails.toString()}");
      Utils().customPrint(
          "getNotificationAppLaunchDetails.payload=============${notificationAppLaunchDetails.payload}");
      if (notificationAppLaunchDetails.payload.compareTo("freshChat") == 0) {
        onSelectNotification = true;
      } else {
        onSelectNotification = false;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("channel_id", "");
      }
      // await onSelectNotification111(notificationAppLaunchDetails.payload);
      //    return notificationAppLaunchDetails.payload;
    }
  }

/*  static void initCall() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification111,
    );
  }*/

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "gmngflutter",
          "gmngflutterchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification.title??"",
        message.notification.body??"",
        notificationDetails??"",
        payload: message.data['_id']??"",
      );
    } on Exception catch (e) {
      Utils().customPrint(e);
    }
  }

  static void showNotificationWithDefaultSound(String body_values) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '166166',
      "thecodexhub",
      channelDescription:
          "This channel is responsible for all the local notifications",
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(
      0,
      'Support Responded',
      body_values??"Support",
      platformChannelSpecifics,
      payload: 'freshChat',
    );
  }

/*  Future<void> onSelectNotification111(String payload) async {
  Utils().customPrint("object call values show");
  Utils().customPrint(payload);
 */ /*   showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Fnm()));

              },
              child: Text("PayLoad")),
          content: Text("Payload : $payload"),
        );
      },
    );*/ /*
  }*/

/*static void onSelectNotification111(String payload) {
    Utils().customPrint("object call values show notification");
    Utils().customPrint(payload.toString());
    if (payload.compareTo("freshChat") == 0) {
      onSelectNotification = true;
    }
    //Fluttertoast.showToast(msg: "msg");
  }*/
}
