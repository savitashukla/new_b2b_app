import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';

//import 'package:flutter_facebook_sdk/flutter_facebook_sdk.dart';
import 'package:get/get.dart';
import 'package:gmng/app_config.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'notificationservice/LocalNotificationService.dart';
import 'utills/Utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCFIM2nago1xrYULh1XlsJMO6IDGxs-j4k",
            appId: "1:123245046616:ios:b7bc675575d879566c532d",
            messagingSenderId: "123245046616",
            projectId: "gmng-1524f"));
  } else {
    await Firebase.initializeApp();
  }
  //initPlatformState();
  Map<String, dynamic> jso = {"app_open": "call"};
  final facebookAppEvents = FacebookAppEvents();
  facebookAppEvents.logEvent(name: 'playstore', parameters: jso);
  AppsflyerController c = await Get.put(AppsflyerController());
  Get.put(CleverTapController());
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  LocalNotificationService.initialize();
/*  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: AppColor().colorPrimary),
    translations: LocaleString(),
    locale: Locale('hi','IN'),
    routes: Routes.getRoutes(),

  ),);*/
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final token = await _fcm.getToken();
  Freshchat.setPushRegistrationToken(token);
  //setEnvironment(Environment.playstore);

  runApp(App(flavor: 'playstore'));
}

Future<void> backgroundHandler(RemoteMessage message) async {
  Map<dynamic, dynamic> bodyCal;
  bodyCal = message.data;
  Utils().customPrint(
      "backgroundHandler ============================================>>>>>>>>>$bodyCal");

  try {
    String body_values = bodyCal["body"];
    String source = bodyCal["source"];

    if (source.compareTo("freshchat_user") == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("channel_id", "${bodyCal["channel_id"]}");

      Utils().customPrint(
          "backgroundHandler call============================================>>>>>>>>>$body_values");
      LocalNotificationService.showNotificationWithDefaultSound(body_values);
    }
  } catch (E) {}
}
