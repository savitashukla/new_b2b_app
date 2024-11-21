import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/model/CmsPageModel.dart';
import 'package:gmng/model/UserModel.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utills/Utils.dart';
import '../../controller/WalletPageController.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class InvoidWebview extends StatefulWidget {
  final String title;

  const InvoidWebview(this.title);

  @override
  InvoidWebviewView createState() => InvoidWebviewView(title);
}

class InvoidWebviewView extends State<InvoidWebview> {
  WalletPageController walletPageController = Get.put(WalletPageController());
  String title = "";
  String url = "";

  InvoidWebviewView(String title) {
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
              child: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (url) {
          Utils().customPrint('onPageStarted for : $url');
        },
        onPageFinished: (url) {
          if (url ==
              ApiUrl().INVOID_CALLBACK_URL + walletPageController.user_id) {
            Utils().customPrint('onPageFinished for : SUccesss page');
            walletPageController.getProfileData();
            Navigator.pop(context);
          }
          Utils().customPrint('onPageFinished for : $url');
        },
        onWebResourceError: (error) {
          Utils().customPrint('onWebResourceError : ${error.errorCode}');
        },
        gestureNavigationEnabled: true,
        zoomEnabled: false,
      ))),
    );
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
    Utils().customPrint("Url final: ${url}");
  }
}
