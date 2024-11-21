import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Form16WebView extends StatefulWidget {
  //const Form16WebView({Key key}) : super(key: key);

  const Form16WebView();

  @override
  State<Form16WebView> createState() => _Form16WebViewState();
}

class _Form16WebViewState extends State<Form16WebView> {
  Completer<WebViewController> webViewCompleter =
      Completer<WebViewController>();

  WebViewController _webViewController;
  String filePath = 'assets/files/tnc_esports.html';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/store_back.png"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/images/store_top.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          title: Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Text("Form 16 Request"),
          )),
        ),
        body: WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          zoomEnabled: true,
          backgroundColor: Colors.white,
          /* onProgress: (int progress) {
             Utils().customPrint('Loading (progress : $progress%)');
          },*/
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            _loadHtmlFromAssets();
          },
        ),
      ),
    );
  }

  _loadHtmlFromAssets() async {
    _webViewController.loadUrl('https://forms.gle/frniwqygMM46NifR7');
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
