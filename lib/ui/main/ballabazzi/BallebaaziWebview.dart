import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/model/CmsPageModel.dart';
import 'package:gmng/model/UserModel.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class BallebaaziWebview extends StatefulWidget {
  final String title;

  const BallebaaziWebview(this.title);

  @override
  BallebaaziWebviewView createState() => BallebaaziWebviewView(title);
}

class BallebaaziWebviewView extends State<BallebaaziWebview> {
  String title = "";
  String url = "";
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  BallebaaziWebviewView(String title) {
    this.title = title;
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
          initialUrl: url,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: [
            JavascriptChannel(
                name: 'flutterWebView',
                onMessageReceived: (message) {
                  Utils().customPrint("object${message.toString()}");

                  if (message.message.contains("bbExitApp")) {
                    //Get.to(() => DashBord(2, ""));
                    Get.offAll(() => DashBord(2, ""));
                  }
                  if (message.message.contains("bbPartnerWalletCTA")) {
                    Get.to(() => DashBord(4, ""));
                  }
                  if (message.message.contains("bbAddMoney")) {
                    Get.to(() => DashBord(4, ""));
                  }
                  Utils().customPrint("BB-----" + message.message);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userPreferences = new UserPreferences(context);
    userPreferences.getUserModel().then((data) => {
          this.userModel = data,
        });
    url = Get.arguments;
    Utils().customPrint("BB Url final: ${url}");
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
