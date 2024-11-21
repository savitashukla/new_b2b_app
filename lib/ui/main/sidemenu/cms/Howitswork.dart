import 'package:gmng/toolbar/TopBar.dart';
import 'package:flutter/material.dart';


// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class HowitsworkPage extends StatefulWidget {
  @override
  HowitsworkPageView createState() => HowitsworkPageView();
}

class HowitsworkPageView extends State<HowitsworkPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: "How its Work",menuicon:false,menuback:true,iconnotifiction:false),
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Image.asset("assets/images/logo.png",
                          height: 100, width: 100),
                      new Text("Chaletebook is the global platform where dreams meet the reality. "
                          "Where every one of us can find his dream home in his dream place with the best offer."
                          " Where peoples can show their properties for sale, rent or exchange between each other.")

                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }


}
