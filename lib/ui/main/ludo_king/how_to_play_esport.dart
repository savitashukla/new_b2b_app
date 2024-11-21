import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utills/Utils.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class how_to_play_esport extends StatefulWidget {
  String url;

  how_to_play_esport(this.url);

  @override
  how_to_play_esportState createState() => how_to_play_esportState(url);
}

class how_to_play_esportState extends State<how_to_play_esport> {
  String url;

  how_to_play_esportState(String url) {
    this.url = url;
  }

  Completer<WebViewController> webViewCompleter =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Image(
              image: AssetImage('assets/images/store_top.png'),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            title: Center(
                child: Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Text("How To Play"),
            )),
          ),
          body: Container(
              child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              webViewCompleter.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) async {
              print("print web values");
              print("${request.url}");

              if (request.url.contains("https://docs.google.com/forms/d/e/")) {
                await launch(
                    "https://docs.google.com/forms/d/e/1FAIpQLSf4hwRTYCjymSAzSYpGwFxKglPe9IwqIzTc5aJldgxMg7HpWg/viewform");
                return NavigationDecision.prevent;
              }
              //  return NavigationDecision.prevent;
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
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
