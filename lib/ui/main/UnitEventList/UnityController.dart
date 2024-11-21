import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/BannerModel/BannerResC.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app.dart';
import '../../../model/ESportsEventList.dart';
import '../../../model/responsemodel/PreJoinUnityResponseModel.dart';
import '../../../model/unity_history/OnlyUnityHistoryModel.dart';
import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import '../../../res/firebase_events.dart';
import '../../../utills/bridge.dart';
import '../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../utills/event_tracker/EventConstant.dart';
import '../../../utills/event_tracker/FaceBookEventController.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/WalletPageController.dart';
import '../../controller/user_controller.dart';

class UnityController extends GetxController {
  var game_id;

  UnityController(this.game_id);

  var unityEventList = ESportEventListModel().obs;
  SharedPreferences prefs;
  String user_id;
  var onlyUnityHistoryModel = OnlyUnityHistoryModel().obs;
  String token;
  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;
  var checkTr = true.obs;

  // pagination add
  var scrollcontroller = ScrollController();
  var currentpage = 0.obs;
  var total_limit = 10;
  var totalAmountValues = 0.obs;
  RxList unity_history_userRegistrations = new List<HistoryData>().obs;
  var bannerModelRV = BannerModelR().obs;

  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getESportsEventList();

    // pagination add

    scrollcontroller.addListener(() {
      if (scrollcontroller.position.atEdge &&
          scrollcontroller.position.pixels != 0) {
        if (totalAmountValues > currentpage.value) {
          currentpage.value = currentpage.value + 10;
          getUnityHistoryOnly(game_id);
        }

        Utils().customPrint("data pagination");
        /* if (maxPaginationCount.value > paginationPage.value) {
            pageLoading.value = true;
            getProductList();
          } else {
            noMoreItems.value = true;
          }*/
      }
    });

    //call banner api
    getBanner(game_id);
  }

  Future<void> getESportsEventList() async {
    unityEventList.value = null;
    Map<String, dynamic> response = await WebServicesHelper()
        .getUnitEventList(token, game_id, "", "", user_id, "active");
    if (response != null) {
      unityEventList.value =
          ESportEventListModel.fromJson(response, "", false, true);
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

/*  Future<void> getUnityHistory(String game_id) async {
    onlyUnityHistoryModel.value = null;


    Map<String, dynamic> response =
        await WebServicesHelper().getUnityHistory(token, user_id, game_id,total_limit,currentpage.value);
    if (response != null) {
      onlyUnityHistoryModel.value = OnlyUnityHistoryModel.fromJson(response);


      unity_history_userRegistrations.addAll(onlyUnityHistoryModel.value.data);
      totalAmountValues.value = onlyUnityHistoryModel.value.pagination.total;

    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }*/
  Future<void> getUnityHistoryOnly(String game_id) async {
    onlyUnityHistoryModel.value = null;

    Map<String, dynamic> response = await WebServicesHelper().getUnityHistory(
        token, user_id, game_id, total_limit, currentpage.value);
    if (response != null) {
      onlyUnityHistoryModel.value = OnlyUnityHistoryModel.fromJson(response);

      unity_history_userRegistrations.addAll(onlyUnityHistoryModel.value.data);
      totalAmountValues.value = onlyUnityHistoryModel.value.pagination.total;
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> OpenUnityGame(
      ContestModel model,
      String gameid,
      String game_name,
      bool is_test,
      String mobile,
      String name,
      String profile,
      String user_id,
      String email) async {
    String winning_type = "";
    String winning_type_amount = "";
    // List<num> winning_type_amount = [];
    if (model.rankAmount != null) {
      for (int i = 0; i < model.rankAmount.length; i++) {
        if (model.rankAmount[i].amount != null) {
          if (model.rankAmount[i].amount.type == "currency") {
            if (!winning_type.isEmpty) {
              winning_type = winning_type + ",WinningWallet";
            } else {
              winning_type = "WinningWallet";
            }

            //     winning_type.add("WinningWallet");
            int amount = model.rankAmount[i].amount.value ~/ 100;
            if (!winning_type_amount.isEmpty) {
              winning_type_amount =
                  winning_type_amount + "," + amount.toString();
            } else {
              winning_type_amount = amount.toString();
            }
            //winning_type_amount.add(amount);
          } else {
            if (!winning_type.isEmpty) {
              winning_type = winning_type + ",BonusWallet";
            } else {
              winning_type = "BonusWallet";
            }
            // winning_type.add("BonusWallet");
            //  winning_type_amount.add(model.rankAmount[i].amount.value);
            if (!winning_type_amount.isEmpty) {
              winning_type_amount = winning_type_amount +
                  "," +
                  model.rankAmount[i].amount.value.toString();
            } else {
              winning_type_amount = model.rankAmount[i].amount.value.toString();
            }
          }
        }
      }
    }

    final Map<String, String> data = {
      "event_id": model.id,
      "game_id": gameid,
      "game_name": game_name,
      "is_test": is_test.toString(),
      "mobile": mobile,
      "name": name,
      "profile": profile,
      "user_id": user_id,
      "email": email,
      "winning_type": winning_type.toString(),
      "winning_type_amount": winning_type_amount.toString(),
    };

    // Navigator.pop(navigatorKey.currentState.context);
    String reposnenative = await NativeBridge.OpenUnityGames(data);
  }

  Future<void> getBanner(String game_id) async {
    Utils().customPrint('Unity Banner: $game_id');
    if (token != null && token != '') {
      Map<String, dynamic> response_str =
          await WebServicesHelper().getBannerViaGameId(token, game_id);
      if (response_str != null) {
        bannerModelRV.value = BannerModelR.fromJson(response_str);
        Utils().customPrint('Unity Banner: ${bannerModelRV.value.data.length}');
      }
    }
  }

  void showPreJoinBoxFree(
      String name,
      String gameid,
      ContestModel _contestModel,
      PreJoinUnityResponseModel preJoinResponseModel,
      String freeVa) {
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
                  child: Column(
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
                            child: Image.asset("assets/images/bonus_coin.png"),
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
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  height: 20,
                                  child: Image.asset(
                                      "assets/images/bonus_coin.png"),
                                ),
                                Text(freeVa,
                                    style:
                                        TextStyle(color: AppColor().whiteColor))
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
                                      color: AppColor().color_side_menu_header,
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
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  height: 20,
                                  child: Image.asset(
                                      "assets/images/bonus_coin.png"),
                                ),
                                Text(
                                  areYouPaying,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      color: AppColor().color_side_menu_header),
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
                        width: MediaQuery.of(navigatorKey.currentState.context)
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
                                  padding: EdgeInsets.symmetric(horizontal: 5),
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
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  height: 20,
                                  child: Image.asset(
                                      "assets/images/winning_coin.webp"),
                                ),
                                Text(
                                    "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(preJoinResponseModel.deposit.value / 100 + preJoinResponseModel.winning.value / 100)}",
                                    style:
                                        TextStyle(color: AppColor().whiteColor))
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
                              Utils()
                                  .customPrint("LOCATION 10: ---------SUCCESS");

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

                              cleverTapController.logEventCT(
                                  EventConstant.EVENT_CLEAVERTAB_Joined_Contest,
                                  map);
                              cleverTapController.logEventCT(
                                  EventConstant.EVENT_Joined_Contest, map);

                              FirebaseEvent().firebaseEvent(
                                  EventConstant
                                      .EVENT_CLEAVERTAB_Joined_Contest_F,
                                  map);
                              FirebaseEvent().firebaseEvent(
                                  EventConstant.EVENT_Joined_Contest_F, map);
                              map["Game_id"] = gameid;
                              appsflyerController.logEventAf(
                                  EventConstant.EVENT_CLEAVERTAB_Joined_Contest,
                                  map);

                              appsflyerController.logEventAf(
                                  EventConstant.EVENT_Joined_Contest,
                                  map); //for appsflyer only
                              FaceBookEventController().logEventFacebook(
                                  EventConstant.EVENT_CLEAVERTAB_Joined_Contest,
                                  map);
                              //FIREBASE EVENT

                              Navigator.pop(navigatorKey.currentState.context);

                              prefs = await SharedPreferences.getInstance();
                              prefs.setBool("unityGameCall", true);

                              OpenUnityGame(
                                _contestModel,
                                gameid,
                                name,
                                false,
                                _userController
                                    .profileDataRes.value.mobile.number
                                    .toString(),
                                _userController.profileDataRes.value.username,
                                _userController.profileDataRes.value.photo !=
                                        null
                                    ? _userController
                                        .profileDataRes.value.photo.url
                                    : "",
                                _userController.profileDataRes.value.id,
                                _userController.profileDataRes.value.email !=
                                        null
                                    ? _userController
                                        .profileDataRes.value.email.address
                                    : "",
                              );
                              Navigator.pop(navigatorKey.currentState.context);
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
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
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
                                walletPageController.alertLookBox("freegame");
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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

                    cleverTapController.logEventCT(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
                    cleverTapController.logEventCT(
                        EventConstant.EVENT_Joined_Contest, map);
                    map["Game_id"] = gameid;
                    appsflyerController.logEventAf(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);

                    appsflyerController.logEventAf(
                        EventConstant.EVENT_Joined_Contest,
                        map); //for appsflyer only
                    FaceBookEventController().logEventFacebook(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
                    //FIREBASE EVENT
                    FirebaseEvent()
                        .firebaseEvent(EventConstant.EVENT_Joined_Contest, map);

                    Navigator.pop(navigatorKey.currentState.context);
                    prefs = await SharedPreferences.getInstance();
                    prefs.setBool("unityGameCall", true);
                    OpenUnityGame(
                      _contestModel,
                      gameid,
                      name,
                      false,
                      _userController.profileDataRes.value.mobile.number
                          .toString(),
                      _userController.profileDataRes.value.username,
                      _userController.profileDataRes.value.photo != null
                          ? _userController.profileDataRes.value.photo.url
                          : "",
                      _userController.profileDataRes.value.id,
                      _userController.profileDataRes.value.email != null
                          ? _userController.profileDataRes.value.email.address
                          : "",
                    );
                    Navigator.pop(navigatorKey.currentState.context);
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
}
