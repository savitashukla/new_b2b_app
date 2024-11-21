import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/main/tamasha_ludo/Tamash_Game_Over.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class TamashaWebview extends StatefulWidget {
  String url;
  String event_id;
  String gameid;
  var playAmount;
  String gameImageUrl;
  String gameName;

  TamashaWebview(this.url, this.gameid, this.event_id, this.playAmount,
      this.gameImageUrl, this.gameName);

  @override
  TamashaWebviewState createState() => TamashaWebviewState(
      url, gameid, event_id, this.playAmount, this.gameImageUrl, this.gameName);
}

class TamashaWebviewState extends State<TamashaWebview> {
  String url;
  String event_id;
  String gameid;
  var playAmount;

  String gameImageUrl;
  String gameName;
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  var user_name = "".obs;

  TamashaWebviewState(this.url, this.gameid, this.event_id, this.playAmount,
      this.gameImageUrl, this.gameName);

  Completer<WebViewController> webViewCompleter =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
            body: Container(
                child: WillPopScope(
          onWillPop: () async {
            bool isPop = false;
            await showAlertDialog(context, (alertResponse) {
              Navigator.of(context).pop();
              // This will dismiss the alert dialog
              isPop = alertResponse;
            });
            return isPop;
          },
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              webViewCompleter.complete(webViewController);
            },
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'NativeJavascriptInterface',
                  onMessageReceived: (JavascriptMessage message) async {
                    try {
                      var messageJson = json.decode(message.message);
                      print("get res....... va$messageJson");

                      if (messageJson != null) {
                        // When No Play Found
                        /*if (messageJson['reason'] == 'normal' ||
                                    messageJson['reason'] == 'refund') {
                                  WebViewController webViewController =
                                  await webViewCompleter.future;
                                  await webViewController.clearCache();
                                  Navigator.of(context).pop();
                                } else {*/

                        if (messageJson['reason'] == 'refund') {
                          print("call data use");
                          Future.delayed(const Duration(seconds: 3), () async {
                            WebViewController webViewController =
                                await webViewCompleter.future;
                            await webViewController.clearCache();
                            //   Navigator.of(navigatorKey.currentState.context).pop();
                          });
                        } else if (messageJson['reason'] == 'data-transfer') {
                          if (messageJson['gameData'] != null &&
                              messageJson['gameData'] != null &&
                              messageJson['gameData']['otherData']
                                      ["eventName"] ==
                                  "end") {
                            print(
                                "name get ${messageJson['gameData']['otherData']["game_data"][0]["name"]}");
                            for (int index = 0;
                                messageJson['gameData']['otherData']
                                            ["game_data"]
                                        .length >
                                    index;
                                index++) {
                              print(
                                  "GO TO LOOP DATA  ${messageJson['gameData']['otherData']["game_data"][index]["name"]}");

                              if (user_name.value.compareTo(
                                      "${messageJson['gameData']['otherData']["game_data"][index]["name"]}") ==
                                  0) {
                                print(
                                    "compre name correct  ${messageJson['gameData']['otherData']["game_data"][index]["rank"] == 1}");

                                if (messageJson['gameData']['otherData']
                                        ["game_data"][index]["rank"] ==
                                    1) {
                                  print(
                                      "compre rank correct  ${messageJson['gameData']['otherData']["game_data"][index]["rank"]}");

                                  WebViewController webViewController =
                                      await webViewCompleter.future;
                                  await webViewController.clearCache();
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    navigatorKey.currentState.context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Tamasha_Game_Over(
                                              gameid,
                                              event_id,
                                              playAmount,
                                              gameName,
                                              gameImageUrl,
                                              true,
                                              messageJson['gameData']
                                                      ['otherData']["game_data"]
                                                  [index]["sc"]),
                                    ),
                                  );
                                } else {
                                  WebViewController webViewController =
                                      await webViewCompleter.future;
                                  await webViewController.clearCache();
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    navigatorKey.currentState.context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Tamasha_Game_Over(
                                              gameid,
                                              event_id,
                                              playAmount,
                                              gameName,
                                              gameImageUrl,
                                              false,
                                              messageJson['gameData']
                                                      ['otherData']["game_data"]
                                                  [index]["sc"]),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                          //sendWinnerLoserEvent(messageJson.toString());
                        }
                        // }
                      }
                    } catch (E) {}

                    //calling
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
          ),
        ))),
      ),
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
    getData();

    if (AppString.helperTimer == 0) {
      AppString.helperTimer =
          60; //we have set 60 sec for match making in ludo tamasha
    }
  }

  Future showAlertDialogOld(
      BuildContext context, YesOrNoTapCallback isYesTapped) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do you want to quit?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              //  Get.to(() => GameJobList(gameid, url1, "Ludo"));
              //isYesTapped(true);
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

  //pop-up for 1mint when user already clicks other events
//lootbox popup for pending
  void showAlertDialog(BuildContext context, YesOrNoTapCallback isYesTapped) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Stack(
            children: [
              Image(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().hole_popup_bg)),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(ImageRes().hole_popup_bg))),
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 250,
                child: Card(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 0, right: 0),
                  elevation: 0,
                  //color: AppColor().wallet_dark_grey,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "         ",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: 60,
                            child: Lottie.asset(
                              'assets/lottie_files/waiting.json',
                              repeat: false,
                              height: 100,
                              width: 100,
                            ),
                            /*Image.asset("assets/images/rupee_gmng.png"),*/
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 18,
                              width: 18,
                              child: Image.asset(ImageRes().close_icon),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 5, bottom: 10, right: 20),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "Existing the game screen will not end the matchmaking, money will not be refunded if a player is found!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColor().whiteColor,
                                fontFamily: "Montserrat",
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              WebViewController webViewController =
                                  await webViewCompleter.future;
                              await webViewController.clearCache();
                              Navigator.of(context).pop();
                              isYesTapped(false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 43,
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 10, bottom: 10),
                              //width: MediaQuery.of(context).size.width - 350,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().green_color_light,
                                    AppColor().green_color,
                                  ],
                                ),

                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFF02310A),
                                    inset: true,
                                  ),
                                ],

                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Text(
                                  "Confirm",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //Navigator.pop(context);
                              Navigator.of(context).pop();
                              // isYesTapped(false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 43,
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 10, bottom: 10),
                              //width: MediaQuery.of(context).size.width - 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().button_bg_light,
                                    AppColor().button_bg_dark,
                                  ],
                                ),

                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFFA73804),
                                    inset: true,
                                  ),
                                  BoxShadow(
                                    offset: Offset(00, 00),
                                    blurRadius: 00,
                                    color: Color(0xFFffffff),
                                    inset: true,
                                  ),
                                ],

                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Text(
                                  "Go Back",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      user_name.value = prefs.getString("user_name");
    } catch (A) {}
  }
}

typedef YesOrNoTapCallback = Function(bool);
