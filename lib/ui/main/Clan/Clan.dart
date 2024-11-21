import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/BaseController.dart';
import 'package:gmng/ui/controller/ClanController.dart';
import 'package:gmng/ui/main/esports/JoinedBattlesDetails.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../../model/ESportsEventList.dart';
import '../../../model/InGame/InGameCheck.dart';
import '../../../model/ProfileModel/TeamGetModelR.dart';
import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../model/responsemodel/PreJoinResponseModel.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../dialog/helperProgressBar.dart';
import '../team_management/TeamManagementNew.dart';

class Clan extends StatelessWidget {
  Clan({Key key}) : super(key: key);
  ClanController controller = Get.put(ClanController());
  BaseController base_controller = Get.put(BaseController());
  PreJoinResponseModel preJoinResponseModel = null;
  ContestModel _contestModel = null;
  String token = "", user_id = "";
  var contest_id = "";
  var gameid = "";
  SharedPreferences _preferences;
  BuildContext context;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    getUserDatils(context);

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/store_back.png"))),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () async {});
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Wrap(
            children: [
              SizedBox(
                height: 100,
              ),

              Container(
                color: AppColor().reward_card_bg,
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 0),
                      height: 40,
                      width: MediaQuery.of(context).size.width * .87,
                      child: Row(
                        children: [
                          Expanded(
                              child: Obx(
                            () => InkWell(
                              onTap: () {
                                controller.allClan.value = true;
                                OnchagesTabClan("All");
                              },
                              child: Container(
                                decoration: controller.allClan.value == true
                                    ? BoxDecoration(
                                        color: AppColor().clan_header_dark,
                                        //color:Colors.transparent,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)))
                                    : null,
                                alignment: Alignment.center,
                                child: Text(
                                  "All clan".tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                            child: Obx(
                              () => InkWell(
                                onTap: () {
                                  controller.matches.value = true;
                                  controller.allClan.value = false;
                                  OnchagesTabClan("Joind Clan");
                                },
                                child: Container(
                                  decoration: controller.allClan.value == true
                                      ? null
                                      : BoxDecoration(
                                          color: AppColor().clan_header_dark,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                  alignment: Alignment.center,
                                  child: Text("Joined clan".tr,
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: PopupMenuButton(
                        icon: Center(
                            child: Image(
                                height: 20,
                                color: AppColor().whiteColor,
                                image: AssetImage(ImageRes().dots))),
                        onSelected: (newValue) {
                          Utils().customPrint('${newValue}');
                          if (newValue == 1) {
                            if (AppString.leaveClan.value == 'inactive') {
                              Fluttertoast.showToast(msg: 'Leave clan disable!');
                              return;
                            }
                            controller.userRemoveClan();
                          } else if (controller.selectedClan.value != null &&
                              newValue == 0) {
                            String text = "Join Clan - \"" +
                                controller.selectedClan.value.name +
                                "\" on GMNG \n" +
                                controller.selectedClan.value.shareUrl +
                                "\n";
                            Utils().funClan(text);
                            // Utils().funShare("");
                          } else {}
                          // add this property
                        },
                        itemBuilder: (context) => [
                          (controller.selectedClan.value != null &&
                                  controller.selectedClan.value.is_slected !=
                                      null &&
                                  controller.selectedClan.value.is_slected)
                              ? PopupMenuItem(
                                  height: 29,
                                  child: Text('Leave Clan'),
                                  value: 1,
                                )
                              : null,
                          (controller.selectedClan.value == null)
                              ? null
                              : PopupMenuItem(
                                  height: 29,
                                  child: Text('Share'),
                                  value: 0,
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => controller.allClan.value
                    ? Obx(() => (controller.clanList.value != null &&
                            controller.clanList.value.data != null &&
                            controller.clanList.value.data.length > 0)
                        ? Container(
                            color: AppColor().clan_header_dark,
                            padding: EdgeInsets.only(left: 6),
                            height: 88,
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.clanList.value.data !=
                                            null &&
                                        controller.clanList.value.data.length >
                                            0
                                    ? controller.clanList.value.data.length
                                    : 0,
                                itemBuilder: (context, index) {
                                  return Obx(
                                      () => ClanlistWidget(context, index));
                                }))
                        : Container())
                    : Obx(() => (controller.clanJoinedList.value != null &&
                            controller.clanJoinedList.value.data != null &&
                            controller.clanJoinedList.value.data.length > 0)
                        ? Container(
                            padding: EdgeInsets.only(left: 6),
                            height: 88,
                            color: AppColor().clan_header_dark,
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    controller.clanJoinedList.value.data !=
                                                null &&
                                            controller.clanJoinedList.value.data
                                                    .length >
                                                0
                                        ? controller
                                            .clanJoinedList.value.data.length
                                        : 0,
                                itemBuilder: (context, index) {
                                  return Obx(() =>
                                      joinedClanlistWidget(context, index));
                                }))
                        : Container(
                            margin: EdgeInsets.only(left: 6),
                            height: 88,
                            alignment: Alignment.center,
                            child: Text(
                              "No clans joined Please join a clan to view it here",
                              //"You haven't Joined any Clans Please Join A Clan to view it here.",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          )),
              ),

              Container(
                color: AppColor().clan_header_dark,
                child: Column(
                  children: [
                    Obx(
                      () => controller.allClan.value == false
                          ? (controller.clanJoinedList.value != null &&
                                  controller.clanJoinedList.value.data !=
                                      null &&
                                  controller.clanJoinedList.value.data.length >
                                      0)
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      (controller.selectedClan != null &&
                                              controller.selectedClan.value !=
                                                  null &&
                                              !controller.selectedClan.value
                                                  .name.isEmpty)
                                          ? controller.selectedClan.value.name
                                          : "",
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text("esports",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "BGMI",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        )),
                                  ],
                                )
                              : Container(
                                  height: 0,
                                )
                          : Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  (controller.selectedClan != null &&
                                          controller.selectedClan.value !=
                                              null &&
                                          !controller
                                              .selectedClan.value.name.isEmpty)
                                      ? controller.selectedClan.value.name
                                      : "",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text("esports",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      "BGMI",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    )),
                              ],
                            ),
                    ),
                    /*    SizedBox(
                      height: 8,
                    ),*/
                    Obx(() => controller.selectedClan.value != null
                        ? Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (controller.selectedClan.value == null)
                                      return;
                                    Utils.launchURLApp(controller
                                        .selectedClan.value
                                        .getvalidYouTubeLink());
                                  },
                                  child: Image(
                                      height: 25,
                                      width: 25,
                                      image: AssetImage(
                                          ImageRes().ic_clan_yooutube))),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (controller.selectedClan.value == null ||
                                        controller.selectedClan.value
                                            .getvalidInstagramLink()
                                            .isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Link not found");
                                      return;
                                    }

                                    Utils.launchURLApp(controller
                                        .selectedClan.value
                                        .getvalidInstagramLink());
                                  },
                                  child: Image(
                                      height: 20,
                                      image: AssetImage(
                                          ImageRes().ic_clan_instagarm))),
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (controller.selectedClan.value == null ||
                                        controller.selectedClan.value
                                            .getvalidDisCordUrl()
                                            .isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Link not found");
                                      return;
                                    }

                                    Utils.launchURLApp(controller
                                        .selectedClan.value
                                        .getvalidDisCordUrl());
                                  },
                                  child: Image(
                                      height: 20,
                                      image: AssetImage(
                                          ImageRes().ic_clan_discord))),
                              SizedBox(
                                width: 8,
                              ),
                              Image(
                                  height: 18,
                                  color: Colors.white,
                                  image: AssetImage(ImageRes().team_duo)),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                  (controller.selectedClan.value != null &&
                                          controller.selectedClan.value
                                                  .joinSummary !=
                                              null)
                                      ? controller
                                          .selectedClan.value.joinSummary.users
                                          .toString()
                                      : "0",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ],
                          )
                        : Container()),
                    /*  SizedBox(
                      height: 10,
                    ),*/
                    Obx(
                      () => controller.allClan.value == false
                          ? (controller.clanJoinedList.value != null &&
                                  controller.clanJoinedList.value.data !=
                                      null &&
                                  controller.clanJoinedList.value.data.length >
                                      0)
                              ? Container(
                                  margin: EdgeInsets.only(top: 0, left: 0),
                                  height: 40,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Obx(
                                        () => InkWell(
                                          onTap: () {
                                            controller.matches.value = true;
                                          },
                                          child: Container(
                                              decoration: controller.matches ==
                                                      true
                                                  ? BoxDecoration(
                                                      color: AppColor()
                                                          .reward_card_bg,
                                                      /* image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                            ImageRes().clan_back),
                                                      ),*/
                                                      // color: AppColor().clan_header_light,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)))
                                                  : null,
                                              alignment: Alignment.center,
                                              child: Text("Matches".tr,
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ),
                                      )),
                                      Expanded(
                                        child: Obx(
                                          () => InkWell(
                                            onTap: () {
                                              controller.matches.value = false;

                                              controller.colorPrimaryAllTime
                                                  .value = Color(0xFFe55f19);
                                              controller.colorwhiteMonthly
                                                  .value = Color(0xFFffffff);
                                              Utils().customPrint(
                                                  "slected clan is=>${controller.selectedClan.value.id}");
                                              controller.getLeaderBoardByClanid(
                                                  controller
                                                      .selectedClan.value.id,
                                                  "",
                                                  "all");
                                            },
                                            child: Container(
                                                decoration: controller
                                                            .matches ==
                                                        true
                                                    ? null
                                                    : BoxDecoration(
                                                        color: AppColor()
                                                            .reward_card_bg,
                                                        /*image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: AssetImage(
                                                              ImageRes().clan_back),
                                                        ),*/
                                                        /*color:
                                                      AppColor().clan_header_light,*/
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    "text_bottom_leader".tr,
                                                    style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 0,
                                )
                          : Container(
                              color: AppColor().clan_header_dark,
                              height: 40,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Obx(
                                    () => InkWell(
                                      onTap: () {
                                        controller.matches.value = true;
                                      },
                                      child: Container(
                                          decoration: controller.matches == true
                                              ? BoxDecoration(
                                                  color:
                                                      AppColor().reward_card_bg,
                                                  /*image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        ImageRes().clan_back),
                                                  ),*/
                                                  // color:Colors.transparent,
                                                  // color: AppColor().clan_header_light,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)))
                                              : null,
                                          alignment: Alignment.center,
                                          child: Text("Matches".tr,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                    ),
                                  )),
                                  Expanded(
                                    child: Obx(
                                      () => InkWell(
                                        onTap: () {
                                          controller.matches.value = false;
                                          controller.leaderboardMonth.value =
                                              true;
                                          controller.colorPrimaryAllTime.value =
                                              Color(0xFFe55f19);
                                          controller.colorwhiteMonthly.value =
                                              Color(0xFFffffff);
                                          Utils().customPrint(
                                              "slected clan is=>${controller.selectedClan.value.id}");
                                          controller.getLeaderBoardByClanid(
                                              controller.selectedClan.value.id,
                                              "",
                                              "all");
                                        },
                                        child: Container(
                                            decoration: controller.matches ==
                                                    true
                                                ? null
                                                : BoxDecoration(
                                                    color: AppColor()
                                                        .reward_card_bg,
                                                    /*image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                          ImageRes().clan_back),
                                                    ),*/
                                                    //   color: AppColor().clan_header_light,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                            alignment: Alignment.center,
                                            child: Text("text_bottom_leader".tr,
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                      ),
                                    ),
                                  )
                                ],
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
                () => controller.allClan.value == false
                    ? (controller.clanJoinedList.value != null &&
                            controller.clanJoinedList.value.data != null &&
                            controller.clanJoinedList.value.data.length > 0)
                        ? Visibility(
                            visible: controller.matches.value,
                            child: Stack(
                              children: [
                                Container(
                                  //height: 100,
                                  height:
                                      MediaQuery.of(context).size.height * .55,
                                  //  color: AppColor().clan_header_light,
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 35,
                                              bottom: 15,
                                              left: 10,
                                              right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () {
                                                  controller.checkTr.value =
                                                      true;
                                                  controller
                                                          .colorPrimary.value =
                                                      Color(0xFFe55f19);
                                                  controller.colorwhite.value =
                                                      Color(0xFFffffff);
                                                },
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "All Battles".tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          color: Colors.white),
                                                    ),
                                                    Obx(
                                                      () => Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        color: controller
                                                            .colorPrimary.value,
                                                        height: 3,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () {
                                                  controller.checkTr.value =
                                                      false;
                                                  controller
                                                          .colorPrimary.value =
                                                      Color(0xFFffffff);
                                                  controller.colorwhite.value =
                                                      Color(0xFFe55f19);
                                                  controller
                                                      .getJoinedContestList("");
                                                },
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Joined Battles".tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          color: Colors.white),
                                                    ),
                                                    Obx(
                                                      () => Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        color: controller
                                                            .colorwhite.value,
                                                        height: 3,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                        /* joined battales list */
                                        Obx(
                                          () => Offstage(
                                              offstage:
                                                  controller.checkTr.value,
                                              child: Obx(() => Container(
                                                  child: (controller.esportJoinedList != null &&
                                                          controller
                                                                  .esportJoinedList
                                                                  .value !=
                                                              null &&
                                                          controller
                                                                  .esportJoinedList
                                                                  .value
                                                                  .data !=
                                                              null)
                                                      ? controller
                                                                  .esportJoinedList
                                                                  .value
                                                                  .data
                                                                  .length >
                                                              0
                                                          ? ListView.builder(
                                                              itemCount: controller
                                                                  .esportJoinedList
                                                                  .value
                                                                  .data
                                                                  .length,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return joinedListView(
                                                                    context,
                                                                    index);
                                                              })
                                                          : null
                                                      : Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            height: 100,
                                                            width: 100,
                                                            color: Colors
                                                                .transparent,
                                                            child: Image(
                                                                height: 100,
                                                                width: 100,
                                                                //color: Colors.transparent,
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: AssetImage(
                                                                    "assets/images/progresbar_images.gif")),
                                                          ))))),
                                        ),
                                        Obx(
                                          () => Visibility(
                                              visible: controller.checkTr.value,
                                              child: Column(
                                                children: [
                                                  controller.esportEventListModel
                                                                  .value !=
                                                              null &&
                                                          controller
                                                                  .esportEventListModel
                                                                  .value
                                                                  .champaiship !=
                                                              null
                                                      ? controller
                                                                  .esportEventListModel
                                                                  .value
                                                                  .champaiship
                                                                  .length >
                                                              0
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      bottom: 0,
                                                                      right:
                                                                          15),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Championship",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            "Inter",
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "Swipe for more"
                                                                            .tr,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                "Inter",
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        //padding: EdgeInsets.all(),
                                                                        height:
                                                                            25,
                                                                        child: Image.asset(
                                                                            "assets/images/ic_right_now.webp"),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 0,
                                                            ) /*Center(
                                              child: Text(
                                                  "No Contests Available right now Please Come back later",
                                                  textAlign:
                                                  TextAlign
                                                      .center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                      "Inter",
                                                      color: Colors
                                                          .white)),
                                            )*/
                                                      : Container(
                                                          height: 0,
                                                        ),
                                                  Column(children: [
                                                    /*champain ship list*/
                                                    Obx(
                                                      () => controller
                                                                  .esportEventListModel
                                                                  .value !=
                                                              null
                                                          ? controller
                                                                          .esportEventListModel
                                                                          .value
                                                                          .champaiship
                                                                          .length >=
                                                                      1 &&
                                                                  controller
                                                                          .esportEventListModel
                                                                          .value
                                                                          .champaiship !=
                                                                      null
                                                              ? Container(
                                                                  height: 210,
                                                                  child: Obx(() => ListView
                                                                      .builder(
                                                                          itemCount: controller
                                                                              .esportEventListModel
                                                                              .value
                                                                              .champaiship
                                                                              .length,
                                                                          shrinkWrap:
                                                                              true,
                                                                          scrollDirection: Axis
                                                                              .horizontal,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            return championship(context,
                                                                                index);
                                                                          })),
                                                                )
                                                              : Container(
                                                                  height: 0,
                                                                )
                                                          : Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                height: 100,
                                                                width: 100,
                                                                color: Colors
                                                                    .transparent,
                                                                child: Image(
                                                                    height: 100,
                                                                    width: 100,
                                                                    //color: Colors.transparent,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    image: AssetImage(
                                                                        "assets/images/progresbar_images.gif")),
                                                              )),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Obx(() => controller
                                                                    .esportEventListModel
                                                                    .value !=
                                                                null &&
                                                            controller
                                                                    .esportEventListModel
                                                                    .value
                                                                    .data !=
                                                                null
                                                        ? controller
                                                                    .esportEventListModel
                                                                    .value
                                                                    .data
                                                                    .length >
                                                                0
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Contest"
                                                                          .tr,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              "Inter",
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Text("")
                                                        : Text("")),
                                                    //conest list
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 1,
                                                                bottom: 1,
                                                                right: 10,
                                                                left: 10),
                                                        child: Obx(
                                                          () => controller
                                                                      .esportEventListModel
                                                                      .value !=
                                                                  null
                                                              ? controller
                                                                          .esportEventListModel
                                                                          .value
                                                                          .data !=
                                                                      null
                                                                  ? ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  5,
                                                                              right:
                                                                                  1,
                                                                              left:
                                                                                  1,
                                                                              bottom:
                                                                                  1),
                                                                          itemCount: controller
                                                                              .esportEventListModel
                                                                              .value
                                                                              .data
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            return Contest(context,
                                                                                index);
                                                                            // return contest(context,index);
                                                                          })
                                                                  : Text("")
                                                              : Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: 0,
                                                                ),
                                                        ),
                                                      ),
                                                    ),

                                                    Container(
                                                      height: 50,
                                                    ),
                                                  ]),

                                                  //conest list
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 0,
                          )
                    : Visibility(
                        visible: controller.matches.value,
                        child: Stack(
                          children: [
                            Container(
                              //height: 100,
                              height: MediaQuery.of(context).size.height * .55,
                              // color: AppColor().clan_header_light,
                              color: Colors.transparent,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 35,
                                          bottom: 15,
                                          left: 10,
                                          right: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              controller.checkTr.value = true;
                                              controller.colorPrimary.value =
                                                  Color(0xFFe55f19);
                                              controller.colorwhite.value =
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
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    color: controller
                                                        .colorPrimary.value,
                                                    height: 3,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              controller.checkTr.value = false;
                                              controller.colorPrimary.value =
                                                  Color(0xFFffffff);
                                              controller.colorwhite.value =
                                                  Color(0xFFe55f19);
                                              controller
                                                  .getJoinedContestList("");
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
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    color: controller
                                                        .colorwhite.value,
                                                    height: 3,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                    /* joined battales list */
                                    Obx(
                                      () => Offstage(
                                          offstage: controller.checkTr.value,
                                          child: Obx(() => Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 90),
                                              child: (controller.esportJoinedList != null &&
                                                      controller
                                                              .esportJoinedList
                                                              .value !=
                                                          null &&
                                                      controller
                                                              .esportJoinedList
                                                              .value
                                                              .data !=
                                                          null)
                                                  ? controller
                                                              .esportJoinedList
                                                              .value
                                                              .data
                                                              .length >
                                                          0
                                                      ? ListView.builder(
                                                          itemCount: controller
                                                              .esportJoinedList
                                                              .value
                                                              .data
                                                              .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return joinedListView(
                                                                context, index);
                                                          })
                                                      : null
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        height: 100,
                                                        width: 100,
                                                        color:
                                                            Colors.transparent,
                                                        child: Image(
                                                            height: 100,
                                                            width: 100,
                                                            //color: Colors.transparent,
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                "assets/images/progresbar_images.gif")),
                                                      ))))),
                                    ),
                                    Obx(
                                      () => Visibility(
                                          visible: controller.checkTr.value,
                                          child: Column(
                                            children: [
                                              controller.esportEventListModel
                                                              .value !=
                                                          null &&
                                                      controller
                                                              .esportEventListModel
                                                              .value
                                                              .champaiship !=
                                                          null
                                                  ? controller
                                                              .esportEventListModel
                                                              .value
                                                              .champaiship
                                                              .length >
                                                          0
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Championship",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        "Inter",
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Swipe for more"
                                                                        .tr,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            "Inter",
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    //padding: EdgeInsets.all(),
                                                                    height: 25,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/images/ic_right_now.webp"),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Text("")
                                                  : Text(""),
                                              Column(children: [
                                                /*champianship ship list*/
                                                controller.esportEventListModel
                                                            .value !=
                                                        null
                                                    ? controller
                                                                    .esportEventListModel
                                                                    .value
                                                                    .champaiship !=
                                                                null &&
                                                            controller
                                                                    .esportEventListModel
                                                                    .value
                                                                    .champaiship
                                                                    .length >=
                                                                1
                                                        ? Container(
                                                            height: 210,
                                                            child: Obx(() => ListView
                                                                .builder(
                                                                    itemCount: controller
                                                                        .esportEventListModel
                                                                        .value
                                                                        .champaiship
                                                                        .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return championship(
                                                                          context,
                                                                          index);
                                                                    })),
                                                          )
                                                        : Container(
                                                            height: 0,
                                                          )
                                                    : Container(
                                                        height: 0,
                                                      ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Obx(() => controller
                                                                .esportEventListModel
                                                                .value !=
                                                            null &&
                                                        controller
                                                                .esportEventListModel
                                                                .value
                                                                .data !=
                                                            null
                                                    ? controller
                                                                .esportEventListModel
                                                                .value
                                                                .data
                                                                .length >
                                                            0
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Contest".tr,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "Inter",
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Text("")
                                                    : Text("")),
                                                //conest list
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 1,
                                                            bottom: 1,
                                                            right: 10,
                                                            left: 10),
                                                    child: Obx(
                                                      () => controller
                                                                  .esportEventListModel
                                                                  .value !=
                                                              null
                                                          ? controller
                                                                      .esportEventListModel
                                                                      .value
                                                                      .data !=
                                                                  null
                                                              ? ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          right:
                                                                              1,
                                                                          left:
                                                                              1,
                                                                          bottom:
                                                                              1),
                                                                      itemCount: controller
                                                                          .esportEventListModel
                                                                          .value
                                                                          .data
                                                                          .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int
                                                                                  index) {
                                                                        return Contest(
                                                                            context,
                                                                            index);
                                                                        // return contest(context,index);
                                                                      })
                                                              : Text("")
                                                          : Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 0),
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  height: 50,
                                                ),
                                              ]),

                                              //conest list
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(() => controller.allClan.value == true
                                ? (controller.allClan.value &&
                                        controller.selectedClan.value != null &&
                                        controller.selectedClan.value
                                                .is_slected !=
                                            null &&
                                        !controller
                                            .selectedClan.value.is_slected)
                                    ? Positioned(
                                        bottom: 25,
                                        right: 40,
                                        left: 40,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: controller.result.value == ""
                                              ? Container(
                                                  height: 0,
                                                )
                                              : SlidableButton(
                                                  initialPosition: SlidableButtonPosition.left,
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 50,
                                                  borderRadius: BorderRadius.circular(30),
                                                  border: Border.all(color:
                                                  AppString.joinClan.value == 'inactive'?AppColor().reward_grey_bg:AppColor().colorPrimary, width: 2),
                                                  color: AppColor().whiteColor,
                                                  buttonColor: Colors.transparent,
                                                  dismissible: false,
                                                  label: CircleAvatar(

                                                    child: Obx(() => controller
                                                                .result.value ==
                                                            ""
                                                        ? Image.asset(ImageRes()
                                                            .ic_kyc_apply,)
                                                        : Image.asset(ImageRes()
                                                            .ic_kyc_completed)),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      controller.result.value,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  onChanged: (position) {
                                                    if (position == SlidableButtonPosition.right) {
                                                      if (AppString.joinClan.value == 'inactive') {
                                                        Fluttertoast.showToast(msg: 'Join clan disable!');
                                                        return;
                                                      }
                                                      controller.result.value = '';
                                                      controller.UserJoinedClanApply();
                                                      //showKycDialog(context);
                                                    } else {
                                                      controller.result.value =
                                                          "Slide to join Clan".tr;
                                                    }
                                                  },
                                                ),
                                        ),
                                      )
                                    : Container()
                                : Container(
                                    height: 0,
                                  )),
                          ],
                        ),
                      ),
              ),

              // Leaderboard UI Call
              Obx(
                () => Offstage(
                  offstage: controller.matches.value,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .55,
                        //color: AppColor().clan_header_light,
                        color: Colors.transparent,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 35, bottom: 15, left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        controller.getLeaderBoardByClanid(
                                            controller.selectedClan.value.id,
                                            "",
                                            "all");
                                        controller.leaderboardMonth.value =
                                            true;
                                        controller.colorPrimaryAllTime.value =
                                            Color(0xFFe55f19);
                                        controller.colorwhiteMonthly.value =
                                            Color(0xFFffffff);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            "All Time".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Inter",
                                                color: Colors.white),
                                          ),
                                          Obx(
                                            () => Container(
                                              margin: EdgeInsets.only(top: 5),
                                              color: controller
                                                  .colorPrimaryAllTime.value,
                                              height: 3,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        controller.getLeaderBoardByClanid(
                                            controller.selectedClan.value.id,
                                            "",
                                            "monthly");
                                        controller.leaderboardMonth.value =
                                            true;
                                        controller.colorPrimaryAllTime.value =
                                            Color(0xFFffffff);
                                        controller.colorwhiteMonthly.value =
                                            Color(0xFFe55f19);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            "MONTHLY".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Inter",
                                                color: Colors.white),
                                          ),
                                          Obx(
                                            () => Container(
                                              margin: EdgeInsets.only(top: 5),
                                              color: controller
                                                  .colorwhiteMonthly.value,
                                              height: 3,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Obx(
                                () => Visibility(
                                    visible: controller.leaderboardMonth.value,
                                    child: Wrap(children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            bottom: 10,
                                            top: 5),
                                        padding: EdgeInsets.all(5),
                                        width: double.infinity,
                                        height: 250,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(ImageRes()
                                                    .leader_board_rank_back)),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Row(
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 55,
                                                  ),
                                                  Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            child: Image.asset(
                                                                "assets/images/ic_cron.png"),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            52)),
                                                            child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(MediaQuery.of(context).size.width *
                                                                                .13)
                                                                        /*BorderRadius
                                                                                .circular(
                                                                                50)*/
                                                                        ,
                                                                        border: Border
                                                                            .all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              AppColor().colorPrimary,
                                                                        )),
                                                                child: controller.user2 != null &&
                                                                        controller.user2.value !=
                                                                            null &&
                                                                        controller.user2.value.photo !=
                                                                            null &&
                                                                        controller.user2.value.photo.url !=
                                                                            null
                                                                    ? CircleAvatar(
                                                                        radius: MediaQuery.of(context).size.width *
                                                                            .12,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        backgroundImage:
                                                                            NetworkImage("${controller.user2.value.photo.url}"),
                                                                      )
                                                                    : CircleAvatar(
                                                                        radius: MediaQuery.of(context).size.width *
                                                                            .12,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        child:
                                                                            Image(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          image:
                                                                              AssetImage(ImageRes().team_group),
                                                                        ),
                                                                      )),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        // alignment: Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            top: 19,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .1),
                                                        child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                AppColor()
                                                                    .colorPrimary_light,
                                                            child: Text(
                                                              "2",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                  Obx(() => Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  ImageRes()
                                                                      .rank_amount_back)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 15,
                                                            vertical: 1,
                                                          ),
                                                          child: Text(
                                                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.user2 != null && controller.user2.value != null && controller.user2.value.amount != null ? controller.user2.value.amount.value ~/ 100 : "0"}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColor()
                                                                    .colorPrimary),
                                                          ),
                                                        ),
                                                      )),
                                                  Obx(
                                                    () => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 3),
                                                      child: Text(
                                                        "${controller.user2 != null && controller.user2.value != null ? controller.user2.value.username : ""}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "Roboto",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColor()
                                                                .whiteColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Center(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              height: 32,
                                                              child: Image.asset(
                                                                  "assets/images/ic_cron.png"),
                                                            ),
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          52),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(MediaQuery.of(context).size.width *
                                                                                .20),
                                                                        border:
                                                                            Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              AppColor().colorPrimary,
                                                                        )),
                                                                child: controller.user1 != null &&
                                                                        controller.user1.value !=
                                                                            null &&
                                                                        controller.user1.value.photo !=
                                                                            null &&
                                                                        controller.user1.value.photo.url !=
                                                                            null
                                                                    ? CircleAvatar(
                                                                        radius: MediaQuery.of(context).size.width *
                                                                            .19,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          radius: MediaQuery.of(context)
                                                                              .size
                                                                              .height,
                                                                          backgroundImage:
                                                                              (NetworkImage("${controller.user1.value.photo.url}")

                                                                              // AssetImage('assets/images/images.png'),
                                                                              ),
                                                                        ),
                                                                      )
                                                                    : CircleAvatar(
                                                                        radius: MediaQuery.of(context).size.width *
                                                                            .19,
                                                                        backgroundColor:
                                                                            Colors.transparent,

                                                                        child:
                                                                            Image(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          image:
                                                                              AssetImage(ImageRes().team_group),
                                                                        ),

                                                                        //radius: 20,
                                                                      ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin: EdgeInsets.only(
                                                              top: 20,
                                                              left: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .17),
                                                          child: CircleAvatar(
                                                              radius: 10,
                                                              backgroundColor:
                                                                  AppColor()
                                                                      .colorPrimary_light,
                                                              child: Center(
                                                                child: Text(
                                                                  "1",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Obx(() => Center(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: AssetImage(
                                                                    ImageRes()
                                                                        .rank_amount_back)),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 20,
                                                              vertical: 1,
                                                            ),
                                                            child: Text(
                                                              "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.user1 != null && controller.user1.value != null && controller.user1.value.amount != null ? controller.user1.value.amount.value ~/ 100 : "0"}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: AppColor()
                                                                      .colorPrimary),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                  Obx(() => Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 3),
                                                          child: Text(
                                                            "${controller.user1 != null && controller.user1.value != null ? controller.user1.value.username : ""}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColor()
                                                                    .whiteColor),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 55,
                                                  ),
                                                  Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            child: Image.asset(
                                                                "assets/images/ic_cron.png"),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            52)),
                                                            child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(MediaQuery.of(context).size.width *
                                                                                .13),
                                                                        border:
                                                                            Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              AppColor().colorPrimary,
                                                                        )),
                                                                child: Obx(
                                                                  () => controller.user3 != null &&
                                                                          controller.user3.value !=
                                                                              null &&
                                                                          controller.user3.value.photo !=
                                                                              null &&
                                                                          controller.user3.value.photo.url !=
                                                                              null
                                                                      ? CircleAvatar(
                                                                          radius:
                                                                              48,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          backgroundImage:
                                                                              NetworkImage("${controller.user3.value.photo.url}"),
                                                                        )
                                                                      : CircleAvatar(
                                                                          radius:
                                                                              MediaQuery.of(context).size.width * .12,

                                                                          /* radius:
                                                                            48,*/
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          child:
                                                                              Image(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            image:
                                                                                AssetImage(ImageRes().team_group),
                                                                          ),
                                                                        ),
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        // alignment: Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            top: 19,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .1),
                                                        child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                AppColor()
                                                                    .colorPrimary_light,
                                                            child: Text(
                                                              "3",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                  Obx(() => Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  ImageRes()
                                                                      .rank_amount_back)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 20,
                                                            vertical: 1,
                                                          ),
                                                          child: Text(
                                                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.user3 != null && controller.user3.value != null && controller.user3.value.amount != null ? controller.user3.value.amount.value ~/ 100 : " 0"}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColor()
                                                                    .colorPrimary),
                                                          ),
                                                        ),
                                                      )),
                                                  Obx(() => Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 3),
                                                        child: Text(
                                                          "${controller.user3 != null && controller.user3.value != null ? controller.user3.value.username : ""}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColor()
                                                                  .whiteColor),
                                                        ),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 50),
                                        child:
                                            controller.leaderBoardlistNew
                                                        .value !=
                                                    null
                                                ? ListView.builder(
                                                    itemCount:
                                                        controller
                                                            .leaderBoardlistNew
                                                            .value
                                                            .length,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return listCallLeaderboard(
                                                          context, index);
                                                    })
                                                : Center(
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      color: Colors.transparent,
                                                      child: Image(
                                                          height: 100,
                                                          width: 100,
                                                          //color: Colors.transparent,
                                                          fit: BoxFit.fill,
                                                          image: AssetImage(
                                                              "assets/images/progresbar_images.gif")),
                                                    ),
                                                  )
                                        /* ListView.builder(
                                                itemCount: 6,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return listCallLeaderboardStatic(
                                                      context, index);
                                                })*/

                                        /*Center(
                                                child: CircularProgressIndicator())*/
                                        ,
                                      )
                                    ])),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 00,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void OnchagesTabClan(String type) {
    if (type == "All") {
      controller.allClan.value = true;
      controller.clanList.value = null;
      controller.selectedClan.value = null;
      controller.getClanList();
      controller.gameListSelectedColor.value = 0;
    } else {
      controller.allClan.value = false;
      controller.clanList.value = null;
      controller.selectedClan.value = null;
      controller.getJoinedClanList();
      controller.gameListSelectedColor.value = 0;
    }
  }

  /*api handler */
  Future getUserDatils(BuildContext context) async {
    _preferences = await SharedPreferences.getInstance();
    token = _preferences.getString("token");
    user_id = _preferences.getString("user_id");
    this.context = context;
  }

  Widget ClanlistWidget(BuildContext context, int index) {
    if (controller.selectedClan.value == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        controller.selectedClan.value = controller.clanList.value.data[0];
        controller.getEventList("", controller.selectedClan.value.id);
        controller.matches.value = true;
        controller.getJoinedContestList("");
        controller.updateSelectedClan();
        //yourcode
      });
    }
    return GestureDetector(
      onTap: () {
        controller.result.value = "Slide to join Clan".tr;
        controller.gameListSelectedColor.value = index;
        controller.selectedClan.value = controller.clanList.value.data[index];
        controller.getEventList("", controller.selectedClan.value.id);
        controller.getJoinedContestList("");
        controller.matches.value = true;
        controller.updateSelectedClan();
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10, left: 1, top: 10, bottom: 10),
        child: Container(
          decoration: controller.gameListSelectedColor.value == index
              ? BoxDecoration(
                  boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: .0,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: AppColor().colorPrimary))
              : BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // color:Colors.transparent,
                      color: AppColor().clan_header_dark,
                      blurRadius: 0,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            child: Image(
                height: 80,
                fit: BoxFit.fill,
                image: controller.clanList.value.data[index].banner != null &&
                        controller.clanList.value.data[index].banner.url != null
                    ? NetworkImage(
                        controller.clanList.value.data[index].banner.url)
                    : AssetImage(ImageRes().userProfileImage)),
          ),
        ),
      ),
    );
  }

  Widget joinedClanlistWidgetStatic(BuildContext context, int index) {
    if (controller.selectedClan.value == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        controller.selectedClan.value = controller.clanJoinedList.value.data[0];
        controller.selectedClan.value.is_slected = true;
        controller.getEventList("", controller.selectedClan.value.id);
        controller.getJoinedContestList("");
        controller.matches.value = true;
        //yourcode
      });
    }
    return GestureDetector(
      onTap: () {
        controller.gameListSelectedColor.value = index;
        controller.selectedClan.value =
            controller.clanJoinedList.value.data[index];
        controller.selectedClan.value.is_slected = true;
        controller.getEventList("", controller.selectedClan.value.id);
        controller.getJoinedContestList("");
        controller.matches.value = true;
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10, left: 1, top: 10, bottom: 10),
        child: Container(
          decoration: controller.gameListSelectedColor.value == index
              ? BoxDecoration(
                  boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: .0,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: AppColor().colorPrimary))
              : BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColor().clan_header_dark,
                      //color:Colors.transparent,
                      blurRadius: 0,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            child: Image(
                height: 80,
                fit: BoxFit.fill,
                image: NetworkImage(
                    controller.clanJoinedList.value.data[index].banner.url)),
          ),
        ),
      ),
    );
  }

  Widget joinedClanlistWidget(BuildContext context, int index) {
    if (controller.selectedClan.value == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        controller.selectedClan.value = controller.clanJoinedList.value.data[0];
        controller.selectedClan.value.is_slected = true;
        controller.getEventList("", controller.selectedClan.value.id);
        controller.getJoinedContestList("");
        controller.matches.value = true;
        //yourcode
      });
    }
    return GestureDetector(
      onTap: () {
        controller.gameListSelectedColor.value = index;
        controller.selectedClan.value =
            controller.clanJoinedList.value.data[index];
        controller.selectedClan.value.is_slected = true;
        controller.getEventList("", controller.selectedClan.value.id);
        controller.getJoinedContestList("");
        controller.matches.value = true;
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10, left: 1, top: 10, bottom: 10),
        child: Container(
          decoration: controller.gameListSelectedColor.value == index
              ? BoxDecoration(
                  boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: .0,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: AppColor().colorPrimary))
              : BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColor().clan_header_dark,
                      //color:Colors.transparent,
                      blurRadius: 0,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            child: Image(
                height: 80,
                fit: BoxFit.fill,
                image: NetworkImage(
                    controller.clanJoinedList.value.data[index].banner.url)),
          ),
        ),
      ),
    );
  }

  Widget listShimmer() {
    return Column(
      children: [
        Container(
          height: 80,
        ),
        Container(
          height: 80,
        )
      ],
    );
  }

  Widget Contest(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
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
                  Text(
                    controller
                        .esportEventListModel.value.data[index].name.capitalize,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "Inter", color: Colors.white),
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
                        DateFormat("yyyy-MM-dd").parse(controller
                            .esportEventListModel
                            .value
                            .data[index]
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
                    controller
                        .esportEventListModel.value.data[index].gameMapId.name,
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
                            null
                        ? controller.esportEventListModel.value.data[index]
                            .gamePerspectiveId.name
                        : "-",
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

                    /*      Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                          .esportEventListModel.value
                          .data[index].winner.prizeAmount!=null?controller
                          .esportEventListModel.value
                          .data[index].winner.prizeAmount.value ~/ 100:"--"}",
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
                    controller.esportEventListModel.value.data[index]
                                .gameModeId !=
                            null
                        ? controller.esportEventListModel.value.data[index]
                            .gameModeId.name
                        : "-",
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
                        /*   "${controller.esportEventListModel.value.data[index]
                                .getTotalWinner()}",*/
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
                              : SizedBox(),
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
                            "${controller.esportEventListModel.value.data[index].entry.fee.value ~/ 100}",
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
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
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
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              CheckJoinContestDetails(context, index);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(13),
                    bottomLeft: Radius.circular(13)),
                color: controller.esportEventListModel.value.data[index]
                            .getRemaningPlayerCount() <=
                        0
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
                      builder:
                          (BuildContext context, Duration value, Widget child) {
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
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("$hours\:$minutes\:$seconds",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16)));
                      })
                  : Obx(
                      () => Text(
                        "${controller.esportEventListModel.value.data[index].getRemaningPlayerCount() <= 0 ? "CONTEST FULL" : "JOIN CONTEST"}",
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

  Future<void> CheckJoinContestDetails(BuildContext context, int index) async {
    contest_id = controller.esportEventListModel.value.data[index].id;
    _contestModel = controller.esportEventListModel.value.data[index];
    gameid = controller.esportEventListModel.value.data[index].gameId.id;

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

    getINGameCheck(gameid);
  }

  Widget championship(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
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
                  Text(
                    controller.esportEventListModel.value.champaiship[index]
                        .name.capitalize,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "Inter", color: Colors.white),
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
                        DateFormat("yyyy-MM-dd").parse(controller
                            .esportEventListModel
                            .value
                            .champaiship[index]
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
                    '${controller.esportEventListModel.value.champaiship[index].eventDate.getStartTimeHHMMSS()}',

                    /*DateFormat("hh:mm aa").format(
                      DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(controller
                          .esportEventListModel
                          .value
                          .champaiship[index]
                          .eventDate
                          .start),
                    ),*/
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

                    /*    Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                          .esportEventListModel.value
                          .champaiship[index].winner.prizeAmount!=null?controller
                          .esportEventListModel.value
                          .champaiship[index].winner.prizeAmount.value~/100:"--"}",
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
                  Obx(
                    () => Text(
                      "${controller.esportEventListModel.value.champaiship[index].winner.isKillType() ? "Per Kill" : "Winners"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
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
                          showWinningBreakupDialog(
                              context,
                              controller.esportEventListModel.value
                                  .champaiship[index]);
                        },
                        child: Container(
                          width: 13,
                          alignment: Alignment.topCenter,
                          child: Image.asset("assets/images/arrow_down.png"),
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
                            "${controller.esportEventListModel.value.champaiship[index].entry.fee.value}",
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
                value: controller.esportEventListModel.value.champaiship[index]
                    .getProgresBar(),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.esportEventListModel.value.champaiship[index]
                      .getRemaningPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
                Text(
                  controller.esportEventListModel.value.champaiship[index]
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
          GestureDetector(
            onTap: () {
              CheckChampionshipDetails(context, index);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(13),
                    bottomLeft: Radius.circular(13)),
                color: controller.esportEventListModel.value.champaiship[index]
                            .getRemaningPlayerCount() <=
                        0
                    ? AppColor().colorGray
                    : AppColor().colorPrimary,
              ),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              height: 40,
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
                      builder:
                          (BuildContext context, Duration value, Widget child) {
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
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("$hours\:$minutes\:$seconds",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16)));
                      })
                  : Obx(
                      () => Text(
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

  void showCustomDialogContestInfo(
      BuildContext context, ContestModel contestModel) {
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
              image: AssetImage("assets/images/profile_bg.webp"),
              fit: BoxFit.cover,
            ),
          ),
          child: Card(
            color: Colors.transparent,
            child: Wrap(
              children: [
                Container(
                  height: 20,
                ),
                Container(
                  height: 55,
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
                          "GMNG TEST",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
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
                              Text(
                                "-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimary),
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
                          height: 10,
                        ),
                        contestModel.rules != null
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Html(
                                  data: contestModel.getRules() ?? "Rules",
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
                      ],
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

  Future<void> CheckChampionshipDetails(BuildContext context, int index) async {
    contest_id = controller.esportEventListModel.value.champaiship[index].id;
    _contestModel = controller.esportEventListModel.value.champaiship[index];
    gameid = controller.esportEventListModel.value.champaiship[index].gameId.id;
    getINGameCheck(gameid);
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
                    /*    Row(
                      children: [
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 34),
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColor().colorPrimary,
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "Prizepool",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white),
                                ),
                              )),
                        ),
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 34),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColor().colorPrimary,
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "GMNG Points",
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
                    SizedBox(
                      height: 10,
                    ),*/
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
                    /*    Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(model.winner
                          .prizeAmount!=null?model.winner
                          .prizeAmount.value ~/ 100:"--")}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        color: AppColor().colorPrimary,
                      ),
                    ),*/
                    ListView.builder(
                        itemCount: model.rankAmount.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return winnerList(context, index, model.rankAmount);
                        })
                  ],
                ),
              ),
            ],
          );
        });
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
                  "Rank ${list[index].rankFrom}",
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
                                  "${list[index].amount != null ? list[index].amount.value ?? "0" : "-"}",
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
                /*     Text(
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
                  color: Colors.transparent,
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),


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
                      controller.teamlist.value.data.length > 0
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
                          ? _Button(context, "Submit", event_id, "")
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
                        ),
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
                  ? DropdownButton<String>(
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
                    )
                  : Center(
                      child: Text(
                        "You are not the captain of any team",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            )));
  }

  void showPreJoinBox(BuildContext context, String event_id) {
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 360,
            child: Card(

              color: Colors.transparent,
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
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
                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${'10'}",
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
                                "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${preJoinResponseModel.deposit.value ~/ 100} ",
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
                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'}38",
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
                                  style:
                                      TextStyle(color: AppColor().whiteColor))
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    _Button(context, "CONFIRM", event_id, ""),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  void showInGameDialog(BuildContext context, String game_id) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 300,

            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().new_rectangle_box_blank)),
            ),
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
                    height: 3,
                  ),
                  _editTitleTextField(
                      controller.inGameName,
                      "Enter your InGameName",
                      controller.inGameCheckModel.value != null
                          ? controller.inGameCheckModel.value.inGameName
                          : ""),
                  SizedBox(
                    height: 10,
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
                    height: 3,
                  ),
                  _editTitleTextField(
                      controller.iNGameId,
                      "Enter your InGameID",
                      controller.inGameCheckModel.value != null
                          ? controller.inGameCheckModel.value.inGameId
                          : ""),
                  SizedBox(
                    height: 15,
                  ),
                  _Button(
                      context,
                      controller.inGameCheckModel.value != null
                          ? "Update"
                          : "Submit",
                      game_id,
                      ""),
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

  Widget _Button(
      BuildContext context, String values, String event_id, String team_id) {
    return GestureDetector(
      onTap: () {
        if (values == "CONFIRM") {
          getJoinEvent(event_id, "", controller.user_id);
          Navigator.pop(context);
        } else if (values == "Submit") {
          if (controller.selected_team.value.isEmpty) {
            Utils.showCustomTosst("Please select Team for join");
            return;
          } else {
            getJoinEvent(event_id, team_id, "");
            Navigator.pop(context);
            // Fluttertoast.showToast(msg: "Team Type");
          }
        } else {
          var mapD = getINGamePost(event_id);
          if (mapD != null) {
            Fluttertoast.showToast(msg: mapD.toString());
            Navigator.pop(context);
          } else {
            //Fluttertoast.showToast(msg: "some error");
          }
        }
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

  Future<Map> getPreJoinEvent(String event_id) async {
    Utils().customPrint("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${user_id}");
    final param = {"userId": user_id};
    showProgress(context, '', true);

    Map<String, dynamic> response =
        await WebServicesHelper().getPreEventJoin(param, token, event_id);
    Utils().customPrint(' respone is finaly ${response}');

    if (response != null && response['statusCode'] == null) {
      hideProgress(context);
      Utils().customPrint(' respone is finaly1 ${response}');
      preJoinResponseModel = PreJoinResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          //Fluttertoast.showToast(msg: "Please add Amount.");
          //Get.offAll(() => DashBord(4, ""));
          Utils().alertInsufficientBalance(context);
        } else {
          Utils().customPrint('datta----1');
          if (_contestModel != null && !_contestModel.isSoloContest()) {
            Utils().customPrint('datta----1');
            getUserTeamList(_contestModel.teamTypeId.id, gameid, true);
          } else {
            Utils().customPrint('datta----2');
            showPreJoinBox(context, event_id);
          }
        }
      } else {
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(response);
        Utils().showErrorMessage("", appBaseErrorModel.error);
      }
    } else if (response['statusCode'] != 500) {
      hideProgress(context);
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else {
      hideProgress(context);
      Utils().customPrint('respone is finaly2${response}');
      //hideLoader();
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
      }
      Utils()
          .customPrint("Size of team ${controller.teamlist.value.data.length}");
      teamTypeCreate(context, _contestModel.id);
    } else {
      //   Fluttertoast.showToast(msg: "Some Error");
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
        } else {
          Map<String, dynamic> response =
              json.decode(response_final.body.toString());
          AppBaseResponseModel appBaseErrorModel =
              AppBaseResponseModel.fromMap(response);
          Utils().showErrorMessage("", appBaseErrorModel.error);
        }

        // Fluttertoast.showToast(msg: response.toString());
      } else {
        if (!controller.selected_team.value.isEmpty) {
          param = {
            "userId": "",
            "teamId": controller.selected_team_id.value,
            "memberIds": []
          };
          final response_final =
              await WebServicesHelper().getEventJoin(param, token, event_id);
          // Fluttertoast.showToast(msg: response.toString());
          if (response_final != null && response_final.statusCode == 200) {
            Fluttertoast.showToast(msg: "Event joined Succesfully");
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

  Future<Map> getINGameCheck(String game_id) async {
    Utils().customPrint("game_id ===>${game_id}");
    Utils().customPrint("user_id ===>${user_id}");
    controller.inGameCheckModel.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getInGameCheck(token, user_id, game_id);
    if (response != null) {
      controller.inGameCheckModel.value = InGameCheck.fromJson(response);
      if (controller.inGameCheckModel.value != null) {
        getPreJoinEvent(contest_id);
      } else {
        showInGameDialog(context, gameid);
      }
      return response;
    } else {
      return response;
    }
  }

  Future<Map> getINGamePost(String game_id) async {
    final param = {
      "inGameId": controller.mapKey["Enter your InGameID"],
      "inGameName": controller.mapKey["Enter your InGameName"]
    };
    Map<String, dynamic> response =
        await WebServicesHelper().getInGamePost(param, token, user_id, game_id);
    return response;
  }

  Widget listCallLeaderboardStatic(BuildContext context, int index) {
    return Container(
      height: 58,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/gradient_rectangular.png")),
          /*color: Colors.grey,*/ borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "1",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 8, top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    height: 45,
                    width: 45,
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/images.png'),
                  ),
                ),
              ),
              Text(
                "savita".capitalize,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10),
            child: Text(
              "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} 40",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget listCallLeaderboard(BuildContext context, int index) {
    return Container(
      height: 58,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/gradient_rectangular.png")),
          /*color: Colors.grey,*/ borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "${controller.leaderBoardlistNew.value[index].rank}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 8, top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                    image:
                        controller.leaderBoardlistNew.value[index].photo != null
                            ? NetworkImage(controller
                                .leaderBoardlistNew.value[index].photo.url)
                            : AssetImage('assets/images/images.png'),
                  ),
                ),
              ),
              Text(
                "${controller.leaderBoardlistNew.value[index].username}"
                    .capitalize,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10),
            child: Text(
              "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.leaderBoardlistNew.value[index].amount.value ~/ 100}",
              // textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
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
              "${controller.esportJoinedList.value.data[index].name}"
                  .capitalize,
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
                          DateFormat("yyyy-MM-dd").parse(controller
                              .esportJoinedList
                              .value
                              .data[index]
                              .eventDate
                              .start),
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
                    controller.esportEventListModel.value.data[index]
                                .eventDate !=
                            null
                        ? '${controller.esportEventListModel.value.data[index].eventDate.getStartTimeHHMMSS()}'
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
                    "Map",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    controller.esportJoinedList.value.data[index].gameMapId !=
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
                            null
                        ? controller.esportJoinedList.value.data[index]
                            .gamePerspectiveId.name
                        : "-",
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

                      /* Text(
                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                            .esportJoinedList.value
                            .data[index].winner.prizeAmount!=null?controller
                            .esportJoinedList.value
                            .data[index].winner.prizeAmount.value ~/ 100:"--"}",
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
                    controller.esportJoinedList.value.data[index].gameModeId
                                .name !=
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
                  Obx(
                    () => Text(
                      "${controller.esportJoinedList.value.data[index].winner.isKillType() ? "Per Kill" : "Winners"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
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
                          showWinningBreakupDialog(context,
                              controller.esportJoinedList.value.data[index]);
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
                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportJoinedList.value.data[index].entry.fee.value ~/ 100}",
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
                /*value: controller.esportEventListModel.value.data[0]
                    .getProgresBar(),*/
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
                              .getRemaningPlayer() !=
                          null
                      ? controller.esportJoinedList.value.data[index]
                          .getRemaningPlayer()
                      : "",
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
            onTap: () {
              Get.to(() => JoinedBattlesDetails(gameid, "",
                  controller.esportJoinedList.value.data[index].id));
            },
            child: Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, bottom: 12, top: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor().whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Text(
                "View All Contest Details".tr,
                style: TextStyle(
                    color: AppColor().colorPrimary,
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
}
