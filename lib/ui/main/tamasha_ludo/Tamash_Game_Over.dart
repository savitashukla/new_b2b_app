import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/main/tamasha_ludo/TamashaListing.dart';
import 'package:gmng/ui/main/tamasha_ludo/TamashaWebView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/responsemodel/PreJoinUnityResponseModel.dart';
import '../../../model/tamasha/WebViewTamashaModel.dart';
import '../../../model/unity_history/OnlyUnityHistoryModel.dart';
import '../../../res/AppColor.dart';
import '../../../res/firebase_events.dart';
import '../../../utills/Utils.dart';
import '../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../utills/event_tracker/EventConstant.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/WalletPageController.dart';
import '../../controller/user_controller.dart';

class Tamasha_Game_Over extends StatefulWidget {
  String event_id;
  String gameid;
  var entry_fee;

  String gameImageUrl;
  String gameName;
  bool isWinnerTrue;
  int Score;

  Tamasha_Game_Over(this.gameid, this.event_id, this.entry_fee, this.gameName,
      this.gameImageUrl, this.isWinnerTrue, this.Score);

  @override
  State<Tamasha_Game_Over> createState() => _Tamasha_Game_OverState(
      gameid,
      event_id,
      entry_fee,
      this.gameName,
      this.gameImageUrl,
      this.isWinnerTrue,
      this.Score);
}

class _Tamasha_Game_OverState extends State<Tamasha_Game_Over>
    with SingleTickerProviderStateMixin {
  String event_id;
  String gameid;
  String mapV;
  var user_name = "".obs, user_photo = "".obs;
  bool popB = false;

  var entry_fee;

  bool cancel = false;

  String gameImageUrl;
  String gameName;
  bool isWinnerTrue;
  int Score;

  _Tamasha_Game_OverState(this.gameid, this.event_id, this.entry_fee,
      this.gameName, this.gameImageUrl, this.isWinnerTrue, this.Score);

  SharedPreferences prefs;
  String user_id;
  String token;

  var onlyUnityHistoryModel = OnlyUnityHistoryModel().obs;
  AnimationController transitionAnimation;

  PreJoinUnityResponseModel preJoinResponseModel;
  UserController userController = Get.put(UserController());
  var webViewData = WebViewTamashaModel().obs;

/*  Match_Making_Screen_Controller match_Making_Screen_Controlleer =
      Get.put(Match_Making_Screen_Controller(event_id,gameid));*/

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    getData();
    //print('Test GameZop:: 3 ${userController.getTotalBalnace()}');

    transitionAnimation = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    transitionAnimation.repeat();
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
          bool isPop = false;
          await showAlertDialog(context, (alertResponse) {
            Navigator.of(context).pop();
            // This will dismiss the alert dialog
            isPop = alertResponse;
          });
          return isPop;
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/store_back.png"))),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isWinnerTrue
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                            height: 130,
                            child:
                                Image.asset("assets/images/you_won_image.png")),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                      left: 8, top: 70, right: 15),
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColor().first_rank,
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor().whiteColor),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 60,
                                        ),
                                        Obx(
                                          () => Text(
                                            "${user_name.value}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Inter",
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "YOUR SCORE",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "$Score",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/second_circle.png")),
                                      ),
                                      child: Obx(
                                        () => user_photo.value != null &&
                                                user_photo.value.isNotEmpty &&
                                                user_photo.value != "-"
                                            ? Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    width: 85,
                                                    height: 85,
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        ("${user_photo.value}"),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                    child: Image(
                                                  height: 30,
                                                  image: AssetImage(
                                                      ImageRes().team_group),
                                                )),
                                              ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 90,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                            height: 130,
                            child: Image.asset(
                                "assets/images/you_lose_image.png")),
                        /*  Container(
                        height: 130,
                        child: Image.asset(
                            "assets/images/gameover_test.png")),*/
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                      left: 8, top: 70, right: 15),
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColor().second_rank,
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor().whiteColor),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 60,
                                        ),
                                        Obx(
                                          () => Text(
                                            "${user_name.value}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Inter",
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "YOUR SCORE",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "$Score",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/second_circle.png")),
                                      ),
                                      child: Obx(
                                        () => user_photo.value != null &&
                                                user_photo.value.isNotEmpty &&
                                                user_photo.value != "-"
                                            ? Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    width: 85,
                                                    height: 85,
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        ("${user_photo.value}"),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                    child: Image(
                                                  height: 30,
                                                  image: AssetImage(
                                                      ImageRes().team_group),
                                                )),
                                              ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 90,
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
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
                                borderRadius: BorderRadius.circular(10)),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: AnimatedBuilder(
                                    animation: transitionAnimation,
                                    builder: (context, child) {
                                      return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(-1, 0),
                                            end: const Offset(0, 0),
                                          ).animate(CurvedAnimation(
                                              curve: const Interval(.01, 0.25,
                                                  curve: Curves.easeIn),
                                              parent: transitionAnimation)),
                                          child: child);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      //    color:AppColor().colorPrimaryDark,
                                      decoration: BoxDecoration(
                                          color: AppColor().colorPrimaryDark,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    cancel = true;
                                    try {
                                      getPreJoinEventTamashaClick(event_id);
                                      // }
                                    } catch (E) {
                                      print("comming ex$E");
                                    }
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Starting New Battle",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 20,
                                          child: Image.asset(
                                              ImageRes().rupee_icon),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "$entry_fee",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.white),
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
                          cancel = true;
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => TamashaListing(
                                  gameid, gameImageUrl, gameName),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColor().whiteColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  color: AppColor().reward_card_bg),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )

              /* Obx(
                  () => onlyUnityHistoryModel.value != null
                  ? onlyUnityHistoryModel.value.data != null &&
                  onlyUnityHistoryModel.value.data.length > 0 &&
                  onlyUnityHistoryModel.value.data[0].status != null &&
                  onlyUnityHistoryModel.value.data[0].status
                      .compareTo("completed") ==
                      0
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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

                        */ /*Container(
                         height: 130,
                         child:Shi)*/ /*
                      ),
                      SizedBox(
                        height: 50,
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                width:
                                MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    left: 8, top: 70, right: 15),
                                padding: EdgeInsets.only(
                                    bottom: 0, top: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColor().second_rank,
                                      width: 5,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: AppColor().whiteColor),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        "${user_name}",
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
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/second_circle.png")),
                                    ),
                                    child: user_photo != null &&
                                        user_photo.isNotEmpty && user_photo!="-"
                                        ? Center(
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        child:
                                        CachedNetworkImage(
                                          width: 85,
                                          height: 85,
                                          fit: BoxFit.fill,
                                          imageUrl:
                                          ("${user_photo}"),
                                        ),
                                      ),
                                    )
                                        : Container(
                                      height: 20,
                                      width: 20,
                                      child: Center(
                                          child: Image(
                                            height: 30,
                                            image: AssetImage(
                                                ImageRes()
                                                    .team_group),
                                          )),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 70,
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
                                        cancel = true;
                                        try {

                                          getPreJoinEventTamashaClick(
                                              event_id);
                                          // }
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
                                              "$entry_fee",
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
                              cancel = true;
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => TamashaListing(
                                      gameid,"", "Tamasha Ludo"),
                                ),
                              );


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
              )
                  : Column(
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
                                        cancel = true;
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
                                              "$entry_fee",
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
                              cancel = true;
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => TamashaListing(
                                      gameid,"", "Tamasha Ludo"),
                                ),
                              );



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
            ),*/
              ),
        ),
      ),
    );
  }

  Future<void> getPreJoinEventTamasha(String contestId) async {
    //API Call

    final param = {
      "contestId": contestId,
    };
    Map<String, dynamic> response_str =
        await WebServicesHelper().getTamashaWebView(token, param);
    //Utils.launchURLApp(response_str["webViewUrl"]);
    //return;
    if (response_str != null) {
      webViewData.value = WebViewTamashaModel.fromJson(response_str);
      Utils().customPrint('getCallGameUrlTamasha ${webViewData.value}');
    }

    Utils().customPrint('["webViewUrl"]: $webViewData.value.webViewUrl}');
    if (webViewData.value != null) {
      if (webViewData.value.deficitAmount.value > 0) {
        int total = 0;
        if (userController.getTotalBalnace() != null &&
            userController.getTotalBalnace() != '') {
          total = int.parse(userController.getTotalBalnace());
        }

        if (total < 5) {
          WalletPageController walletPageController =
              Get.put(WalletPageController());
          walletPageController.alertLookBox("zero_amount");
        } else {
          userController.currentIndex.value = 4;
          Utils().alertInsufficientBalance(context);
        }
      } else {
        Future.delayed(const Duration(seconds: 6), () {
          if (cancel) {
            // cancel = false;
            //Get.offAll(() => GameJobList(gameid, url1, "Ludo"));
          } else {
            //RE PLAY event
            try {
              Map<String, dynamic> map = new Map<String, dynamic>();
              map["game_id"] = gameid;
              map["event_id"] = event_id;
              map["gameName"] = gameName;
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
                builder: (BuildContext context) => TamashaWebview(
                    webViewData.value.webViewUrl,
                    gameid,
                    event_id,
                    entry_fee,
                    gameImageUrl,
                    gameName),
              ),
            );
          }
        });
      }
    }
  }

  Future<void> getPreJoinEventTamashaClick(String contestId) async {
    //API Call

    final param = {
      "contestId": contestId,
    };
    Map<String, dynamic> response_str =
        await WebServicesHelper().getTamashaWebView(token, param);
    //Utils.launchURLApp(response_str["webViewUrl"]);
    //return;
    if (response_str != null) {
      webViewData.value = WebViewTamashaModel.fromJson(response_str);
      Utils().customPrint('getCallGameUrlTamasha ${webViewData.value}');
    }

    Utils().customPrint('["webViewUrl"]: $webViewData.value.webViewUrl}');
    if (webViewData.value != null) {
      if (webViewData.value.deficitAmount.value > 0) {
        try {
          int total = int.parse(userController.getTotalBalnace());
          if (total < 5) {
            WalletPageController walletPageController =
                Get.put(WalletPageController());
            walletPageController.alertLookBox("zero_amount");
          } else {
            userController.currentIndex.value = 4;
            Utils().alertInsufficientBalance(context);
          }
        } catch (E) {
          print("comming ex$E");
        }
      } else {
        try {
          Map<String, dynamic> map = new Map<String, dynamic>();
          map["game_id"] = gameid;
          map["event_id"] = event_id;
          map["gameName"] = gameName;
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
            builder: (BuildContext context) => TamashaWebview(
                webViewData.value.webViewUrl,
                gameid,
                event_id,
                entry_fee,
                gameImageUrl,
                gameName),
          ),
        );
      }
    }
  }

  Future<void> getUnityHistoryOnly(String game_id) async {
    onlyUnityHistoryModel.value = null;

    Map<String, dynamic> response = await WebServicesHelper()
        .getUnityHistory(token, user_id, game_id, 1, 0);
    if (response != null) {
      onlyUnityHistoryModel.value = OnlyUnityHistoryModel.fromJson(response);

      if (onlyUnityHistoryModel.value.data != null &&
          onlyUnityHistoryModel.value.data.length > 0 &&
          onlyUnityHistoryModel.value.data[0].rounds[0].result != null) {
        //completed case
        //GAME OVER CT EVENTS WORK
        Map<String, Object> map = new Map<String, Object>();
        map["event_id"] = event_id;
        map["Game_id"] = gameid;
        map["playAmount"] = "$entry_fee";
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
        map["Game Jop Game Over Pending"] = "Yes";
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
      // EVENT_Game_Over_Pending_Event

      try {
        double total = double.parse(userController.getTotalBalnace());
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
          getPreJoinEventTamasha(event_id);
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
    user_name.value = prefs.getString("user_name");
    user_photo.value = prefs.getString("user_photo");
    //print("images data ${user_photo.value}");
    try {
      double total = double.parse(userController.getTotalBalnace());
      if (total < 5) {
        WalletPageController walletPageController =
            Get.put(WalletPageController());
        walletPageController.alertLookBox("zero_amount");
      } else {
        getPreJoinEventTamasha(event_id);
      }
    } catch (E) {
      print("comming ex$E");
    }

    //Event Call
    try {
      Map<String, dynamic> map = new Map<String, dynamic>();
      map["event_id"] = event_id;
      map["Game_id"] = gameid;
      map["playAmount"] = entry_fee;
      map["Rank"] = isWinnerTrue ? 1 : 2;
      map["USER_ID"] = user_id;
      map["score"] = Score;
      CleverTapController cleverTapController = Get.put(CleverTapController());
      cleverTapController.logEventCT(
          EventConstant.EVENT_Casual_Game_Complete, map);

      FirebaseEvent()
          .firebaseEvent(EventConstant.EVENT_Casual_Game_Complete_F, map);
      AppsflyerController appsflyerController = Get.put(AppsflyerController());
      appsflyerController.logEventAf(
          EventConstant.EVENT_Casual_Game_Complete, map);
      // getUnityHistoryOnly(gameid);
    } catch (E) {
      print("comming ex$E");
    }
  }

  Future showAlertDialog(
      BuildContext context, YesOrNoTapCallback isYesTapped) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do you want to quit?"),
      actions: [
        TextButton(
            onPressed: () {
              cancel = true;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              //  Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      TamashaListing(gameid, gameImageUrl, gameName),
                ),
              );
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
