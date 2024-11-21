import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'GameZopList.dart';
import 'Match_Making_Screen.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class GameJobWebview extends StatefulWidget {
  String url;
  String event_id;
  String gameid;
  String playAmount;
  String url1;

  GameJobWebview(
      this.url, this.gameid, this.event_id, this.playAmount, this.url1);

  @override
  GameJobWebviewState createState() =>
      GameJobWebviewState(url, gameid, event_id, this.playAmount, this.url1);
}

class GameJobWebviewState extends State<GameJobWebview> {
  String url;
  String event_id;
  String gameid;
  String playAmount;
  String url1;
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  GameJobWebviewState(
      this.url, this.gameid, this.event_id, this.playAmount, this.url1);

  Completer<WebViewController> webViewCompleter =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: WillPopScope(
      onWillPop: () async {
        bool isPop = false;
        await showAlertDialog(context, (alertResponse) {
          Navigator.of(context).pop();
          // This will dismiss the alert dialog
          isPop = alertResponse;
        });
        return isPop;
      },
      child: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        onWebViewCreated: (WebViewController webViewController) {
          webViewCompleter.complete(webViewController);
        },
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'AndroidBridge',
              onMessageReceived: (JavascriptMessage message) async {
                Utils().customPrint("----- wevview onMessageReceived");
                String mapVa = message.message;

                final resData = json.decode(message.message);
                Utils().customPrint(
                    'Completed Game Over Event Testing ${resData}');
                // call other data
                if (resData["event"] == "match_over" ||
                    resData["event"] == "match_result") {
                  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                  WebViewController webViewController =
                      await webViewCompleter.future;
                  await webViewController.clearCache();
                  Navigator.of(context).pop();
                  Get.to((Match_Making_Screen(
                      event_id, gameid, mapVa, playAmount, url1)));
                }
              })
        ]),
        onProgress: (progr) {
          Utils().customPrint('onProgress : $progr');
        },
        onPageFinished: (url) {
          // Get.to(()=>Match_Making_Screen());
          Utils().customPrint('onPageFinished for : $url');
        },
        onPageStarted: (url) {},
        onWebResourceError: (error) {
          Utils().customPrint('onWebResourceError : ${error.errorCode}');
        },
        zoomEnabled: false,
      ),
    )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //for only fruit chop
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
  }

  @override
  void dispose() {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Future showAlertDialog(
      BuildContext context, YesOrNoTapCallback isYesTapped) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do you want to quit?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              Get.to(() => GameJobList(gameid, url1, "Ludo"));
              //isYesTapped(true);
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              isYesTapped(false);
              // Navigator.of(context).pop();
            },
            child: Text("No")),
      ],
    );
    await showDialog(context: context, builder: (_) => alert);
  }
}

typedef YesOrNoTapCallback = Function(bool);
