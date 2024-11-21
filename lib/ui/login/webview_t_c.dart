import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewTermsConditions extends StatefulWidget {
  //const WebViewTermsConditions({Key key}) : super(key: key);
  final String title;
  const WebViewTermsConditions(this.title);

  @override
  State<WebViewTermsConditions> createState() => _WebViewTermsConditionsState();
}

class _WebViewTermsConditionsState extends State<WebViewTermsConditions> {
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
                child: Text(widget.title),
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
    String fileHtmlContents = await rootBundle.loadString(filePath);
    if(widget.title=='Privacy Policy'){
      _webViewController.loadUrl('https://gmng.pro/privacy-policy/');
    }else{
      _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
    }



  }
}
