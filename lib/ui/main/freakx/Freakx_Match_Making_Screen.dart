import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/main/Freakx/FreakxList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../model/responsemodel/PreJoinUnityResponseModel.dart';
import '../../../model/unity_history/OnlyUnityHistoryModel.dart';
import '../../../res/AppColor.dart';
import '../../../utills/Utils.dart';
import '../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../utills/event_tracker/EventConstant.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/WalletPageController.dart';
import '../../controller/user_controller.dart';
import 'FreakxWebview.dart';

class Freakx_Match_Making_Screen extends StatefulWidget {
  String event_id;
  String gameid;
  String mapV;
  String playAmount;
  String url1;
  String nameGame;

  Freakx_Match_Making_Screen(
      this.gameid, this.event_id, this.mapV, this.playAmount, this.url1,this.nameGame);

  @override
  State<Freakx_Match_Making_Screen> createState() =>
      _Freakx_Match_Making_ScreenState(
          event_id, gameid, mapV, playAmount, url1);
}

class _Freakx_Match_Making_ScreenState extends State<Freakx_Match_Making_Screen>
    with SingleTickerProviderStateMixin {
  String event_id;
  String gameid;
  String mapV;
  String playAmount;
  String user_name, user_photo;
  bool popB = false;
  String url1;

  var cancel = false.obs;
  var back_cancel_dis = false.obs;

  _Freakx_Match_Making_ScreenState(
      this.gameid, this.event_id, this.mapV, this.playAmount, this.url1);

  SharedPreferences prefs;
  String user_id;
  String token;

  var onlyUnityHistoryModel = OnlyUnityHistoryModel().obs;

  PreJoinUnityResponseModel preJoinResponseModel;
  //UserController userController = Get.find();

  UserController userController = Get.put(UserController());
  AnimationController transitionAnimation;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    getData();

    transitionAnimation = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    transitionAnimation.repeat();
    Utils().customPrint("game zob data call $mapV");
  }

  @override
  dispose() {
    transitionAnimation.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: const Text(
                ' ',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Color(0xffE5E5E5),
                ),
              ),
            ),
            GestureDetector(
              child: const Text(
                'YOUR SCORE',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Color(0xffE5E5E5),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ],
                    color: AppColor().colorPrimary,
                    borderRadius: BorderRadius.circular(15)),
                height: 45,
                width: 80,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 0, left: 8, right: 8, bottom: 0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                            colors: [Colors.white38, Colors.white24]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, right: 0, left: 5, bottom: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image(
                                        width: 13,
                                        height: 13,
                                        image: ApiUrl().isPlayStore
                                            ? AssetImage(
                                                "assets/images/deposited.webp")
                                            : AssetImage(
                                                "assets/images/rupee_icon.png")),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      ' ${userController.getTotalBalnace()}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w400,
                                          color: AppColor().whiteColor),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image(
                                        width: 13,
                                        height: 13,
                                        image: AssetImage(
                                            "assets/images/bonus_coin.png")),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      ' ${userController.getBonuseCashBalance()}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w400,
                                          color: AppColor().whiteColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (back_cancel_dis.isTrue) {
            return false;
          } else {
            bool isPop = false;
            await showAlertDialog(context, (alertResponse) {
              Navigator.of(context).pop();
              // This will dismiss the alert dialog
              isPop = alertResponse;
            });
            return isPop;
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/store_back.png"))),
          child: Obx(
            () => onlyUnityHistoryModel.value != null
                ? onlyUnityHistoryModel.value.data != null &&
                        onlyUnityHistoryModel.value.data.length > 0 &&
                        onlyUnityHistoryModel.value.data[0].rounds[0].result !=
                            null &&
                        onlyUnityHistoryModel
                                .value.data[0].opponents[0].rounds[0].result !=
                            null
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Obx(
                                  () => onlyUnityHistoryModel.value != null
                                      ? onlyUnityHistoryModel.value.data !=
                                                  null &&
                                              onlyUnityHistoryModel
                                                      .value.data.length >
                                                  0 &&
                                              onlyUnityHistoryModel
                                                  .value.data[0].isWinner
                                          ? Container(
                                              height: 130,
                                              child: Image.asset(
                                                  "assets/images/you_won_image.png"))
                                          : Container(
                                              height: 130,
                                              child: Image.asset(
                                                  "assets/images/you_lose_image.png"))
                                      : Shimmer.fromColors(
                                          child: Container(
                                            height: 130,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          baseColor:
                                              Colors.grey.withOpacity(0.2),
                                          highlightColor:
                                              Colors.grey.withOpacity(0.4),
                                          enabled: true,
                                        ),

                                  /*Container(
                         height: 130,
                         child:Shi)*/
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Obx(
                                  () =>
                                      onlyUnityHistoryModel.value != null &&
                                              onlyUnityHistoryModel
                                                      .value.data !=
                                                  null &&
                                              onlyUnityHistoryModel
                                                      .value.data.length >
                                                  0 &&
                                              onlyUnityHistoryModel
                                                  .value.data[0].isWinner
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 7,
                                                                  top: 60,
                                                                  left: 15),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 0,
                                                                  top: 0),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColor()
                                                                        .first_rank,
                                                                    width: 5,
                                                                  ),
                                                                  color: AppColor()
                                                                      .whiteColor),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 70,
                                                                ),
                                                                Text(
                                                                  user_name ??
                                                                      "------",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          "Inter",
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  "YOUR SCORE",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          "Inter",
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                                onlyUnityHistoryModel.value !=
                                                                            null &&
                                                                        onlyUnityHistoryModel.value.data.length >
                                                                            0
                                                                    ? onlyUnityHistoryModel.value.data[0].opponents[0].rounds[0].result !=
                                                                                null &&
                                                                            onlyUnityHistoryModel.value.data[0].opponents[0].rounds[0].result.score !=
                                                                                null
                                                                        ? Text(
                                                                            "${onlyUnityHistoryModel.value.data[0].rounds[0].result.score}",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: "Inter",
                                                                                color: Colors.black),
                                                                          )
                                                                        : Text(
                                                                            "0",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: "Inter",
                                                                                color: Colors.black),
                                                                          )
                                                                    : Text(
                                                                        "0",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                "Inter",
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                SizedBox(
                                                                  height: 40,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                              height: 150,
                                                              width: 150,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/first_rank_circle.png")),
                                                              ),
                                                              child: user_photo !=
                                                                          null &&
                                                                      user_photo
                                                                          .isNotEmpty
                                                                  ? user_photo.compareTo(
                                                                              "-") ==
                                                                          0
                                                                      ? Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          child: Center(
                                                                              child: Image(
                                                                            height:
                                                                                30,
                                                                            image:
                                                                                AssetImage(ImageRes().team_group),
                                                                          )),
                                                                        )
                                                                      : Center(
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(50),
                                                                            ),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              width: 88,
                                                                              height: 88,
                                                                              fit: BoxFit.fill,
                                                                              imageUrl: ("${user_photo}"),
                                                                            ),
                                                                          ),
                                                                        )
                                                                  : Container(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child: Center(
                                                                          child: Image(
                                                                        height:
                                                                            30,
                                                                        image: AssetImage(
                                                                            ImageRes().team_group),
                                                                      )),
                                                                    )),
                                                        )
                                                      ],
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        children: [
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    top: 70,
                                                                    right: 15),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 0,
                                                                    top: 0),
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: AppColor()
                                                                          .second_rank,
                                                                      width: 5,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: AppColor()
                                                                        .whiteColor),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 50,
                                                                  ),
                                                                  Text(
                                                                    "${onlyUnityHistoryModel.value.data[0].opponents[0].housePlayerName ?? onlyUnityHistoryModel.value.data[0].opponents[0].userId.username}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            "Inter",
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    "YOUR SCORE",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            "Inter",
                                                                        color: Colors
                                                                            .black54),
                                                                  ),
                                                                  onlyUnityHistoryModel
                                                                                  .value !=
                                                                              null &&
                                                                          onlyUnityHistoryModel.value.data[0].opponents[0].rounds[0].result !=
                                                                              null &&
                                                                          onlyUnityHistoryModel.value.data[0].opponents[0].rounds[0].result.score !=
                                                                              null
                                                                      ? Text(
                                                                          "${onlyUnityHistoryModel.value.data[0].opponents[0].rounds[0].result.score}",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: "Inter",
                                                                              color: Colors.black),
                                                                        )
                                                                      : Text(
                                                                          "0",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: "Inter",
                                                                              color: Colors.black),
                                                                        ),
                                                                  SizedBox(
                                                                    height: 25,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Container(
                                                                height: 150,
                                                                width: 150,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          "assets/images/second_circle.png")),
                                                                ),
                                                                child: onlyUnityHistoryModel.value != null &&
                                                                        onlyUnityHistoryModel.value.data !=
                                                                            null &&
                                                                        onlyUnityHistoryModel.value.data[0].opponents[0].userId.photo !=
                                                                            null &&
                                                                        onlyUnityHistoryModel.value.data[0].opponents[0].userId.photo.url !=
                                                                            null
                                                                    ? Center(
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(50),
                                                                          ),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            width:
                                                                                85,
                                                                            height:
                                                                                85,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            imageUrl:
                                                                                ("${onlyUnityHistoryModel.value.data[0].opponents[0].userId.photo.url}"),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        child: Center(
                                                                            child: Image(
                                                                          height:
                                                                              30,
                                                                          image:
                                                                              AssetImage(ImageRes().team_group),
                                                                        )),
                                                                      )),
                                                          )
                                                        ],
                                                      ),
                                                    ))
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 7,
                                                                  top: 60,
                                                                  left: 15),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 0,
                                                                  top: 0),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColor()
                                                                        .first_rank,
                                                                    width: 5,
                                                                  ),
                                                                  color: AppColor()
                                                                      .whiteColor),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 70,
                                                                ),
                                                                onlyUnityHistoryModel.value != null &&
                                                                        onlyUnityHistoryModel.value.data !=
                                                                            null &&
                                                                        onlyUnityHistoryModel.value.data.length >
                                                                            0
                                                                    ? Text(
                                                                        "${onlyUnityHistoryModel.value.data[0].opponents[0].housePlayerName ?? onlyUnityHistoryModel.value.data[0].opponents[0].userId.username}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                "Inter",
                                                                            color:
                                                                                Colors.black),
                                                                      )
                                                                    : Text(
                                                                        "--",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                "Inter",
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  "YOUR SCORE",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          "Inter",
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                                onlyUnityHistoryModel.value != null &&
                                                                        onlyUnityHistoryModel.value.data !=
                                                                            null &&
                                                                        onlyUnityHistoryModel.value.data.length >
                                                                            0
                                                                    ? onlyUnityHistoryModel.value.data[0].opponents[0].rounds[0].result !=
                                                                                null &&
                                                                            onlyUnityHistoryModel.value.data[0].opponents[0].rounds[0].result.score !=
                                                                                null
                                                                        ? Text(
                                                                            "${onlyUnityHistoryModel.value.data[0].opponents[0].rounds[0].result.score}",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: "Inter",
                                                                                color: Colors.black),
                                                                          )
                                                                        : Text(
                                                                            "0",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: "Inter",
                                                                                color: Colors.black),
                                                                          )
                                                                    : Text(
                                                                        "0",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                "Inter",
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                SizedBox(
                                                                  height: 40,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                              height: 150,
                                                              width: 150,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/first_rank_circle.png")),
                                                              ),
                                                              child: onlyUnityHistoryModel.value != null &&
                                                                      onlyUnityHistoryModel
                                                                              .value
                                                                              .data !=
                                                                          null &&
                                                                      onlyUnityHistoryModel
                                                                              .value
                                                                              .data
                                                                              .length >
                                                                          0 &&
                                                                      onlyUnityHistoryModel
                                                                              .value
                                                                              .data[
                                                                                  0]
                                                                              .opponents[
                                                                                  0]
                                                                              .userId
                                                                              .photo !=
                                                                          null &&
                                                                      onlyUnityHistoryModel
                                                                              .value
                                                                              .data[0]
                                                                              .opponents[0]
                                                                              .userId
                                                                              .photo
                                                                              .url !=
                                                                          null
                                                                  ? Center(
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              50),
                                                                        ),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          width:
                                                                              85,
                                                                          height:
                                                                              85,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          imageUrl:
                                                                              ("${onlyUnityHistoryModel.value.data[0].opponents[0].userId.photo.url}"),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child: Center(
                                                                          child: Image(
                                                                        height:
                                                                            30,
                                                                        image: AssetImage(
                                                                            ImageRes().team_group),
                                                                      )),
                                                                    )),
                                                        )
                                                      ],
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        children: [
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    top: 70,
                                                                    right: 15),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 0,
                                                                    top: 0),
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: AppColor()
                                                                          .second_rank,
                                                                      width: 5,
                                                                    ),
                                                                    /*    image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage("assets/images/store_back.png")),*/
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: AppColor()
                                                                        .whiteColor),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 50,
                                                                  ),
                                                                  Text(
                                                                    "${user_name}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            "Inter",
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    "YOUR SCORE",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            "Inter",
                                                                        color: Colors
                                                                            .black54),
                                                                  ),
                                                                  onlyUnityHistoryModel.value != null &&
                                                                          onlyUnityHistoryModel.value.data !=
                                                                              null &&
                                                                          onlyUnityHistoryModel.value.data.length >
                                                                              0
                                                                      ? onlyUnityHistoryModel.value.data[0].rounds[0].result != null &&
                                                                              onlyUnityHistoryModel.value.data[0].rounds[0].result.score != null
                                                                          ? Text(
                                                                              onlyUnityHistoryModel.value.data[0].rounds[0].result.score ?? "0",
                                                                              style: TextStyle(fontSize: 14, fontFamily: "Inter", color: Colors.black),
                                                                            )
                                                                          : Text(
                                                                              "0",
                                                                              style: TextStyle(fontSize: 14, fontFamily: "Inter", color: Colors.black),
                                                                            )
                                                                      : Text(
                                                                          "0",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: "Inter",
                                                                              color: Colors.black),
                                                                        ),
                                                                  SizedBox(
                                                                    height: 25,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Container(
                                                                height: 150,
                                                                width: 150,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          "assets/images/second_circle.png")),
                                                                ),
                                                                child: user_photo !=
                                                                            null &&
                                                                        user_photo
                                                                            .isNotEmpty
                                                                    ? user_photo.compareTo("-") ==
                                                                            0
                                                                        ? Container(
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                            child: Center(
                                                                                child: Image(
                                                                              height: 30,
                                                                              image: AssetImage(ImageRes().team_group),
                                                                            )),
                                                                          )
                                                                        : Center(
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(50),
                                                                              ),
                                                                              child: CachedNetworkImage(
                                                                                width: 85,
                                                                                height: 85,
                                                                                fit: BoxFit.fill,
                                                                                imageUrl: ("${user_photo}"),
                                                                              ),
                                                                            ),
                                                                          )
                                                                    : Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        child: Center(
                                                                            child: Image(
                                                                          height:
                                                                              30,
                                                                          image:
                                                                              AssetImage(ImageRes().team_group),
                                                                        )),
                                                                      )),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              ],
                                            ),
                                ),
                                SizedBox(
                                  height: 80,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 50),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 22),
                                      child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: AppColor().colorPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: AnimatedBuilder(
                                                  animation:
                                                      transitionAnimation,
                                                  builder: (context, child) {
                                                    return SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                              -1, 0),
                                                          end: const Offset(
                                                              0, 0),
                                                        ).animate(CurvedAnimation(
                                                            curve: const Interval(
                                                                .01, 0.25,
                                                                curve: Curves
                                                                    .easeIn),
                                                            parent:
                                                                transitionAnimation)),
                                                        child: child);
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    //    color:AppColor().colorPrimaryDark,

                                                    decoration: BoxDecoration(
                                                        color: AppColor()
                                                            .colorPrimaryDark,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  cancel.value = true;

                                                  try {
                                                    getPreJoinEventFreakxClick(
                                                        event_id);
                                                  } catch (E) {
                                                    print("comming ex$E");
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  height: 50,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Starting New Battle",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Inter",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        child: Image.asset(
                                                            ImageRes()
                                                                .rupee_icon),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "$playAmount",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Inter",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        // Fluttertoast.showToast(msg: "call data ${back_cancel_dis.value}");
                                        if (back_cancel_dis.isTrue) {
                                        } else {
                                          cancel.value = true;
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Get.to(() => FreakxList(
                                              gameid, url1, widget.nameGame));
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: AppColor().whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: "Inter",
                                                color:
                                                    AppColor().reward_card_bg),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                                height: 130,
                                child: Image.asset(
                                    "assets/images/gameover_test.png")),
                            SizedBox(
                              height: 90,
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Center(
                                        child: AspectRatio(
                                          aspectRatio: 2 / 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(ImageRes()
                                                        .resultserror))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 90,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 50),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 22),
                                      child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: AppColor().colorPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: AnimatedBuilder(
                                                  animation:
                                                      transitionAnimation,
                                                  builder: (context, child) {
                                                    return SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                              -1, 0),
                                                          end: const Offset(
                                                              0, 0),
                                                        ).animate(CurvedAnimation(
                                                            curve: const Interval(
                                                                .01, 0.25,
                                                                curve: Curves
                                                                    .easeIn),
                                                            parent:
                                                                transitionAnimation)),
                                                        child: child);
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    //    color:AppColor().colorPrimaryDark,

                                                    decoration: BoxDecoration(
                                                        color: AppColor()
                                                            .colorPrimaryDark,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  cancel.value = true;

                                                  try {
                                                    getPreJoinEventFreakxClick(
                                                        event_id);
                                                  } catch (E) {
                                                    print("comming ex$E");
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  height: 50,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Starting New Battle",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Inter",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        child: Image.asset(
                                                            ImageRes()
                                                                .rupee_icon),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "$playAmount",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Inter",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        // Fluttertoast.showToast(msg: "call data ${back_cancel_dis.value}");
                                        if (back_cancel_dis.isTrue) {
                                        } else {
                                          cancel.value = true;
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Get.to(() => FreakxList(
                                              gameid, url1, widget.nameGame));
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: AppColor().whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: "Inter",
                                                color:
                                                    AppColor().reward_card_bg),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                : Shimmer.fromColors(
                    child: Container(
                      height: 130,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: MediaQuery.of(context).size.width,
                    ),
                    baseColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.grey.withOpacity(0.4),
                    enabled: true,
                  ),
          ),
        ),
      ),
    );
  }

  Future<Map> getPreJoinEventGameZob(String event_id) async {
    Utils().customPrint("user_id ===> ${user_id}");
    final param = {
      "userId": user_id,
      "thirdParty": {"type": "freakx", "gameCode": ""}
    };

    Map<String, dynamic> response = await WebServicesHelper()
        .getPreEventJoinGameJob(param, token, event_id);

    debugPrint(' respone is finaly ${response}');
    if (response != null && response['statusCode'] == null) {
      preJoinResponseModel = PreJoinUnityResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount1 deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          try {
            userController.currentIndex.value = 4;
            Utils().alertInsufficientBalance(context);
            //}
          } catch (E) {
            print("comming ex$E");
          }
        } else {
          Future.delayed(const Duration(seconds: 6), () {
            if (cancel.isTrue) {
              //cancel.value = false;
              //Get.offAll(() => GameJobList(gameid, url1, "Ludo"));
            } else {
              //cancel.value = true;
              back_cancel_dis.value = true;
              //RE PLAY event
              try {
                Map<String, dynamic> map = new Map<String, dynamic>();
                map["game_id"] = gameid;
                map["event_id"] = event_id;
                map["gameName"] = '';
                CleverTapController cleverTapController =
                    Get.put(CleverTapController());
                cleverTapController.logEventCT(
                    EventConstant.EVENGT_REPLAY, map);

                FirebaseEvent()
                    .firebaseEvent(EventConstant.EVENGT_REPLAY_F, map);

                AppsflyerController appsflyerController =
                    Get.put(AppsflyerController());
                appsflyerController.logEventAf(
                    EventConstant.EVENGT_REPLAY, map);
              } catch (e) {}
              navigator.pushReplacement<void, void>(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => FreakxWebview(
                      preJoinResponseModel.webViewUrl,
                      gameid,
                      event_id,
                      playAmount,
                      url1,widget.nameGame),
                ),
              );
            }
          });
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
      Utils().customPrint('respone is finaly2${response}');
    }
  }

  Future<Map> getPreJoinEventFreakxClick(String event_id) async {
    // Utils().customPrint("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${user_id}");
    final param = {
      "userId": user_id,
      "thirdParty": {"type": "freakx", "gameCode": ""}
    };

    Map<String, dynamic> response = await WebServicesHelper()
        .getPreEventJoinGameJob(param, token, event_id);
    debugPrint(' respone is finaly ${response}');
    if (response != null && response['statusCode'] == null) {
      preJoinResponseModel = PreJoinUnityResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount1 deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          try {
            double total = double.parse(userController.getTotalBalnace());

            /* if (total < 5) {
              WalletPageController walletPageController =
                  Get.put(WalletPageController());
              walletPageController.alertLookBox("zero_amount");
            } else {*/
            userController.currentIndex.value = 4;
            Utils().alertInsufficientBalance(context);
            // }
          } catch (E) {
            print("comming ex$E");
          }
          /*     try {
            String totalBa = userController.getTotalBalnace();
            int getBonuse =
            userController.getBonuseCashBalanceInt();
            var totalBaI = double.parse(totalBa);
            if (totalBaI <= 0 && getBonuse <= 0) {
              WalletPageController walletPageController = Get.put(WalletPageController());
              walletPageController.alertLookBox();
            }
          } catch (E) {
            print("comming ex$E");
          }*/
          //Fluttertoast.showToast(msg: "Please add Amount.");
          //Get.offAll(() => DashBord(4, ""));
        } else {
          //RE PLAY event
          try {
            Map<String, dynamic> map = new Map<String, dynamic>();
            map["game_id"] = gameid;
            map["event_id"] = event_id;
            map["gameName"] = '';
            CleverTapController cleverTapController =
                Get.put(CleverTapController());
            cleverTapController.logEventCT(EventConstant.EVENGT_REPLAY, map);

            FirebaseEvent().firebaseEvent(EventConstant.EVENGT_REPLAY_F, map);
            AppsflyerController appsflyerController =
                Get.put(AppsflyerController());
            appsflyerController.logEventAf(EventConstant.EVENGT_REPLAY, map);
          } catch (e) {}
          navigator.pushReplacement<void, void>(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => FreakxWebview(
                  preJoinResponseModel.webViewUrl,
                  gameid,
                  event_id,
                  playAmount,
                  url1,widget.nameGame),
            ),
          );
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
      Utils().customPrint('respone is finaly2${response}');
    }
  }

  Future<void> getUnityHistoryOnly(String game_id) async {
    onlyUnityHistoryModel.value = null;

    Map<String, dynamic> response = await WebServicesHelper()
        .getUnityHistory(token, user_id, game_id, 1, 0);
    if (response != null) {
      //  onlyUnityHistoryModel.value = [];
      onlyUnityHistoryModel.value = OnlyUnityHistoryModel.fromJson(response);
      Utils().customPrint(
          'Completed Game Over Event Testing rank ${onlyUnityHistoryModel.value.data.length}');

      if (onlyUnityHistoryModel.value.data != null &&
          onlyUnityHistoryModel.value.data.length > 0 &&
          onlyUnityHistoryModel.value.data[0].rounds[0].result != null) {
        Utils().customPrint(
            'Completed Game Over Event Testing rank ${onlyUnityHistoryModel.value.data[0].rounds[0].result.rank}');

        //GAME OVER CT EVENTS WORK
        Map<String, Object> map = new Map<String, Object>();
        map["event_id"] = event_id;
        map["Game_id"] = gameid;
        map["playAmount"] = playAmount;
        map["Rank"] = onlyUnityHistoryModel.value.data[0].rounds[0].result.rank;
        map["USER_ID"] = user_id;
        CleverTapController cleverTapController =
            Get.put(CleverTapController());
        cleverTapController.logEventCT(
            EventConstant.EVENT_Casual_Game_Complete, map);

        FirebaseEvent()
            .firebaseEvent(EventConstant.EVENT_Casual_Game_Complete_F, map);
        AppsflyerController appsflyerController =
            Get.put(AppsflyerController());
        appsflyerController.logEventAf(
            EventConstant.EVENT_Casual_Game_Complete, map);
      } else {
        Map<String, Object> map = new Map<String, Object>();
        map["Freakx Game Over Pending"] = "Yes";
        map["USER_ID"] = user_id;
        AppsflyerController appsflyerController =
            Get.put(AppsflyerController());
        CleverTapController cleverTapController =
            Get.put(CleverTapController());

        //calling
        cleverTapController.logEventCT(
            EventConstant.EVENT_Game_Over_Pending_Event, map);
        FirebaseEvent()
            .firebaseEvent(EventConstant.EVENT_Game_Over_Pending_Event_F, map);
        appsflyerController.logEventAf(
            EventConstant.EVENT_Game_Over_Pending_Event, map);
      }

      try {
        String depositeBalnace = userController.getDepositeBalnace();
        //int getBonuse = userController.getBonuseCashBalanceInt();
        /*int getWinning = int.parse(userController.getWinningBalance());
        var totalBaI = double.parse(depositeBalnace);
        double depositeBalnaceSum = totalBaI + getWinning;*/
        double total = double.parse(userController.getTotalBalnace());
        //Utils().customPrint('Completed Game Over Event Testing rank total ${total}');
        //Utils().customPrint('Completed Game Over Event Testing rank isWinner ${onlyUnityHistoryModel.value.data[0].isWinner}');
        if (total < 5) {
          if (onlyUnityHistoryModel.value.data != null &&
              onlyUnityHistoryModel.value.data.length > 0 &&
              onlyUnityHistoryModel.value.data[0].isWinner != null &&
              onlyUnityHistoryModel.value.data[0].isWinner == false) {
            WalletPageController walletPageController =
                Get.put(WalletPageController());
            walletPageController.alertLookBox("zero_amount");
          }
        } else {
          getPreJoinEventGameZob(event_id);
        }
      } catch (E) {
        print("comming ex$E");
      }
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    user_name = prefs.getString("user_name");
    user_photo = prefs.getString("user_photo");

    debugPrint("photo call $user_photo");
    getUnityHistoryOnly(gameid);
  }

  Future showAlertDialog(
      BuildContext context, YesOrNoTapCallback isYesTapped) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do you want to quit?"),
      actions: [
        TextButton(
            onPressed: () {
              cancel.value = true;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Get.to(() => FreakxList(gameid, url1, widget.nameGame));
              // isYesTapped(true);
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
}

typedef YesOrNoTapCallback = Function(bool);
