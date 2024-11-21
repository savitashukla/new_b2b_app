import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/ui/controller/JoinedBottlesController.dart';
import 'package:intl/intl.dart';

import '../../../model/ESportsEventList.dart';
import '../../../res/AppColor.dart';
import '../../../res/FontSizeC.dart';
import '../../../res/ImageRes.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/ApiUrl.dart';
import '../../controller/BaseController.dart';
import '../../controller/user_controller.dart';

class JoinedBattlesDetails extends StatelessWidget {
  String url;
  String event_id;
  String gameid;

  JoinedBattlesDetails(this.gameid, this.url, this.event_id);

  BaseController base_controller = Get.put(BaseController());
  UserController _userController = Get.put(UserController());

  JoinedBattlesController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(JoinedBattlesController(event_id));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.getJoinedBattlesDetails(event_id);
    });
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/store_back.png"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: url.isNotEmpty ? NetworkImage(url) : AssetImage(
                          ImageRes().logo_login_tranparnt),
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
              delegate: SliverChildListDelegate([
                Wrap(
                  children: [
                    Container(
                      height: 30,
                    ),
                    Container(
                      height: 25,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                              Utils().customPrint(
                                    "Watch Stream=> ${controller
                                        .joinedBattlesDetailsModel.value
                                        .getStreamUrl()}");
                                if (controller.joinedBattlesDetailsModel !=
                                    null &&
                                    controller
                                        .joinedBattlesDetailsModel.value !=
                                        null &&
                                    !controller.joinedBattlesDetailsModel.value
                                        .getStreamUrl()
                                        .isEmpty) {
                                  Utils.launchURLApp(controller
                                      .joinedBattlesDetailsModel.value
                                      .getStreamUrl());
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 40, right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColor().colorGray, width: 1),
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.transparent),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12.0,
                                      child: Image.asset(
                                          "assets/images/ic_link.webp"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 10),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Watch Stream",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: FontSizeC().front_small,
                                              color: Colors.white),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                //showCustomDialog(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 50),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColor().colorGray, width: 1),
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.transparent),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12.0,
                                      child: Image.asset(
                                          "assets/images/ic_link.webp"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                      Utils().customPrint(
                                            "Clan Link=> ${controller
                                                .joinedBattlesDetailsModel.value
                                                .getClanLink()}");
                                        if (controller
                                            .joinedBattlesDetailsModel !=
                                            null &&
                                            controller.joinedBattlesDetailsModel
                                                .value !=
                                                null &&
                                            controller.joinedBattlesDetailsModel
                                                .value.clanUrl !=
                                                null &&
                                            !controller
                                                .joinedBattlesDetailsModel
                                                .value
                                                .clanUrl
                                                .isEmpty) {
                                          Utils.launchURLApp(controller
                                              .joinedBattlesDetailsModel.value
                                              .getClanLink());
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Clan Link",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: FontSizeC().front_small,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: 75,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                controller.joinedDetailsType.value = "Details";
                              },
                              child: Obx(
                                    () =>
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          right: 5,
                                          top: 10,
                                          bottom: 5),
                                      child: Text(
                                        "Details".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Inter",
                                            color: Colors.white),
                                      ),
                                      decoration: controller
                                          .joinedDetailsType.value ==
                                          "Details"
                                          ? BoxDecoration(
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 1),
                                          color: AppColor().colorPrimary,
                                          borderRadius:
                                          BorderRadius.circular(8))
                                          : BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                controller.joinedDetailsType.value = "Players";
                                controller.getDetailsPlayers(event_id);
                              },
                              child: Obx(
                                    () =>
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 10,
                                          bottom: 5),
                                      child: Text(
                                        "Players".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Inter",
                                            color: Colors.white),
                                      ),
                                      decoration: controller
                                          .joinedDetailsType.value ==
                                          "Players"
                                          ? BoxDecoration(
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 1),
                                          color: AppColor().colorPrimary,
                                          borderRadius:
                                          BorderRadius.circular(8))
                                          : BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                controller.joinedDetailsType.value = "Rules";
                              },
                              child: Obx(
                                    () =>
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 10,
                                          bottom: 5),
                                      child: Text(
                                        "Rules".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Inter",
                                            color: Colors.white),
                                      ),
                                      decoration: controller
                                          .joinedDetailsType.value ==
                                          "Rules"
                                          ? BoxDecoration(
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 1),
                                          color: AppColor().colorPrimary,
                                          borderRadius:
                                          BorderRadius.circular(8))
                                          : BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                    ),
                              ),
                            ),
                          ),
                          Obx(
                                () =>
                            (controller.joinedBattlesDetailsModel !=
                                null &&
                                controller
                                    .joinedBattlesDetailsModel.value !=
                                    null &&
                                controller.joinedBattlesDetailsModel.value
                                    .type != null &&
                                controller.joinedBattlesDetailsModel.value
                                    .isChampainShip())
                                ? Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  controller.joinedDetailsType.value =
                                  "Table";
                                },
                                child: Obx(
                                      () =>
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        margin: EdgeInsets.only(
                                            left: 5,
                                            right: 10,
                                            top: 10,
                                            bottom: 5),
                                        child: Text(
                                          "Table".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        ),
                                        decoration: controller
                                            .joinedDetailsType
                                            .value ==
                                            "Table"
                                            ? BoxDecoration(
                                            border: Border.all(
                                                color: AppColor()
                                                    .colorPrimary,
                                                width: 1),
                                            color:
                                            AppColor().colorPrimary,
                                            borderRadius:
                                            BorderRadius.circular(8))
                                            : BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 1),
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                      ),
                                ),
                              ),
                            )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    Obx(
                            () =>
                            Center(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "${(controller.joinedBattlesDetailsModel
                                        .value != null &&
                                        controller.joinedBattlesDetailsModel
                                            .value.name != null)
                                        ? controller.joinedBattlesDetailsModel
                                        .value.name : ""}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w900,
                                        color: AppColor()
                                            .whiteColor),
                                  ),
                                )

                            )),
                    Container(
                      height: 5,
                    ),
                    Obx(
                          () =>
                          Padding(
                              padding: EdgeInsets.all(0),
                              child: controller.joinedDetailsType.value !=
                                  null && controller.joinedDetailsType.value ==
                                  "Details"
                                  ? controller.joinedBattlesDetailsModel
                                  .value !=
                                  null
                                  ? Wrap(
                                children: [
                                  /*in case of champain ship */
                                  (controller
                                      .joinedBattlesDetailsModel !=
                                      null &&
                                      controller
                                          .joinedBattlesDetailsModel
                                          .value !=
                                          null &&
                                      controller
                                          .joinedBattlesDetailsModel
                                          .value
                                          .isChampainShip())
                                      ? Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        color:
                                        AppColor().whiteColor,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10)),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Date",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .wallet_medium_grey),
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                        "dd/MM/yyyy")
                                                        .format(
                                                      DateFormat(
                                                          "yyyy-MM-dd")
                                                          .parse(controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .joiningDate
                                                          .start),
                                                    ),
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Time",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      '${controller
                                                          .joinedBattlesDetailsModel
                                                          .value.eventDate
                                                          .getStartTimeHHMMSS()}',
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Map",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameMapId
                                                          .name != null
                                                          ? controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameMapId
                                                          .name
                                                          : "",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Perspective",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gamePerspectiveId !=
                                                          null &&controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gamePerspectiveId
                                                          .name!=null ? controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gamePerspectiveId
                                                          .name : "",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          height: 8,
                                        ),
                                        Container(
                                          height: 1,
                                          color:
                                          AppColor().colorGray,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Prizepool",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .wallet_medium_grey),
                                                  ),
                                                  controller
                                                      .joinedBattlesDetailsModel
                                                      .value.winner
                                                      .customPrize !=
                                                      null &&
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .winner.customPrize
                                                          .isNotEmpty
                                                      ? Text(
                                                    "${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .customPrize}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  )
                                                      : controller
                                                      .joinedBattlesDetailsModel
                                                      .value
                                                      .winner.prizeAmount !=
                                                      null &&
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .winner.prizeAmount
                                                          .type
                                                          .compareTo("bonus") ==
                                                          0
                                                      ? Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          child: Image.asset(
                                                              ImageRes()
                                                                  .ic_coin),
                                                        ),
                                                        Text(
                                                          "${controller
                                                              .joinedBattlesDetailsModel
                                                              .value.winner
                                                              .prizeAmount !=
                                                              null
                                                              ? controller
                                                              .joinedBattlesDetailsModel
                                                              .value.winner
                                                              .prizeAmount.value
                                                              : "-"}",
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: "Inter",
                                                              color: AppColor()
                                                                  .colorPrimary),
                                                        )
                                                      ])
                                                      : Text(
                                                    "${ApiUrl().isPlayStore
                                                        ? ""
                                                        : '\u{20B9}'} ${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount !=
                                                        null ? controller
                                                        .joinedBattlesDetailsModel
                                                        .value
                                                        .winner.prizeAmount
                                                        .value ~/ 100 : "-"}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),

                                                  /* Text(
                                                    "${ApiUrl().isPlayStore
                                                        ? ""
                                                        : '\u{20B9}'} ${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount != null
                                                        ? controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount.value /
                                                        100
                                                        : "--"}",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),*/
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Type",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameModeId
                                                          .name,
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Winners",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .getTotalWinner(),
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Entry Fee",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Container(
                                                      child: controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .entry
                                                          .fee
                                                          .value >
                                                          0
                                                          ? Text(
                                                        "${controller
                                                            .joinedBattlesDetailsModel
                                                            .value.entry.fee
                                                            .value ~/ 100}",
                                                        textAlign:
                                                        TextAlign
                                                            .center,
                                                        style: TextStyle(
                                                            fontSize:
                                                            14,
                                                            fontFamily:
                                                            "Inter",
                                                            color:
                                                            AppColor()
                                                                .colorPrimary),
                                                      )
                                                          : Text(
                                                        "Free",
                                                        textAlign:
                                                        TextAlign
                                                            .center,
                                                        style: TextStyle(
                                                            fontSize:
                                                            14,
                                                            fontFamily:
                                                            "Inter",
                                                            color:
                                                            AppColor()
                                                                .colorPrimary),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  )
                                      : Container(),
                                  Container(
                                    height: 10,
                                  ),
                                  (controller
                                      .joinedBattlesDetailsModel !=
                                      null &&
                                      controller
                                          .joinedBattlesDetailsModel
                                          .value !=
                                          null &&
                                      controller
                                          .joinedBattlesDetailsModel
                                          .value
                                          .isChampainShip())
                                      ? Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "CONTEST ROUND DETAILS".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: AppColor()
                                                  .whiteColor),
                                        ),
                                      )

                                  )

                                      : Container(),

                                  /*in case of ChampainShip contest */

                                  (controller
                                      .joinedBattlesDetailsModel !=
                                      null &&
                                      controller
                                          .joinedBattlesDetailsModel
                                          .value !=
                                          null &&
                                      controller
                                          .joinedBattlesDetailsModel
                                          .value
                                          .isChampainShip())
                                      ? controller
                                      .joinedBattlesDetailsModel
                                      .value.isSoloContest() ?
                                  Obx(() =>
                                      ListView.builder(

                                          itemCount: controller
                                              .joinedUserDetailsSoloResult !=
                                              null && controller
                                              .joinedUserDetailsSoloResult.value!=null &&
                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds != null &&
                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value
                                                  .rounds.length > 0
                                              ? controller
                                              .joinedUserDetailsSoloResult
                                              .value
                                              .rounds
                                              .length
                                              : 0,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(top: 5),
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return contestListRoundWiseSolo(
                                                context, index);
                                          }))
                                      :
                                  Obx(() =>
                                      ListView.builder(
                                          itemCount: (controller
                                              .joinedUserDetailsResult
                                              .value != null &&
                                              controller
                                                  .joinedUserDetailsResult
                                                  .value.members != null &&
                                              controller
                                                  .joinedUserDetailsResult
                                                  .value.members[0] != null &&
                                              controller
                                                  .joinedUserDetailsResult
                                                  .value.members[0]
                                                  .eventRegistration != null
                                              && controller
                                                  .joinedUserDetailsResult
                                                  .value.members[0]
                                                  .eventRegistration.rounds !=
                                                  null &&
                                              controller
                                                  .joinedUserDetailsResult
                                                  .value.members[0]
                                                  .eventRegistration.rounds
                                                  .length
                                                  > 0)
                                              ? controller
                                              .joinedUserDetailsResult
                                              .value.members[0]
                                              .eventRegistration.rounds.length
                                              : 0,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(top: 5),
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return contestListRoundWise(
                                                context, index);
                                          }))
                                      : Container(),

                                  /*in case of normal contest */
                                  (controller
                                      .joinedBattlesDetailsModel !=
                                      null &&
                                      controller
                                          .joinedBattlesDetailsModel
                                          .value !=
                                          null &&
                                      !controller
                                          .joinedBattlesDetailsModel
                                          .value
                                          .isChampainShip())
                                      ? controller
                                      .joinedBattlesDetailsModel
                                      .value.isSoloContest() ?
                                  Container(
                                    padding:
                                    EdgeInsets.only(top: 5),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5),
                                    decoration: BoxDecoration(
                                        color:
                                        AppColor().whiteColor,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10)),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Date",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .wallet_medium_grey),
                                                  ),
                                                  Text(
                                                    DateFormat("dd/MM/yyyy")
                                                        .format(DateFormat(
                                                        "yyyy-MM-dd")
                                                        .parse(controller
                                                        .joinedBattlesDetailsModel
                                                        .value
                                                        .eventDate
                                                        .start)),
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Time",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      '${controller
                                                          .joinedBattlesDetailsModel
                                                          .value.eventDate
                                                          .getStartTimeHHMMSS()}',
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Map",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameMapId != null &&
                                                          controller
                                                              .joinedBattlesDetailsModel
                                                              .value
                                                              .gameMapId.name !=
                                                              null ?
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameMapId.name : '',
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Perspective",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gamePerspectiveId !=
                                                          null && controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gamePerspectiveId
                                                          .name != null ?
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gamePerspectiveId
                                                          .name : '',
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 1,
                                          color:
                                          AppColor().colorGray,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Prizepool",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .wallet_medium_grey),
                                                  ),
                                                  controller
                                                      .joinedBattlesDetailsModel
                                                      .value.winner
                                                      .customPrize !=
                                                      null &&
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .winner.customPrize
                                                          .isNotEmpty
                                                      ? Text(
                                                    "${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .customPrize}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  )
                                                      : controller
                                                      .joinedBattlesDetailsModel
                                                      .value
                                                      .winner.prizeAmount !=
                                                      null &&
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .winner.prizeAmount
                                                          .type
                                                          .compareTo("bonus") ==
                                                          0
                                                      ? Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          child: Image.asset(
                                                              ImageRes()
                                                                  .ic_coin),
                                                        ),
                                                        Text(
                                                          "${controller
                                                              .joinedBattlesDetailsModel
                                                              .value.winner
                                                              .prizeAmount !=
                                                              null
                                                              ? controller
                                                              .joinedBattlesDetailsModel
                                                              .value.winner
                                                              .prizeAmount.value
                                                              : "-"}",
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: "Inter",
                                                              color: AppColor()
                                                                  .colorPrimary),
                                                        )
                                                      ])
                                                      : Text(
                                                    "${ApiUrl().isPlayStore
                                                        ? ""
                                                        : '\u{20B9}'} ${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount !=
                                                        null ? controller
                                                        .joinedBattlesDetailsModel
                                                        .value
                                                        .winner.prizeAmount
                                                        .value ~/ 100 : "-"}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),

                                                  /* Text(
                                                    "${ApiUrl().isPlayStore
                                                        ? ""
                                                        : '\u{20B9}'} ${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount != null
                                                        ? controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount.value /
                                                        100
                                                        : "--"}",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),*/
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Type",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameModeId != null &&
                                                          controller
                                                              .joinedBattlesDetailsModel
                                                              .value
                                                              .gameModeId
                                                              .name != null ?
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameModeId
                                                          .name : '',
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Winners",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          controller
                                                              .joinedBattlesDetailsModel
                                                              .value
                                                              .getTotalWinner(),
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                              fontSize:
                                                              14,
                                                              fontFamily:
                                                              "Inter",
                                                              color: AppColor()
                                                                  .colorPrimary),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            showWinningBreakupDialog(
                                                                context,
                                                                controller
                                                                    .joinedBattlesDetailsModel
                                                                    .value);
                                                          },
                                                          child:
                                                          Container(
                                                            width: 13,
                                                            alignment:
                                                            Alignment
                                                                .topCenter,
                                                            child: Image
                                                                .asset(
                                                                "assets/images/arrow_down.png"),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Entry Fee",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      "${controller
                                                          .joinedBattlesDetailsModel
                                                          .value.entry.fee
                                                          .value ~/ 100}",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Container(
                                          margin:
                                          EdgeInsets.symmetric(
                                              horizontal: 9,
                                              vertical: 3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(20),
                                          ),
                                          child:
                                          LinearProgressIndicator(
                                            valueColor:
                                            AlwaysStoppedAnimation(
                                                AppColor()
                                                    .colorPrimary),
                                            backgroundColor:
                                            AppColor()
                                                .colorGray,
                                            value: controller
                                                .joinedBattlesDetailsModel
                                                .value
                                                .getProgresBar(),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 2,
                                              bottom: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                controller
                                                    .joinedBattlesDetailsModel
                                                    .value
                                                    .getRemaningPlayer(),
                                                textAlign: TextAlign
                                                    .center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                    "Inter",
                                                    color: AppColor()
                                                        .wallet_medium_grey),
                                              ),
                                              Text(
                                                controller
                                                    .joinedBattlesDetailsModel
                                                    .value
                                                    .getEventJoinedPlayer(),
                                                textAlign: TextAlign
                                                    .center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                    "Inter",
                                                    color: AppColor()
                                                        .wallet_medium_grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: AppColor()
                                                  .colorPrimary,
                                              borderRadius:
                                              BorderRadius.only(
                                                  bottomRight: Radius
                                                      .circular(
                                                      10),
                                                  bottomLeft: Radius
                                                      .circular(
                                                      10))),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child:
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left:
                                                            10,
                                                            bottom:
                                                            5,
                                                            top: 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              "Room ID",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  fontFamily:
                                                                  "Inter",
                                                                  color:
                                                                  AppColor()
                                                                      .whiteColor),
                                                            ),
                                                            Container(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  (controller
                                                                      .joinedBattlesPlayersModel
                                                                      .value !=
                                                                      null &&
                                                                      controller
                                                                          .joinedBattlesDetailsModel
                                                                          .value !=
                                                                          null)
                                                                      ? '${controller
                                                                      .joinedBattlesPlayersModel
                                                                      .value
                                                                      .getRoomName(
                                                                      controller
                                                                          .joinedBattlesDetailsModel
                                                                          .value
                                                                          .rounds[0]
                                                                          .id)}'
                                                                      : "",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: "Inter",
                                                                      color: AppColor()
                                                                          .whiteColor),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                        msg: "Copied Succesfully");
                                                                    Clipboard
                                                                        .setData(
                                                                        ClipboardData(
                                                                            text: (controller
                                                                                .joinedBattlesPlayersModel
                                                                                .value !=
                                                                                null
                                                                                &&
                                                                                controller
                                                                                    .joinedBattlesDetailsModel
                                                                                    .value !=
                                                                                    null)
                                                                                ?
                                                                            '${controller
                                                                                .joinedBattlesPlayersModel
                                                                                .value
                                                                                .getRoomName(
                                                                                controller
                                                                                    .joinedBattlesDetailsModel
                                                                                    .value
                                                                                    .rounds[0]
                                                                                    .id)}'
                                                                                : ""));
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    height:
                                                                    20,
                                                                    width:
                                                                    20,
                                                                    child:
                                                                    Image.asset(
                                                                      "assets/images/ic_copy.webp",
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                  Container(
                                                    margin: EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        10),
                                                    width: 1,
                                                    height: 30,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                  Expanded(
                                                      child:
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            right:
                                                            10,
                                                            bottom:
                                                            5,
                                                            top: 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              "Password",
                                                              textAlign:
                                                              TextAlign
                                                                  .start,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  fontFamily:
                                                                  "Inter",
                                                                  color:
                                                                  AppColor()
                                                                      .whiteColor),
                                                            ),
                                                            Container(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  (controller
                                                                      .joinedBattlesPlayersModel
                                                                      .value !=
                                                                      null &&
                                                                      controller
                                                                          .joinedBattlesDetailsModel
                                                                          .value !=
                                                                          null)
                                                                      ? '${controller
                                                                      .joinedBattlesPlayersModel
                                                                      .value
                                                                      .getRoompasswordNew(
                                                                      controller
                                                                          .joinedBattlesDetailsModel
                                                                          .value
                                                                          .rounds[0]
                                                                          .id)}'
                                                                      : "",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: "Inter",
                                                                      color: AppColor()
                                                                          .whiteColor),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    Clipboard
                                                                        .setData(
                                                                        ClipboardData(
                                                                          text: (controller
                                                                              .joinedBattlesPlayersModel
                                                                              .value !=
                                                                              null &&
                                                                              controller
                                                                                  .joinedBattlesDetailsModel
                                                                                  .value !=
                                                                                  null)
                                                                              ?
                                                                          '${controller
                                                                              .joinedBattlesPlayersModel
                                                                              .value
                                                                              .getRoompasswordNew(
                                                                              controller
                                                                                  .joinedBattlesDetailsModel
                                                                                  .value
                                                                                  .rounds[0]
                                                                                  .id)}'
                                                                              : "",
                                                                        ));

                                                                    Fluttertoast
                                                                        .showToast(
                                                                        msg: "Copied Succesfully");
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    height:
                                                                    20,
                                                                    width:
                                                                    20,
                                                                    child:
                                                                    Image.asset(
                                                                      "assets/images/ic_copy.webp",
                                                                      color: Colors
                                                                          .white,
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
                                              Container(
                                                height: 5,
                                              ),
                                              Text(
                                                "Details will be shared 15 mins before the game starts",
                                                textAlign:
                                                TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                    "Inter",
                                                    color: AppColor()
                                                        .whiteColor),
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              controller
                                                  .joinedBattlesDetailsModel
                                                  .value.isSoloContest()
                                                  ? Container(
                                                height: 0,
                                              )
                                                  : Column(
                                                  children: [

                                                    Container(height: 1,
                                                      color: Colors.white,),
                                                    Container(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left:
                                                                  10,
                                                                  bottom:
                                                                  5,
                                                                  top: 5),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                    "Team Name",
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        14,
                                                                        fontFamily:
                                                                        "Inter",
                                                                        color:
                                                                        AppColor()
                                                                            .whiteColor),
                                                                  ),
                                                                  Container(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    controller
                                                                        .joinedUserDetailsResult
                                                                        .value !=
                                                                        null&&controller
                                                                        .joinedUserDetailsResult
                                                                        .value
                                                                        .teamId!=null
                                                                        ? controller
                                                                        .joinedUserDetailsResult
                                                                        .value
                                                                        .teamId
                                                                        .name
                                                                        : "",
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: "Inter",
                                                                        color: AppColor()
                                                                            .whiteColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              10),
                                                          width: 1,
                                                          height: 30,
                                                          color: Colors
                                                              .white,
                                                        ),
                                                        Expanded(
                                                            child:
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right:
                                                                  10,
                                                                  bottom:
                                                                  5,
                                                                  top: 5),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                    "Slot",
                                                                    textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        14,
                                                                        fontFamily:
                                                                        "Inter",
                                                                        color:
                                                                        AppColor()
                                                                            .whiteColor),
                                                                  ),
                                                                  Container(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "${ controller
                                                                            .joinedUserDetailsResult
                                                                            .value !=
                                                                            null
                                                                            ? controller
                                                                            .joinedUserDetailsResult
                                                                            .value
                                                                            .members[0]
                                                                            .eventRegistration !=
                                                                            null
                                                                            ? controller
                                                                            .joinedUserDetailsResult
                                                                            .value
                                                                            .members[0]
                                                                            .eventRegistration
                                                                            .rounds
                                                                            .length >
                                                                            0
                                                                            ? controller
                                                                            .joinedUserDetailsResult
                                                                            .value
                                                                            .members[0]
                                                                            .eventRegistration
                                                                            .rounds[0]
                                                                            .slot ??
                                                                            ""
                                                                            : ""
                                                                            : ""
                                                                            : ""}",
                                                                        textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                        style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontFamily: "Inter",
                                                                            color: AppColor()
                                                                                .whiteColor),
                                                                      ),

                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ]
                                              ),

                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                      : Container(
                                    padding:
                                    EdgeInsets.only(top: 5),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5),
                                    decoration: BoxDecoration(
                                        color:
                                        AppColor().whiteColor,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10)),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Date",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .wallet_medium_grey),
                                                  ),
                                                  Text(
                                                    DateFormat("dd/MM/yyyy")
                                                        .format(DateFormat(
                                                        "yyyy-MM-dd")
                                                        .parse(controller
                                                        .joinedBattlesDetailsModel
                                                        .value
                                                        .eventDate
                                                        .start)),
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Time",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      '${controller
                                                          .joinedBattlesDetailsModel
                                                          .value.eventDate
                                                          .getStartTimeHHMMSS()}',
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Map",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameMapId
                                                          != null &&controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameMapId
                                                          .name!=null ? controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameMapId
                                                          .name : "-",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColor()
                                                  .colorGray,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Perspective",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gamePerspectiveId
                                                          != null ? controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gamePerspectiveId
                                                          .name : "-",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 1,
                                          color:
                                          AppColor().colorGray,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Prizepool",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .wallet_medium_grey),
                                                  ),

                                                  controller
                                                      .joinedBattlesDetailsModel
                                                      .value.winner
                                                      .customPrize !=
                                                      null &&
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .winner.customPrize
                                                          .isNotEmpty
                                                      ? Text(
                                                    "${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .customPrize}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  )
                                                      : controller
                                                      .joinedBattlesDetailsModel
                                                      .value
                                                      .winner.prizeAmount !=
                                                      null &&
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .winner.prizeAmount
                                                          .type
                                                          .compareTo("bonus") ==
                                                          0
                                                      ? Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          child: Image.asset(
                                                              ImageRes()
                                                                  .ic_coin),
                                                        ),
                                                        Text(
                                                          "${controller
                                                              .joinedBattlesDetailsModel
                                                              .value.winner
                                                              .prizeAmount !=
                                                              null
                                                              ? controller
                                                              .joinedBattlesDetailsModel
                                                              .value.winner
                                                              .prizeAmount.value
                                                              : "-"}",
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: "Inter",
                                                              color: AppColor()
                                                                  .colorPrimary),
                                                        )
                                                      ])
                                                      : Text(
                                                    "${ApiUrl().isPlayStore
                                                        ? ""
                                                        : '\u{20B9}'} ${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount !=
                                                        null ? controller
                                                        .joinedBattlesDetailsModel
                                                        .value
                                                        .winner.prizeAmount
                                                        .value ~/ 100 : "-"}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),

                                                  /*    Text(
                                                    "${ApiUrl().isPlayStore
                                                        ? ""
                                                        : '\u{20B9}'} ${controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount != null
                                                        ? controller
                                                        .joinedBattlesDetailsModel
                                                        .value.winner
                                                        .prizeAmount.value /
                                                        100
                                                        : "--"}",
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                        14,
                                                        fontFamily:
                                                        "Inter",
                                                        color: AppColor()
                                                            .colorPrimary),
                                                  ),*/
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Type",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      controller
                                                          .joinedBattlesDetailsModel
                                                          .value
                                                          .gameModeId
                                                          .name,
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Winners",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          controller
                                                              .joinedBattlesDetailsModel
                                                              .value
                                                              .getTotalWinner(),
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                              fontSize:
                                                              14,
                                                              fontFamily:
                                                              "Inter",
                                                              color: AppColor()
                                                                  .colorPrimary),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            showWinningBreakupDialog(
                                                                context,
                                                                controller
                                                                    .joinedBattlesDetailsModel
                                                                    .value);
                                                          },
                                                          child:
                                                          Container(
                                                            width: 13,
                                                            alignment:
                                                            Alignment
                                                                .topCenter,
                                                            child: Image
                                                                .asset(
                                                                "assets/images/arrow_down.png"),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )),
                                            Container(
                                              width: 1,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Entry Fee",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .wallet_medium_grey),
                                                    ),
                                                    Text(
                                                      "${controller
                                                          .joinedBattlesDetailsModel
                                                          .value.entry.fee
                                                          .value ~/ 100}",
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          "Inter",
                                                          color: AppColor()
                                                              .colorPrimary),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Container(
                                          margin:
                                          EdgeInsets.symmetric(
                                              horizontal: 9,
                                              vertical: 3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(20),
                                          ),
                                          child:
                                          LinearProgressIndicator(
                                            valueColor:
                                            AlwaysStoppedAnimation(
                                                AppColor()
                                                    .colorPrimary),
                                            backgroundColor:
                                            AppColor()
                                                .colorGray,
                                            value: controller
                                                .joinedBattlesDetailsModel
                                                .value
                                                .getProgresBar(),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 2,
                                              bottom: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                controller
                                                    .joinedBattlesDetailsModel
                                                    .value
                                                    .getRemaningPlayer(),
                                                textAlign: TextAlign
                                                    .center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                    "Inter",
                                                    color: AppColor()
                                                        .wallet_medium_grey),
                                              ),
                                              Text(
                                                controller
                                                    .joinedBattlesDetailsModel
                                                    .value
                                                    .getEventJoinedPlayer(),
                                                textAlign: TextAlign
                                                    .center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                    "Inter",
                                                    color: AppColor()
                                                        .wallet_medium_grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: AppColor()
                                                  .colorPrimary,
                                              borderRadius:
                                              BorderRadius.only(
                                                  bottomRight: Radius
                                                      .circular(
                                                      10),
                                                  bottomLeft: Radius
                                                      .circular(
                                                      10))),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child:
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left:
                                                            10,
                                                            bottom:
                                                            5,
                                                            top: 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              "Room ID",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  fontFamily:
                                                                  "Inter",
                                                                  color:
                                                                  AppColor()
                                                                      .whiteColor),
                                                            ),
                                                            Container(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  (controller
                                                                      .joinedBattlesPlayersModel
                                                                      .value !=
                                                                      null &&
                                                                      controller
                                                                          .joinedBattlesDetailsModel
                                                                          .value !=
                                                                          null)
                                                                      ? '${controller
                                                                      .joinedBattlesPlayersModel
                                                                      .value
                                                                      .getRoomNameTeam(
                                                                      controller
                                                                          .joinedBattlesDetailsModel
                                                                          .value
                                                                          .rounds[0]
                                                                          .id)}'
                                                                      : "",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: "Inter",
                                                                      color: AppColor()
                                                                          .whiteColor),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                        msg: "Copied Succesfully");
                                                                    Clipboard
                                                                        .setData(
                                                                        ClipboardData(
                                                                            text: (controller
                                                                                .joinedBattlesPlayersModel
                                                                                .value !=
                                                                                null
                                                                                &&
                                                                                controller
                                                                                    .joinedBattlesDetailsModel
                                                                                    .value !=
                                                                                    null)
                                                                                ?
                                                                            '${controller
                                                                                .joinedBattlesPlayersModel
                                                                                .value
                                                                                .getRoomNameTeam(
                                                                                controller
                                                                                    .joinedBattlesDetailsModel
                                                                                    .value
                                                                                    .rounds[0]
                                                                                    .id)}'
                                                                                : ""));
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    height:
                                                                    20,
                                                                    width:
                                                                    20,
                                                                    child:
                                                                    Image.asset(
                                                                      "assets/images/ic_copy.webp",
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                  Container(
                                                    margin: EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        10),
                                                    width: 1,
                                                    height: 30,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                  Expanded(
                                                      child:
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            right:
                                                            10,
                                                            bottom:
                                                            5,
                                                            top: 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              "Password",
                                                              textAlign:
                                                              TextAlign
                                                                  .start,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  fontFamily:
                                                                  "Inter",
                                                                  color:
                                                                  AppColor()
                                                                      .whiteColor),
                                                            ),
                                                            Container(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  (controller
                                                                      .joinedBattlesPlayersModel
                                                                      .value !=
                                                                      null &&
                                                                      controller
                                                                          .joinedBattlesDetailsModel
                                                                          .value !=
                                                                          null)
                                                                      ? '${controller
                                                                      .joinedBattlesPlayersModel
                                                                      .value
                                                                      .getRoompassword(
                                                                      controller
                                                                          .joinedBattlesDetailsModel
                                                                          .value
                                                                          .rounds[0]
                                                                          .id)}'
                                                                      : "",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: "Inter",
                                                                      color: AppColor()
                                                                          .whiteColor),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    Clipboard
                                                                        .setData(
                                                                        ClipboardData(
                                                                          text: (controller
                                                                              .joinedBattlesPlayersModel
                                                                              .value !=
                                                                              null &&
                                                                              controller
                                                                                  .joinedBattlesDetailsModel
                                                                                  .value !=
                                                                                  null)
                                                                              ?
                                                                          '${controller
                                                                              .joinedBattlesPlayersModel
                                                                              .value
                                                                              .getRoompassword(
                                                                              controller
                                                                                  .joinedBattlesDetailsModel
                                                                                  .value
                                                                                  .rounds[0]
                                                                                  .id)}'
                                                                              : "",
                                                                        ));

                                                                    Fluttertoast
                                                                        .showToast(
                                                                        msg: "Copied Succesfully");
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    height:
                                                                    20,
                                                                    width:
                                                                    20,
                                                                    child:
                                                                    Image.asset(
                                                                      "assets/images/ic_copy.webp",
                                                                      color: Colors
                                                                          .white,
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
                                              Container(
                                                height: 5,
                                              ),
                                              Text(
                                                "Details will be shared 15 mins before the game starts",
                                                textAlign:
                                                TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                    "Inter",
                                                    color: AppColor()
                                                        .whiteColor),
                                              ),
                                              Container(
                                                height: 10,
                                              ),

                                              controller
                                                  .joinedBattlesDetailsModel
                                                  .value.isSoloContest()
                                                  ? Container(
                                                height: 0,
                                              )
                                                  : Column(
                                                children: [
                                                  Container(height: 1,
                                                    color: Colors.white,),
                                                  Container(
                                                    height: 5,
                                                  ), Row(
                                                    children: [
                                                      Expanded(
                                                          child:
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left:
                                                                10,
                                                                bottom:
                                                                5,
                                                                top: 5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  "Team Name",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      fontFamily:
                                                                      "Inter",
                                                                      color:
                                                                      AppColor()
                                                                          .whiteColor),
                                                                ),
                                                                Container(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  controller
                                                                      .joinedUserDetailsResult
                                                                      .value !=
                                                                      null&&controller
                                                                      .joinedUserDetailsResult
                                                                      .value
                                                                      .teamId!=null
                                                                      ? controller
                                                                      .joinedUserDetailsResult
                                                                      .value
                                                                      .teamId
                                                                      .name
                                                                      : "",

                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: "Inter",
                                                                      color: AppColor()
                                                                          .whiteColor),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            10),
                                                        width: 1,
                                                        height: 30,
                                                        color: Colors
                                                            .white,
                                                      ),
                                                      Expanded(
                                                          child:
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right:
                                                                10,
                                                                bottom:
                                                                5,
                                                                top: 5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  "Slot",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      fontFamily:
                                                                      "Inter",
                                                                      color:
                                                                      AppColor()
                                                                          .whiteColor),
                                                                ),
                                                                Container(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "${ controller
                                                                          .joinedUserDetailsResult
                                                                          .value !=
                                                                          null
                                                                          ? controller
                                                                          .joinedUserDetailsResult
                                                                          .value
                                                                          .members !=
                                                                          null &&
                                                                          controller
                                                                              .joinedUserDetailsResult
                                                                              .value
                                                                              .members
                                                                              .length >
                                                                              0
                                                                          ? controller
                                                                          .joinedUserDetailsResult
                                                                          .value
                                                                          .members[0]
                                                                          .eventRegistration
                                                                          .rounds
                                                                          .length >
                                                                          0
                                                                          ? controller
                                                                          .joinedUserDetailsResult
                                                                          .value
                                                                          .members[0]
                                                                          .eventRegistration
                                                                          .rounds[0]
                                                                          .slot ??
                                                                          ""
                                                                          : ""
                                                                          : ""
                                                                          : ""}",
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontFamily: "Inter",
                                                                          color: AppColor()
                                                                              .whiteColor),
                                                                    ),

                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),


                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                      : Container(),
                                  Container(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: AppColor().colorPrimary,
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                            Radius.circular(10.0),
                                            topRight:
                                            Radius.circular(10.0))),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "User Name".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "Winnings".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "Kills".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "Ranks".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() =>
                                  (controller
                                      .joinedBattlesDetailsModel !=
                                      null &&
                                      controller
                                          .joinedBattlesDetailsModel
                                          .value !=
                                          null &&
                                      !controller
                                          .joinedBattlesDetailsModel
                                          .value
                                          .isSoloContest())
                                      ? Container(
                                    margin: EdgeInsets.only(
                                        bottom: 10,
                                        top: 0,
                                        left: 10,
                                        right: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor().whiteColor,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Obx(() =>
                                        ListView.builder(
                                          // physics:
                                          // NeverScrollableScrollPhysics(),
                                            padding:
                                            EdgeInsets.all(0),
                                            itemCount: (controller
                                                .joinedBattlesDetailsModel !=
                                                null &&
                                                controller
                                                    .joinedUserDetailsResult !=
                                                    null &&
                                                controller
                                                    .joinedUserDetailsResult
                                                    .value !=
                                                    null &&
                                                controller
                                                    .joinedUserDetailsResult
                                                    .value
                                                    .members !=
                                                    null &&
                                                controller
                                                    .joinedUserDetailsResult
                                                    .value
                                                    .members
                                                    .length >
                                                    0)
                                                ? controller
                                                .joinedUserDetailsResult
                                                .value
                                                .members
                                                .length
                                                : 0,
                                            shrinkWrap: true,
                                            itemBuilder:
                                                (context, index) {
                                              return playerResultInfoTeam(
                                                  index);
                                            })),
                                  )
                                      : playerResultInfoSolo()),
                                  Container(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text(
                                      "Invite your friend to join this contest".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Roboto",
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Utils().funShare(_userController
                                          .getUserReferalCode());
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 45,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 15),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 2),
                                          color: AppColor().whiteColor,
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 25,
                                            width: 25,
                                            child: Image.asset(
                                              "assets/images/share_icon_new.png",
                                            ),
                                          ),
                                          Text(
                                            "INVITE FRIENDS".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w500,
                                                fontFamily: "Inter",
                                                color: AppColor().colorPrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Find us on".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          base_controller.facebook();
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 0, bottom: 5, top: 5),
                                            child: Image(
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/facebook.webp'),
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          base_controller
                                              .launchInstagram(
                                              "https://www.instagram.com/gmngofficial/?hl=en");
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Image(
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/instagram.webp'),
                                            )),
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          base_controller
                                              .launchYouTube();
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Image(
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/youtube.webp'),
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          base_controller
                                              .launchdiscord();
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Image(
                                              height: 47,
                                              width: 47,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/iv_discord_new.png'),
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              )
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
                                  : controller.joinedDetailsType.value ==
                                  "Players"
                                  ? Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 15),
                                          decoration: BoxDecoration(
                                              color:
                                              AppColor().colorPrimary,
                                              borderRadius: BorderRadius
                                                  .only(
                                                  topLeft:
                                                  Radius.circular(
                                                      10.0),
                                                  topRight:
                                                  Radius.circular(
                                                      10.0))),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "User Name".tr,
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "Winnings".tr,
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "Kills".tr,
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "Ranks".tr,
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0,
                                        ),
                                        Container(

                                          margin: EdgeInsets.only(
                                              bottom: 10,
                                              top: 0,
                                              left: 10,
                                              right: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: AppColor().whiteColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(
                                                      10),
                                                  bottomLeft: Radius.circular(
                                                      10))

                                          ),
                                          child: Obx(() =>
                                          controller
                                              .joinedBattlesPlayersModel !=
                                              null &&
                                              controller
                                                  .joinedBattlesPlayersModel
                                                  .value !=
                                                  null &&
                                              controller
                                                  .joinedBattlesPlayersModel
                                                  .value
                                                  .teams
                                                  .length >
                                                  0 ?
                                          ListView.builder(
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              padding:
                                              EdgeInsets.all(0),
                                              itemCount: (controller
                                                  .joinedBattlesPlayersModel !=
                                                  null &&
                                                  controller
                                                      .joinedBattlesPlayersModel
                                                      .value !=
                                                      null &&
                                                  controller
                                                      .joinedBattlesPlayersModel
                                                      .value
                                                      .teams
                                                      .length >
                                                      0)
                                                  ? controller
                                                  .joinedBattlesPlayersModel
                                                  .value
                                                  .teams
                                                  .length
                                                  : 0,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (context, index) {
                                                return playerDetailsTeams(
                                                    index);
                                              })

                                              : ListView.builder(
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              padding:
                                              EdgeInsets.all(0),
                                              itemCount: (controller
                                                  .joinedBattlesPlayersModel !=
                                                  null &&
                                                  controller
                                                      .joinedBattlesPlayersModel
                                                      .value !=
                                                      null &&
                                                  controller
                                                      .joinedBattlesPlayersModel
                                                      .value
                                                      .users
                                                      .length >
                                                      0)
                                                  ? controller
                                                  .joinedBattlesPlayersModel
                                                  .value
                                                  .users
                                                  .length
                                                  : 0,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (context, index) {
                                                return playerDetailsUser(
                                                    index);
                                              })
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                                  : controller.joinedDetailsType.value ==
                                  "Rules"
                                  ? Column(
                                children: [
                                  Container(
                                    child: (controller
                                        .joinedBattlesDetailsModel != null &&
                                        controller
                                            .joinedBattlesDetailsModel
                                            .value !=
                                            null &&
                                        controller
                                            .joinedBattlesDetailsModel
                                            .value
                                            .rules !=
                                            null &&
                                        controller
                                            .joinedBattlesDetailsModel
                                            .value
                                            .rules
                                            .length >
                                            0)
                                        ? Container(
                                      margin:
                                      EdgeInsets.all(10.0),
                                      child: Html(
                                        data: controller
                                            .joinedBattlesDetailsModel
                                            .value
                                            .getRules() ??
                                            "Rules",
                                        style: {
                                          "body": Style(
                                              fontSize:
                                              FontSize(
                                                  14.0),
                                              fontWeight:
                                              FontWeight
                                                  .w400,
                                              color:
                                              Colors.white),
                                          "p": Style(
                                            fontSize: FontSize(14.0),
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        },
                                      )

                                      /*Text(
                                                        controller
                                                            .joinedBattlesDetailsModel
                                                            .value
                                                            .getRules(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )*/
                                      ,
                                    )
                                        : Text(""),
                                  )
                                ],
                              )
                                  : controller.joinedDetailsType.value ==
                                  "Table"
                                  ? Column(
                                children: [
                                  Container(
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: url != null ? Image.network(

                                          url) : AssetImage(
                                          "assets/images/login_bg.webp")),
                                ],
                              )
                                  : null),
                    )
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  /*Team player details*/
  Widget playerDetails(int pos) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Wrap(
        children: [
          Row(
            /* mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,*/
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.joinedBattlesPlayersModel.value.teams[pos]
                          .teamId.name}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                    Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: "Inter",
                          color: AppColor().colorGray),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  "----",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().colorGray),
                ),
              ),
              Expanded(
                child: Text(
                  "---",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().colorGray),
                ),
              ),
              Expanded(
                child: Text(
                  "--",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().colorGray),
                ),
              )
            ],
          ),
          Container(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  /* champianship round waise list */
  Widget contestListRoundWise(BuildContext context, int index) {
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AppColor().whiteColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 42,
            child: Container(
              padding: EdgeInsets.only(left: 7, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Round-${index + 1} ${ (controller.joinedUserDetailsResult
                          .value.members[0].eventRegistration.rounds[index] !=
                          null
                          && controller.joinedUserDetailsResult
                              .value.members[0].eventRegistration.rounds[index]
                              .lobbyId != null) ?
                      controller.joinedBattlesPlayersModel.value != null
                          ? controller.joinedBattlesPlayersModel.value
                          .getLobbyInfo(
                          controller.joinedUserDetailsResult
                              .value.members[0].eventRegistration.rounds[index]
                              .roundId, controller.joinedUserDetailsResult
                          .value.members[0].eventRegistration.rounds[index]
                          .lobbyId) != null ?
                      " (Lobby" + '${controller.joinedBattlesPlayersModel.value
                          .getLobbyInfo(controller.joinedUserDetailsResult
                          .value.members[0].eventRegistration.rounds[index]
                          .roundId, controller.joinedUserDetailsResult
                          .value.members[0].eventRegistration.rounds[index]
                          .lobbyId)
                          .serialNumber})' : ''
                          : "" : ""}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
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

                      '${(controller.joinedUserDetailsResult
                          .value.members[0].eventRegistration.rounds[index] !=
                          null &&
                          controller.joinedUserDetailsResult
                              .value.members[0].eventRegistration.rounds[index]
                              .lobbyId != null
                          && (controller.joinedBattlesPlayersModel.value != null
                              ? controller.joinedBattlesPlayersModel.value
                              .getLobbyInfo(controller.joinedUserDetailsResult
                              .value.members[0].eventRegistration.rounds[index]
                              .roundId,
                              controller.joinedUserDetailsResult
                                  .value.members[0].eventRegistration
                                  .rounds[index].lobbyId)
                              .startDate
                              : "") != null
                      ) ? DateFormat("dd/MM/yyyy").format(
                          DateFormat("yyyy-MM-dd").parse(controller
                              .joinedBattlesPlayersModel.value != null
                              ? controller
                              .joinedBattlesPlayersModel.value
                              .getLobbyInfo(controller.joinedUserDetailsResult
                              .value.members[0].eventRegistration.rounds[index]
                              .roundId,
                              controller.joinedUserDetailsResult
                                  .value.members[0].eventRegistration
                                  .rounds[index].lobbyId)
                              .startDate
                              : "0000-00-00")) : "-"}',
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
                        '${(controller.joinedUserDetailsResult
                            .value.members[0].eventRegistration.rounds[index] !=
                            null &&
                            controller.joinedUserDetailsResult
                                .value.members[0].eventRegistration
                                .rounds[index].lobbyId != null
                            && (controller.joinedBattlesPlayersModel.value
                                != null ? controller.joinedBattlesPlayersModel
                                .value
                                .getLobbyInfo(controller.joinedUserDetailsResult
                                .value.members[0].eventRegistration
                                .rounds[index].roundId,
                                controller.joinedUserDetailsResult
                                    .value.members[0].eventRegistration
                                    .rounds[index].lobbyId)
                                .startDate : "") != null
                        )
                            ? DateFormat("hh:mm aa").format(
                            DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(controller
                                .joinedBattlesPlayersModel.value != null
                                ? controller
                                .joinedBattlesPlayersModel.value
                                .getLobbyInfo(controller.joinedUserDetailsResult
                                .value.members[0].eventRegistration
                                .rounds[index].roundId,
                                controller.joinedUserDetailsResult
                                    .value.members[0].eventRegistration
                                    .rounds[index].lobbyId)
                                .startDate
                                : "2022-03-09T15:54:14.740Z", true).toLocal())
                            : "-"}',
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
                        '${(controller.joinedUserDetailsResult
                            .value.members[0].eventRegistration.rounds[index] !=
                            null &&
                            controller.joinedUserDetailsResult
                                .value.members[0].eventRegistration
                                .rounds[index].lobbyId != null
                            &&
                            (controller.joinedBattlesPlayersModel.value != null
                                ? controller.joinedBattlesPlayersModel.value
                                .getLobbyInfo(controller.joinedUserDetailsResult
                                .value.members[0].eventRegistration
                                .rounds[index].roundId,
                                controller.joinedUserDetailsResult
                                    .value.members[0].eventRegistration
                                    .rounds[index].lobbyId)
                                .gameMapId
                                : "2022-03-09T15:54:14.740Z") != null
                        ) ? (controller.joinedBattlesPlayersModel.value != null
                            ? controller.joinedBattlesPlayersModel.value
                            .getLobbyInfo(controller.joinedUserDetailsResult
                            .value.members[0].eventRegistration.rounds[index]
                            .roundId,
                            controller.joinedUserDetailsResult
                                .value.members[0].eventRegistration
                                .rounds[index].lobbyId)
                            .gameMapId
                            .name
                            : "2022-03-09T15:54:14.740Z") : "-"}',
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
                        controller
                            .joinedBattlesDetailsModel.value.gamePerspectiveId
                            != null ? controller
                            .joinedBattlesDetailsModel.value.gamePerspectiveId
                            .name : "-",
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
          Container(
            height: 5,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
          Container(
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
                    controller.joinedBattlesDetailsModel.value.winner
                        .customPrize !=
                        null &&
                        controller.joinedBattlesDetailsModel.value
                            .winner.customPrize.isNotEmpty
                        ? Text(
                      "${controller.joinedBattlesDetailsModel.value.winner
                          .customPrize}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    )
                        : controller.joinedBattlesDetailsModel.value
                        .winner.prizeAmount !=
                        null &&
                        controller.joinedBattlesDetailsModel.value
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
                            "${controller.joinedBattlesDetailsModel.value.winner
                                .prizeAmount != null ? controller
                                .joinedBattlesDetailsModel.value.winner
                                .prizeAmount.value : "-"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        ])
                        : Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                          .joinedBattlesDetailsModel.value.winner.prizeAmount !=
                          null ? controller.joinedBattlesDetailsModel.value
                          .winner.prizeAmount.value ~/ 100 : "-"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),

                    /* Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                          .joinedBattlesDetailsModel.value
                          .winner.prizeAmount!=null?controller
                          .joinedBattlesDetailsModel.value
                          .winner.prizeAmount.value ~/ 100:"--"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    )*/
                  ],
                ),
              ),
              Container(
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
                        controller.joinedBattlesDetailsModel.value.gameModeId
                            .name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  )),
              Container(
                width: 1,
              ),
              Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Winners",
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
                            controller.joinedBattlesDetailsModel.value
                                .getTotalWinner(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          ),
                          GestureDetector(
                            onTap: () {
                              showWinningBreakupDialog(context,
                                  controller.joinedBattlesDetailsModel.value);
                            },
                            child: Container(
                              width: 13,
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                  "assets/images/arrow_down.png"),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Container(
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
                      Text(
                        "${controller.joinedBattlesDetailsModel.value.entry.fee
                            .value ~/ 100}",
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
          Container(
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
                value:
                controller.joinedBattlesDetailsModel.value.getProgresBar(),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.joinedBattlesDetailsModel.value
                      .getRemaningPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
                Text(
                  controller.joinedBattlesDetailsModel.value
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
          Container(
            height: 5,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Column(
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
                              Container(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,

                                children: [
                                  Text((controller.joinedBattlesPlayersModel
                                      .value != null &&
                                      controller.joinedUserDetailsResult
                                          .value.members[0].eventRegistration
                                          .rounds[index] != null
                                      && controller.joinedUserDetailsResult
                                          .value.members[0].eventRegistration
                                          .rounds[index].lobbyId != null
                                  ) ?
                                  controller.joinedBattlesPlayersModel.value
                                      .getRoomNameChampainShip(
                                      controller.joinedUserDetailsResult
                                          .value.members[0].eventRegistration
                                          .rounds[index].roundId,
                                      controller.joinedUserDetailsResult
                                          .value.members[0].eventRegistration
                                          .rounds[index].lobbyId) : "",
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
                                          text: (controller
                                              .joinedUserDetailsResult
                                              .value.members[0]
                                              .eventRegistration
                                              .rounds[index] != null &&
                                              controller.joinedUserDetailsResult
                                                  .value.members[0]
                                                  .eventRegistration
                                                  .rounds[index].lobbyId != null
                                              ?
                                          controller.joinedBattlesPlayersModel
                                              .value
                                              .getRoomNameChampainShip(
                                              controller.joinedUserDetailsResult
                                                  .value.members[0]
                                                  .eventRegistration
                                                  .rounds[index].roundId,
                                              controller.joinedUserDetailsResult
                                                  .value.members[0]
                                                  .eventRegistration
                                                  .rounds[index].lobbyId)
                                              : "")));
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
                              Container(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    (controller.joinedUserDetailsResult
                                        .value.members[0].eventRegistration
                                        .rounds[index] != null
                                        && controller.joinedUserDetailsResult
                                            .value.members[0].eventRegistration
                                            .rounds[index].lobbyId != null) ?
                                    controller.joinedBattlesPlayersModel
                                        .value != null ? controller
                                        .joinedBattlesPlayersModel.value
                                        .getRoompasswordChampainShip(
                                        controller.joinedUserDetailsResult
                                            .value.members[0].eventRegistration
                                            .rounds[index].roundId,
                                        controller.joinedUserDetailsResult
                                            .value.members[0].eventRegistration
                                            .rounds[index].lobbyId) : "" : "",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
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
                                          text: (controller
                                              .joinedUserDetailsResult
                                              .value.members[0]
                                              .eventRegistration
                                              .rounds[index] != null)
                                              ?
                                          controller.joinedBattlesPlayersModel
                                              .value
                                              .getRoompassword(
                                              controller.joinedUserDetailsResult
                                                  .value.members[0]
                                                  .eventRegistration
                                                  .rounds[index].roundId)
                                              : ""));
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
                Container(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                  child: Text(
                    "Details will be shared 15 mins before the game starts",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().whiteColor),
                  ),
                ),
                Container(
                  height: 10,
                ),


                controller
                    .joinedBattlesDetailsModel
                    .value.isSoloContest()
                    ? Container(
                  height: 0,
                )
                    : Column(
                  children: [
                    Container(height: 1, color: Colors.white,),
                    Container(
                      height: 5,
                    ), Row(
                      children: [
                        Expanded(
                            child:
                            Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                  left:
                                  10,
                                  bottom:
                                  5,
                                  top: 5),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    "Team Name",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style: TextStyle(
                                        fontSize:
                                        14,
                                        fontFamily:
                                        "Inter",
                                        color:
                                        AppColor()
                                            .whiteColor),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Text(
                                    controller.joinedUserDetailsResult.value !=
                                        null ? controller
                                        .joinedUserDetailsResult.value.teamId
                                        .name : "",

                                    textAlign:
                                    TextAlign
                                        .center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        color: AppColor()
                                            .whiteColor),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          margin: EdgeInsets
                              .symmetric(
                              horizontal:
                              10),
                          width: 1,
                          height: 30,
                          color: Colors
                              .white,
                        ),
                        Expanded(
                            child:
                            Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                  right:
                                  10,
                                  bottom:
                                  5,
                                  top: 5),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    "Slot",
                                    textAlign:
                                    TextAlign
                                        .start,
                                    style: TextStyle(
                                        fontSize:
                                        14,
                                        fontFamily:
                                        "Inter",
                                        color:
                                        AppColor()
                                            .whiteColor),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        "${ controller.joinedUserDetailsResult
                                            .value != null ? controller
                                            .joinedUserDetailsResult
                                            .value.members[0]
                                            .eventRegistration != null
                                            ? controller.joinedUserDetailsResult
                                            .value.members[0].eventRegistration
                                            .rounds.length > 0 ? controller
                                            .joinedUserDetailsResult
                                            .value.members[0].eventRegistration
                                            .rounds[index].slot ?? "" : ""
                                            : "" : ""}",

                                        textAlign:
                                        TextAlign
                                            .center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: AppColor()
                                                .whiteColor),
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),


              ],
            ),
          )
        ],
      ),
    );
  }

  Widget contestListRoundWiseSolo(BuildContext context, int index) {
    return Container(
      // padding: EdgeInsets.only(top: 5),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AppColor().whiteColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 42,
            child: Container(
              padding: EdgeInsets.only(left: 7, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Round-${index + 1} ${(controller
                          .joinedBattlesPlayersModel.value != null &&
                          controller.joinedUserDetailsSoloResult.value
                              .rounds[index] != null &&
                          controller.joinedUserDetailsSoloResult.value
                              .rounds[index].lobbyId != null) ?
                      controller.joinedBattlesPlayersModel.value
                          .getLobbyInfo(controller.joinedUserDetailsSoloResult
                          .value.rounds[index].roundId,
                          controller.joinedUserDetailsSoloResult.value
                              .rounds[index].lobbyId) != null ?
                      " (Lobby" + '${controller.joinedBattlesPlayersModel.value
                          .getLobbyInfo(controller.joinedUserDetailsSoloResult
                          .value.rounds[index].roundId,
                          controller.joinedUserDetailsSoloResult.value
                              .rounds[index].lobbyId)
                          .serialNumber} )' : "" : ""}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
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
                      '${(controller.joinedBattlesPlayersModel.value != null &&
                          controller.joinedUserDetailsSoloResult.value
                              .rounds[index] != null &&
                          controller.joinedUserDetailsSoloResult.value
                              .rounds[index].lobbyId != null
                          && (controller.joinedBattlesPlayersModel.value
                              .getLobbyInfo(controller
                              .joinedUserDetailsSoloResult.value.rounds[index]
                              .roundId,
                              controller.joinedUserDetailsSoloResult.value
                                  .rounds[index].lobbyId)
                              .startDate) != null
                      ) ?
                      DateFormat("dd/MM/yyyy").format(
                          DateFormat("yyyy-MM-dd").parse(controller
                              .joinedBattlesPlayersModel.value
                              .getLobbyInfo(controller
                              .joinedUserDetailsSoloResult.value.rounds[index]
                              .roundId,
                              controller.joinedUserDetailsSoloResult.value
                                  .rounds[index].lobbyId)
                              .startDate)) : "-"}',
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
                        '${(controller.joinedBattlesPlayersModel.value !=
                            null &&
                            controller.joinedUserDetailsSoloResult.value
                                .rounds[index] != null &&
                            controller.joinedUserDetailsSoloResult.value
                                .rounds[index].lobbyId != null
                            && (controller.joinedBattlesPlayersModel.value
                                .getLobbyInfo(controller
                                .joinedUserDetailsSoloResult.value.rounds[index]
                                .roundId,
                                controller.joinedUserDetailsSoloResult.value
                                    .rounds[index].lobbyId)
                                .startDate) != null
                        ) ?
                        DateFormat("hh:mm aa").format(
                            DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(controller
                                .joinedBattlesPlayersModel.value
                                .getLobbyInfo(
                                controller.joinedUserDetailsSoloResult.value
                                    .rounds[index].roundId,
                                controller.joinedUserDetailsSoloResult.value
                                    .rounds[index].lobbyId)
                                .startDate, true).toLocal()) : "-"}',
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
                        '${(controller.joinedBattlesPlayersModel.value !=
                            null &&
                            controller.joinedUserDetailsSoloResult.value
                                .rounds[index] != null &&
                            controller.joinedUserDetailsSoloResult.value
                                .rounds[index].lobbyId != null
                            && (controller.joinedBattlesPlayersModel.value
                                .getLobbyInfo(controller
                                .joinedUserDetailsSoloResult.value.rounds[index]
                                .roundId,
                                controller.joinedUserDetailsSoloResult.value
                                    .rounds[index].lobbyId)).gameMapId != null
                        ) ? controller.joinedBattlesPlayersModel.value
                            .getLobbyInfo(
                            controller.joinedUserDetailsSoloResult.value
                                .rounds[index].roundId,
                            controller.joinedUserDetailsSoloResult.value
                                .rounds[index].lobbyId)
                            .gameMapId
                            .name : "-"}',
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
                        controller
                            .joinedBattlesDetailsModel.value.gamePerspectiveId
                            .name,
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
          Container(
            height: 5,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
          Container(
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
                    controller.joinedBattlesDetailsModel.value.winner
                        .customPrize !=
                        null &&
                        controller.joinedBattlesDetailsModel.value
                            .winner.customPrize.isNotEmpty
                        ? Text(
                      "${controller.joinedBattlesDetailsModel.value.winner
                          .customPrize}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    )
                        : controller.joinedBattlesDetailsModel.value
                        .winner.prizeAmount !=
                        null &&
                        controller.joinedBattlesDetailsModel.value
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
                            "${controller.joinedBattlesDetailsModel.value.winner
                                .prizeAmount != null ? controller
                                .joinedBattlesDetailsModel.value.winner
                                .prizeAmount.value : "-"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        ])
                        : Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                          .joinedBattlesDetailsModel.value.winner.prizeAmount !=
                          null ? controller.joinedBattlesDetailsModel.value
                          .winner.prizeAmount.value ~/ 100 : "-"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),


                    /*   Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                          .joinedBattlesDetailsModel.value
                          .winner.prizeAmount != null ? controller
                          .joinedBattlesDetailsModel.value
                          .winner.prizeAmount.value ~/ 100 : "--"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),*/
                  ],
                ),
              ),
              Container(
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
                        controller.joinedBattlesDetailsModel.value.gameModeId
                            .name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  )),
              Container(
                width: 1,
              ),
              Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Winners",
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
                            controller.joinedBattlesDetailsModel.value
                                .getTotalWinner(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          ),
                          GestureDetector(
                            onTap: () {
                              showWinningBreakupDialog(context,
                                  controller.joinedBattlesDetailsModel.value);
                            },
                            child: Container(
                              width: 13,
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                  "assets/images/arrow_down.png"),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Container(
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
                      Text(
                        "${controller.joinedBattlesDetailsModel.value.entry.fee
                            .value ~/ 100}",
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
          Container(
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
                value:
                controller.joinedBattlesDetailsModel.value.getProgresBar(),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.joinedBattlesDetailsModel.value
                      .getRemaningPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
                Text(
                  controller.joinedBattlesDetailsModel.value
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
          Container(
            height: 5,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Column(
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
                              Container(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    (controller.joinedBattlesPlayersModel
                                        .value != null
                                        &&
                                        controller.joinedUserDetailsSoloResult
                                            .value != null &&
                                        controller.joinedUserDetailsSoloResult
                                            .value.rounds[index].lobbyId !=
                                            null &&
                                        controller.joinedUserDetailsSoloResult
                                            .value.rounds[index] != null) ?
                                    controller.joinedBattlesPlayersModel.value
                                        .getRoomNameChampainShip(
                                        controller.joinedUserDetailsSoloResult
                                            .value.rounds[index].roundId,
                                        controller.joinedUserDetailsSoloResult
                                            .value.rounds[index].lobbyId
                                    ) : "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        color: AppColor().whiteColor),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: (controller
                                              .joinedBattlesPlayersModel
                                              .value != null
                                              && controller
                                                  .joinedUserDetailsSoloResult
                                                  .value != null &&

                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds[index]
                                                  .lobbyId != null &&
                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds[index] != null)
                                              ?
                                          controller.joinedBattlesPlayersModel
                                              .value
                                              .getRoomNameChampainShip(
                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds[index].roundId,
                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds[index].lobbyId)
                                              : ""));

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
                              Container(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    (controller.joinedBattlesPlayersModel
                                        .value != null &&
                                        controller.joinedUserDetailsSoloResult
                                            .value.rounds[index] != null &&
                                        controller.joinedUserDetailsSoloResult
                                            .value.rounds[index].lobbyId !=
                                            null) ?
                                    controller.joinedBattlesPlayersModel.value
                                        .getRoompasswordChampainShip(
                                        controller.joinedUserDetailsSoloResult
                                            .value.rounds[index].roundId,
                                        controller.joinedUserDetailsSoloResult
                                            .value.rounds[index].lobbyId) : "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        color: AppColor().whiteColor),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: (controller
                                              .joinedBattlesPlayersModel
                                              .value != null &&
                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds[index] != null
                                              && controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds[index]
                                                  .lobbyId != null
                                          )
                                              ?
                                          controller.joinedBattlesPlayersModel
                                              .value
                                              .getRoompasswordChampainShip(
                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds[index].roundId,
                                              controller
                                                  .joinedUserDetailsSoloResult
                                                  .value.rounds[index].lobbyId)
                                              : ""));


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
                  ],
                ),
                Container(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                  child: Text(
                    "Details will be shared 15 mins before the game starts",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().whiteColor),
                  ),
                ),
                Container(
                  height: 10,
                ),


                controller
                    .joinedBattlesDetailsModel
                    .value.isSoloContest()
                    ? Container(
                  height: 0,
                )
                    : Column(children: [
                  Container(height: 1, color: Colors.white,),
                  Container(
                    height: 5,
                  ), Row(
                    children: [
                      Expanded(
                          child:
                          Padding(
                            padding:
                            const EdgeInsets
                                .only(
                                left:
                                10,
                                bottom:
                                5,
                                top: 5),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  "Team Name",
                                  textAlign:
                                  TextAlign
                                      .center,
                                  style: TextStyle(
                                      fontSize:
                                      14,
                                      fontFamily:
                                      "Inter",
                                      color:
                                      AppColor()
                                          .whiteColor),
                                ),
                                Container(
                                  height: 5,
                                ),
                                Text(
                                  controller.joinedUserDetailsResult.value !=
                                      null ? controller.joinedUserDetailsResult
                                      .value.teamId.name : "",

                                  textAlign:
                                  TextAlign
                                      .center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: AppColor()
                                          .whiteColor),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        margin: EdgeInsets
                            .symmetric(
                            horizontal:
                            10),
                        width: 1,
                        height: 30,
                        color: Colors
                            .white,
                      ),
                      Expanded(
                          child:
                          Padding(
                            padding:
                            const EdgeInsets
                                .only(
                                right:
                                10,
                                bottom:
                                5,
                                top: 5),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  "Slot",
                                  textAlign:
                                  TextAlign
                                      .start,
                                  style: TextStyle(
                                      fontSize:
                                      14,
                                      fontFamily:
                                      "Inter",
                                      color:
                                      AppColor()
                                          .whiteColor),
                                ),
                                Container(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      "${ controller.joinedUserDetailsResult
                                          .value != null
                                          ? controller.joinedUserDetailsResult
                                          .value.members[0].eventRegistration !=
                                          null ? controller
                                          .joinedUserDetailsResult
                                          .value.members[0].eventRegistration
                                          .rounds.length > 0 ? controller
                                          .joinedUserDetailsResult
                                          .value.members[0].eventRegistration
                                          .rounds[index].slot ?? "" : "" : ""
                                          : ""}",
                                      textAlign:
                                      TextAlign
                                          .center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          color: AppColor()
                                              .whiteColor),
                                    ),

                                  ],
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ],),


              ],
            ),
          )
        ],
      ),
    );
  }

  /*player details in team*/
  Widget playerDetailsTeams(int pos) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Wrap(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.joinedBattlesPlayersModel.value.teams[pos]
                          .teamId.name}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                    Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: "Inter",
                          color: AppColor().colorGray),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  "${controller.joinedBattlesPlayersModel.value.teams[pos]
                      .members != null &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members.length > 0 &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration != null
                      &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration.prizeAmount != null
                      ?
                  '${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                      .joinedBattlesPlayersModel.value
                      .teams[pos].members[0].eventRegistration.prizeAmount
                      .value ~/ 100}' : '---'}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              ),
              Expanded(
                child: Text(
                  "${controller.joinedBattlesPlayersModel.value.teams[pos]
                      .members != null &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members.length > 0 &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration != null
                      &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration.rounds != null
                      && controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration.rounds.length != null
                      &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration.rounds.length > 0
                      && controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration
                          .rounds[controller.joinedBattlesPlayersModel.value
                          .teams[pos].members[0].eventRegistration.rounds
                          .length - 1].result != null
                      ?
                  controller.joinedBattlesPlayersModel.value.teams[pos]
                      .members[0].eventRegistration
                      .rounds[controller.joinedBattlesPlayersModel.value
                      .teams[pos].members[0].eventRegistration.rounds.length -
                      1].result.kill == null ? 0 : '' : '---'}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              ),
              Expanded(
                child: Text(
                  "${controller.joinedBattlesPlayersModel.value.teams[pos]
                      .members != null &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members.length > 0 &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration != null
                      &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration.rounds != null
                      && controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration.rounds.length != null
                      &&
                      controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration.rounds.length > 0
                      && controller.joinedBattlesPlayersModel.value.teams[pos]
                          .members[0].eventRegistration
                          .rounds[controller.joinedBattlesPlayersModel.value
                          .teams[pos].members[0].eventRegistration.rounds
                          .length - 1].result != null
                      ?
                  controller.joinedBattlesPlayersModel.value.teams[pos]
                      .members[0].eventRegistration
                      .rounds[controller.joinedBattlesPlayersModel.value
                      .teams[pos].members[0].eventRegistration.rounds.length -
                      1].result.getRank() : '---'}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              )
            ],
          ),
          Container(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  /*player dteails in solo user  players tab*/
  Widget playerDetailsUser(int pos) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Wrap(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller
                          .joinedBattlesPlayersModel
                          .value
                          .users[pos].userId.username}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                    Text(
                      "${controller
                          .joinedBattlesPlayersModel
                          .value
                          .users[pos].userId.mobile.getMoblieNumber()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: "Inter",
                          color: AppColor().colorGray),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  "${controller
                      .joinedBattlesPlayersModel
                      .value
                      .users[pos].winningCredited && controller
                      .joinedBattlesPlayersModel
                      .value
                      .users[pos].prizeAmount != null ? controller
                      .joinedBattlesPlayersModel
                      .value
                      .users[pos].prizeAmount.value ~/ 100 : "-----"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              ),
              Expanded(
                child: Text(
                  "${controller.joinedBattlesPlayersModel.value.users[pos]
                      .rounds != null &&
                      controller.joinedBattlesPlayersModel.value.users[pos]
                          .rounds.length > 0 &&
                      controller.joinedBattlesPlayersModel.value.users[pos]
                          .rounds[controller.joinedBattlesPlayersModel.value
                          .users[pos].rounds.length - 1].result != null ?
                  controller.joinedBattlesPlayersModel.value.users[pos]
                      .rounds[controller.joinedBattlesPlayersModel.value
                      .users[pos].rounds.length - 1].result.kill == null
                      ? 0
                      : '' : '---'}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              ),
              Expanded(
                child: Text(
                  "${controller.joinedBattlesPlayersModel.value.users[pos]
                      .rounds != null &&
                      controller.joinedBattlesPlayersModel.value.users[pos]
                          .rounds.length > 0 &&
                      controller.joinedBattlesPlayersModel.value.users[pos].
                      rounds[controller.joinedBattlesPlayersModel.value
                          .users[pos].rounds.length - 1].result != null ?
                  controller.joinedBattlesPlayersModel.value.users[pos]
                      .rounds[controller.joinedBattlesPlayersModel.value
                      .users[pos].rounds.length - 1].result.getRank() : '---'}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              )
            ],
          ),
          Container(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  /*in case of team result widget*/
  Widget playerResultInfoTeam(int pos) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Wrap(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.joinedUserDetailsResult.value.members[pos]
                          .userId.username}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                    Text(
                      "${controller.joinedUserDetailsResult.value.members[pos]
                          .userId.mobile != null
                          ? controller.joinedUserDetailsResult.value
                          .members[pos].userId.mobile.getMoblieNumber()
                          : '--'}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: "Inter",
                          color: AppColor().blackColor),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  "${controller.joinedUserDetailsResult.value.members.length >
                      0 && controller.joinedUserDetailsResult.value.members[pos]
                      .eventRegistration.rounds != null
                      && controller.joinedUserDetailsResult.value.members[pos]
                          .eventRegistration.prizeAmount != null &&
                      controller.joinedUserDetailsResult.value.members[pos]
                          .eventRegistration.winningCredited
                      ?
                  '${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller
                      .joinedUserDetailsResult.value
                      .members[pos].eventRegistration.prizeAmount != null
                      ? controller
                      .joinedUserDetailsResult.value
                      .members[pos].eventRegistration.prizeAmount.value ~/ 100
                      : "---"}'
                      : "---"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              ),
              Expanded(
                child: Text(
                  "${controller.joinedUserDetailsResult.value.members.length >
                      0 && controller.joinedUserDetailsResult.value.members[pos]
                      .eventRegistration.rounds != null
                      && controller.joinedUserDetailsResult.value.members[pos]
                          .eventRegistration.rounds != null
                      && controller.joinedUserDetailsResult.value.members[pos]
                          .eventRegistration.rounds.length > 0
                      && controller.joinedUserDetailsResult.value.members[pos].
                      eventRegistration.rounds[controller
                          .joinedUserDetailsResult.value.members[pos]
                          .eventRegistration.rounds.length - 1].result != null
                      ?
                  controller.joinedUserDetailsResult.value.members[pos]
                      .eventRegistration.rounds[controller
                      .joinedUserDetailsResult.value.members[pos]
                      .eventRegistration.rounds.length - 1].result.kill == null
                      ? 0
                      : ''
                      : "---"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              ),
              Expanded(
                child: Text(
                  "${controller.joinedUserDetailsResult.value.members.length >
                      0 && controller.joinedUserDetailsResult.value.members[pos]
                      .eventRegistration.rounds != null
                      && controller.joinedUserDetailsResult.value.members[pos]
                          .eventRegistration.rounds != null &&
                      controller.joinedUserDetailsResult.value.members[pos]
                          .eventRegistration.rounds.length > 0 &&
                      controller.joinedUserDetailsResult.value.members[pos].
                      eventRegistration.rounds[controller
                          .joinedUserDetailsResult.value.members[pos]
                          .eventRegistration.rounds.length - 1].result != null
                      ? controller.joinedUserDetailsResult.value.members[pos]
                      .eventRegistration.rounds[controller
                      .joinedUserDetailsResult.value.members[pos]
                      .eventRegistration.rounds.length - 1].result.getRank()
                      : "---"}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: AppColor().blackColor),
                ),
              )
            ],
          ),
          Container(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  /*in solow result widget*/
  Widget playerResultInfoSolo() {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 0, left: 10, right: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          color: AppColor().whiteColor,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.joinedUserDetailsSoloResult != null &&
                              controller.joinedUserDetailsSoloResult.value !=
                                  null &&
                              controller.joinedUserDetailsSoloResult.value
                                  .userId != null &&
                              controller.joinedUserDetailsSoloResult.value
                                  .userId.username != null
                              ? controller.joinedUserDetailsSoloResult.value
                              .userId.username : ""}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Inter",
                              color: AppColor().colorPrimary),
                        ),
                        Text(
                          "${controller.joinedUserDetailsSoloResult != null &&
                              controller.joinedUserDetailsSoloResult.value !=
                                  null
                              && controller.joinedUserDetailsSoloResult.value
                                  .userId != null ?
                          controller.joinedUserDetailsSoloResult.value.userId
                              .mobile.getMoblieNumber() : "******"}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${controller.joinedUserDetailsSoloResult != null &&
                          controller.joinedUserDetailsSoloResult.value !=
                              null &&
                          controller.joinedUserDetailsSoloResult.value.rounds !=
                              null &&
                          controller.joinedUserDetailsSoloResult.value.rounds
                              .length > 0 &&
                          controller.joinedUserDetailsSoloResult.value
                              .winningCredited &&
                          controller.joinedUserDetailsSoloResult.value
                              .prizeAmount != null ?
                      '${ApiUrl().isPlayStore ? "" : '\u{20B9}'}  ${controller
                          .joinedUserDetailsSoloResult.value
                          .prizeAmount.value != null ? controller
                          .joinedUserDetailsSoloResult.value
                          .prizeAmount.value ~/ 100 : "---"}' : "---"
                      }",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          color: AppColor().blackColor),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${controller.joinedUserDetailsSoloResult != null &&
                          controller.joinedUserDetailsSoloResult.value !=
                              null &&
                          controller.joinedUserDetailsSoloResult.value.rounds !=
                              null &&
                          controller.joinedUserDetailsSoloResult.value.rounds
                              .length > 0 &&
                          controller.joinedUserDetailsSoloResult.value
                              .rounds[controller.joinedUserDetailsSoloResult
                              .value.rounds.length - 1].result != null
                          ?
                      controller.joinedUserDetailsSoloResult.value
                          .rounds[controller.joinedUserDetailsSoloResult.value
                          .rounds.length - 1].result.kill == null ? 0 : ''
                          : "---"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          color: AppColor().blackColor),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${controller.joinedUserDetailsSoloResult != null &&
                          controller.joinedUserDetailsSoloResult.value !=
                              null &&
                          controller.joinedUserDetailsSoloResult.value.rounds !=
                              null &&
                          controller.joinedUserDetailsSoloResult.value.rounds
                              .length > 0
                          && controller.joinedUserDetailsSoloResult.value
                              .rounds[controller.joinedUserDetailsSoloResult
                              .value.rounds.length - 1].result != null ?
                      controller.joinedUserDetailsSoloResult.value
                          .rounds[controller.joinedUserDetailsSoloResult.value
                          .rounds.length - 1].result.getRank() : "---"}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          color: AppColor().blackColor),
                    ),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Container(
                height: 1,
                color: AppColor().colorGray,
                width: double.infinity,
              ),
            ],
          ),
        ));
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
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
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
                            "${model.winner.prizeAmount != null ? model.winner
                                .prizeAmount.value : "-"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        ])
                        : Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${model.winner
                          .prizeAmount != null ? model.winner.prizeAmount
                          .value ~/ 100 : "-"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().colorPrimary),
                    ),
                    /*     Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(model.winner
                          .prizeAmount != null ? model.winner
                          .prizeAmount.value ~/ 100 : "--")}",
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
                        itemBuilder: (context,
                            index,) {
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
                        "${list[index].amount != null
                            ? list[index].amount.value
                            : "-"}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      )
                    ])
                    : Text(
                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${list[index]
                      .amount.value ~/ 100}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      color: Colors.white),
                ),
                /*   Text(
                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${list[index]
                      .amount.value ~/ 100}",
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
}
