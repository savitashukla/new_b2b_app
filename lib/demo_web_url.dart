import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utills/Utils.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class demo_web_url extends StatefulWidget {


  @override
  demo_web_urlState createState() => demo_web_urlState();
}

class demo_web_urlState extends State<demo_web_url> {
  String url;



  Completer<WebViewController> webViewCompleter =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

          body: Container(
              child: WebView(
             //   initialUrl: url,
                initialUrl: "https://gmngesports.com/javascript_demo.html",
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                onWebViewCreated: (WebViewController webViewController) {
                  webViewCompleter.complete(webViewController);
                },

                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'AndroidBridge',
                      onMessageReceived: (JavascriptMessage message) {
                        Utils().customPrint("----- wevview onMessageReceived");

                        Utils().customPrint(message.message);
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
  }
}
