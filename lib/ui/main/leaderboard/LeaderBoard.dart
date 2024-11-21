import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/LeaderBoardController.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/webservices/ApiUrl.dart';

import '../../controller/GameTypeController.dart';

class LeaderBoard extends StatelessWidget {
  LeaderBoardController leaderBoardController =
      Get.put(LeaderBoardController());
  GameTypeController gameTypeController = Get.put(GameTypeController());
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Data _selectedgame;

  @override
  Widget build(BuildContext context) {
    // gameTypeController.getGameType();
    return Container(

      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/store_back.png"))),
      child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () async {
              leaderBoardController.type.value = "monthly";
              callLeaderBoarApi();
            });
          },
          child: AppString.offerWallLoot == "active"
              ? Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    flexibleSpace: Image(
                      image: AssetImage('assets/images/store_top.png'),
                      fit: BoxFit.cover,
                    ),
                    backgroundColor: Colors.transparent,
                    title: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: Text("LeaderBoard".tr),
                    )),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 12),
                            height: 105,
                            child: Obx(
                              () => gameTypeController.esportList != null
                                  ? gameTypeController.esportList != null
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: gameTypeController
                                              .esportList.length,
                                          itemBuilder: (context, index) {
                                            return Obx(() => listViewCallTop(
                                                context, index));
                                          })
                                      : Container(
                                          alignment: Alignment.topCenter,
                                          height: 20,
                                          child: Text(
                                            "No Game found",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                color: Colors.white),
                                          ))
                                  : Container(
                                      alignment: Alignment.topCenter,
                                      height: 20,
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
                                      )),
                            )),
                        Container(
                          decoration: BoxDecoration(
                              /*   image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage("assets/images/rewards_bg_bottom.webp"))*/
                              ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          leaderBoardController.type.value =
                                              "monthly";
                                          callLeaderBoarApi();
                                          /* leaderBoardController.getLeaderBoardList(
                                      "", leaderBoardController.type.value);*/
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              "MONTHLY".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Inter",
                                                  color: Colors.white),
                                            ),
                                            Obx(
                                              () => Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 5, right: 5),
                                                height: 2,
                                                color: leaderBoardController
                                                            .type.value
                                                            .compareTo(
                                                                "monthly") ==
                                                        0
                                                    ? AppColor().colorPrimary
                                                    : null,
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                leaderBoardController
                                                    .type.value = "weekly";
                                                callLeaderBoarApi();
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "WEEKLY".tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: "Inter",
                                                        color: Colors.white),
                                                  ),
                                                  Obx(
                                                    () => Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          left: 5,
                                                          right: 5),
                                                      height: 2,
                                                      color: leaderBoardController
                                                                  .type.value
                                                                  .compareTo(
                                                                      "weekly") ==
                                                              0
                                                          ? AppColor()
                                                              .colorPrimary
                                                          : null,
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ],
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          leaderBoardController.type.value =
                                              "daily";
                                          callLeaderBoarApi();
                                          /*       leaderBoardController.getLeaderBoardList(
                                      "", leaderBoardController.type.value);*/
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              "DAILY".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Inter",
                                                  color: Colors.white),
                                            ),
                                            Obx(
                                              () => Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 5, right: 5),
                                                height: 2,
                                                color: leaderBoardController
                                                            .type.value
                                                            .compareTo(
                                                                "daily") ==
                                                        0
                                                    ? AppColor().colorPrimary
                                                    : null,
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: true,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Obx(
                                              () =>
                                                  leaderBoardController
                                                              .user1.value !=
                                                          null
                                                      ? leaderBoardController
                                                                  .user1
                                                                  .value
                                                                  .amount !=
                                                              null
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      bottom:
                                                                          10,
                                                                      top: 5),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              width: double
                                                                  .infinity,
                                                              height: 260,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: AssetImage(
                                                                          ImageRes()
                                                                              .leader_board_rank_back)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Center(
                                                                child: Row(
                                                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              65,
                                                                        ),
                                                                        Stack(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: 30,
                                                                                  child: Image.asset("assets/images/ic_cron.png"),
                                                                                ),
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(52)),
                                                                                  child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .13),
                                                                                          border: Border.all(
                                                                                            width: 2,
                                                                                            color: AppColor().colorPrimary,
                                                                                          )),
                                                                                      child: leaderBoardController.user2 != null && leaderBoardController.user2.value != null && leaderBoardController.user2.value.photo != null && leaderBoardController.user2.value.photo.url != null && !leaderBoardController.user2.value.photo.url.isEmpty
                                                                                          ? CircleAvatar(
                                                                                              radius: MediaQuery.of(context).size.width * .12,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              backgroundImage: NetworkImage("${leaderBoardController.user2.value.photo.url}"),
                                                                                            )
                                                                                          : CircleAvatar(
                                                                                              radius: MediaQuery.of(context).size.width * .12,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              child: Image(
                                                                                                height: 40,
                                                                                                width: 40,
                                                                                                fit: BoxFit.fill,
                                                                                                image: AssetImage(ImageRes().team_group),
                                                                                              ),
                                                                                            )),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Container(
                                                                              // alignment: Alignment.center,
                                                                              margin: EdgeInsets.only(top: 19, left: MediaQuery.of(context).size.width * .1),
                                                                              child: CircleAvatar(
                                                                                  radius: 10,
                                                                                  backgroundColor: AppColor().colorPrimary_light,
                                                                                  child: Text(
                                                                                    "2",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Obx(() =>
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(fit: BoxFit.cover, image: AssetImage(ImageRes().rank_amount_back)),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 15,
                                                                                  vertical: 1,
                                                                                ),
                                                                                child: Text(
                                                                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${leaderBoardController.user2 != null && leaderBoardController.user2.value != null ? leaderBoardController.user2.value.amount.value ~/ 100 : "0"}",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 20, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().colorPrimary),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                        Obx(
                                                                          () =>
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5, bottom: 3),
                                                                            child:
                                                                                Text(
                                                                              "${leaderBoardController.user2 != null && leaderBoardController.user2.value != null ? leaderBoardController.user2.value.username : "User"}".capitalize,
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().whiteColor),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Stack(
                                                                          children: [
                                                                            Center(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    padding: EdgeInsets.all(0),
                                                                                    height: 32,
                                                                                    child: Image.asset("assets/images/ic_cron.png"),
                                                                                  ),
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(52),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .20),
                                                                                          border: Border.all(
                                                                                            width: 2,
                                                                                            color: AppColor().colorPrimary,
                                                                                          )),
                                                                                      child: leaderBoardController.user1 != null && leaderBoardController.user1.value != null && leaderBoardController.user1.value.photo != null && leaderBoardController.user1.value.photo.url != null && !leaderBoardController.user1.value.photo.url.isEmpty
                                                                                          ? CircleAvatar(
                                                                                              radius: MediaQuery.of(context).size.width * .19,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              child: CircleAvatar(
                                                                                                backgroundColor: Colors.transparent,
                                                                                                radius: MediaQuery.of(context).size.height,
                                                                                                backgroundImage: (NetworkImage("${leaderBoardController.user1.value.photo.url}")

                                                                                                    // AssetImage('assets/images/images.png'),
                                                                                                    ),
                                                                                              ),
                                                                                            )
                                                                                          : CircleAvatar(
                                                                                              radius: MediaQuery.of(context).size.width * .19,
                                                                                              backgroundColor: Colors.transparent,

                                                                                              child: Image(
                                                                                                height: 40,
                                                                                                width: 40,
                                                                                                fit: BoxFit.fill,
                                                                                                image: AssetImage(ImageRes().team_group),
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
                                                                                alignment: Alignment.center,
                                                                                margin: EdgeInsets.only(top: 20, left: MediaQuery.of(context).size.width * .17),
                                                                                child: CircleAvatar(
                                                                                    radius: 10,
                                                                                    backgroundColor: AppColor().colorPrimary_light,
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "1",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Obx(() =>
                                                                            Center(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  image: DecorationImage(fit: BoxFit.cover, image: AssetImage(ImageRes().rank_amount_back)),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 20,
                                                                                    vertical: 1,
                                                                                  ),
                                                                                  child: Text(
                                                                                    "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${leaderBoardController.user1 != null && leaderBoardController.user1.value != null ? leaderBoardController.user1.value.amount.value ~/ 100 : "0"}",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontSize: 20, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().colorPrimary),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                        Obx(() =>
                                                                            Center(
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(top: 5, bottom: 3),
                                                                                child: Text(
                                                                                  "${leaderBoardController.user1 != null && leaderBoardController.user1.value != null ? leaderBoardController.user1.value.username : ""}".toUpperCase(),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().whiteColor),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              65,
                                                                        ),
                                                                        Stack(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: 30,
                                                                                  child: Image.asset("assets/images/ic_cron.png"),
                                                                                ),
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(52)),
                                                                                  child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .13),
                                                                                          border: Border.all(
                                                                                            width: 2,
                                                                                            color: AppColor().colorPrimary,
                                                                                          )),
                                                                                      child: Obx(
                                                                                        () => leaderBoardController.user3 != null && leaderBoardController.user3.value != null && leaderBoardController.user3.value.photo != null && leaderBoardController.user3.value.photo.url != null && !leaderBoardController.user3.value.photo.url.isEmpty
                                                                                            ? CircleAvatar(
                                                                                                radius: MediaQuery.of(context).size.width * .12,
                                                                                                backgroundColor: Colors.transparent,
                                                                                                backgroundImage: NetworkImage("${leaderBoardController.user3.value.photo.url}"),
                                                                                              )
                                                                                            : CircleAvatar(
                                                                                                radius: MediaQuery.of(context).size.width * .12,
                                                                                                backgroundColor: Colors.transparent,
                                                                                                child: Image(
                                                                                                  height: 40,
                                                                                                  width: 40,
                                                                                                  fit: BoxFit.fill,
                                                                                                  image: AssetImage(ImageRes().team_group),
                                                                                                ),
                                                                                              ),
                                                                                      )),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Container(
                                                                              // alignment: Alignment.center,
                                                                              margin: EdgeInsets.only(top: 19, left: MediaQuery.of(context).size.width * .1),
                                                                              child: CircleAvatar(
                                                                                  radius: 10,
                                                                                  backgroundColor: AppColor().colorPrimary_light,
                                                                                  child: Text(
                                                                                    "3",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Obx(() =>
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(fit: BoxFit.cover, image: AssetImage(ImageRes().rank_amount_back)),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 20,
                                                                                  vertical: 1,
                                                                                ),
                                                                                child: Text(
                                                                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${leaderBoardController.user3 != null && leaderBoardController.user3.value != null ? leaderBoardController.user3.value.amount.value ~/ 100 : " 0"}",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 20, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().colorPrimary),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                        Obx(() =>
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 5, bottom: 3),
                                                                              child: Text(
                                                                                "${leaderBoardController.user3 != null && leaderBoardController.user3.value != null ? leaderBoardController.user3.value.username : "User"}".capitalize,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().whiteColor),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Center(
                                                              child: Container(
                                                              child: Text(""),
                                                            ))
                                                      : Center(
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

                                                            //image:AssetImage("assets/images/progresbar_images.gif")),
                                                          ),
                                                        )),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            child: Obx(
                                              () => (leaderBoardController
                                                              .leaderBoardlistNew !=
                                                          null &&
                                                      leaderBoardController
                                                              .leaderBoardlistNew
                                                              .value !=
                                                          null)
                                                  ? ListView.builder(
                                                      itemCount:
                                                          leaderBoardController
                                                              .leaderBoardlistNew
                                                              .value
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return listCall(
                                                            context, index);
                                                      })
                                                  : Container(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 12),
                            height: 105,
                            child: Obx(
                              () => gameTypeController.esportList != null
                                  ? gameTypeController.esportList != null
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: gameTypeController
                                              .esportList.length,
                                          itemBuilder: (context, index) {
                                            return Obx(() => listViewCallTop(
                                                context, index));
                                          })
                                      : Container(
                                          alignment: Alignment.topCenter,
                                          height: 20,
                                          child: Text(
                                            "No Game found",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                color: Colors.white),
                                          ))
                                  : Container(
                                      alignment: Alignment.topCenter,
                                      height: 20,
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
                                      )),
                            )),
                        Container(
                          decoration: BoxDecoration(
                              /*   image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage("assets/images/rewards_bg_bottom.webp"))*/
                              ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          leaderBoardController.type.value =
                                              "monthly";
                                          callLeaderBoarApi();
                                          /* leaderBoardController.getLeaderBoardList(
                                      "", leaderBoardController.type.value);*/
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              "MONTHLY".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Inter",
                                                  color: Colors.white),
                                            ),
                                            Obx(
                                              () => Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 5, right: 5),
                                                height: 2,
                                                color: leaderBoardController
                                                            .type.value
                                                            .compareTo(
                                                                "monthly") ==
                                                        0
                                                    ? AppColor().colorPrimary
                                                    : null,
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                leaderBoardController
                                                    .type.value = "weekly";
                                                callLeaderBoarApi();
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "WEEKLY".tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: "Inter",
                                                        color: Colors.white),
                                                  ),
                                                  Obx(
                                                    () => Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          left: 5,
                                                          right: 5),
                                                      height: 2,
                                                      color: leaderBoardController
                                                                  .type.value
                                                                  .compareTo(
                                                                      "weekly") ==
                                                              0
                                                          ? AppColor()
                                                              .colorPrimary
                                                          : null,
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ],
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          leaderBoardController.type.value =
                                              "daily";
                                          callLeaderBoarApi();
                                          /*       leaderBoardController.getLeaderBoardList(
                                      "", leaderBoardController.type.value);*/
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              "DAILY".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Inter",
                                                  color: Colors.white),
                                            ),
                                            Obx(
                                              () => Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 5, right: 5),
                                                height: 2,
                                                color: leaderBoardController
                                                            .type.value
                                                            .compareTo(
                                                                "daily") ==
                                                        0
                                                    ? AppColor().colorPrimary
                                                    : null,
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: true,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Obx(
                                              () =>
                                                  leaderBoardController
                                                              .user1.value !=
                                                          null
                                                      ? leaderBoardController
                                                                  .user1
                                                                  .value
                                                                  .amount !=
                                                              null
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      bottom:
                                                                          10,
                                                                      top: 5),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              width: double
                                                                  .infinity,
                                                              height: 260,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: AssetImage(
                                                                          ImageRes()
                                                                              .leader_board_rank_back)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Center(
                                                                child: Row(
                                                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              65,
                                                                        ),
                                                                        Stack(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: 30,
                                                                                  child: Image.asset("assets/images/ic_cron.png"),
                                                                                ),
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(52)),
                                                                                  child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .13),
                                                                                          border: Border.all(
                                                                                            width: 2,
                                                                                            color: AppColor().colorPrimary,
                                                                                          )),
                                                                                      child: leaderBoardController.user2 != null && leaderBoardController.user2.value != null && leaderBoardController.user2.value.photo != null && leaderBoardController.user2.value.photo.url != null && !leaderBoardController.user2.value.photo.url.isEmpty
                                                                                          ? CircleAvatar(
                                                                                              radius: MediaQuery.of(context).size.width * .12,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              backgroundImage: NetworkImage("${leaderBoardController.user2.value.photo.url}"),
                                                                                            )
                                                                                          : CircleAvatar(
                                                                                              radius: MediaQuery.of(context).size.width * .12,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              child: Image(
                                                                                                height: 40,
                                                                                                width: 40,
                                                                                                fit: BoxFit.fill,
                                                                                                image: AssetImage(ImageRes().team_group),
                                                                                              ),
                                                                                            )),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Container(
                                                                              // alignment: Alignment.center,
                                                                              margin: EdgeInsets.only(top: 19, left: MediaQuery.of(context).size.width * .1),
                                                                              child: CircleAvatar(
                                                                                  radius: 10,
                                                                                  backgroundColor: AppColor().colorPrimary_light,
                                                                                  child: Text(
                                                                                    "2",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Obx(() =>
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(fit: BoxFit.cover, image: AssetImage(ImageRes().rank_amount_back)),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 15,
                                                                                  vertical: 1,
                                                                                ),
                                                                                child: Text(
                                                                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${leaderBoardController.user2 != null && leaderBoardController.user2.value != null ? leaderBoardController.user2.value.amount.value ~/ 100 : "0"}",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 20, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().colorPrimary),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                        Obx(
                                                                          () =>
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5, bottom: 3),
                                                                            child:
                                                                                Text(
                                                                              "${leaderBoardController.user2 != null && leaderBoardController.user2.value != null ? leaderBoardController.user2.value.username : "User"}".capitalize,
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().whiteColor),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Stack(
                                                                          children: [
                                                                            Center(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    padding: EdgeInsets.all(0),
                                                                                    height: 32,
                                                                                    child: Image.asset("assets/images/ic_cron.png"),
                                                                                  ),
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(52),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .20),
                                                                                          border: Border.all(
                                                                                            width: 2,
                                                                                            color: AppColor().colorPrimary,
                                                                                          )),
                                                                                      child: leaderBoardController.user1 != null && leaderBoardController.user1.value != null && leaderBoardController.user1.value.photo != null && leaderBoardController.user1.value.photo.url != null && !leaderBoardController.user1.value.photo.url.isEmpty
                                                                                          ? CircleAvatar(
                                                                                              radius: MediaQuery.of(context).size.width * .19,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              child: CircleAvatar(
                                                                                                backgroundColor: Colors.transparent,
                                                                                                radius: MediaQuery.of(context).size.height,
                                                                                                backgroundImage: (NetworkImage("${leaderBoardController.user1.value.photo.url}")

                                                                                                    // AssetImage('assets/images/images.png'),
                                                                                                    ),
                                                                                              ),
                                                                                            )
                                                                                          : CircleAvatar(
                                                                                              radius: MediaQuery.of(context).size.width * .19,
                                                                                              backgroundColor: Colors.transparent,

                                                                                              child: Image(
                                                                                                height: 40,
                                                                                                width: 40,
                                                                                                fit: BoxFit.fill,
                                                                                                image: AssetImage(ImageRes().team_group),
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
                                                                                alignment: Alignment.center,
                                                                                margin: EdgeInsets.only(top: 20, left: MediaQuery.of(context).size.width * .17),
                                                                                child: CircleAvatar(
                                                                                    radius: 10,
                                                                                    backgroundColor: AppColor().colorPrimary_light,
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "1",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Obx(() =>
                                                                            Center(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  image: DecorationImage(fit: BoxFit.cover, image: AssetImage(ImageRes().rank_amount_back)),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 20,
                                                                                    vertical: 1,
                                                                                  ),
                                                                                  child: Text(
                                                                                    "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${leaderBoardController.user1 != null && leaderBoardController.user1.value != null ? leaderBoardController.user1.value.amount.value ~/ 100 : "0"}",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontSize: 20, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().colorPrimary),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                        Obx(() =>
                                                                            Center(
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(top: 5, bottom: 3),
                                                                                child: Text(
                                                                                  "${leaderBoardController.user1 != null && leaderBoardController.user1.value != null ? leaderBoardController.user1.value.username : ""}".toUpperCase(),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().whiteColor),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              65,
                                                                        ),
                                                                        Stack(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: 30,
                                                                                  child: Image.asset("assets/images/ic_cron.png"),
                                                                                ),
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(52)),
                                                                                  child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .13),
                                                                                          border: Border.all(
                                                                                            width: 2,
                                                                                            color: AppColor().colorPrimary,
                                                                                          )),
                                                                                      child: Obx(
                                                                                        () => leaderBoardController.user3 != null && leaderBoardController.user3.value != null && leaderBoardController.user3.value.photo != null && leaderBoardController.user3.value.photo.url != null && !leaderBoardController.user3.value.photo.url.isEmpty
                                                                                            ? CircleAvatar(
                                                                                                radius: MediaQuery.of(context).size.width * .12,
                                                                                                backgroundColor: Colors.transparent,
                                                                                                backgroundImage: NetworkImage("${leaderBoardController.user3.value.photo.url}"),
                                                                                              )
                                                                                            : CircleAvatar(
                                                                                                radius: MediaQuery.of(context).size.width * .12,
                                                                                                backgroundColor: Colors.transparent,
                                                                                                child: Image(
                                                                                                  height: 40,
                                                                                                  width: 40,
                                                                                                  fit: BoxFit.fill,
                                                                                                  image: AssetImage(ImageRes().team_group),
                                                                                                ),
                                                                                              ),
                                                                                      )),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Container(
                                                                              // alignment: Alignment.center,
                                                                              margin: EdgeInsets.only(top: 19, left: MediaQuery.of(context).size.width * .1),
                                                                              child: CircleAvatar(
                                                                                  radius: 10,
                                                                                  backgroundColor: AppColor().colorPrimary_light,
                                                                                  child: Text(
                                                                                    "3",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Obx(() =>
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(fit: BoxFit.cover, image: AssetImage(ImageRes().rank_amount_back)),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 20,
                                                                                  vertical: 1,
                                                                                ),
                                                                                child: Text(
                                                                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${leaderBoardController.user3 != null && leaderBoardController.user3.value != null ? leaderBoardController.user3.value.amount.value ~/ 100 : " 0"}",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 20, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().colorPrimary),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                        Obx(() =>
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 5, bottom: 3),
                                                                              child: Text(
                                                                                "${leaderBoardController.user3 != null && leaderBoardController.user3.value != null ? leaderBoardController.user3.value.username : "User"}".capitalize,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: AppColor().whiteColor),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Center(
                                                              child: Container(
                                                              child: Text(""),
                                                            ))
                                                      : Center(
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

                                                            //image:AssetImage("assets/images/progresbar_images.gif")),
                                                          ),
                                                        )),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            child: Obx(
                                              () => (leaderBoardController
                                                              .leaderBoardlistNew !=
                                                          null &&
                                                      leaderBoardController
                                                              .leaderBoardlistNew
                                                              .value !=
                                                          null)
                                                  ? ListView.builder(
                                                      itemCount:
                                                          leaderBoardController
                                                              .leaderBoardlistNew
                                                              .value
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return listCall(
                                                            context, index);
                                                      })
                                                  : Container(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }

  Widget listViewCallTop(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          leaderBoardController.type.value = "monthly";
          if (index == 0) {
            leaderBoardController.selectedgame.value = "";
          } else {
            leaderBoardController.selectedgame.value =
                gameTypeController.esportList[index].id;
          }
          gameTypeController.gameListSelectedColor.value = index;
          Utils().customPrint(
              "data game name ${gameTypeController.esportList[index]}");

          callLeaderBoarApi();
        },
        child: gameTypeController.gameListSelectedColor1.value == 0 &&
                index == 0
            ? Container(
                padding: const EdgeInsets.only(
                    right: 10, left: 1, top: 10, bottom: 10),
                child: Container(
                  width: 90,
                  decoration: gameTypeController.gameListSelectedColor.value ==
                          index
                      ? BoxDecoration(
                          boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: .0,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              ),
                            ],
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  ImageRes().rectangle_orange_gradient_box)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1, color: AppColor().whiteColor))
                      : BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  ImageRes().rectangle_orange_gradient_box)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor().clan_header_dark,
                              blurRadius: 0,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                  child: Center(
                    child: Text(
                      "All".tr,
                      style: TextStyle(
                          color: AppColor().whiteColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.only(
                    right: 10, left: 1, top: 10, bottom: 10),
                child: Container(
                  decoration:
                      gameTypeController.gameListSelectedColor.value == index
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
                              border: Border.all(
                                  width: 1, color: AppColor().whiteColor))
                          : BoxDecoration(
                              boxShadow: [
                                BoxShadow(
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
                      height: 105,
                      width: 90,
                      fit: BoxFit.cover,
                      image: gameTypeController.esportList[index].banner !=
                                  null &&
                              !gameTypeController
                                  .esportList[index].banner.url.isEmpty
                          ? NetworkImage(
                              gameTypeController.esportList[index].banner.url)
                          : AssetImage('assets/images/images.png'),
                    ),
                  ),
                ),
              ));
  }

  void callLeaderBoarApi() {
    leaderBoardController.getLeaderBoardList(
        leaderBoardController.selectedgame.value,
        leaderBoardController.type.value);
  }

  Widget listCall(BuildContext context, int index) {
    return Container(
      height: 58,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/gradient_rectangular.png")),
          /* color: Colors.transparent,*/
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "${leaderBoardController.leaderBoardlistNew.value[index].rank}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                    image: leaderBoardController
                                .leaderBoardlistNew.value[index].photo !=
                            null
                        ? NetworkImage(leaderBoardController
                            .leaderBoardlistNew.value[index].photo.url)
                        : AssetImage('assets/images/group.png'),
                  ),
                ),
              ),
              Text(
                leaderBoardController.leaderBoardlistNew.value[index].username,
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
              "${ApiUrl().isPlayStore ? "" : '\u{20B9}'}${leaderBoardController.leaderBoardlistNew.value[index].amount.value ~/ 100}",
              // textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColor().whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
