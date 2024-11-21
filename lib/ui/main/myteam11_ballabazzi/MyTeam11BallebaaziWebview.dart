import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/CmsPageModel.dart';
import 'package:gmng/model/UserModel.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/user_controller.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class MyTeam11BallebaaziWebview extends StatefulWidget {
  final String webUrlResponce;

  const MyTeam11BallebaaziWebview(this.webUrlResponce);

  @override
  MyTeam11BallebaaziWebviewState createState() =>
      MyTeam11BallebaaziWebviewState(webUrlResponce);
}

class MyTeam11BallebaaziWebviewState extends State<MyTeam11BallebaaziWebview> {
  String webUrlResponce = "";

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  MyTeam11BallebaaziWebviewState(String title) {
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
          navigationDelegate: (NavigationRequest request) async {
            print("print web values");
            print("${request.url}");
            if (request.url.startsWith('https://api.whatsapp.com/send?phone')) {
              print('blocking navigation to $request}');
          //    List<String> urlSplitted = request.url.split("&text=");

              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: [
            JavascriptChannel(
                name: 'AndroidBridge',
                onMessageReceived: (message) {
                  Utils().customPrint("object get data team11 ${message.message.toString()}");

                  if (message.message.contains("goToLobby")) {
                    //Get.to(() => DashBord(2, ""));
                    Get.offAll(() => DashBord(2, ""));
                  }
                  if (message.message.contains("goToAddCash")) {
                    UserController _userController = Get.find();

                    _userController.currentIndex.value = 4;
                    Get.to(() => DashBord(4, ""));
                  }
                  if (message.message.contains("gmng_download://${message}")) {
                    Fluttertoast.showToast(msg: "$message");
                    UserController _userController = Get.find();
                    _userController.currentIndex.value = 4;
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
          onProgress: (url) {
            print("call weview run data $url");
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
    /*WebViewController webViewController = await _controller.future;

   *//* bool canNavigate = await webViewController.canGoBack();
    if (canNavigate) {
      webViewController.goBack();
      return false;
    } else {*//*
      bool isPop = false;
      await showAlertDialog(context, (alertResponse) {
        Navigator.of(context).pop();
        // This will dismiss the alert dialog
        isPop = alertResponse;
      });*/
      return false;
    //}
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
