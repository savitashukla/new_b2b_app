import 'package:gmng/toolbar/TopBar.dart';
import 'package:flutter/material.dart';


// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class Myproperty extends StatefulWidget {
  @override
  MypropertyView createState() => MypropertyView();
}

class MypropertyView extends State<Myproperty> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: "My Listing",menuicon:false,menuback:true,iconnotifiction:false),
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Container(
              child: Center(

              ),
            ),
          ]),
        ));
  }


}
