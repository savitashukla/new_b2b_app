import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';
import '../../model/ESportsEventList.dart';
import '../../model/responsemodel/PreJoinUnityResponseModel.dart';
import '../../model/setting/PublicSetting.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';
import '../../res/firebase_events.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../../utills/event_tracker/CleverTapController.dart';
import '../../utills/event_tracker/EventConstant.dart';
import '../../utills/event_tracker/FaceBookEventController.dart';
import '../../webservices/ApiUrl.dart';
import '../../webservices/WebServicesHelper.dart';
import '../main/Freakx/FreakxWebview.dart';
import '../main/GameZop/GameZopWebview.dart';

class BaseController extends GetxController {
  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;
  var publicSettingModel = PublicSetting().obs;
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  var checkTr = true.obs;
  var remainingDayData = .6.obs;

  void launchURLApp(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openwhatsapp(String message) async {
    print(message);
    print(message.length);
    var whatsapp = "";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=${message}";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";

    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        Fluttertoast.showToast(msg: "whatsapp no installed");
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        Fluttertoast.showToast(msg: "whatsapp no installed");
      }
    }
  }

  launchInstagram(String instagram) async {
    if (!instagram.isEmpty) {
      if (await canLaunch(instagram)) {
        await launch(instagram);
      } else {
        Utils().customPrint("can't open Instagram");
      }
    } else {
      const nativeUrl = "instagram://user?username=severinas_app";
      const webUrl = "https://www.instagram.com/severinas_app/";
      if (await canLaunch(nativeUrl)) {
        await launch(nativeUrl);
      }
      /*else if (await canLaunch(webUrl)) {
      await launch(webUrl);
    }*/
      else {
        Utils().customPrint("can't open Instagram");
      }
    }
  }

  void facebook() async {
    String url = "https://www.facebook.com/GMNGOfficial/";
    Utils().customPrint("launchingUrl: $url");
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  launchURLYouTube() async {
    String link = "https://www.youtube.com/c/GMNGApp/videos";
    if (Platform.isIOS) {
      if (await canLaunch(
          'youtube://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw')) {
        await launch(
            'youtube://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw',
            forceSafariVC: false);
      } else {
        if (await canLaunch(
            'https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw')) {
          await launch(
              'https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw');
        } else {
          throw 'Could not launch https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw';
        }
      }
    } else {
      const url = 'https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void launchYouTube() async {
    String url = "https://www.youtube.com/c/GMNGApp/videos";
    Utils().customPrint("launchingUrl: $url");
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void launchdiscord() async {
    String url = "https://discord.com/invite/frppR7ZPwu";
    Utils().customPrint("launchingUrl: $url");
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void launchTelegram() async {
    String url = "https://telegram.me/<telegram_username>";
    Utils().customPrint("launchingUrl: $url");
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> getSettingPublicM() async {
    Utils().customPrint('getSettingPublicM: STARTED');
    Map<dynamic, dynamic> response =
        await WebServicesHelper().getSettingPublic();
    if (response != null) {
      print(" call getSettingPu $response");
      publicSettingModel.value = PublicSetting.fromJson(response);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("whatsappMobile",
          "${publicSettingModel.value.support.whatsappMobile}");
      print(
          " call getSetting whatsappMobile ${publicSettingModel.value.support.whatsappMobile}");
    } else {
      Fluttertoast.showToast(msg: "ERROR!");
    }
  }

  void alertBecomeAffiliate(String userId) {
    var number = "";
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Center(
              child: Container(
                width:
                    MediaQuery.of(navigatorKey.currentState.context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(ImageRes().affiliat_bg))),
                padding: EdgeInsets.symmetric(horizontal: 00),
                height: 350,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                          height: 350,
                          width:
                              MediaQuery.of(navigatorKey.currentState.context)
                                  .size
                                  .width,
                          fit: BoxFit.fill,
                          image: AssetImage(ImageRes().affiliat_bg)),
                    ),
                    Card(
                      margin: EdgeInsets.only(top: 35, bottom: 10),
                      elevation: 100,
                      //color: AppColor().wallet_dark_grey,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(00),
                              child: Image(
                                height: 115,
                                width: MediaQuery.of(
                                        navigatorKey.currentState.context)
                                    .size
                                    .width,
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    ImageRes().become_affiliate_banner),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 0),
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              height: 52,
                              child: TextField(
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.bottom,
                                onTap: () {},
                                style: TextStyle(color: AppColor().colorGray),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: AppColor().whiteColor,
                                      fontFamily: "Montserrat",
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: AppColor().whiteColor,
                                          width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: AppColor().whiteColor,
                                          width: 1.5),
                                    ),
                                    hintText: "Enter Number".tr),
                                onChanged: (text) {
                                  number = text;
                                },
                                autofocus: false,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Utils()
                                    .customPrint("First text field: $number");
                                if (number.length == 0) {
                                  Fluttertoast.showToast(
                                      msg: 'Please enter mobile no.!');
                                  return;
                                } else if (number.length < 10) {
                                  Fluttertoast.showToast(
                                      msg: 'Mobile no. must be of 10 digits!');
                                  return;
                                }
                                Map<String, Object> map =
                                    new Map<String, Object>();

                                map = {"USER_ID": userId};

                                CleverTapController cleverTapController =
                                    Get.put(CleverTapController());

                                cleverTapController.logEventCT(
                                    EventConstant.Become_User_Affiliate, map);
                                FirebaseEvent().firebaseEvent(
                                    EventConstant.Become_User_Affiliate_F, map);

                                Navigator.pop(
                                    navigatorKey.currentState.context);

                                Utils().thanksPopUp();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    // Where the linear gradient begins and ends
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    // Add one stop for each color. Stops should increase from 0 to 1
                                    //  stops: [0.1, 0.5, 0.7, 0.9],
                                    colors: [
                                      // Colors are easy thanks to Flutter's Colors class.

                                      AppColor().button_bg_light,
                                      AppColor().button_bg_dark,
                                    ],
                                  ),
                                  border: Border.all(
                                      color: AppColor().whiteColor, width: 2),
                                  borderRadius: BorderRadius.circular(30),

                                  boxShadow: [
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
                                  // color: AppColor().whiteColor
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Submit".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                          color: AppColor().blackColor),
                                    ),
                                  ],
                                ),
                              ),

                              /*Container(
                                height: 45,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppColor().pr,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat',
                                        color: AppColor().whiteColor),
                                  ),
                                ),
                              )*/
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        );
      },
    );
  }

  void showPreJoinBoxFree(
      String gameType,
      String gameZopWebViewUrl,
      String gameid,
      String url,
      ContestModel _contestModel,
      String event_id,
      PreJoinUnityResponseModel preJoinResponseModel,
      String freeVa,
      String gameNmae) {
    var areYouPaying =
        "${((preJoinResponseModel.deposit.value + preJoinResponseModel.winning.value) / 100) + preJoinResponseModel.bonus.value}";
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",

      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().new_rectangle_box_blank)),
            ),
            height: 405,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                      height: 370,
                      width: MediaQuery.of(navigatorKey.currentState.context)
                          .size
                          .width,
                      fit: BoxFit.fill,
                      image: AssetImage(ImageRes().new_rectangle_box_blank)),
                ),
                Card(
                  color: Colors.transparent,
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "            ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                height: 50,
                                child:
                                    Image.asset("assets/images/bonus_coin.png"),
                              ),
                              new IconButton(
                                  icon: new Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(
                                        navigatorKey.currentState.context);
                                  })
                            ],
                          ),
                          Text(
                            "CONFIRM".tr,
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Roboto",
                                color: AppColor().colorPrimary),
                          ),
                          Text(
                            "CHARGES".tr,
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text("ENTRY FEE".tr,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: AppColor().whiteColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: "Roboto")),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Wrap(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 20,
                                      child: Image.asset(
                                          "assets/images/bonus_coin.png"),
                                    ),
                                    Text(freeVa,
                                        style: TextStyle(
                                            color: AppColor().whiteColor))
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text("You are paying".tr,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color:
                                              AppColor().color_side_menu_header,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: "Roboto")),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Wrap(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 20,
                                      child: Image.asset(
                                          "assets/images/bonus_coin.png"),
                                    ),
                                    Text(
                                      areYouPaying,
                                      style: TextStyle(
                                          color: AppColor()
                                              .color_side_menu_header),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 1,
                            color: Colors.white,
                            width:
                                MediaQuery.of(navigatorKey.currentState.context)
                                    .size
                                    .width,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text("From Bonus Cash".tr,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: AppColor().whiteColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: "Roboto")),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Wrap(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 20,
                                      child: Image.asset(
                                          "assets/images/bonus_coin.png"),
                                    ),
                                    Text(
                                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${preJoinResponseModel.bonus.value}",
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: AppColor().whiteColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            fontFamily: "Roboto"))
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text(
                                      "From Deposited Cash & Winning Cash".tr,
                                      maxLines: 2,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: AppColor().whiteColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: "Roboto")),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Wrap(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 20,
                                      child: Image.asset(
                                          "assets/images/winning_coin.webp"),
                                    ),
                                    Text(
                                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(preJoinResponseModel.deposit.value / 100 + preJoinResponseModel.winning.value / 100)}",
                                        style: TextStyle(
                                            color: AppColor().whiteColor))
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Utils().customPrint(
                                      "LOCATION 10: ---------SUCCESS");

                                  Map<String, Object> map =
                                      new Map<String, Object>();
                                  UserController _userController =
                                      Get.put(UserController());
                                  map["USER_ID"] = _userController.user_id;
                                  map["Game Name"] = _contestModel.name;
                                  map["Buyin Amount"] =
                                      _contestModel.entry.fee.value > 0
                                          ? _contestModel.entry.fee.value ~/ 100
                                          : "Free";
                                  //map["Bonus Application"] = "";
                                  map["Prize Pool"] = "";
                                  map["Game Category"] = _contestModel.name;
                                  map["BONUS_CASH"] =
                                      preJoinResponseModel.bonus.value ~/ 100;
                                  map["WINNING_CASH"] =
                                      preJoinResponseModel.winning.value ~/ 100;
                                  map["DEPOSITE_CASH"] =
                                      preJoinResponseModel.deposit.value ~/ 100;
                                  map["Game Id"] = _contestModel.id;
                                  map["is_championship"] = _contestModel.type
                                              .compareTo("championship") ==
                                          0
                                      ? "yes"
                                      : "No";
                                  AppsflyerController appsflyerController =
                                      Get.put(AppsflyerController());
                                  CleverTapController cleverTapController =
                                      Get.put(CleverTapController());
                                  cleverTapController.logEventCT(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Joined_Contest,
                                      map);
                                  FirebaseEvent().firebaseEvent(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Joined_Contest_F,
                                      map);

                                  cleverTapController.logEventCT(
                                      EventConstant.EVENT_Joined_Contest, map);
                                  FirebaseEvent().firebaseEvent(
                                      EventConstant.EVENT_Joined_Contest_F,
                                      map);
                                  map["Game_id"] = gameid;
                                  appsflyerController.logEventAf(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Joined_Contest,
                                      map);

                                  appsflyerController.logEventAf(
                                      EventConstant.EVENT_Joined_Contest,
                                      map); //for appsflyer only
                                  FaceBookEventController().logEventFacebook(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Joined_Contest,
                                      map);
                                  //FIREBASE EVENT

                                  Navigator.pop(
                                      navigatorKey.currentState.context);

                                  if (gameType.compareTo("freakx") == 0) {
                                    Navigator.push(
                                      navigatorKey.currentState.context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FreakxWebview(
                                                gameZopWebViewUrl,
                                                gameid,
                                                event_id,
                                                "${_contestModel.entry.fee.value > 0 ? _contestModel.entry.fee.value ~/ 100 : "Free"}",
                                                url,
                                                gameNmae),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      navigatorKey.currentState.context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            GameJobWebview(
                                                gameZopWebViewUrl,
                                                gameid,
                                                event_id,
                                                "${_contestModel.entry.fee.value > 0 ? _contestModel.entry.fee.value ~/ 100 : "Free"}",
                                                url),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  //    margin: EdgeInsets.symmetric(horizontal: 2),
                                  height: 48,
                                  width: MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .size
                                          .width *
                                      .34,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      // Where the linear gradient begins and ends
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      // Add one stop for each color. Stops should increase from 0 to 1
                                      //  stops: [0.1, 0.5, 0.7, 0.9],
                                      colors: [
                                        // Colors are easy thanks to Flutter's Colors class.

                                        AppColor().button_bg_light,
                                        AppColor().button_bg_dark,
                                      ],
                                    ),
                                    border: Border.all(
                                        color: AppColor().whiteColor, width: 2),
                                    borderRadius: BorderRadius.circular(30),

                                    boxShadow: [
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
                                    // color: AppColor().whiteColor
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Join Free \n Game".tr,
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                            color: AppColor().whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    WalletPageController walletPageController =
                                        Get.put(WalletPageController());
                                    walletPageController
                                        .alertLookBox("freegame");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 0),
                                    height: 49,
                                    //  width: MediaQuery.of(navigatorKey.currentState.context).size.width*.20,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          AppColor().special_bg_c,
                                          AppColor().special_bg_c2,
                                        ],
                                      ),
                                      border: Border.all(
                                          color: AppColor().whiteColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(30),

                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(
                                            0.0,
                                            5.0,
                                          ),
                                          blurRadius: 1.0,
                                          spreadRadius: .3,
                                          color: Color(0xFF573838),
                                          inset: true,
                                        ),
                                        BoxShadow(
                                          offset: Offset(00, 00),
                                          blurRadius: 00,
                                          color: Color(0xFFffffff),
                                          inset: true,
                                        ),
                                      ],
                                      // color: AppColor().whiteColor
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(navigatorKey
                                                          .currentState.context)
                                                      .size
                                                      .width -
                                                  350),
                                          child: Text(
                                            "Win Free \n Cash".tr,
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Utils().customPrint("LOCATION 10: ---------SUCCESS");

                    Map<String, Object> map = new Map<String, Object>();
                    UserController _userController = Get.put(UserController());
                    map["USER_ID"] = _userController.user_id;
                    map["Game Name"] = _contestModel.name;
                    map["Buyin Amount"] = _contestModel.entry.fee.value > 0
                        ? _contestModel.entry.fee.value ~/ 100
                        : "Free";
                    //map["Bonus Application"] = "";
                    map["Prize Pool"] = "";
                    map["Game Category"] = _contestModel.name;
                    map["BONUS_CASH"] = preJoinResponseModel.bonus.value ~/ 100;
                    map["WINNING_CASH"] =
                        preJoinResponseModel.winning.value ~/ 100;
                    map["DEPOSITE_CASH"] =
                        preJoinResponseModel.deposit.value ~/ 100;
                    map["Game Id"] = _contestModel.id;

                    map["is_championship"] =
                        _contestModel.type.compareTo("championship") == 0
                            ? "yes"
                            : "No";
                    AppsflyerController appsflyerController =
                        Get.put(AppsflyerController());
                    CleverTapController cleverTapController =
                        Get.put(CleverTapController());

                    cleverTapController.logEventCT(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
                    cleverTapController.logEventCT(
                        EventConstant.EVENT_Joined_Contest, map);
                    FirebaseEvent().firebaseEvent(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest_F, map);
                    FirebaseEvent().firebaseEvent(
                        EventConstant.EVENT_Joined_Contest_F, map);
                    map["Game_id"] = gameid;
                    appsflyerController.logEventAf(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
                    appsflyerController.logEventAf(
                        EventConstant.EVENT_Joined_Contest,
                        map); //for appsflyer only
                    FaceBookEventController().logEventFacebook(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
                    //FIREBASE EVENT

                    Navigator.pop(navigatorKey.currentState.context);

                    if (gameType.compareTo("freakx") == 0) {
                      Navigator.push(
                        navigatorKey.currentState.context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => FreakxWebview(
                              gameZopWebViewUrl,
                              gameid,
                              event_id,
                              "${_contestModel.entry.fee.value > 0 ? _contestModel.entry.fee.value ~/ 100 : "Free"}",
                              url,
                              gameNmae),
                        ),
                      );
                    } else {
                      Navigator.push(
                        navigatorKey.currentState.context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => GameJobWebview(
                              gameZopWebViewUrl,
                              gameid,
                              event_id,
                              "${_contestModel.entry.fee.value > 0 ? _contestModel.entry.fee.value ~/ 100 : "Free"}",
                              url),
                        ),
                      );
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 405,
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(navigatorKey.currentState.context)
                                .size
                                .width -
                            234,
                        bottom: 39),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            /* WalletPageController walletPageController =
                                Get.put(WalletPageController());
                            walletPageController.alertLookBox();*/
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 0),
                            height: 130,
                            width: 110,
                            child: Lottie.asset(
                              'assets/lottie_files/redeem.json',
                              repeat: true,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
          ),
        );
      },
    );
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  openwhatsappOTPV() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var whatsapp = prefs.getString("whatsappMobile");
    //var whatsapp = publicSettingModel.value.support.whatsappMobile;
    print("call wha number ${whatsapp}");
    var whatsappURl_android = "whatsapp://send?phone=" + "91$whatsapp";
    var whatappURL_ios = "https://wa.me/91$whatsapp";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        Fluttertoast.showToast(msg: "whatsapp no installed");
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        Fluttertoast.showToast(msg: "whatsapp no installed");
      }
    }
  }

  dialNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var whatsapp = prefs.getString("whatsappMobile");
    //var whatsapp = publicSettingModel.value.support.whatsappMobile;
    print("call wha number ${whatsapp}");
    var whatsappURl_android = "tel:" + "91$whatsapp";
    var whatappURL_ios = "tel:91$whatsapp";
    if (Platform.isIOS) {
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        Fluttertoast.showToast(msg: "Some error occurred!");
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        Fluttertoast.showToast(msg: "Some error occurred!");
      }
    }
  }

  msgNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var whatsapp = prefs.getString("whatsappMobile");
    //var whatsapp = publicSettingModel.value.support.whatsappMobile;
    print("call wha number ${whatsapp}");
    var whatsappURl_android = "sms:+91$whatsapp";
    var whatappURL_ios = "sms:+91$whatsapp";
    if (Platform.isIOS) {
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        Fluttertoast.showToast(msg: "Some error occurred!");
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        Fluttertoast.showToast(msg: "Some error occurred!");
      }
    }
  }

  whatsappNumber() async {
    var whatsappURl_android = "whatsapp://send?phone=" +
        "918448369538"; //fix for now will change acc. to needs.
    var whatappURL_ios = "https://wa.me/918448369538";
    if (Platform.isIOS) {
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        Fluttertoast.showToast(msg: "whatsApp no installed");
      }
    } else {
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        Fluttertoast.showToast(msg: "whatsApp no installed");
      }
    }
  }
}
