import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'FreakxList.dart';
import 'Freakx_Match_Making_Screen.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class FreakxWebview extends StatefulWidget {
  String url;
  String event_id;
  String gameid;
  String playAmount;
  String url1;
  String nameGame;

  FreakxWebview(
      this.url, this.gameid, this.event_id, this.playAmount, this.url1,this.nameGame);

  @override
  FreakxWebviewState createState() =>
      FreakxWebviewState(url, gameid, event_id, this.playAmount, this.url1);
}

class FreakxWebviewState extends State<FreakxWebview> {
  String url;
  String event_id;
  String gameid;
  String playAmount;
  String url1;
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  FreakxWebviewState(
      this.url, this.gameid, this.event_id, this.playAmount, this.url1);

  Completer<WebViewController> webViewCompleter =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  Utils().customPrint(message.message);
                  Utils().customPrint(
                      'Completed Game Over Event Testing ${message.message}');
                  //  webViewCompleter.isCompleted;

                  /*//GAME OVER CT EVENTS WORK
                  Map<String, Object> map = new Map<String, Object>();
                  map["event_id"] = event_id;
                  map["Game_id"] = gameid;
                  map["playAmount"] = playAmount;

                  //calling
                  cleverTapController.logEventCT(
                      EventConstant.EVENT_Casual_Game_Complete, map);
                  appsflyerController.logEventAf(
                      EventConstant.EVENT_Casual_Game_Complete, map);*/

                  WebViewController webViewController =
                      await webViewCompleter.future;
                  await webViewController.clearCache();

                  // Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          Freakx_Match_Making_Screen(

                              event_id, gameid, mapVa, playAmount, url1,  widget.nameGame),
                    ),
                  );
                  /* Get.to((Freakx_Match_Making_Screen(
                      event_id, gameid, mapVa, playAmount, url1)));*/
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
      ))),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future showAlertDialog(
      BuildContext context, YesOrNoTapCallback isYesTapped) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do you want to quit?"),
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              Get.to(() => FreakxList(gameid, url1, widget.nameGame));
              WebViewController webViewController =
              await webViewCompleter.future;
              await webViewController.clearCache();
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
