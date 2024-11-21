import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewCms extends StatelessWidget {
 String url;
 WebViewCms(this.url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const WebView(
      initialUrl: 'https://flutter.io',
      javascriptMode: JavascriptMode.unrestricted,
    );


      /*Card(
        elevation: 10,
        child: Column(
          children: <Widget>[
            WebView(
              initialUrl: 'https://flutter.io',
              javascriptMode: JavascriptMode.unrestricted,
            ),


            // Image.asset('assets/profile.png'),
          ],
        ))*/;;
  }

}
