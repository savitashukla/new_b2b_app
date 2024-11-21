import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../model/HomeModel/HomePageListModel.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/AppString.dart';
import '../../../../utills/OnlyOff.dart';
import '../../../../utills/Utils.dart';
import '../../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../../utills/event_tracker/CleverTapController.dart';
import '../../../../utills/event_tracker/EventConstant.dart';
import '../../../controller/HomePageController.dart';
import '../../../controller/user_controller.dart';
import '../DashBord.dart';

class FavouriteGame extends StatelessWidget {
  FavouriteGame({Key key}) : super(key: key);
  HomePageController controller = Get.put(HomePageController());
  var gameListSelectedColor = 0.obs;
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')}, //hindi
    {'name': 'ગુજરાતી', 'locale': Locale('gu', 'IN')}, //Gujarati
    {'name': 'ಕನ್ನಡ', 'locale': Locale('kn', 'IN')}, //Kannada
    {'name': 'મરાઠી', 'locale': Locale('mr', 'IN')}, //Marathi
  ];
  var langSelect = "".obs;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () async {
      controller.getHomePage();
    });
    double cardWidth = MediaQuery.of(context).size.width / 3.3;
    double cardHeight = MediaQuery.of(context).size.height / 7.4;
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (controller.homePageListModel.value != null &&
          controller.homePageListModel.value.gamesMyFav != null &&
          controller.homePageListModel.value.gamesMyFav.length > 0) {
      } else {
        print("get data again call");

        //   controller.getHomePage();
      }
    });
    if (onlyOffi.gamesMyFavSelected.value != null &&
        onlyOffi.gamesMyFavSelected.length > 0) {
      gameListSelectedColor.value = 100;
    }
    Future<bool> _onWillPop() async {
      // Fluttertoast.showToast(msg: "Please press continue & enjoy the game!");
      //SystemNavigator.pop();
      return true;
    }

    //print("call media values $cardWidth   fa $cardHeight");
    //get language prefs
    getSharedPrefs();

    return RefreshIndicator(
      onRefresh: () async {
        return Future.delayed(const Duration(seconds: 1), () async {});
      },
      child: Stack(
        children: [
          Container(
            height:
                MediaQuery.of(navigatorKey.currentState.context).size.height,
            width: MediaQuery.of(navigatorKey.currentState.context).size.width,
            child: Image(
              image: AssetImage('assets/images/favi_game_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            fontSize: 22,
                            color: Colors.white)),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text("Select Your Favourite Game".tr,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                    color: Colors.white)),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 15, right: 15, bottom: 30, top: 20),
                            //   height: MediaQuery.of(context).size.height - 300,
                            child: Obx(
                              () => controller.homePageListModel.value !=
                                          null &&
                                      controller.homePageListModel.value
                                              .gamesMyFav !=
                                          null &&
                                      controller.homePageListModel.value
                                              .gamesMyFav.length >
                                          0
                                  ? GridView.count(
                                      crossAxisCount: 2,
                                      controller: new ScrollController(
                                          keepScrollOffset: false),
                                      shrinkWrap: true,
                                      crossAxisSpacing: 25.0,
                                      mainAxisSpacing: 50,
                                      childAspectRatio:
                                          (cardWidth / cardHeight),
                                      children: List.generate(
                                          controller.homePageListModel.value
                                              .gamesMyFav.length, (index) {
                                        return Obx(
                                            () => listGameShowPopUp(index));
                                      }))
                                  : Shimmer.fromColors(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        height: 400,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      baseColor: Colors.grey.withOpacity(0.2),
                                      highlightColor:
                                          Colors.grey.withOpacity(0.4),
                                      enabled: true,
                                    ),
                            ),
                          ),
                          //choose lang work OLD
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 0),
                            child: Text("Choose Language".tr,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Montserrat",
                                    fontSize: 15,
                                    color: Colors.white)),
                          ),
                          Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      langSelect.value = "en";
                                      Utils.language.value = "en";
                                      Utils.language_country.value = "US";

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("language", "en");
                                      prefs.setString("language_country", "US");
                                      Utils().getLocation();
                                      //updateLanguage(locale[0]['locale']);
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: langSelect.value == "en"
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().green_color,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().whiteColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 70,
                                            //   width: 17,
                                            child: SvgPicture.asset(
                                              "assets/images/english_letter.svg",
                                              height: 50,
                                              color: AppColor().whiteColor, //
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "English",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      langSelect.value = "hi";
                                      Utils.language.value = "hi";
                                      Utils.language_country.value = "IN";

                                      Utils().getLocation();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("language", "hi");
                                      prefs.setString("language_country", "IN");
                                      Utils.language.value =
                                          prefs.getString("language");
                                      //updateLanguage(locale[1]['locale']);
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: langSelect.value == "hi"
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().green_color,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().whiteColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 70,
                                            //   width: 17,
                                            child: SvgPicture.asset(
                                              "assets/images/hindi_letter.svg",
                                              height: 50,
                                              color: AppColor().whiteColor, //
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            //"Hindi".tr,
                                            "हिंदी",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          //choose lang work NEW
                          /*Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 0),
                            child: Text("Choose Language".tr,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Montserrat",
                                    fontSize: 15,
                                    color: Colors.white)),
                          ),
                          Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      langSelect.value = "en";
                                      Utils.language.value = "en";
                                      Utils.language_country.value = "US";

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("language", "en");
                                      prefs.setString("language_country", "US");
                                      Utils().getLocation();
                                      //updateLanguage(locale[0]['locale']);
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: langSelect.value == "en"
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().green_color,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().whiteColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            //height: 70,
                                            //   width: 17,
                                            child: SvgPicture.asset(
                                              "assets/images/english_letter.svg",
                                              height: 40,
                                              color: AppColor().whiteColor, //
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "English",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      langSelect.value = "hi";
                                      Utils.language.value = "hi";
                                      Utils.language_country.value = "IN";

                                      Utils().getLocation();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("language", "hi");
                                      prefs.setString("language_country", "IN");
                                      Utils.language.value =
                                          prefs.getString("language");
                                      //updateLanguage(locale[1]['locale']);
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: langSelect.value == "hi"
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().green_color,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().whiteColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            //height: 70,
                                            //   width: 17,
                                            child: SvgPicture.asset(
                                              "assets/images/hindi_letter.svg",
                                              height: 40,
                                              color: AppColor().whiteColor, //
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            //"Hindi".tr,
                                            "हिंदी",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      langSelect.value = "gu";
                                      Utils.language.value = "gu";
                                      Utils.language_country.value = "IN";

                                      Utils().getLocation();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("language", "gu");
                                      prefs.setString("language_country", "IN");
                                      Utils.language.value =
                                          prefs.getString("language");
                                      //updateLanguage(locale[1]['locale']);
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: langSelect.value == "gu"
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().green_color,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().whiteColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            //height: 70,
                                            //   width: 17,
                                            child: SvgPicture.asset(
                                              "assets/images/hindi_letter.svg",
                                              height: 40,
                                              color: AppColor().whiteColor, //
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            //"Hindi".tr,
                                            "ગુજરાતી",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      langSelect.value = "kn";
                                      Utils.language.value = "kn";
                                      Utils.language_country.value = "US";

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("language", "kn");
                                      prefs.setString("language_country", "US");
                                      Utils().getLocation();
                                      //updateLanguage(locale[0]['locale']);
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: langSelect.value == "kn"
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().green_color,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().whiteColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            //height: 60,
                                            //   width: 17,
                                            child: SvgPicture.asset(
                                              "assets/images/hindi_letter.svg",
                                              height: 40,
                                              color: AppColor().whiteColor, //
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "ಕನ್ನಡ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      langSelect.value = "mr";
                                      Utils.language.value = "mr";
                                      Utils.language_country.value = "IN";

                                      Utils().getLocation();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("language", "mr");
                                      prefs.setString("language_country", "IN");
                                      Utils.language.value =
                                          prefs.getString("language");
                                      //updateLanguage(locale[1]['locale']);
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: langSelect.value == "mr"
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().green_color,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor().whiteColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            //height: 60,
                                            //   width: 17,
                                            child: SvgPicture.asset(
                                              "assets/images/hindi_letter.svg",
                                              height: 40,
                                              color: AppColor().whiteColor, //
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            //"Hindi".tr,
                                            "મરાઠી",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),*/
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            if (controller.homePageListModel.value != null) {
                              controller.sendFavoriteGame(
                                  context, controller.selectedGameId.value);
                              controller.sendFavoriteGame(
                                  context, controller.selectedGameId.value);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              if (onlyOffi.gamesMyFavSelected.value != null &&
                                  onlyOffi.gamesMyFavSelected.value.length >
                                      0 &&
                                  onlyOffi.gamesMyFavSelected.value[0] !=
                                      null) {
                                Games list =
                                    onlyOffi.gamesMyFavSelected.value[0];
                                String rawJson = jsonEncode(list);
                                prefs.setString("gamesMyFavStore", rawJson);
                                var getValues =
                                    prefs.getString("gamesMyFavStore");

                                var mapData = await jsonDecode(getValues);
                                //   Games listasdfg=mapData;
                                print("call selected game call ${mapData}");
                                Games aaa = await Games.fromJson(mapData);
                                if (aaa != null) {
                                  onlyOffi.gamesMyFavSelected.value = [];

                                  onlyOffi.gamesMyFavSelected.value.add(aaa);

                                  Map<String, dynamic> map =
                                      new Map<String, dynamic>();
                                  map["game_id"] =
                                      onlyOffi.gamesMyFavSelected[0].id;
                                  map["user_id"] = prefs.getString("user_id");
                                  map["gameName"] =
                                      onlyOffi.gamesMyFavSelected[0].name;
                                  CleverTapController cleverTapController =
                                      Get.put(CleverTapController());
                                  cleverTapController.logEventCT(
                                      EventConstant.game_favorite_game, map);
                                  FirebaseEvent().firebaseEvent(
                                      EventConstant.game_favorite_game_F, map);
                                  AppsflyerController appsflyerController =
                                      Get.put(AppsflyerController());
                                  appsflyerController.logEventAf(
                                      EventConstant.game_favorite_game, map);

                                  UserController userController =
                                      Get.put(UserController());

                                  userController.currentIndex.value = 2;
                                  Get.offAll(() => DashBord(2, ""));
                                }
                              } else {
                                Games game = controller
                                    .homePageListModel.value.gamesMyFav[0];
                                onlyOffi.gamesMyFavSelected.value = [];
                                onlyOffi.gamesMyFavSelected.add(game);

                                Games list =
                                    onlyOffi.gamesMyFavSelected.value[0];
                                String rawJson = jsonEncode(list);
                                prefs.setString("gamesMyFavStore", rawJson);

                                Map<String, dynamic> map =
                                    new Map<String, dynamic>();
                                map["game_id"] =
                                    onlyOffi.gamesMyFavSelected[0].id;
                                map["user_id"] = prefs.getString("user_id");
                                map["gameName"] =
                                    onlyOffi.gamesMyFavSelected[0].name;
                                CleverTapController cleverTapController =
                                    Get.put(CleverTapController());
                                cleverTapController.logEventCT(
                                    EventConstant.game_favorite_game, map);
                                FirebaseEvent().firebaseEvent(
                                    EventConstant.game_favorite_game_F, map);
                                AppsflyerController appsflyerController =
                                    Get.put(AppsflyerController());
                                appsflyerController.logEventAf(
                                    EventConstant.game_favorite_game, map);

                                UserController userController =
                                    Get.put(UserController());
                                userController.currentIndex.value = 2;
                                Get.offAll(() => DashBord(2, ""));
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Loading…Please wait for favorite game!");
                            }
                            //lang work
                            if (langSelect.value != null) {
                              if (langSelect.value == "en") {
                                updateLanguage(locale[0]['locale']);
                              } else if (langSelect.value == "hi") {
                                updateLanguage(locale[1]['locale']);
                              } else if (langSelect.value == "gu") {
                                updateLanguage(locale[2]['locale']);
                              } else if (langSelect.value == "kn") {
                                updateLanguage(locale[3]['locale']);
                              } else if (langSelect.value == "mr") {
                                updateLanguage(locale[4]['locale']);
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 200,
                            height: 48,
                            margin:
                                EdgeInsets.only(right: 10, top: 25, bottom: 0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                // Where the linear gradient begins and ends
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                // Add one stop for each color. Stops should increase from 0 to 1
                                //  stops: [0.1, 0.5, 0.7, 0.9],
                                colors: [
                                  AppColor().button_bg_light,
                                  AppColor().button_bg_dark,
                                ],
                              ),
                              border: Border.all(
                                  color: AppColor().whiteColor, width: 2),
                              borderRadius: BorderRadius.circular(30),

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
                              // color: AppColor().whiteColor
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "CONTINUE".tr,
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
                        ),
                        SizedBox(height: 15),
                        Text("Don't worry you can change this later".tr,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                fontSize: 10,
                                color: Colors.white)),
                        SizedBox(height: 20)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listGameShowPopUp(int index) {
    return GestureDetector(
      onTap: () {
        controller.selectedGameId.value =
            controller.homePageListModel.value.gamesMyFav[index].id;

        AppString.isSelectMyGameCount++;
        AppString.gameName =
            controller.homePageListModel.value.gamesMyFav[index].name;
        controller.homePageListModel.value.gamesMyFav[index].isSelect = true;
        gameListSelectedColor.value = index;

        Games game = controller.homePageListModel.value.gamesMyFav[index];
        onlyOffi.gamesMyFavSelected.value = [];
        onlyOffi.gamesMyFavSelected.add(game);

        Utils().customPrint(
            'gamesMyFavSelected : ${onlyOffi.gamesMyFavSelected.length}');

        print(
            "check condition values ${onlyOffi.gamesMyFavSelected.value != null && onlyOffi.gamesMyFavSelected.length > 0 && onlyOffi.gamesMyFavSelected[0].name == controller.homePageListModel.value.gamesMyFav[index].name} ");
      },
      child: Container(
        height: MediaQuery.of(navigatorKey.currentState.context).size.height,
        width: MediaQuery.of(navigatorKey.currentState.context).size.width,
        decoration: onlyOffi.gamesMyFavSelected.value != null &&
                onlyOffi.gamesMyFavSelected.length > 0 &&
                onlyOffi.gamesMyFavSelected[0].name ==
                    controller.homePageListModel.value.gamesMyFav[index].name
            ? BoxDecoration(
                border: Border.all(color: AppColor().green_color, width: 4),
                borderRadius: BorderRadius.circular(15),
              )
            : gameListSelectedColor.value == index
                ? BoxDecoration(
                    border: Border.all(color: AppColor().green_color, width: 4),
                    borderRadius: BorderRadius.circular(15),
                  )
                : BoxDecoration(
                    border:
                        Border.all(color: AppColor().whiteColor, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(navigatorKey.currentState.context)
                    .size
                    .height,
                width:
                    MediaQuery.of(navigatorKey.currentState.context).size.width,
                padding:
                    const EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
                child: Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: CachedNetworkImage(
                        height: MediaQuery.of(navigatorKey.currentState.context)
                            .size
                            .height,
                        width: MediaQuery.of(navigatorKey.currentState.context)
                            .size
                            .width,
                        fit: BoxFit.fill,
                        imageUrl: controller.homePageListModel.value
                            .gamesMyFav[index].banner.url,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
                )),
            /* Container(
              height: 5,
            ),*/
            /*  Container(
              height: MediaQuery.of(navigatorKey.currentState.context).size.height,
              width: MediaQuery.of(navigatorKey.currentState.context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0,bottom:5),
                    child: Text(
                      controller.homePageListModel.value.gamesMyFav[index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //  decoration: TextDecoration.underline,
                        fontSize: FontSizeC().front_very_small,
                        color: AppColor().whiteColor,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    langSelect.value = prefs.getString("language");
    if (langSelect.value == null) {
      langSelect.value = "en";
    }
    Utils().customPrint("langSelect : $langSelect");
  }

  updateLanguage(Locale locale) {
    //Get.back();
    Get.updateLocale(locale);
  }
}
