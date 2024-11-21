import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../res/ImageRes.dart';
import '../../../utills/Utils.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class how_to_play_rummy extends StatefulWidget {
  @override
  how_to_play_rummyState createState() => how_to_play_rummyState();
}

class how_to_play_rummyState extends State<how_to_play_rummy> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Completer<WebViewController> webViewCompleter =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          /* appBar: AppBar(
            flexibleSpace: Image(
              image: AssetImage('assets/images/store_top.png'),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            title: Center(
                child: Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Text("How To Play Poker"),
            )),
          ),*/
          body: Stack(
        children: [
          Container(
              child: WebView(
            initialUrl: "https://gmng.pro/r014587/",
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            navigationDelegate: (NavigationRequest request) async {
              print("print web values");
              print("${request.url}");
              launch("${request.url}");
              return NavigationDecision.prevent;
              //  BaseController().launchURLApp("${request.url}");

              /*  if (request.url
                      .startsWith('https://api.whatsapp.com/send?phone')) {
                    print('blocking navigation to $request}');
                    List<String> urlSplitted = request.url.split("&text=");

                    String phone = "0123456789";
                    String message =
                    urlSplitted.last.toString().replaceAll("%20", " ");

                  */ /*  await _launchURL(
                        "https://wa.me/$phone/?text=${Uri.parse(message)}");*/ /*
                    return NavigationDecision.prevent;
                  }*/
              //  return NavigationDecision.prevent;
              print('allowing navigation to $request');
              //return NavigationDecision.navigate;
            },
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
          )),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 25,
              width: 25,
              child: Image.asset(ImageRes().close_icon),
            ),
          )
        ],
      )),
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
}
