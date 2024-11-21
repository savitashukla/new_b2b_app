import 'package:gmng/model/CmsPageModel.dart';
import 'package:gmng/model/UserModel.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/toolbar/TopBar.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class Cmspage extends StatefulWidget {
  final String title;

  const Cmspage(this.title);

  @override
  CmspageView createState() => CmspageView(title);
}

class CmspageView extends State<Cmspage> {

  String title = "";

  CmspageView(String title) {
    this.title = title;
  }

  UserPreferences userPreferences;
  UserModel userModel;
  CmsPageModel data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: '${title}',
            menuicon: false,
            menuback: true,
            iconnotifiction: false),
        body:  Container(
            child: WebView(
                initialUrl: 'https://flutter.dev',
                javascriptMode: JavascriptMode.unrestricted
              // backgroundColor: const Color(0x00000000),
            )

        )


    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userPreferences = new UserPreferences(context);
    userPreferences.getUserModel().then((data) =>
    {
      this.userModel = data,
    });
  }



}
