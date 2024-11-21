import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/ESportsEventList.dart';
import 'package:gmng/model/ProfileModel/TeamGetModelR.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/controller/BaseController.dart';
import 'package:gmng/ui/controller/GameTypeController.dart';
import 'package:gmng/ui/controller/TeamTypeController.dart';
import 'package:gmng/ui/main/esports/JoinedBattlesDetails.dart';
import 'package:gmng/ui/main/team_management/TeamManagementNew.dart';
import 'package:gmng/utills/event_tracker/FaceBookEventController.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../model/responsemodel/PreJoinResponseModel.dart';
import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import '../../../utills/Utils.dart';
import '../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../utills/event_tracker/EventConstant.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/ESportsController.dart';
import '../ludo_king/how_to_play_esport.dart';
import 'Affiliated_Contest.dart';
import 'JoinedBattlesDetails.dart';

class ESports extends StatelessWidget {
  String gameid;
  String event_id = "";
  String url;
  String howToPlay = "";

  ESports(this.gameid, this.url, this.howToPlay, this.event_id);

  ESportsController controller;
  BaseController base_controller = Get.put(BaseController());
  TeamTypeController teamType_controller = Get.put(TeamTypeController());
  GameTypeController gameType_controller = Get.put(GameTypeController());
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  String token = "", user_id = "";
  var contest_id = "";
  SharedPreferences prefs;

  SharedPreferences _preferences;
  BuildContext context;
  PreJoinResponseModel preJoinResponseModel = null;
  ContestModel _contestModel = null;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int contestAmountLocal = 0;

  @override
  Widget build(BuildContext context) {
    getUserDatils(context);

    Utils().customPrint("event_id=> ${event_id}");
    controller = Get.put(ESportsController(gameid, event_id));
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        // Replace this delay with the code to be executed during refresh
        // and return a Future when code finishs execution.
        // return Future<void>.delayed(const Duration(seconds: 3));
        return Future.delayed(const Duration(seconds: 1), () async {
          prefs = await SharedPreferences.getInstance();
          token = prefs.getString("token");
          user_id = prefs.getString("user_id");
          controller.getESportsEventList(gameid);
          controller.getINGameCheck(gameid);
          controller.getJoinedContestList(gameid);
          controller.getMap("");
          Utils().customPrint("event_id==>${event_id}");
        });
      },
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/home_back.png"))),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
                automaticallyImplyLeading: false,
                snap: false,
                pinned: true,
                floating: false,
                expandedHeight: 180.0,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  // height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 40, left: 10),
                        alignment: Alignment.topLeft,
                        child: Image.asset("assets/images/right_arrow.png")),
                  ),
                )),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 20,
                  ),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => how_to_play_esport(howToPlay));

                              //showCustomDialogHowToPlay(context);
                            },
                            child: Container(
                              height: 30,
                              margin: EdgeInsets.only(left: 10, right: 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColor().whiteColor, width: 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    child: Image.asset(
                                      "assets/images/ic_question.webp",
                                      color: AppColor().colorGray,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 0),
                                    // alignment: Alignment.center,
                                    child: Text(
                                      "How to Play".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              showInGameDialog(context, gameid);
                            },
                            child: Container(
                              height: 30,
                              margin: EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor().whiteColor, width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.transparent),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    child: Image.asset(
                                      "assets/images/ic_link.webp",
                                      color: AppColor().colorGray,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Obx(() => Text(
                                          (controller.inGameCheckModel !=
                                                      null &&
                                                  controller.inGameCheckModel
                                                          .value !=
                                                      null &&
                                                  !controller
                                                      .inGameCheckModel.value
                                                      .getInGameName()
                                                      .isEmpty)
                                              ? controller
                                                  .inGameCheckModel.value
                                                  .getInGameName()
                                              : "Link ID",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        /*Visibility(
                          visible: AppString.gameName != '' &&
                                  AppString.gameName == 'LUDO KING'
                              ? true
                              : false,
                          child:*/
                        AppString.gameName != null &&
                                AppString.gameName.compareTo("LUDO KING") == 0
                            ? Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    Utils().customPrint('open ludo...');
                                    //NativeBridge().OpenLudoKing();
                                    try {
                                      ///checks if the app is installed on your mobile device
                                      bool isInstalled =
                                          await DeviceApps.isAppInstalled(
                                              'com.ludo.king');
                                      if (isInstalled) {
                                        Utils().customPrint('open ludo...IF');
                                        DeviceApps.openApp("com.ludo.king");
                                      } else {
                                        Utils().customPrint('open ludo...ELSE');

                                        ///if the app is not installed it lunches google play store so you can install it from there
                                        Utils.launchURLApp(
                                            "market://details?id=" +
                                                "com.ludo.king");
                                      }
                                    } catch (e) {
                                      Utils().customPrint(e);
                                      Utils().customPrint('open ludo...E');
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor().whiteColor,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.transparent),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 13,
                                          child: Image.asset(
                                            ImageRes().ludo_king_play_icon,
                                            color: AppColor().colorGray,
                                          ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Open Ludo",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        /*),*/
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 8, left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            base_controller.checkTr.value = true;
                            base_controller.colorPrimary.value =
                                Color(0xFFe55f19);
                            base_controller.colorwhite.value =
                                Color(0xFFffffff);
                          },
                          child: Column(
                            children: [
                              Text(
                                "All Battles".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                              Obx(
                                () => Container(
                                  margin: EdgeInsets.only(top: 5),
                                  color: base_controller.colorPrimary.value,
                                  height: 3,
                                ),
                              )
                            ],
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            base_controller.checkTr.value = false;
                            base_controller.colorPrimary.value =
                                Color(0xFFffffff);
                            base_controller.colorwhite.value =
                                Color(0xFFe55f19);
                            controller.getJoinedContestList(gameid);
                          },
                          child: Column(
                            children: [
                              Text(
                                "Joined Battles".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                              Obx(
                                () => Container(
                                  margin: EdgeInsets.only(top: 5),
                                  color: base_controller.colorwhite.value,
                                  height: 3,
                                ),
                              )
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  /* Joined Battles*/
                  Obx(
                    () => Offstage(
                        offstage: base_controller.checkTr.value,
                        child: Obx(() => Container(
                            child: (controller.esportJoinedList != null &&
                                    controller.esportJoinedList.value != null &&
                                    controller.esportJoinedList.value.data !=
                                        null &&
                                    controller.esportJoinedList.value.data
                                            .length >
                                        0)
                                ? controller.esportJoinedList.value.data
                                            .length >
                                        0
                                    ? ListView.builder(
                                        itemCount: controller
                                            .esportJoinedList.value.data.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return joinedListView(context, index);
                                        })
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .61,
                                        child: Center(
                                          child: Text(
                                            "No items are available Please Come back later",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ))
                                : Container(
                                    height: 0,
                                  )))),
                  ),
                  /* All Battles*/

                  Obx(
                    () => Visibility(
                        visible: base_controller.checkTr.value,
                        child: Wrap(
                          children: [
                            Obx(
                              () => (controller.esportEventListModel != null &&
                                      controller.esportEventListModel.value !=
                                          null &&
                                      controller.esportEventListModel.value
                                              .affiliate !=
                                          null &&
                                      controller.esportEventListModel.value
                                              .affiliate.length >
                                          0)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 15,
                                          top: 10,
                                          bottom: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Special Contest".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Inter",
                                                color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Swipe for more".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color: Colors.white),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  //Get.to(() => Affiliated());
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  height: 25,
                                                  child: Image.asset(
                                                    "assets/images/next_arrow.png",
                                                    color: AppColor().colorGray,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: 0,
                                    ),
                            ),

                            /* Affiliate ship list*/
                            Obx(() => (controller.esportEventListModel !=
                                        null &&
                                    controller.esportEventListModel.value !=
                                        null &&
                                    controller.esportEventListModel.value
                                            .affiliate !=
                                        null &&
                                    controller.esportEventListModel.value
                                            .affiliate.length >
                                        0)
                                ? Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 210,
                                    child: ListView.builder(
                                        itemCount:
                                            (controller.esportEventListModel !=
                                                        null &&
                                                    controller
                                                            .esportEventListModel
                                                            .value !=
                                                        null &&
                                                    controller
                                                            .esportEventListModel
                                                            .value
                                                            .affiliate !=
                                                        null &&
                                                    controller
                                                            .esportEventListModel
                                                            .value
                                                            .affiliate
                                                            .length >
                                                        0)
                                                ? controller
                                                    .esportEventListModel
                                                    .value
                                                    .affiliate
                                                    .length
                                                : 0,
                                        //shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return affiliated(context, index);
                                        }),
                                  )
                                : Container(
                                    height: 0,
                                  )),

                            /* champain ship list*/

                            Obx(() => ((controller.esportEventListModel !=
                                        null &&
                                    controller.esportEventListModel.value !=
                                        null &&
                                    controller.esportEventListModel.value
                                            .champaiship !=
                                        null &&
                                    controller.esportEventListModel.value
                                            .champaiship.length >
                                        0)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 15,
                                        top: 15,
                                        bottom: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Championship".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Swipe for more".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Inter",
                                                  color: Colors.white),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                //Get.to(() => Affiliated());
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                height: 25,
                                                child: Image.asset(
                                                  "assets/images/next_arrow.png",
                                                  color: AppColor().colorGray,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ))),

                            Obx(() => ((controller.esportEventListModel != null &&
                                    controller.esportEventListModel.value !=
                                        null &&
                                    controller.esportEventListModel.value.champaiship !=
                                        null &&
                                    controller.esportEventListModel.value.champaiship.length >
                                        0)
                                ? Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 210,
                                    child: ListView.builder(
                                        itemCount:
                                            (controller.esportEventListModel != null &&
                                                    controller.esportEventListModel.value !=
                                                        null &&
                                                    controller
                                                            .esportEventListModel
                                                            .value
                                                            .champaiship !=
                                                        null &&
                                                    controller
                                                            .esportEventListModel
                                                            .value
                                                            .champaiship
                                                            .length >
                                                        0)
                                                ? controller
                                                    .esportEventListModel
                                                    .value
                                                    .champaiship
                                                    .length
                                                : 0,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int index) {
                                          return championship(context, index);
                                        }))
                                : Text(""))),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => controller.esportEventListModel !=
                                                null &&
                                            controller.esportEventListModel
                                                    .value !=
                                                null &&
                                            controller.esportEventListModel
                                                    .value.data !=
                                                null &&
                                            controller.esportEventListModel
                                                    .value.data.length >
                                                0
                                        ? Text(
                                            "Contest".tr,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Inter",
                                                color: Colors.white),
                                          )
                                        : Text(""),
                                  ),
                                  Obx(() => controller
                                              .esportEventListModel.value !=
                                          null
                                      ? controller.esportEventListModel.value
                                                      .data !=
                                                  null ||
                                              controller.esportEventListModel
                                                      .value.affiliate !=
                                                  null ||
                                              controller.esportEventListModel
                                                      .value.champaiship !=
                                                  null
                                          ? controller.esportEventListModel.value
                                                          .data.length >=
                                                      1 ||
                                                  controller
                                                          .esportEventListModel
                                                          .value
                                                          .affiliate
                                                          .length >=
                                                      1 ||
                                                  controller
                                                          .esportEventListModel
                                                          .value
                                                          .champaiship
                                                          .length >=
                                                      1
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showbottomsheetfilter(
                                                        context);
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 27,
                                                    child: Image.asset(
                                                      ImageRes().filter,
                                                      color:
                                                          AppColor().whiteColor,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: 1,
                                                  width: 1,
                                                )
                                          : Container(
                                              height: 1,
                                              width: 1,
                                            )
                                      : Container(
                                          height: 1,
                                          width: 1,
                                        )),
                                ],
                              ),
                            ),

                            //contest list
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  //  height: MediaQuery.of(context).size.height,
                                  child: (controller.esportEventListModel != null &&
                                          controller.esportEventListModel.value !=
                                              null &&
                                          controller.esportEventListModel.value
                                                  .data !=
                                              null &&
                                          controller.esportEventListModel.value
                                                  .data.length >
                                              0)
                                      ? controller.esportEventListModel.value
                                                  .data.length >=
                                              1
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  right: 1,
                                                  left: 1,
                                                  bottom: 1),
                                              itemCount: controller
                                                  .esportEventListModel
                                                  .value
                                                  .data
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Obx(() =>
                                                    Contest(context, index));
                                                // return contest(context,index);
                                              })
                                          : Text("")
                                      : Text(""),
                                ),
                              ),
                            ),

                            // empty screen
                            Obx(() => controller.esportEventListModel.value !=
                                    null
                                ? controller.esportEventListModel.value
                                                .data !=
                                            null &&
                                        controller.esportEventListModel.value
                                                .affiliate !=
                                            null &&
                                        controller.esportEventListModel.value
                                                .champaiship !=
                                            null
                                    ? controller.esportEventListModel.value.data
                                                    .length <=
                                                0 &&
                                            controller.esportEventListModel
                                                    .value.affiliate.length <=
                                                0 &&
                                            controller.esportEventListModel
                                                    .value.champaiship.length <=
                                                0
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: AspectRatio(
                                                  aspectRatio: 2 / 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                "assets/images/empty_screen.png"))),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            height: 1,
                                            width: 1,
                                          )
                                    : Container(
                                        height: 1,
                                        width: 1,
                                      )
                                : Shimmer.fromColors(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: listShimmer(),
                                            );
                                          }),
                                    ),
                                    baseColor: Colors.grey.withOpacity(0.2),
                                    highlightColor:
                                        Colors.grey.withOpacity(0.6),
                                    enabled: true,
                                  )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget Contest(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      //  width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13))),
            width: MediaQuery.of(context).size.width,
            height: 42,
            child: Container(
              padding: EdgeInsets.only(left: 7, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      controller.esportEventListModel.value.data[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showCustomDialogContestInfo(context,
                          controller.esportEventListModel.value.data[index]);
                    },
                    child: Container(
                      child: Image.asset(
                        ImageRes().iv_info,
                        width: 15,
                        height: 15,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Date",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy").format(
                        DateFormat("yyyy-MM-dd").parse(
                            controller.esportEventListModel.value.data[index]
                                .eventDate.start,
                            true),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                ),
              ),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    '${controller.esportEventListModel.value.data[index].eventDate.getStartTimeHHMMSS()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Map",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    controller.esportEventListModel.value.data[index]
                                    .gameMapId !=
                                null &&
                            controller.esportEventListModel.value.data[index]
                                    .gameMapId.name !=
                                null &&
                            !controller.esportEventListModel.value.data[index]
                                .gameMapId.name.isEmpty
                        ? controller.esportEventListModel.value.data[index]
                            .gameMapId.name
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Perspective",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    controller.esportEventListModel.value.data[index]
                                    .gamePerspectiveId !=
                                null &&
                            controller.esportEventListModel.value.data[index]
                                    .gamePerspectiveId.name !=
                                null
                        ? controller.esportEventListModel.value.data[index]
                            .gamePerspectiveId.name
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: AppColor().colorGray,
            width: MediaQuery.of(context).size.width,
            height: 2,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Prizepool",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    controller.esportEventListModel.value.data[index].winner
                                    .customPrize !=
                                null &&
                            controller.esportEventListModel.value.data[index]
                                .winner.customPrize.isNotEmpty
                        ? Text(
                            "${controller.esportEventListModel.value.data[index].winner.customPrize}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        : controller.esportEventListModel.value.data[index]
                                        .winner.prizeAmount !=
                                    null &&
                                controller.esportEventListModel.value
                                        .data[index].winner.prizeAmount.type
                                        .compareTo("bonus") ==
                                    0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Container(
                                      height: 20,
                                      child: Image.asset(ImageRes().ic_coin),
                                    ),
                                    Text(
                                      "${controller.esportEventListModel.value.data[index].winner.prizeAmount != null ? controller.esportEventListModel.value.data[index].winner.prizeAmount.value : "-"}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          color: AppColor().colorPrimary),
                                    )
                                  ])
                            : Text(
                                "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportEventListModel.value.data[index].winner.prizeAmount != null ? controller.esportEventListModel.value.data[index].winner.prizeAmount.value ~/ 100 : "-"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimary),
                              ),
                  ],
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Type",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    controller
                        .esportEventListModel.value.data[index].gameModeId.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "${controller.esportEventListModel.value.data[index].winner.isKillType() ? "Per Kill" : "Winners"}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${!controller.esportEventListModel.value.data[index].winner.isKillType() ? controller.esportEventListModel.value.data[index].getTotalWinner() : controller.esportEventListModel.value.data[index].winner.perKillAmount.value ~/ 100}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller.esportEventListModel.value.data[index]
                                  .getTotalWinner()
                                  .compareTo("null") ==
                              0) {
                          } else {
                            showWinningBreakupDialog(
                                context,
                                controller
                                    .esportEventListModel.value.data[index]);
                          }
                        },
                        child: Container(
                          width: 13,
                          alignment: Alignment.topCenter,
                          child: !controller
                                  .esportEventListModel.value.data[index].winner
                                  .isKillType()
                              ? Image.asset("assets/images/arrow_down.png")
                              : Container(),
                        ),
                      )
                    ],
                  ),
                ],
              )),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Entry Fee",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Container(
                    child: controller.esportEventListModel.value.data[index]
                                .entry.fee.value >
                            0
                        ? Text(
                            controller.esportEventListModel.value.data[index]
                                        .entry.fee.type ==
                                    "bonus"
                                ? "${controller.esportEventListModel.value.data[index].entry.fee.value}"
                                : "${controller.esportEventListModel.value.data[index].entry.fee.value ~/ 100}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        : Text(
                            "Free",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          ),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor().colorPrimary),
                backgroundColor: AppColor().colorGray,
                value: controller.esportEventListModel.value.data[index]
                    .getProgresBar(),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 3),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.esportEventListModel.value.data[index]
                        .getRemaningPlayer(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    controller.esportEventListModel.value.data[index]
                        .getEventJoinedPlayer(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          controller.esportEventListModel.value.data[index].joiningDate !=
                      null &&
                  controller.esportEventListModel.value.data[index].joiningDate
                          .start !=
                      null
              ? GestureDetector(
                  onTap: () {
                    print(
                        'contestAmount esport 1 ${controller.esportEventListModel.value.data[index].entry.fee.type}');
                    if (controller.esportEventListModel.value.data[index].entry
                            .fee.type ==
                        'bonus') {
                      contestAmountLocal = controller.esportEventListModel.value
                          .data[index].entry.fee.value;
                    } else {
                      contestAmountLocal = controller.esportEventListModel.value
                              .data[index].entry.fee.value ~/
                          100;
                    }

                    CheckJoinContestDetails(context, index);
                  },
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(13),
                            bottomLeft: Radius.circular(13)),
                        color: controller.esportEventListModel.value.data[index]
                                        .getRemaningPlayerCount() <=
                                    0 ||
                                AppString.joinContest.value == 'inactive'
                            ? AppColor().colorGray
                            : AppColor().colorPrimary,
                      ),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 42,
                      child: ((DateTime.parse(
                                          "${controller.esportEventListModel.value.data[index].joiningDate.start}")
                                      .toUtc())
                                  .difference(controller.getCurrentdate())
                                  .inSeconds) >
                              0
                          ? TweenAnimationBuilder<Duration>(
                              duration: Duration(
                                  seconds: controller.subtractDate(DateTime.parse(
                                      "${controller.esportEventListModel.value.data[index].joiningDate.start}"))),
                              tween: Tween(
                                  begin: Duration(
                                      seconds: controller.subtractDate(DateTime.parse(
                                          "${controller.esportEventListModel.value.data[index].joiningDate.start}"))),
                                  end: Duration.zero),
                              onEnd: () {
                                Utils().customPrint('Timer ended');
                              },
                              builder: (BuildContext context, Duration value,
                                  Widget child) {
                                String seconds = (value.inSeconds % 60)
                                    .toInt()
                                    .toString()
                                    .padLeft(2, '0');
                                String minutes = ((value.inSeconds / 60) % 60)
                                    .toInt()
                                    .toString()
                                    .padLeft(2, '0');
                                String hours = (value.inSeconds ~/ 3600)
                                    .toString()
                                    .padLeft(2, '0');
                                /*    final minutes = value.inMinutes;
                      final seconds = value.inSeconds % 60;*/
                                return /*seconds.compareTo("00") == 0
                                    ? Text(
                                        "JOIN CONTEST",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: Colors.white),
                                      )
                                    :*/
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                            "JOIN IN $hours\:$minutes\:$seconds",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16)));
                              })
                          : Text(
                              "${controller.esportEventListModel.value.data[index].getRemaningPlayerCount() <= 0 ? "CONTEST FULL" : "JOIN CONTEST"}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: Colors.white),
                            ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Utils().customPrint("gameid ludo king $gameid");
                    print(
                        'contestAmount esport 1 ${controller.esportEventListModel.value.data[index].entry.fee.type}');
                    if (controller.esportEventListModel.value.data[index].entry
                            .fee.type ==
                        'bonus') {
                      contestAmountLocal = controller.esportEventListModel.value
                          .data[index].entry.fee.value;
                    } else {
                      contestAmountLocal = controller.esportEventListModel.value
                              .data[index].entry.fee.value ~/
                          100;
                    }
                    CheckJoinContestDetails(context, index);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(13),
                            bottomLeft: Radius.circular(13)),
                        color: AppColor().colorPrimary,
                      ),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 42,
                      child: Text(
                        "${controller.esportEventListModel.value.data[index].getRemaningPlayerCount() <= 0 ? "CONTEST FULL" : "JOIN CONTEST"}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ))),
        ],
      ),
    );
  }

  Future<void> CheckJoinContestDetails(BuildContext context, int index) async {
    if (AppString.joinContest.value == 'inactive') {
      Fluttertoast.showToast(msg: 'Join contest disable!');
      return;
    }
    if (controller.esportEventListModel.value.data[index]
            .getRemaningPlayerCount() <=
        0) {
      Fluttertoast.showToast(msg: "Contest Full");
      return;
    }

    if (controller.subtractDate(DateTime.parse(
            "${controller.esportEventListModel.value.data[index].joiningDate.start}")) >=
        0) {
      Fluttertoast.showToast(msg: "Game Not Started Please Wait");
      return;
    }

    if (controller.inGameCheckModel.value != null) {
      contest_id = controller.esportEventListModel.value.data[index].id;
      _contestModel = controller.esportEventListModel.value.data[index];

      if (!_contestModel.getPassword().isEmpty) {
        showCheckPassword(context);
      } else {
        getPreJoinEvent(contest_id);
      }
    } else {
      contest_id = controller.esportEventListModel.value.data[index].id;
      _contestModel = controller.esportEventListModel.value.data[index];
      showInGameDialog(
          context, controller.esportEventListModel.value.data[index].gameId.id);
    }
  }

  // affiliated list

  Widget affiliated(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13))),
            width: MediaQuery.of(context).size.width,
            height: 42,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      controller
                          .esportEventListModel.value.affiliate[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showCustomDialogContestInfo(
                          context,
                          controller
                              .esportEventListModel.value.affiliate[index]);
                    },
                    child: Container(
                      child: Image.asset(
                        ImageRes().iv_info,
                        color: Colors.white,
                        width: 15,
                        height: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Date",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(
                          DateFormat("yyyy-MM-dd").parse(controller
                              .esportEventListModel
                              .value
                              .affiliate[index]
                              .eventDate
                              .start),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 25,
                  width: 1,
                  color: AppColor().colorGray,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Time",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      '${controller.esportEventListModel.value.affiliate[index].eventDate.getStartTimeHHMMSS()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                )),
                Container(
                  height: 25,
                  width: 1,
                  color: AppColor().colorGray,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Map",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      controller.esportEventListModel.value.affiliate[index]
                          .gameMapId.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                )),
                Container(
                  height: 25,
                  width: 1,
                  color: AppColor().colorGray,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Perspective",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      controller.esportEventListModel.value.affiliate[index]
                          .gamePerspectiveId.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: AppColor().colorGray,
            width: MediaQuery.of(context).size.width,
            height: 2,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 38,
            child: Row(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Prizepool",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      controller.esportEventListModel.value.affiliate[index]
                                      .winner.customPrize !=
                                  null &&
                              controller
                                  .esportEventListModel
                                  .value
                                  .affiliate[index]
                                  .winner
                                  .customPrize
                                  .isNotEmpty
                          ? Text(
                              "${controller.esportEventListModel.value.affiliate[index].winner.customPrize}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            )
                          : controller
                                          .esportEventListModel
                                          .value
                                          .affiliate[index]
                                          .winner
                                          .prizeAmount !=
                                      null &&
                                  controller
                                          .esportEventListModel
                                          .value
                                          .affiliate[index]
                                          .winner
                                          .prizeAmount
                                          .type
                                          .compareTo("bonus") ==
                                      0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Container(
                                        height: 20,
                                        child: Image.asset(ImageRes().ic_coin),
                                      ),
                                      Text(
                                        "${controller.esportEventListModel.value.affiliate[index].winner.prizeAmount != null ? controller.esportEventListModel.value.affiliate[index].winner.prizeAmount.value : "-"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: AppColor().colorPrimary),
                                      )
                                    ])
                              : Text(
                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportEventListModel.value.affiliate[index].winner.prizeAmount != null ? controller.esportEventListModel.value.affiliate[index].winner.prizeAmount.value ~/ 100 : "-"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: AppColor().colorPrimary),
                                ),

                      /* Text(
                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'}${controller.esportEventListModel.value.affiliate[index].winner.prizeAmount != null ? controller.esportEventListModel.value.affiliate[index].winner.prizeAmount.value ~/ 100 : "--"}",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      )*/
                    ],
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Type",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      controller.esportEventListModel.value.affiliate[index]
                          .gameModeId.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                )),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "${controller.esportEventListModel.value.affiliate[index].winner.isKillType() ? "Per Kill" : "Winners"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${!controller.esportEventListModel.value.affiliate[index].winner.isKillType() ? controller.esportEventListModel.value.affiliate[index].getTotalWinner() : controller.esportEventListModel.value.affiliate[index].winner.perKillAmount.value ~/ 100}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Inter",
                              color: AppColor().colorPrimary),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller
                                    .esportEventListModel.value.affiliate[index]
                                    .getTotalWinner() !=
                                null) {
                              showWinningBreakupDialog(
                                  context,
                                  controller.esportEventListModel.value
                                      .affiliate[index]);
                            }
                          },
                          child: Container(
                            width: 13,
                            alignment: Alignment.topCenter,
                            child: !controller.esportEventListModel.value
                                    .affiliate[index].winner
                                    .isKillType()
                                ? Image.asset("assets/images/arrow_down.png")
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Entry Fee",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Container(
                      child: controller.esportEventListModel.value
                                  .affiliate[index].entry.fee.value >
                              0
                          ? Text(
                              "${controller.esportEventListModel.value.affiliate[index].entry.fee.value ~/ 100}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            )
                          : Text(
                              "Free",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            ),
                    ),
                  ],
                )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),

          //LinearProgressIndicator
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 2),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor().colorPrimary),
                backgroundColor: AppColor().colorGray,
                // value: .7,
                value: controller.esportEventListModel.value.affiliate[index]
                    .getProgresBar(),
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            height: 25,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${controller.esportEventListModel.value.affiliate[index].getRemaningPlayer()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    "${controller.esportEventListModel.value.affiliate[index].getEventJoinedPlayer()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              CheckaffiliatedDetails(context, index);
            },
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(13),
                      bottomLeft: Radius.circular(13)),
                  // color: AppColor().colorPrimary,
                  color: controller.esportEventListModel.value.affiliate[index]
                              .getRemaningPlayerCount() <=
                          0
                      ? AppColor().colorGray
                      : AppColor().colorPrimary,
                ),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 38,
                child: ((DateTime.parse(
                                    "${controller.esportEventListModel.value.affiliate[index].joiningDate.start}")
                                .toUtc())
                            .difference(controller.getCurrentdate())
                            .inSeconds) >
                        0
                    ? TweenAnimationBuilder<Duration>(
                        duration: Duration(
                            seconds: controller.subtractDate(DateTime.parse(
                                "${controller.esportEventListModel.value.affiliate[index].joiningDate.start}"))),
                        tween: Tween(
                            begin: Duration(
                                seconds: controller.subtractDate(DateTime.parse(
                                    "${controller.esportEventListModel.value.affiliate[index].joiningDate.start}"))),
                            end: Duration.zero),
                        onEnd: () {
                          Utils().customPrint('Timer ended');
                        },
                        builder: (BuildContext context, Duration value,
                            Widget child) {
                          String seconds = (value.inSeconds % 60)
                              .toInt()
                              .toString()
                              .padLeft(2, '0');
                          String minutes = ((value.inSeconds / 60) % 60)
                              .toInt()
                              .toString()
                              .padLeft(2, '0');
                          String hours = (value.inSeconds ~/ 3600)
                              .toString()
                              .padLeft(2, '0');
                          /*    final minutes = value.inMinutes;
                        final seconds = value.inSeconds % 60;*/
                          return /*seconds.compareTo("00") == 0
                              ? Text(
                                  "${controller.esportEventListModel.value.affiliate[index].getRemaningPlayerCount() <= 0 ? "CONTEST FULL" : "JOIN CONTEST"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                )
                              :*/
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text("$hours\:$minutes\:$seconds",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)));
                        })
                    : Text(
                        "${controller.esportEventListModel.value.affiliate[index].getRemaningPlayerCount() <= 0 ? "CONTEST FULL" : "JOIN CONTEST"}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> CheckaffiliatedDetails(BuildContext context, int index) async {
    if (controller.esportEventListModel.value.affiliate[index]
            .getRemaningPlayerCount() <=
        0) {
      Fluttertoast.showToast(msg: "Contest Full");
      return;
    }

    if (controller.inGameCheckModel.value != null) {
      contest_id = controller.esportEventListModel.value.affiliate[index].id;
      _contestModel = controller.esportEventListModel.value.affiliate[index];
      if (!_contestModel.getPassword().isEmpty) {
        showCheckPassword(context);
      } else {
        getPreJoinEvent(contest_id);
      }
    } else {
      contest_id = controller.esportEventListModel.value.affiliate[index].id;
      _contestModel = controller.esportEventListModel.value.affiliate[index];
      showInGameDialog(context,
          controller.esportEventListModel.value.affiliate[index].gameId.id);
    }
  }

  Widget championship(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13))),
            width: MediaQuery.of(context).size.width,
            height: 42,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      controller
                          .esportEventListModel.value.champaiship[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showCustomDialogContestInfo(
                          context,
                          controller
                              .esportEventListModel.value.champaiship[index]);
                    },
                    child: Container(
                      child: Image.asset(
                        ImageRes().iv_info,
                        color: Colors.white,
                        width: 15,
                        height: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Date",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(
                          DateFormat("yyyy-MM-dd").parse(
                              controller.esportEventListModel.value
                                  .champaiship[index].eventDate.start,
                              true),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 25,
                  width: 1,
                  color: AppColor().colorGray,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Time",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      '${controller.esportEventListModel.value.champaiship[index].eventDate.getStartTimeHHMMSS()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                )),
                Container(
                  height: 25,
                  width: 1,
                  color: AppColor().colorGray,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Map",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      controller.esportEventListModel.value.champaiship[index]
                          .gameMapId.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                )),
                Container(
                  height: 25,
                  width: 1,
                  color: AppColor().colorGray,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Perspective",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      controller.esportEventListModel.value.champaiship[index]
                          .gamePerspectiveId.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: AppColor().colorGray,
            width: MediaQuery.of(context).size.width,
            height: 2,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 38,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Prizepool",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      controller.esportEventListModel.value.champaiship[index]
                                      .winner.customPrize !=
                                  null &&
                              controller
                                  .esportEventListModel
                                  .value
                                  .champaiship[index]
                                  .winner
                                  .customPrize
                                  .isNotEmpty
                          ? Text(
                              "${controller.esportEventListModel.value.champaiship[index].winner.customPrize}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            )
                          : controller
                                          .esportEventListModel
                                          .value
                                          .champaiship[index]
                                          .winner
                                          .prizeAmount !=
                                      null &&
                                  controller
                                          .esportEventListModel
                                          .value
                                          .champaiship[index]
                                          .winner
                                          .prizeAmount
                                          .type
                                          .compareTo("bonus") ==
                                      0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Container(
                                        height: 20,
                                        child: Image.asset(ImageRes().ic_coin),
                                      ),
                                      Text(
                                        "${controller.esportEventListModel.value.champaiship[index].winner.prizeAmount != null ? controller.esportEventListModel.value.champaiship[index].winner.prizeAmount.value : "-"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: AppColor().colorPrimary),
                                      )
                                    ])
                              : Text(
                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportEventListModel.value.champaiship[index].winner.prizeAmount != null ? controller.esportEventListModel.value.champaiship[index].winner.prizeAmount.value ~/ 100 : "-"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: AppColor().colorPrimary),
                                ),

                      /*   Text(
                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportEventListModel.value.champaiship[index].winner.prizeAmount != null ? controller.esportEventListModel.value.champaiship[index].winner.prizeAmount.value ~/ 100 : "--"}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      )*/
                    ],
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Type",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Text(
                      controller.esportEventListModel.value.champaiship[index]
                          .gameModeId.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                  ],
                )),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "${controller.esportEventListModel.value.champaiship[index].winner.isKillType() ? "Per Kill" : "Winners"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${!controller.esportEventListModel.value.champaiship[index].winner.isKillType() ? controller.esportEventListModel.value.champaiship[index].getTotalWinner() : controller.esportEventListModel.value.champaiship[index].winner.perKillAmount.value ~/ 100}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Inter",
                              color: AppColor().colorPrimary),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.esportEventListModel.value
                                    .champaiship[index]
                                    .getTotalWinner() !=
                                null) {
                              showWinningBreakupDialog(
                                  context,
                                  controller.esportEventListModel.value
                                      .champaiship[index]);
                            }
                          },
                          child: Container(
                            width: 13,
                            alignment: Alignment.topCenter,
                            child: !controller.esportEventListModel.value
                                    .champaiship[index].winner
                                    .isKillType()
                                ? Image.asset("assets/images/arrow_down.png")
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Entry Fee",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Container(
                      child: controller.esportEventListModel.value
                                  .champaiship[index].entry.fee.value >
                              0
                          ? Text(
                              "${controller.esportEventListModel.value.champaiship[index].entry.fee.value ~/ 100}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            )
                          : Text(
                              "Free",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            ),
                    ),
                  ],
                )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),

          //LinearProgressIndicator
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor().colorPrimary),
                backgroundColor: AppColor().colorGray,
                // value: .7,
                value: controller.esportEventListModel.value.champaiship[index]
                    .getProgresBar(),
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            height: 25,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${controller.esportEventListModel.value.champaiship[index].getRemaningPlayer()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    "${controller.esportEventListModel.value.champaiship[index].getEventJoinedPlayer()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              CheckChampionshipDetails(context, index);
            },
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(13),
                      bottomLeft: Radius.circular(13)),
                  color: controller
                              .esportEventListModel.value.champaiship[index]
                              .getRemaningPlayerCount() <=
                          0
                      ? AppColor().colorGray
                      : AppColor().colorPrimary,
                ),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 38,
                child: ((DateTime.parse(
                                    "${controller.esportEventListModel.value.champaiship[index].joiningDate.start}")
                                .toUtc())
                            .difference(controller.getCurrentdate())
                            .inSeconds) >
                        0
                    ? TweenAnimationBuilder<Duration>(
                        duration: Duration(
                            seconds: controller.subtractDate(DateTime.parse(
                                "${controller.esportEventListModel.value.champaiship[index].joiningDate.start}"))),
                        tween: Tween(
                            begin: Duration(
                                seconds: controller.subtractDate(DateTime.parse(
                                    "${controller.esportEventListModel.value.champaiship[index].joiningDate.start}"))),
                            end: Duration.zero),
                        onEnd: () {
                          Utils().customPrint('Timer ended');
                        },
                        builder: (BuildContext context, Duration value,
                            Widget child) {
                          String seconds = (value.inSeconds % 60)
                              .toInt()
                              .toString()
                              .padLeft(2, '0');
                          String minutes = ((value.inSeconds / 60) % 60)
                              .toInt()
                              .toString()
                              .padLeft(2, '0');
                          String hours = (value.inSeconds ~/ 3600)
                              .toString()
                              .padLeft(2, '0');
                          return /*seconds.compareTo("00") == 0
                              ? Text(
                                  "${controller.esportEventListModel.value.champaiship[index].getRemaningPlayerCount() <= 0 ? "CONTEST FULL" : "JOIN CONTEST"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                )
                              :*/
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text("$hours\:$minutes\:$seconds",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)));
                        })
                    : Text(
                        "${controller.esportEventListModel.value.champaiship[index].getRemaningPlayerCount() <= 0 ? "CONTEST FULL" : "JOIN CONTEST"}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> CheckChampionshipDetails(BuildContext context, int index) async {
    if (controller.esportEventListModel.value.champaiship[index]
            .getRemaningPlayerCount() <=
        0) {
      Fluttertoast.showToast(msg: "Contest Full");
      return;
    }

    if (controller.inGameCheckModel.value != null) {
      contest_id = controller.esportEventListModel.value.champaiship[index].id;
      _contestModel = controller.esportEventListModel.value.champaiship[index];
      if (!_contestModel.getPassword().isEmpty) {
        showCheckPassword(context);
      } else {
        getPreJoinEvent(contest_id);
      }
    } else {
      contest_id = controller.esportEventListModel.value.champaiship[index].id;
      _contestModel = controller.esportEventListModel.value.champaiship[index];
      showInGameDialog(context,
          controller.esportEventListModel.value.champaiship[index].gameId.id);
    }
  }

  /*joined contest list*/
  Widget joinedListView(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AppColor().whiteColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 12, bottom: 12),
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            width: double.infinity,
            child: Text(
              "${controller.esportJoinedList.value.data[index].name}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontSize: 14),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(
                          DateFormat("yyyy-MM-dd").parse(
                              controller.esportJoinedList.value.data[index]
                                  .eventDate.start,
                              true),
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    '${controller.esportJoinedList.value.data[index].eventDate.getStartTimeHHMMSS()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Map",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    controller.esportJoinedList.value.data[index].gameMapId !=
                                null &&
                            controller.esportJoinedList.value.data[index]
                                    .gameMapId.name !=
                                null
                        ? controller
                            .esportJoinedList.value.data[index].gameMapId.name
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Perspective",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    controller.esportJoinedList.value.data[index]
                                    .gamePerspectiveId !=
                                null &&
                            controller.esportJoinedList.value.data[index]
                                    .gamePerspectiveId.name !=
                                null
                        ? controller.esportJoinedList.value.data[index]
                            .gamePerspectiveId.name
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prizepool",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      controller.esportJoinedList.value.data[index].winner
                                      .customPrize !=
                                  null &&
                              controller.esportJoinedList.value.data[index]
                                  .winner.customPrize.isNotEmpty
                          ? Text(
                              "${controller.esportJoinedList.value.data[index].winner.customPrize}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            )
                          : controller.esportJoinedList.value.data[index].winner
                                          .prizeAmount !=
                                      null &&
                                  controller.esportJoinedList.value.data[index]
                                          .winner.prizeAmount.type
                                          .compareTo("bonus") ==
                                      0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Container(
                                        height: 20,
                                        child: Image.asset(ImageRes().ic_coin),
                                      ),
                                      Text(
                                        "${controller.esportJoinedList.value.data[index].winner.prizeAmount != null ? controller.esportJoinedList.value.data[index].winner.prizeAmount.value : "-"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: AppColor().colorPrimary),
                                      )
                                    ])
                              : Text(
                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportJoinedList.value.data[index].winner.prizeAmount != null ? controller.esportJoinedList.value.data[index].winner.prizeAmount.value ~/ 100 : "-"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: AppColor().colorPrimary),
                                ),
                      /*   Text(
                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportJoinedList.value.data[index].winner.prizeAmount != null ? controller.esportJoinedList.value.data[index].winner.prizeAmount.value ~/ 100 : "-"}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),*/
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Type",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    controller.esportJoinedList.value.data[index].gameModeId !=
                                null &&
                            controller.esportJoinedList.value.data[index]
                                    .gameModeId.name !=
                                null
                        ? controller
                            .esportJoinedList.value.data[index].gameModeId.name
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "${controller.esportJoinedList.value.data[index].winner.isKillType() ? "Per Kill" : "Winners"}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${!controller.esportJoinedList.value.data[index].winner.isKillType() ? controller.esportJoinedList.value.data[index].getTotalWinner() : controller.esportJoinedList.value.data[index].winner.perKillAmount.value ~/ 100}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller.esportJoinedList.value.data[index]
                                  .getTotalWinner() !=
                              null) {
                            showWinningBreakupDialog(context,
                                controller.esportJoinedList.value.data[index]);
                          }
                        },
                        child: Container(
                          width: 13,
                          alignment: Alignment.topCenter,
                          child: !controller
                                  .esportJoinedList.value.data[index].winner
                                  .isKillType()
                              ? Image.asset("assets/images/arrow_down.png")
                              : Container(),
                        ),
                      )
                    ],
                  ),
                ],
              )),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Entry Fee",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Container(
                    child: controller.esportJoinedList.value.data[index].entry
                                .fee.value >
                            0
                        ? Text(
                            controller.esportJoinedList.value.data[index].entry
                                        .fee.type ==
                                    'bonus'
                                ? controller.esportJoinedList.value.data[index]
                                    .entry.fee.value
                                    .toString()
                                : "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportJoinedList.value.data[index].entry.fee.value ~/ 100}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        : Text(
                            "Free",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          ),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 7,
          ),

          //LinearProgressIndicator

          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor().colorPrimary),
                backgroundColor: AppColor().colorGray,
                value: controller.esportJoinedList.value.data[index]
                    .getProgresBar(),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.esportJoinedList.value.data[index]
                      .getRemaningPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
                Text(
                  controller.esportJoinedList.value.data[index]
                      .getEventJoinedPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor().colorPrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Room ID",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${controller.esportJoinedList.value.data[index].rounds != null && controller.esportJoinedList.value.data[index].rounds.length > 0 && controller.esportJoinedList.value.userRegistrations != null && controller.esportJoinedList.value.userRegistrations.length > 0 ? controller.esportJoinedList.value.data[index].affiliate != null && !controller.esportJoinedList.value.data[index].isCompletedJoined(controller.esportJoinedList.value.data[index].id, controller.esportJoinedList.value.userRegistrations) ? "" : controller.esportJoinedList.value.data[index].getUserRoundRoomId(controller.esportJoinedList.value.userRegistrations) : "--"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().whiteColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          "${controller.esportJoinedList.value.data[index].rounds != null && controller.esportJoinedList.value.data[index].rounds.length > 0 && controller.esportJoinedList.value.userRegistrations != null && controller.esportJoinedList.value.userRegistrations.length > 0 ? controller.esportJoinedList.value.data[index].getUserRoundRoomId(controller.esportJoinedList.value.userRegistrations) : "--"}"));

                                  Fluttertoast.showToast(
                                      msg: "Copied Succesfully");
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    "assets/images/ic_copy.webp",
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: 1,
                      height: 30,
                      color: Colors.white,
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${controller.esportJoinedList.value.data[index].rounds != null && controller.esportJoinedList.value.data[index].rounds.length > 0 && controller.esportJoinedList.value.userRegistrations != null && controller.esportJoinedList.value.userRegistrations.length > 0 ? controller.esportJoinedList.value.data[index].affiliate != null && !controller.esportJoinedList.value.data[index].isCompletedJoined(controller.esportJoinedList.value.data[index].id, controller.esportJoinedList.value.userRegistrations) ? "" : controller.esportJoinedList.value.data[index].getRoomName(controller.esportJoinedList.value.userRegistrations) : "--"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().whiteColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Fluttertoast.showToast(
                                      msg: "Copied Succesfully");

                                  Clipboard.setData(ClipboardData(
                                      text:
                                          "${controller.esportJoinedList.value.data[index].rounds != null && controller.esportJoinedList.value.data[index].rounds.length > 0 && controller.esportJoinedList.value.userRegistrations != null && controller.esportJoinedList.value.userRegistrations.length > 0 ? controller.esportJoinedList.value.data[index].getRoomName(controller.esportJoinedList.value.userRegistrations) : "--"}"));
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    "assets/images/ic_copy.webp",
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Details will be shared 15 mins before the game starts",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().whiteColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
          ),
          GestureDetector(
            onTap: () async {
              if (controller.esportJoinedList.value.data[index].affiliate !=
                  null) {
                if (controller.esportJoinedList.value.data[index]
                    .isSoloContest()) {
                  var res = await controller.getRegistrationMemberJoinedCheck(
                      controller.esportJoinedList.value.data[index].id,
                      gameid,
                      url,
                      controller.esportJoinedList.value.data[index]);
                } else {
                  var res =
                      await controller.getRegistrationMemberJoinedCheckTeamType(
                          controller.esportJoinedList.value.data[index].id,
                          gameid,
                          url,
                          controller.esportJoinedList.value.data[index]);
                }
              } else {
                Get.to(() => JoinedBattlesDetails(gameid, url,
                    controller.esportJoinedList.value.data[index].id));
              }
            },
            child: Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, bottom: 12, top: 12),
              alignment: Alignment.center,
              decoration: controller
                              .esportJoinedList.value.data[index].affiliate !=
                          null &&
                      !controller.esportJoinedList.value.data[index]
                          .isCompletedJoined(
                              controller.esportJoinedList.value.data[index].id,
                              controller
                                  .esportJoinedList.value.userRegistrations)
                  ? BoxDecoration(
                      color: AppColor().colorPrimary,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)))
                  : BoxDecoration(
                      color: AppColor().whiteColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
              child: Text(
                "${controller.esportJoinedList.value.data[index].affiliate != null && !controller.esportJoinedList.value.data[index].isCompletedJoined(controller.esportJoinedList.value.data[index].id, controller.esportJoinedList.value.userRegistrations) ? "PENDING" : "View All Contest Details"}",
                style: TextStyle(
                    color: controller.esportJoinedList.value.data[index]
                                    .affiliate !=
                                null &&
                            !controller.esportJoinedList.value.data[index]
                                .isCompletedJoined(
                                    controller
                                        .esportJoinedList.value.data[index].id,
                                    controller.esportJoinedList.value
                                        .userRegistrations)
                        ? AppColor().whiteColor
                        : AppColor().colorPrimary,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _Button(BuildContext context, String values, String event_id,
      String team_id, ContestModel contestModel) {
    return GestureDetector(
      onTap: () {
        if (values == "CONFIRM") {
          if (_contestModel != null) {
            if (_contestModel.affiliate != null) {
              Navigator.pop(context);
              Get.to(() => Affiliated(
                  contestModel,
                  _contestModel.isSoloContest(),
                  controller.selected_team_id.value,
                  false));
            } else {
              getJoinEvent(event_id, "", controller.user_id);
              Navigator.pop(context);
            }
          } else {
            getJoinEvent(event_id, "", controller.user_id);
            Navigator.pop(context);
          }
        } else if (values == "Submit") {
          if (controller.selected_team.value.isEmpty) {
            Utils.showCustomTosst("Please select Team for join");
            return;
          } else if (controller.selected_team_id.value.isEmpty) {
            Utils.showCustomTosst("Please select Team for join");
            return;
          } else {
            if (_contestModel != null) {
              if (_contestModel.affiliate != null) {
                Navigator.pop(context);
                Get.to(() => Affiliated(
                    contestModel,
                    _contestModel.isSoloContest(),
                    controller.selected_team_id.value,
                    false));
              } else {
                getJoinEvent(event_id, team_id, "");
                Navigator.pop(context);
              }
            } else {
              getJoinEvent(event_id, team_id, "");
              Navigator.pop(context);
            }

            // Fluttertoast.showToast(msg: "Team Type");
          }
        } else {
          var mapD = controller.getINGamePost(event_id);
          if (mapD != null) {
            Fluttertoast.showToast(msg: mapD.toString());
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(msg: "some error");
          }
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 34),
          height: 50,
          width: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(ImageRes().submit_bg)),
            // color: AppColor().colorPrimary,
          ),
          child: Center(
            child: Text(
              values,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
            ),
          )),
    );
  }

  Widget _editTitleTextField(
      TextEditingController controllerV, String text, String values) {
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      margin: EdgeInsets.symmetric(horizontal: 35),
      height: 50,
      child: TextField(
        style: TextStyle(color: AppColor().whiteColor),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColor().whiteColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            hintText: "${text}"),
        onChanged: (textv) {
          controller.mapKey[text] = textv;
          Utils().customPrint("First text field: $textv");
        },
        autofocus: false,
        controller: controllerV,
      ),
    );
  }

  Widget customFieldBox(
      String title, String key, var regex, String typeCondition) {
    var textEditingController =
        TextEditingController(text: controller.mapKey[key]);
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.4),
                borderRadius: BorderRadius.circular(4)),
            child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(regex)),
                  FilteringTextInputFormatter.deny(RegExp(","))
                ],
                textCapitalization: TextCapitalization.sentences,
                keyboardType: (typeCondition.compareTo("email") == 0)
                    ? TextInputType.emailAddress
                    : TextInputType.name,
                controller: textEditingController,
                onChanged: (val) {
                  TextSelection previousSelection =
                      textEditingController.selection;
                  controller.mapKey[key] = val;
                  textEditingController.selection = previousSelection;
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                textInputAction: (typeCondition.compareTo("email") == 0)
                    ? TextInputAction.done
                    : TextInputAction.next),
          ),
        ],
      ),
    );
  }

  void showInGameDialog(BuildContext context, String game_id) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      // barrierColor: Colors.black.withOpacity(0.5),

      // barrierColor: Colors.transparent,
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 375,
            width: 1080,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().new_rectangle_box_blank)),
            ),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "   ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "Game Name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      new IconButton(
                          icon: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "InGameName",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _editTitleTextField(
                      controller.inGameName,
                      "Enter your InGameName",
                      controller.inGameCheckModel.value != null
                          ? controller.inGameCheckModel.value.inGameName
                          : ""),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "InGameID",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _editTitleTextField(
                      controller.iNGameId,
                      "Enter your InGameID",
                      controller.inGameCheckModel.value != null
                          ? controller.inGameCheckModel.value.inGameId
                          : ""),
                  SizedBox(
                    height: 35,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.inGameCheckModel.value != null) {
                        // Fluttertoast.showToast(msg:"Updated");
                        var mapD = controller.updateIngameId();
                        if (mapD != null) {
                          Fluttertoast.showToast(msg: "Updated successfully");
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(msg: "some error");
                        }
                      } else {
                        var mapD = controller.addIngameId(game_id);
                        if (mapD != null) {
                          Fluttertoast.showToast(
                              msg: "ingame added successfully");
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(msg: "some error");
                        }
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 34),
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().submit_bg)),
                          // color: AppColor().colorPrimary,
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            controller.inGameCheckModel.value != null
                                ? "UPDATE"
                                : "SUBMIT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal,
                                color: Colors.white),
                          ),
                        )),
                  ),

                  /*   game_id.compareTo("63495e301de830d4d3ab60cf") ==0?  */
                  // staging ludo king id
                  AppString.gameName != null &&
                          AppString.gameName.compareTo("LUDO KING") == 0
                      ? InkWell(
                          onTap: () {
                            showInGameImages(context);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "How to Join ludo king contest",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimary),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        )
                      : Text(""),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  void showInGameImages(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 635,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(ImageRes().ludo_king_bg)),
            ),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "   ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      new IconButton(
                          icon: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Container(
                    height: 500,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/images/how_to_play_ludo_king.png"))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        ///checks if the app is installed on your mobile device
                        bool isInstalled =
                            await DeviceApps.isAppInstalled('com.ludo.king');
                        if (isInstalled) {
                          Utils().customPrint('open ludo...IF');
                          DeviceApps.openApp("com.ludo.king");
                        } else {
                          Utils().customPrint('open ludo...ELSE');

                          ///if the app is not installed it lunches google play store so you can install it from there
                          Utils.launchURLApp(
                              "market://details?id=" + "com.ludo.king");
                        }
                      } catch (e) {
                        Utils().customPrint(e);
                        Utils().customPrint('open ludo...E');
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 34),
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColor().colorPrimary,
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            "Open Ludo King",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  void teamTypeCreate(BuildContext context, String event_id) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(ImageRes().new_rectangle_box_blank)),
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "   ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                          Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                          new IconButton(
                              icon: new Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                      controller.teamlist.value.data.length >= 2
                          ? Text(
                              "Select Team",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  color: Colors.white),
                            )
                          : Container(
                              height: 0,
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      spinnerTeam(),
                      SizedBox(
                        height: 20,
                      ),
                      controller.teamlist.value.data.length > 0
                          ? _Button(
                              context, "Submit", event_id, "", _contestModel)
                          : Container(
                              height: 0,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      controller.teamlist.value.data.length > 0
                          ? Text(
                              "OR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            )
                          : Container(
                              height: 0,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => TeamManagementNew());
                            //showCreateTeam(context);
                            //showCustomDialog(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColor().whiteColor,
                            radius: 40,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  ImageRes().rectangle_orange_gradient_box),
                              radius: 39,
                              child: Center(
                                  child: Image.asset(
                                "assets/images/ic_create_tem_upload.webp",
                                color: Colors.white,
                                height: 30,
                              )),
                            ),
                          ) /*CircleAvatar(
                          backgroundColor: AppColor().whiteColor,
                          radius: 40,
                          child: CircleAvatar(
                            backgroundColor: AppColor().reward_card_bg,
                            radius: 39,
                            child: Center(
                                child: Image.asset(
                              "assets/images/ic_create_tem_upload.webp",
                              color: Colors.white,
                              height: 30,
                            )),
                          ),
                        ),*/
                          ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: Text(
                          "Create Team".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Roboto",
                              color: AppColor().whiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showWinningBreakupDialog(BuildContext context, ContestModel model) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "WINNING BREAKUP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                        ),
                        new IconButton(
                            icon: new Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Total Amount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    model.winner.customPrize != null &&
                            model.winner.customPrize.isNotEmpty
                        ? Text(
                            "${model.winner.customPrize}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        : model.winner.prizeAmount != null &&
                                model.winner.prizeAmount.type
                                        .compareTo("bonus") ==
                                    0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Container(
                                      height: 20,
                                      child: Image.asset(ImageRes().ic_coin),
                                    ),
                                    Text(
                                      "${model.winner.prizeAmount != null ? model.winner.prizeAmount.value : "-"}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          color: AppColor().colorPrimary),
                                    )
                                  ])
                            : Text(
                                "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${model.winner.prizeAmount != null ? model.winner.prizeAmount.value ~/ 100 : "-"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimary),
                              ),

                    /*   Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(model.winner.prizeAmount != null ? model.winner.prizeAmount.value ~/ 100 : "--")}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        color: AppColor().colorPrimary,
                      ),
                    ),*/
                    model.rankAmount != null && model.rankAmount.length > 0
                        ? ListView.builder(
                            itemCount: model.rankAmount.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              return winnerList(
                                  context, index, model.rankAmount);
                            })
                        : Container(
                            height: 0,
                          )
                  ],
                ),
              ),
            ],
          );
        });
  }

  void showbottomsheetfilter(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColor().reward_grey_bg,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              color: Colors.white),
                        ),
                        new IconButton(
                            icon: new Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "SORT & FILTER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.fillter_map_type.value = "";
                            controller.fillter_price_range.value = "";
                            controller.fillter_time.value = "";
                            controller.getESportsEventList(gameid);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              "CLEAR ALL",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Time",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.fillter_time.value = "All";
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  "All",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                decoration: controller.fillter_time.value ==
                                        "All"
                                    ? BoxDecoration(
                                        color: AppColor().colorPrimary,
                                        borderRadius: BorderRadius.circular(10))
                                    : BoxDecoration(
                                        border: Border.all(
                                            color: AppColor().colorGray,
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              controller.fillter_time.value = "Today";
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "Today",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                              decoration: controller.fillter_time.value ==
                                      "Today"
                                  ? BoxDecoration(
                                      color: AppColor().colorPrimary,
                                      borderRadius: BorderRadius.circular(10))
                                  : BoxDecoration(
                                      border: Border.all(
                                          color: AppColor().colorGray,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                            ),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              controller.fillter_time.value = "Tomorrow";
                              Utils().customPrint(1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "Tomorrow",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                              decoration: controller.fillter_time.value ==
                                      "Tomorrow"
                                  ? BoxDecoration(
                                      color: AppColor().colorPrimary,
                                      borderRadius: BorderRadius.circular(10))
                                  : BoxDecoration(
                                      border: Border.all(
                                          color: AppColor().colorGray,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                            ),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: AppColor().colorGray,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Text(
                        "Map",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Obx(
                      () => Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 40,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.mapMopdelR.value != null &&
                                    controller.mapMopdelR.value.data != null &&
                                    controller.mapMopdelR.value.data.length > 0
                                ? controller.mapMopdelR.value.data.length
                                : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return mapList(context, index);
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: AppColor().colorGray,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Prize Range",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.fillter_price_range.value = "1";
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  "Rs 0 - Rs 100",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                decoration:
                                    controller.fillter_price_range.value == "1"
                                        ? BoxDecoration(
                                            color: AppColor().colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(10))
                                        : BoxDecoration(
                                            border: Border.all(
                                                color: AppColor().colorGray,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.fillter_price_range.value = "2";
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  "Rs 101 - Rs 500",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                decoration:
                                    controller.fillter_price_range.value == "2"
                                        ? BoxDecoration(
                                            color: AppColor().colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(10))
                                        : BoxDecoration(
                                            border: Border.all(
                                                color: AppColor().colorGray,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.fillter_price_range.value = "3";
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  "Rs 501 - Rs 1000",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                decoration:
                                    controller.fillter_price_range.value == "3"
                                        ? BoxDecoration(
                                            color: AppColor().colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(10))
                                        : BoxDecoration(
                                            border: Border.all(
                                                color: AppColor().colorGray,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.fillter_price_range.value = "4";
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  "Rs 1001 - Rs 5000",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                decoration:
                                    controller.fillter_price_range.value == "4"
                                        ? BoxDecoration(
                                            color: AppColor().colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(10))
                                        : BoxDecoration(
                                            border: Border.all(
                                                color: AppColor().colorGray,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.getESportsEventList(gameid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 45,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor().colorPrimary),
                        child: Text(
                          "APPLY FILTERS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget mapList(BuildContext context, int index) {
    return Obx(() => Center(
            child: GestureDetector(
          onTap: () {
            controller.fillter_map_type.value = index.toString();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              controller.mapMopdelR.value.data[index].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, fontFamily: "Inter", color: Colors.white),
            ),
            decoration: controller.fillter_map_type.value == index.toString()
                ? BoxDecoration(
                    color: AppColor().colorPrimary,
                    borderRadius: BorderRadius.circular(10))
                : BoxDecoration(
                    border: Border.all(color: AppColor().colorGray, width: 1),
                    borderRadius: BorderRadius.circular(10)),
          ),
        )));
  }

  spinnerTeam() {
    return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 1),
        child: Obx(() => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor().whiteColor, width: 1),
              ),
              child: controller.teamlist.value.data.length > 0
                  ? Obx(
                      () => DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: AppColor().colorGray,
                        onChanged: (String value) {
                          Utils().customPrint("select team== ${value}");
                          controller.selected_team.value = value;
                          for (var i in controller.teamlist.value.data) {
                            if (i.name == value) {
                              Utils().customPrint("${i.id}");
                              controller.selected_team_id.value = i.id;
                            }
                          }
                        },
                        underline: const SizedBox(),
                        hint: Center(
                          child: controller.teamlist.value.data.length > 1
                              ? Text(
                                  "Select Game",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  "You are not the captain of any team",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        value: controller.teamlist.value.data[0].name,
                        items: controller.teamlist.value.data.map((value) {
                          return DropdownMenuItem(
                            value: value.name,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                value.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Center(
                      child: Text(
                        "You are not the captain of any team",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            )));
  }

  void showCustomDialogHowToPlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile_bg.webp"),
                fit: BoxFit.cover,
              ),
            ),
            child: Card(
              color: Colors.transparent,
              child: Wrap(
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            "How to Play".tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                        ),
                        new IconButton(
                            icon: new Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .89,
                    child: WebView(
                        initialUrl: this.howToPlay,
                        javascriptMode: JavascriptMode.unrestricted),
                  )
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  void showCustomDialogContestInfo(
      BuildContext context, ContestModel esportEventListModel1) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/gmng_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Card(
            color: Colors.transparent,
            child: Wrap(
              children: [
                Container(
                  height: 30,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/store_top.png"))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "${esportEventListModel1.name}".capitalize,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                              color: Colors.white),
                        ),
                      ),
                      new IconButton(
                          icon: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/gmng_bg.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                          ),
                          Container(
                            child: Text(
                              "Overview",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Clan",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                Container(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (!esportEventListModel1
                                        .getClanLink()
                                        .isEmpty) {
                                      base_controller.launchURLApp(
                                          esportEventListModel1.getClanLink());
                                    } else {}
                                  },
                                  child: Text(
                                    '${!esportEventListModel1.getClanLink().isEmpty ? esportEventListModel1.getClanLink() : "-"}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                        color: AppColor().colorPrimary),
                                  ),
                                ),
                                Container(
                                  height: 5,
                                ),
                                Text(
                                  "Get Access Code",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                Text(
                                  "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                Text(
                                  "Watch Stream",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                Container(
                                  height: 5,
                                ),
                                Text(
                                  "Will be shared 15 minutes before the contest start ",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: AppColor().colorPrimary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                          esportEventListModel1.rules != null
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Html(
                                    data: esportEventListModel1.getRules() ??
                                        "Rules",
                                    style: {
                                      "body": Style(
                                          fontSize: FontSize(14.0),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                      "p": Style(
                                        fontSize: FontSize(14.0),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    },
                                  ),
                                )
                              : Text(
                                  "Rules".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                          Container(
                            height: 35,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 0),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  void showCreateTeam(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
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
            height: 450,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Create Team".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              color: Colors.white),
                        ),
                      ),
                      new IconButton(
                          icon: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AppColor().whiteColor,
                    radius: 40,
                    child: CircleAvatar(
                      backgroundColor: AppColor().colorGray,
                      radius: 39,
                      child: Center(
                          child: Image.asset(
                        "assets/images/ic_create_tem_upload.webp",
                        color: Colors.white,
                        height: 30,
                      )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "Team Name",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  _editTitleTextField(controller.teamName, "Team Name", ""),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "Game",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  spinnerGameList(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "No. of Player",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  spinnerTeam(),
                  SizedBox(
                    height: 15,
                  ),
                  _Button(context, "Create", "", "", null),
                  SizedBox(
                    height: 0,
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  spinnerGameList() {
    return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 1),
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor().whiteColor, width: 1),
            ),
            child: gameType_controller.esports_model_v.value != null
                ? DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: AppColor().colorGray,
                    onChanged: (String value) {
                      gameType_controller.selectedValueGame.value = value;
                      for (var i
                          in gameType_controller.esports_model_v.value.data) {
                        if (i.name == value) {
                          gameType_controller.teamTypeId.value = i.id;

                          Fluttertoast.showToast(
                              msg: gameType_controller.teamTypeId.value);
                        }
                      }
                    },
                    underline: const SizedBox(),
                    hint: Text(
                      "Select Game",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: gameType_controller.selectedValueGame.value,
                    items: gameType_controller.esports_model_v.value.data
                        .map((value) {
                      return DropdownMenuItem(
                        value: value.name,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : Text(
                    "Select Game",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ));
  }

  void showCheckPassword(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
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
            height: 300,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "   ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "Verify Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      new IconButton(
                          icon: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "Enter password",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  _editTitleTextField(
                      controller.password, "Enter password", ""),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      getCheckEventVerify(context);
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 34),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor().colorPrimary,
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            'SUBMIT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /*api handler */
  Future getUserDatils(BuildContext context) async {
    _preferences = await SharedPreferences.getInstance();
    token = _preferences.getString("token");
    user_id = _preferences.getString("user_id");
    this.context = context;
  }

  Future<Map> getCheckEventVerify(BuildContext context) async {
    Utils().customPrint("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${user_id}");
    Utils().customPrint("password ===> ${controller.mapKey["Enter password"]}");
    final param = {"password": controller.mapKey["Enter password"]};
    //showProgress(context, "", true);
    showProgress(context);
    /*  progressDialog1 = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    await progressDialog1.show();
    Fluttertoast.showToast(msg: "getCheckEventVerify");*/
    final response_final =
        await WebServicesHelper().getCheckEventVerify(param, token, contest_id);
    ;
    Navigator.pop(context);
    //progressDialog1.hide();
    if (response_final.statusCode == 200) {
      Navigator.pop(context);
      getPreJoinEvent(contest_id);
    } else {
      Map<String, dynamic> response =
          json.decode(response_final.body.toString());
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    }
  }

  //get team list

  Future<Map> getUserTeamList(
      String teamTypeId, String gameId, bool isCaptain) async {
    controller.teamlist.value = null;
    Map<String, dynamic> response = await WebServicesHelper()
        .getUserTeamForJoinContest(
            token, user_id, teamTypeId, gameId, true, "active");
    if (response != null) {
      controller.teamlist.value = TeamGetModelR.fromJson(response);
      if (controller.teamlist.value.data.length > 0) {
        controller.selected_team.value = controller.teamlist.value.data[0].name;
        controller.selected_team_id.value =
            controller.teamlist.value.data[0].id;
      }
      Utils()
          .customPrint("Size of team ${controller.teamlist.value.data.length}");
      teamTypeCreate(context, _contestModel.id);
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
    return response;
  }

  Future<Map> getJoinEvent(
      String event_id, String team_id, String userid) async {
    // Map<String, dynamic> response;
    if (_contestModel != null) {
      var param = {};

      if (_contestModel.isSoloContest()) {
        param = {"userId": user_id, "teamId": "", "memberIds": []};

        final response_final =
            await WebServicesHelper().getEventJoin(param, token, event_id);

        if (response_final != null && response_final.statusCode == 200) {
          Fluttertoast.showToast(msg: "Event joined Succesfully");
          base_controller.checkTr.value = false;
          base_controller.colorPrimary.value = Color(0xFFffffff);
          base_controller.colorwhite.value = Color(0xFFe55f19);
          controller.getJoinedContestList(gameid);
          controller.getESportsEventList(gameid);
          LogeventJoined();
        } else {
          Map<String, dynamic> response =
              json.decode(response_final.body.toString());
          AppBaseResponseModel appBaseErrorModel =
              AppBaseResponseModel.fromMap(response);
          Utils().showErrorMessage("", appBaseErrorModel.error);
        }
      } else {
        if (!controller.selected_team.value.isEmpty) {
          param = {
            "userId": "",
            "teamId": controller.selected_team_id.value,
            "memberIds": []
          };
          final response_final =
              await WebServicesHelper().getEventJoin(param, token, event_id);

          if (response_final != null && response_final.statusCode == 200) {
            Fluttertoast.showToast(msg: "Event joined Succesfully");
            base_controller.checkTr.value = false;
            base_controller.colorPrimary.value = Color(0xFFffffff);
            base_controller.colorwhite.value = Color(0xFFe55f19);
            controller.getJoinedContestList(gameid);
            controller.getESportsEventList(gameid);
            LogeventJoined();
          } else {
            Map<String, dynamic> response =
                json.decode(response_final.body.toString());
            AppBaseResponseModel appBaseErrorModel =
                AppBaseResponseModel.fromMap(response);
            Utils().showErrorMessage("", appBaseErrorModel.error);
          }
        }
      }
    }
  }

  void LogeventJoined() {
    Map<String, Object> map = new Map<String, Object>();
    map["USER_ID"] = controller.user_id;
    map["Game Name"] = _contestModel.name;
    map["Buyin Amount"] = _contestModel.entry.fee.value > 0
        ? _contestModel.entry.fee.value ~/ 100
        : "Free";
    map["Bonus Application"] = "";
    map["Prize Pool"] = "";

    map["BONUS_CASH"] = preJoinResponseModel.bonus.value ~/ 100;
    map["WINNING_CASH"] = preJoinResponseModel.winning.value ~/ 100;
    map["DEPOSITE_CASH"] = preJoinResponseModel.deposit.value ~/ 100;
    map["is_Affilate"] = _contestModel.affiliate != null ? "yes" : "No";
    map["is_championship"] =
        _contestModel.type.compareTo("championship") == 0 ? "yes" : "No";
/*
   */
/* String bifurcation="${preJoinResponseModel.bonus.value ~/ 100},${preJoinResponseModel.winning.value ~/ 100},${preJoinResponseModel.deposit.value ~/ 100}";
    Map<String, Object> map1 = new Map<String, Object>();

    map1["Event Name"] = _contestModel.name;
    map1["amount"] = _contestModel.entry.fee.value > 0
        ? _contestModel.entry.fee.value ~/ 100
        : "Free";

    map1["Event Id"] = _contestModel.id;

    map1["wallet bifurcation"] =bifurcation ;*/

    cleverTapController.logEventCT(
        EventConstant.ESports_CLEAVERTAB_Joined_Contest, map);
    cleverTapController.logEventCT(EventConstant.EVENT_Joined_Contest, map);

    //FIREBASE EVENT
    FirebaseEvent().firebaseEvent(EventConstant.EVENT_Joined_Contest_F, map);

    /*   cleverTapController.logEventCT(
        EventConstant.ESports_CLEAVERTAB_Joined_Contest, map1);*/

    map["Game_id"] = gameid;
    map["Game Category"] = _contestModel.name;
    map["Game Id"] = _contestModel.id;

    appsflyerController.logEventAf(
        EventConstant.ESports_CLEAVERTAB_Joined_Contest, map);

    appsflyerController.logEventAf(EventConstant.EVENT_Joined_Contest, map);

    FaceBookEventController()
        .logEventFacebook(EventConstant.ESports_CLEAVERTAB_Joined_Contest, map);

  }

  Widget winnerList(BuildContext context, int index, List<RankAmount> list) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${list[index].getRank()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),
                list[index].custom != null && list[index].custom.isNotEmpty
                    ? Text(
                        "${list[index].custom}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      )
                    : list[index].amount != null &&
                            list[index].amount.type.compareTo("bonus") == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Container(
                                  height: 20,
                                  child: Image.asset(ImageRes().ic_coin),
                                ),
                                Text(
                                  "${list[index].amount != null ? list[index].amount.value : "-"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: AppColor().colorPrimary),
                                )
                              ])
                        : Text(
                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${list[index].amount.value ~/ 100}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                /*   Text(
                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${list[index].amount.value ~/ 100}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),*/
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            )
          ],
        ));
  }

  Widget listShimmer() {
    return Column(
      children: [
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13)),
          ),
        ),
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor().colorPrimary,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(13),
                bottomRight: Radius.circular(13)),
            //borderRadius: BorderRadius.circular(8),
          ),
          height: 50,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }

  showProgress(BuildContext context) async {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 100,
            width: 100,

            color: Colors.transparent,
            child: Image(
                height: 100,
                width: 100,
                //color: Colors.transparent,
                fit: BoxFit.fill,
                image: AssetImage("assets/images/progresbar_images.gif")),

            //image:AssetImage("assets/images/progresbar_images.gif")),
          ),
        );
      },
    );
  }

  Future<Map> getPreJoinEvent(String event_id) async {
    Utils().customPrint("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${user_id}");

    Utils().customPrint("game id ludo king ===> ${gameid}");
    final param = {"userId": user_id};
    // showProgress(context, "", true);
    showProgress(context);

    Map<String, dynamic> response =
        await WebServicesHelper().getPreEventJoin(param, token, event_id);
    Utils().customPrint(' respone is finaly ${response}');
    Navigator.pop(context);
    if (response != null && response['statusCode'] == null) {
      Utils().customPrint(' respone is finaly1 ${response}');
      preJoinResponseModel = PreJoinResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          //Fluttertoast.showToast(msg: "Please add Amount.");
          //Get.offAll(() => DashBord(4, ""));
          AppString.contestAmount = contestAmountLocal;
          Utils().alertInsufficientBalance(context);
          Utils()
              .customPrint('contestAmount esport ${AppString.contestAmount}');
        } else {
          Utils().customPrint('datta----1');
          if (_contestModel != null && !_contestModel.isSoloContest()) {
            Utils().customPrint('datta----1');
            getUserTeamList(_contestModel.teamTypeId.id, gameid, true);
          } else {
            Utils().customPrint('datta----2');
            showPreJoinBox(
                context, event_id, preJoinResponseModel, _contestModel);
          }
        }
      } else {
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(response);
        Utils().showErrorMessage("", appBaseErrorModel.error);
      }
    } else if (response['statusCode'] != 400) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else if (response['statusCode'] != 500) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else {
      // hideLoader();
      Utils().customPrint('respone is finaly2${response}');
      //hideLoader();
    }
  }

  void showPreJoinBox(BuildContext context, String event_id,
      PreJoinResponseModel preJoinResponseModel, ContestModel _contestModel) {
    var areYouPaying =
        "${((preJoinResponseModel.deposit.value + preJoinResponseModel.winning.value) / 100) + preJoinResponseModel.bonus.value}";

    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
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
            height: 370,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Text(
                    "CONFIRM",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Roboto",
                        color: AppColor().colorPrimary),
                  ),
                  Text(
                    "CHARGES",
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
                          child: Text("ENTRY FEE",
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
                              child:
                                  Image.asset("assets/images/bonus_coin.png"),
                            ),
                            Text(
                                //"${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${'0'}",
                                _contestModel.entry.fee.type == "bonus"
                                    ? _contestModel.entry.fee.value.toString()
                                    : "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} "
                                        "${_contestModel.entry.fee.value > 0 ? _contestModel.entry.fee.value ~/ 100 : "Free"}",
                                style: TextStyle(color: AppColor().whiteColor))
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
                          child: Text("You are paying",
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
                              child:
                                  Image.asset("assets/images/bonus_coin.png"),
                            ),
                            Text(
                              "$areYouPaying",
                              //${preJoinResponseModel.deposit.value ~/ 100}
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
                    width: MediaQuery.of(context).size.width,
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
                          child: Text("From Bonus Cash",
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
                              child:
                                  Image.asset("assets/images/bonus_coin.png"),
                            ),
                            Text(
                                "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${preJoinResponseModel.bonus.value}",
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
                          child: Text("From Deposited Cash & Winning Cash",
                              maxLines: 2,
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
                                "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(preJoinResponseModel.deposit.value + preJoinResponseModel.winning.value) ~/ 100}",
                                style: TextStyle(color: AppColor().whiteColor))
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _Button(context, "CONFIRM", event_id, "", _contestModel),
                  SizedBox(
                    height: 0,
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }
}
