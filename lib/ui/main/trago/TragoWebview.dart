import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/model/CmsPageModel.dart';
import 'package:gmng/model/UserModel.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/ui/main/cash_free/CashFreeScreen.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class TragoWebview extends StatefulWidget {
  final String webUrlResponce;

  const TragoWebview(this.webUrlResponce);

  @override
  TragoWebviewState createState() => TragoWebviewState(webUrlResponce);
}

class TragoWebviewState extends State<TragoWebview> {
  String webUrlResponce = "";

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  TragoWebviewState(String title) {
    this.webUrlResponce = title;
  }

  UserPreferences userPreferences;
  UserModel userModel;
  CmsPageModel data;
  Completer<WebViewController> webViewCompleter =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

          /* appBar: AppBar(

            backgroundColor: Colors.transparent,
          ),*/
          body: Container(
              child: WillPopScope(
        onWillPop: onWillPop,
        child: WebView(
          initialUrl: webUrlResponce,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: [
            JavascriptChannel(
                name: 'AndroidBridge',
                onMessageReceived: (message) async {
                  Utils().customPrint("object::: ${message.toString()}");
                  Utils().customPrint("BB-----" + message.message);

                  if (message.message.contains("Exit From Trago")) {
                    //Get.to(() => DashBord(2, ""));
                    Get.offAll(() => DashBord(2, ""));
                  } else if (message.message.contains("Wallet Click")) {
                    Get.offAll(() => DashBord(4, ""));
                  } else if (message.message.contains("Recharge")) {
                    Navigator.of(context).pop();
                    Get.to(() => CashFreeScreen());
                  }
                })
          ].toSet(),
          onPageStarted: (url) {
            Utils().customPrint('onPageStarted for : $url');
          },
          onPageFinished: (url) {
            Utils().customPrint('onPageFinished for : $url');
          },
          onWebResourceError: (error) {
            Utils().customPrint('onWebResourceError : ${error.errorCode}');
          },
          gestureNavigationEnabled: true,
          zoomEnabled: false,
        ),
      ))),
    );
  }

  // Add from here ...
  Set<JavascriptChannel> _createJavascriptChannels(BuildContext context) {
    return {
      JavascriptChannel(
        name: 'flutterWebView',
        onMessageReceived: (message) {
          Utils().customPrint('message.message: ${message.message}');
          /* ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));*/
        },
      ),
    };
  }

  Future<bool> onWillPop() async {
    WebViewController webViewController = await _controller.future;

    bool canNavigate = await webViewController.canGoBack();
    if (canNavigate) {
      webViewController.goBack();
      return false;
    } else {
      bool isPop = false;
      await showAlertDialog(context, (alertResponse) {
        Navigator.of(context).pop();
        // This will dismiss the alert dialog
        isPop = alertResponse;
      });
      return isPop;
    }
  }

  Future showAlertDialog(
      BuildContext context, YesOrNoTapCallback isYesTapped) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do you want to quit?"),
      actions: [
        TextButton(
            onPressed: () {
              isYesTapped(true);
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
