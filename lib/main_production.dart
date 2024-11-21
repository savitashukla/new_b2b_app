//@dart=2.9

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:gmng/app_config.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/utills/OnlyOff.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_bar_control/status_bar_control.dart';

import 'app.dart';
import 'notificationservice/LocalNotificationService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

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
  //full screen work
  await StatusBarControl.setTranslucent(false);
  await StatusBarControl.setHidden(false, animation: StatusBarAnimation.SLIDE);

  AppString.appBarHeight.value = await StatusBarControl.getHeight;

  //print("app bar Height$height");

/*  Map<String, dynamic> jso = {"app_open": "call"};
  final facebookAppEvents = FacebookAppEvents();*/

/*  await facebookAppEvents.logEvent(name: 'production_init', parameters: jso);*/
  AppsflyerController c = await Get.put(AppsflyerController());

  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final token = await _fcm.getToken();

  // final SmsAutoFill _autoFill = SmsAutoFill();
  //final signature = await SmsAutoFill().getAppSignature;
  //print("call data${signature}");
  //  final completePhoneNumber = await _autoFill.hint;

  Freshchat.setPushRegistrationToken(token);
  Utils().customPrint("call main $token");
  //setEnvironment(Environment.production);//need to check
  Get.put(CleverTapController());
  //runApp(App(flavor: 'production'));

  //SentryFlutter Code for Error Detection
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://6ac71903d38b45dfb2dfc7829d5ffd04@o4505520604643328.ingest.sentry.io/4505525122105344'; //LIVE
      //options.dsn = 'https://d084463f6478432bab3c9b3c276410f0@o4505520604643328.ingest.sentry.io/4505549739196416'; //STAGING
      //options.dsn = 'https://a952bcbc1d574a69b2617894b73dd151@o4505327396257792.ingest.sentry.io/4505327402680320'; //TEST1

      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(App(flavor: 'production')),
  );
}

Future<void> backgroundHandler(RemoteMessage message) async {
  Map<dynamic, dynamic> bodyCal;
  bodyCal = message.data;
  Utils().customPrint(
      "backgroundHandler ============================================>>>>>>>>>$bodyCal");

  //print("show data values ${bodyCal["type"]}");
  try {
    if (bodyCal["type"] != null &&
        bodyCal["type"] == "instantCashAddedFromGamePlay") {
      //   onlyOffi.instancePoP.value=true;
      print("instantCashAdded true ${bodyCal["type"]}");
      //  SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setBool("instantCashAdded", true);
    }
  } catch (A) {}

  try {
    String body_values = bodyCal["body"];
    String source = bodyCal["source"];

    if (source.compareTo("freshchat_user") == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("channel_id", "${bodyCal["channel_id"]}");
      prefs.setString("source", "${source}");
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
