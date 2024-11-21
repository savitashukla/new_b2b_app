import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:gmng/app_config.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'app.dart';
import 'notificationservice/LocalNotificationService.dart';

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
  initDynamicLinks();
  Map<String, dynamic> jso = {"app_open": "call"};
  final facebookAppEvents = FacebookAppEvents();
  await facebookAppEvents.logEvent(name: 'production_init', parameters: jso);
  AppsflyerController c = await Get.put(AppsflyerController());
  Get.put(CleverTapController());
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final token = await _fcm.getToken();
  Freshchat.setPushRegistrationToken(token);
  //setEnvironment(Environment.production);
  runApp(App(flavor: 'fantasy'));
  Utils().customPrint('TIME:::::::: ${DateTime.now().millisecondsSinceEpoch}');
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
      Utils().customPrint(
          "backgroundHandler call============================================>>>>>>>>>$body_values");
      LocalNotificationService.showNotificationWithDefaultSound(body_values);
    }
  } catch (E) {}
}

initDynamicLinks() async {
  WidgetsFlutterBinding.ensureInitialized();
  var data = await FirebaseDynamicLinks.instance.getInitialLink();
  if (data != null) {
    Utils().customPrint("data link call ${data.link}");
    var deepLink = data.link;
    Utils().customPrint('DynamicLinks onLink ${deepLink}');
  }

  FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
    var deepLink = dynamicLink?.link;

    Utils().customPrint('DynamicLinks onLink succ data ${deepLink}');
  }, onError: (e) async {
    Utils().customPrint('DynamicLinks onError $e');
  });
}
