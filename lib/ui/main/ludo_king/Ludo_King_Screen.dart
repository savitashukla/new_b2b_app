import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/main/ludo_king/LudoKingController.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../model/ESportsEventList.dart';
import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../model/responsemodel/PreJoinResponseModel.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/ESportsController.dart';
import '../../controller/user_controller.dart';
import '../dashbord/DashBord.dart';
import '../profile/Profile.dart';
import 'JoinLudoKing.dart';
import 'how_to_play_esport.dart';

class LudoKingScreen extends StatefulWidget {
  String gameid = "";
  String event_id = "";
  String howToPlayUrl = "";

  LudoKingScreen(this.gameid, this.event_id, this.howToPlayUrl);

  @override
  State<LudoKingScreen> createState() =>
      LudoKingScreenState(gameid, howToPlayUrl);
}

class LudoKingScreenState extends State<LudoKingScreen>
    with WidgetsBindingObserver {
  String gameid = "";
  String howToPlayUrl = "";

  bool click_pay = true;

  LudoKingScreenState(this.gameid, this.howToPlayUrl);

  PreJoinResponseModel preJoinResponseModel = null;

  UserController _userController = Get.put(UserController());

  LudoKingController ludo_king_controller = Get.put(LudoKingController());

  ESportsController controller;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int contestAmountLocal = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Utils().customPrint("didChangeAppLifecycleState ludo join ");

/*    Future.delayed(const Duration(seconds: 3), () async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var instantCashAdded = prefs.getBool("instantCashAdded");
        print("get notification done  instantCashAdded $instantCashAdded");
        if (instantCashAdded) {
          prefs.setBool("instantCashAdded", false);
          _userController.showCustomDialogConfettiNew();
        //  Utils().showOfferWaleFeedBack(0);
        }
      } catch (A) {}
    });*/

    if (state == AppLifecycleState.paused) {
      Utils().customPrint("didChangeAppLifecycleState  ludo join");
      controller.getESportsEventList("");
      _userController.getWalletAmount();
    }
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    //checking for app update

    Utils().customPrint("call again initState call");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(ESportsController(widget.gameid, widget.event_id));

    return SafeArea(
      child: Stack(
        children: [
          RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              // return Future<void>.delayed(const Duration(seconds: 3));
              return Future.delayed(const Duration(seconds: 1), () async {
                controller.getESportsEventList(gameid);
                controller.getINGameCheck(gameid);
                controller.getJoinedContestList(gameid);
                controller.getMap("");
              });
            },
            child: WillPopScope(
              onWillPop: onWillPopMain,
              child: Scaffold(
                body: Container(
                  color: AppColor().blackColor,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                          automaticallyImplyLeading: false,
                          expandedHeight: 180.0,
                          floating: false,
                          pinned: true,
                          snap: false,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: GestureDetector(
                            onTap: () {
                              Get.to(() => how_to_play_esport(howToPlayUrl));
                              /* if (click_pay) {
                                click_pay = false;
                                showCustomDialogHowToPlay(context);
                              }*/
                            },
                            child: Image(
                              //  height: 180,
                              width: MediaQuery.of(context).size.width,

                              image:
                                  AssetImage("assets/images/ludo_banner.png"),
                              fit: BoxFit.cover,
                            ),
                          )),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 15),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      ludo_king_controller.checkEventHis.value =
                                          true;
                                      ludo_king_controller.colorPrimary.value =
                                          Color(0xFFe55f19);
                                      ludo_king_controller.colorwhite.value =
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
                                            color: ludo_king_controller
                                                .colorPrimary.value,
                                            height: 3,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      ludo_king_controller.checkEventHis.value =
                                          false;
                                      ludo_king_controller.colorPrimary.value =
                                          Color(0xFFffffff);
                                      ludo_king_controller.colorwhite.value =
                                          Color(0xFFe55f19);
                                      controller
                                          .getJoinedContestList(widget.gameid);
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
                                            color: ludo_king_controller
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
                        Obx(
                          () => ludo_king_controller.checkEventHis.isTrue
                              ? controller.esportEventListModel.value != null
                                  ? controller.esportEventListModel.value
                                                  .data !=
                                              null &&
                                          controller.esportEventListModel.value
                                                  .data.length >
                                              0
                                      ? ListView.builder(
                                          itemCount: controller
                                              .esportEventListModel
                                              .value
                                              .data
                                              .length,
                                          padding: EdgeInsets
                                              .symmetric(
                                                  horizontal: 10, vertical: 10),
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, int index) {
                                            return listContainer(
                                                context, index);
                                          })
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 60),
                                          child: AspectRatio(
                                            aspectRatio: 2 / 1,
                                            child: Container(
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/images/empty_screen.png")),
                                            ),
                                          ),
                                        )
                                  : Container(
                                      height: 0,
                                    )
                              : controller.esportJoinedList != null &&
                                      controller.esportJoinedList.value !=
                                          null &&
                                      controller.esportJoinedList.value.data !=
                                          null &&
                                      controller.esportJoinedList.value.data
                                              .length >
                                          0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => Profile(gameid));
                                          },
                                          child: Container(
                                            height: 42,
                                            width: 150,
                                            margin: EdgeInsets.only(right: 10),
                                            alignment: Alignment.centerRight,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color:
                                                        AppColor().colorPrimary,
                                                    width: 2)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "View Results",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: FontSizeC()
                                                          .front_very_small14,
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                SvgPicture.asset(
                                                  "assets/images/ludo_king_result.svg",
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                            itemCount: controller
                                                .esportJoinedList
                                                .value
                                                .data
                                                .length,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return listContainerHistory(
                                                  context, index);
                                            })
                                      ],
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                        ),
                      ]))
                    ],
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
              child: BlurryContainer(
                height: 50,
                blur: 999999999999,
                color: Colors.white.withOpacity(0.1),
                padding: const EdgeInsets.all(0),
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                elevation: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.offAll(() => DashBord(2, ""));
                        },
                        child: Container(
                            //    margin: EdgeInsets.only(top: 40, left: 10),
                            // alignment: Alignment.topLeft,
                            child:
                                Image.asset("assets/images/right_arrow.png")),
                      ),
                    ),
                    Text(
                      "Ludo King",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: FontSizeC().front_larger18,
                          color: AppColor().whiteColor,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showInGameDialog(context, gameid);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 1),
                            ),
                            height: 20,
                            width: 20,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text("ID",
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: FontSizeC().front_very_small10,
                                      color: AppColor().whiteColor,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => how_to_play_esport(howToPlayUrl));
                            /* if (click_pay) {
                              click_pay = false;
                              showCustomDialogHowToPlay(context);
                            }*/
                          },
                          child: Image.asset(
                            ImageRes().how_to_pay_ludo_king,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        InkWell(
                          onTap: () {
                            _userController.checkWallet_class_call.value =
                                false;
                            _userController.getWalletAmount();
                            !ApiUrl().isPlayStore
                                ? _userController.wallet_s.value = true
                                : _userController.wallet_s.value = false;

                            if (!ApiUrl().isPlayStore) {
                              _userController.checkWallet_class_call.value =
                                  false;
                              _userController.currentIndex.value = 4;
                              Get.offAll(() => DashBord(4, ""));
                              //   Wallet().showBottomSheetAddAmount(context);
                            } else {
                              Get.offAll(() => DashBord(4, ""));
                            }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2, right: 0, left: 5, bottom: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image(
                                            width: 13,
                                            height: 13,
                                            image: ApiUrl().isPlayStore
                                                ? AssetImage(
                                                    "assets/images/deposited.webp")
                                                : AssetImage(
                                                    "assets/images/rupee_icon.png")),
                                        Obx(
                                          () => Text(
                                            ' ${_userController.getTotalBalnace()}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                                color: AppColor().whiteColor),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image(
                                            width: 13,
                                            height: 13,
                                            image: AssetImage(
                                                "assets/images/bonus_coin.png")),
                                        Obx(
                                          () => Text(
                                            ' ${_userController.getBonuseCashBalance()}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                                color: AppColor().whiteColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
                                child: !ApiUrl().isPlayStore
                                    ? Image(
                                        height: 30,
                                        //width: 40,
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            ImageRes().plus_new_icon))
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listContainer(BuildContext context, int index) {
    return Container(
      height: 136,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.5, color: AppColor().colorPrimary)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.esportEventListModel.value.data[index].name,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: FontSizeC().front_larger18,
                    color: AppColor().whiteColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  if (click_pay) {
                    click_pay = false;

                    showCustomDialogContestInfoChan(context,
                        controller.esportEventListModel.value.data[index]);
                    //   showCustomDialogHowToPlay(context);
                  }
                },
                child: Container(
                  child: Image.asset(
                    ImageRes().iv_info,
                    color: Colors.white,
                    width: 15,
                    height: 15,
                  ),
                ),

                /*CircleAvatar(
                  radius: 11,
                  child: Image.asset(
                    "assets/images/ic_question.webp",
                    color: AppColor().colorGray,
                  ),
                  backgroundColor: Colors.transparent,
                )*/
              ),
            ],
          ),
          SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    child: Lottie.asset(
                      'assets/lottie_files/truphy.json',
                      repeat: true,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Win ",
                    style: TextStyle(
                        fontSize: FontSizeC().front_very_small15,
                        color: AppColor().yellow_color,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),
                  ),
                  controller.esportEventListModel.value.data[index].winner
                                  .prizeAmount !=
                              null &&
                          controller.esportEventListModel.value.data[index]
                                  .winner.prizeAmount.type
                                  .compareTo("bonus") ==
                              0
                      ? Text(
                          "${AppString().txt_currency_symbole}${controller.esportEventListModel.value.data[index].winner.prizeAmount.value}",
                          style: TextStyle(
                              fontSize: FontSizeC().front_very_small15,
                              color: AppColor().yellow_color,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "${AppString().txt_currency_symbole}${(controller.esportEventListModel.value.data[index].winner.prizeAmount.value / 100).toString().replaceAll(ludo_king_controller.regex, '')}",
                          style: TextStyle(
                              fontSize: FontSizeC().front_very_small15,
                              color: AppColor().yellow_color,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Starts in",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: FontSizeC().front_larger20,
                        color: AppColor().whiteColor,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500),
                  ),
                  Obx(
                    () => ((DateTime.parse(
                                        "${controller.esportEventListModel.value.data[index].eventDate.start}")
                                    .toUtc())
                                .difference(controller.getCurrentdate())
                                .inSeconds) >
                            0
                        ? TweenAnimationBuilder<Duration>(
                            duration: Duration(
                                seconds: controller.subtractDate(DateTime.parse(
                                    "${controller.esportEventListModel.value.data[index].eventDate.start}"))),
                            tween: Tween(
                                begin: Duration(
                                    seconds: controller.subtractDate(DateTime.parse(
                                        "${controller.esportEventListModel.value.data[index].eventDate.start}"))),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text("$hours\:$minutes\:$seconds",
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: FontSizeC()
                                                  .front_very_small15,
                                              color: AppColor().colorAccent,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500)));
                            })
                        : Text(
                            '${controller.esportEventListModel.value.data[index].eventDate.getStartTimeHHMMSS()}',
                            style: TextStyle(
                                fontSize: FontSizeC().front_very_small15,
                                color: AppColor().colorAccent,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500),
                          ),
                  ),

                  /*    Text(
                    '${controller.esportEventListModel.value.data[index].eventDate.getStartTimeHHMMSS()}',
                    style: TextStyle(
                        fontSize: FontSizeC().front_very_small15,
                        color: AppColor().colorAccent,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500),
                  ),*/
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (AppString.joinContest.value == 'inactive') {
                    Fluttertoast.showToast(msg: 'Join contest disable!');
                    return;
                  }

                  ludo_king_controller.Confirm_test.value = "CONFIRM";
                  print(
                      'contestAmount ludoking 1 ${controller.esportEventListModel.value.data[index].entry.fee.type}');
                  if (controller.esportEventListModel.value.data[index].entry
                          .fee.type ==
                      'bonus') {
                    contestAmountLocal = controller
                        .esportEventListModel.value.data[index].entry.fee.value;
                  } else {
                    contestAmountLocal = controller.esportEventListModel.value
                            .data[index].entry.fee.value ~/
                        100;
                  }

                  CheckJoinContestDetails(
                      controller.esportEventListModel.value.data[index],
                      context);
                  /* getPreJoinEvent(
                      controller.esportEventListModel.value.data[index],
                      context);*/
                  // Get.to(() => JoinLudoKingScreen(controller.esportEventListModel.value.data[index]));
                },
                child: Container(
                  width: 120,
                  height: 38,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(
                          0.0,
                          5.0,
                        ),
                        blurRadius: 3.2,
                        spreadRadius: 0.3,
                        color: Color(0xFFA73804),
                        inset: true,
                      ),
                    ],

                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColor().button_bg_light,
                        AppColor().button_bg_dark,
                      ],
                    ),
                    border: Border.all(color: AppColor().whiteColor, width: 2),
                    borderRadius: BorderRadius.circular(30),
                    // color: AppColor().whiteColor
                  ),
                  child: Obx(
                    () => controller.esportEventListModel.value.data[index]
                                    .maxPlayers ==
                                controller.esportEventListModel.value
                                    .data[index].joinSummary.users ||
                            (controller.esportEventListModel.value.data[index]
                                            .maxPlayers -
                                        controller.esportEventListModel.value
                                            .data[index].joinSummary.users) -
                                    1 <=
                                0
                        ? Center(
                            child: Text(
                              "Full",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: FontSizeC().front_larger18,
                                  color: AppColor().whiteColor,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*   Text(AppString().txt_currency_symbole,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: FontSizeC().front_larger18,
                                color: AppColor().whiteColor,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600)),*/
                              SvgPicture.asset(
                                ImageRes().triangle_rupees,
                                height: 20,
                                width: 36,
                                fit: BoxFit.fill,
                              ),
                              controller.esportEventListModel.value.data[index]
                                          .entry.fee.value >
                                      0
                                  ? Text(
                                      controller.esportEventListModel.value
                                                  .data[index].entry.fee.type ==
                                              "bonus"
                                          ? "${controller.esportEventListModel.value.data[index].entry.fee.value}"
                                          : "${controller.esportEventListModel.value.data[index].entry.fee.value ~/ 100}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: FontSizeC().front_larger18,
                                          color: AppColor().whiteColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "Free",
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: FontSizeC().front_larger18,
                                          color: AppColor().whiteColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600),
                                    )
                              /* Text("Join",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: FontSizeC().front_larger18,
                                color: AppColor().whiteColor,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600))*/
                              ,
                            ],
                          ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              controller.esportEventListModel.value != null &&
                      controller.esportEventListModel.value.data != null &&
                      controller.esportEventListModel.value.data.length > 0 &&
                      controller.esportEventListModel.value.data[index]
                              .getRemaningPlayerLudoKing() >
                          0
                  ? Row(
                      children: [
                        Image(
                          height: 8,
                          width: 10,
                          fit: BoxFit.fill,
                          color: AppColor().yellow_color,
                          image: AssetImage(ImageRes().ludo_king_team),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        controller.esportEventListModel.value != null &&
                                controller.esportEventListModel.value.data
                                        .length >
                                    0 &&
                                controller.esportEventListModel.value
                                        .data[index].joinSummary.users >
                                    0
                            ? Text(
                                "${controller.esportEventListModel.value != null && controller.esportEventListModel.value.data.length > 0 && controller.esportEventListModel.value.data[index].joinSummary.users > 0 ? controller.esportEventListModel.value.data[index].joinSummary.users == controller.esportEventListModel.value.data[index].maxPlayers ? controller.esportEventListModel.value.data[index].joinSummary.users - 1 : controller.esportEventListModel.value.data[index].joinSummary.users : "0"}/${controller.esportEventListModel.value.data[index].maxPlayers - 1}",
                                style: TextStyle(
                                    fontSize: FontSizeC().front_very_small10,
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400),
                              )
                            : Text(
                                "${controller.esportEventListModel.value.data[index].maxPlayers - 1}",
                                style: TextStyle(
                                    fontSize: FontSizeC().front_very_small10,
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400),
                              ),
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                width: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Image(
                  height: 15,
                  width: 15,
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().win_crown),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Text(
                  "${!controller.esportEventListModel.value.data[index].winner.isKillType() ? controller.esportEventListModel.value.data[index].getTotalWinner() : controller.esportEventListModel.value.data[index].winner.perKillAmount.value ~/ 100}",
                  style: TextStyle(
                      fontSize: FontSizeC().front_very_small10,
                      color: AppColor().whiteColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget listContainerHistory(BuildContext context, int index) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.5, color: AppColor().colorPrimary)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            controller.esportJoinedList.value.data[index].name,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: FontSizeC().front_larger18,
                color: AppColor().whiteColor,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    child: Lottie.asset(
                      'assets/lottie_files/truphy.json',
                      repeat: true,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Win ",
                    style: TextStyle(
                        fontSize: FontSizeC().front_very_small15,
                        color: AppColor().yellow_color,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),
                  ),
                  controller.esportJoinedList.value.data[index].winner
                                  .prizeAmount !=
                              null &&
                          controller.esportJoinedList.value.data[index].winner
                                  .prizeAmount.type
                                  .compareTo("bonus") ==
                              0
                      ? Text(
                          "${AppString().txt_currency_symbole}${controller.esportJoinedList.value.data[index].winner.prizeAmount.value}",
                          style: TextStyle(
                              fontSize: FontSizeC().front_very_small15,
                              color: AppColor().yellow_color,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "${AppString().txt_currency_symbole}${(controller.esportJoinedList.value.data[index].winner.prizeAmount.value / 100).toString().replaceAll(ludo_king_controller.regex, '')}",
                          style: TextStyle(
                              fontSize: FontSizeC().front_very_small15,
                              color: AppColor().yellow_color,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                ],
              ),
              Column(
                children: [
                  Obx(
                    () => ((DateTime.parse(
                                        "${controller.esportJoinedList.value.data[index].eventDate.start}")
                                    .toUtc())
                                .difference(controller.getCurrentdate())
                                .inSeconds) >
                            0
                        ? TweenAnimationBuilder<Duration>(
                            duration: Duration(
                                seconds: controller.subtractDate(DateTime.parse(
                                    "${controller.esportJoinedList.value.data[index].eventDate.start}"))),
                            tween: Tween(
                                begin: Duration(
                                    seconds: controller.subtractDate(DateTime.parse(
                                        "${controller.esportJoinedList.value.data[index].eventDate.start}"))),
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
                                  Column(
                                children: [
                                  Text(
                                    "Starts in",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: FontSizeC().front_regular17,
                                        color: AppColor().whiteColor,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Text("$hours\:$minutes\:$seconds",
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: FontSizeC()
                                                  .front_very_small15,
                                              color: AppColor().colorAccent,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500))),
                                ],
                              );
                            })
                        : Text(
                            "Result\n Pending",
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: FontSizeC().front_very_small15,
                                color: AppColor().whiteColor,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                  /*  Text(
                    "Result\n Pending",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: FontSizeC().front_very_small15,
                        color: AppColor().whiteColor,

                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500),
                  ),*/
                  /*   Text(
                    '${controller.esportJoinedList.value.data[index].eventDate.getStartTimeHHMMSS()}',
                    style: TextStyle(
                        fontSize: FontSizeC().front_very_small15,
                        color: AppColor().colorAccent,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500),
                  ),*/
                ],
              ),
              GestureDetector(
                onTap: () {
                  ludo_king_controller.Confirm_test = "REGISTERED".obs;

                  controller.selected_contest.value =
                      controller.esportJoinedList.value.data[index];

                  controller.selected_userRegistrations.value =
                      controller.esportJoinedList.value.userRegistrations;

                  Get.to(() => JoinLudoKingScreen(
                      widget.gameid,
                      controller.esportJoinedList.value.data[index],
                      preJoinResponseModel,
                      controller.esportJoinedList.value.userRegistrations,
                      howToPlayUrl));
                  /* getPreJoinEvent(
                      controller.esportJoinedList.value.data[index],
                      context);*/
                  // Get.to(() => JoinLudoKingScreen(controller.esportEventListModel.value.data[index]));
                },
                child: Container(
                  width: 130,
                  height: 38,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(
                          0.0,
                          5.0,
                        ),
                        blurRadius: 3.2,
                        spreadRadius: 0.3,
                        color: Color(0xFFA73804),
                        inset: true,
                      ),
                    ],

                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColor().button_bg_light,
                        AppColor().button_bg_dark,
                      ],
                    ),
                    border: Border.all(color: AppColor().whiteColor, width: .9),
                    borderRadius: BorderRadius.circular(30),
                    // color: AppColor().whiteColor
                  ),
                  /*     decoration: BoxDecoration(
                    border: Border.all(color: AppColor().whiteColor),
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColor().button_bg_light,
                        AppColor().button_bg_dark,
                      ],
                    ),
                    boxShadow: const [],
                  ),*/
                  child: Center(
                    child: Text("View Details",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: FontSizeC().front_very_small14,
                            color: AppColor().whiteColor,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              controller.esportJoinedList.value != null &&
                      controller.esportJoinedList.value.data != null &&
                      controller.esportJoinedList.value.data.length > 0 &&
                      controller.esportJoinedList.value.data[index].joinSummary
                              .users >
                          0
                  ? Row(
                      children: [
                        Image(
                          height: 8,
                          width: 10,
                          fit: BoxFit.fill,
                          color: AppColor().yellow_color,
                          image: AssetImage(ImageRes().ludo_king_team),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${controller.esportJoinedList.value != null && controller.esportJoinedList.value.data.length > 0 && controller.esportJoinedList.value.data[index].joinSummary.users > 0 ? controller.esportJoinedList.value.data[index].maxPlayers == controller.esportJoinedList.value.data[index].joinSummary.users ? controller.esportJoinedList.value.data[index].joinSummary.users - 1 : controller.esportJoinedList.value.data[index].joinSummary.users : "0"}/${controller.esportJoinedList.value.data[index].maxPlayers - 1}",
                          style: TextStyle(
                              fontSize: FontSizeC().front_very_small10,
                              color: AppColor().whiteColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                width: 3,
              ),
              Image(
                height: 15,
                width: 15,
                fit: BoxFit.fill,
                image: AssetImage(ImageRes().win_crown),
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                "${!controller.esportJoinedList.value.data[index].winner.isKillType() ? controller.esportJoinedList.value.data[index].getTotalWinner() : controller.esportJoinedList.value.data[index].winner.perKillAmount.value ~/ 100}",
                style: TextStyle(
                    fontSize: FontSizeC().front_very_small10,
                    color: AppColor().whiteColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
          /* Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              controller.esportJoinedList.value != null &&
                      controller.esportJoinedList.value.data != null &&
                      controller.esportJoinedList.value.data.length > 0 &&
                      controller.esportJoinedList.value.data[index]
                              .getRemaningPlayerLudoKing() >
                          0
                  ? Row(
                      children: [
                        Image(
                          height: 13,
                          width: 14,
                          fit: BoxFit.fill,
                          color: AppColor().yellow_color,
                          image: AssetImage(ImageRes().ludo_king_team),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "${controller.esportJoinedList.value.data[index].getRemaningPlayerLudoKing()}",
                          style: TextStyle(
                              fontSize: FontSizeC().front_very_small10,
                              fontFamily: 'Montserrat',
                              color: AppColor().whiteColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                width: 3,
              ),
              Image(
                height: 15,
                width: 15,
                fit: BoxFit.fill,
                image: AssetImage(ImageRes().win_crown),
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                "${controller.esportJoinedList.value != null && controller.esportJoinedList.value.data.length > 0 && controller.esportJoinedList.value.data[index].joinSummary.users > 0 ? controller.esportJoinedList.value.data[index].joinSummary.users : "0"}",
                style: TextStyle(
                    fontSize: FontSizeC().front_very_small10,
                    color: AppColor().whiteColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400),
              ),
            ],
          )*/
        ],
      ),
    );
  }

  Future<Map> getPreJoinEvent(
      ContestModel data, BuildContext context, String howtoPlay) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String user_id = prefs.getString("user_id");
    Utils().customPrint("game id ludo king ===> ${widget.gameid}");
    final param = {"userId": user_id};
    // showProgress(context, "", true);

    Map<String, dynamic> response =
        await WebServicesHelper().getPreEventJoin(param, token, data.id);
    Utils().customPrint(' respone is finaly ${response}');
    if (response != null && response['statusCode'] == null) {
      Utils().customPrint(' respone is finaly1 ${response}');
      preJoinResponseModel = PreJoinResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          AppString.contestAmount = contestAmountLocal;
          Utils().alertInsufficientBalance(context);
          Utils().customPrint(
              'contestAmount ludo king ${AppString.contestAmount}');
        } else {
          controller.selected_contest.value = data;
          controller.selected_userRegistrations.value =
              controller.esportJoinedList.value.userRegistrations;
          Get.to(() => JoinLudoKingScreen(
              widget.gameid,
              data,
              preJoinResponseModel,
              controller.esportJoinedList.value.userRegistrations,
              howtoPlay));
        }
      } else {
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(response);
        Fluttertoast.showToast(msg: "${appBaseErrorModel.error}");
        // Utils().showErrorMessage("", appBaseErrorModel.error);
      }
    } else if (response['statusCode'] != 400) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);

      Fluttertoast.showToast(msg: "${appBaseErrorModel.error}");

      //  Utils().showErrorMessage("", appBaseErrorModel.error);
    } else if (response['statusCode'] != 500) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Fluttertoast.showToast(msg: "${appBaseErrorModel.error}");

      // Utils().showErrorMessage("", appBaseErrorModel.error);
    } else {
      // hideLoader();
      Utils().customPrint('respone is finaly2${response}');
      //hideLoader();
    }
  }

  String getStartTimeHHMMSS(String date_c) {
    return DateFormat("yyyy-MM-dd' 'HH:mm:ss").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date_c, true).toLocal());
  }

  void showCustomDialogHowToPlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
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
              child: WillPopScope(
                onWillPop: _onWillPop,
                child: Wrap(
                  children: [
                    Container(
                      color: AppColor().reward_card_bg,
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
                                click_pay = true;
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .89,
                      child: WebView(
                          initialUrl: howToPlayUrl ?? "",
                          javascriptMode: JavascriptMode.unrestricted),
                    )
                  ],
                ),
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

  Future<bool> _onWillPop() async {
    click_pay = true;
    //SystemNavigator.pop();
    return true;
  }

  Future<void> CheckJoinContestDetails(
      ContestModel contestModel, BuildContext context) async {
    if (contestModel.maxPlayers == contestModel.joinSummary.users ||
        (contestModel.maxPlayers - contestModel.joinSummary.users) - 1 <= 0) {
      Fluttertoast.showToast(msg: "Contest Full");
      return;
    }
    if (controller.inGameCheckModel.value != null) {
      getPreJoinEvent(contestModel, context, howToPlayUrl);
    } else {
      showInGameDialog(context, contestModel.gameId.id);
    }
    //EVENT CALL
    //event work
    try {
      AppsflyerController appsflyerController = Get.put(AppsflyerController());
      CleverTapController cleverTapController = Get.put(CleverTapController());

      Map<String, Object> map = new Map<String, Object>();
      map["USER_ID"] = controller.user_id;
      map["Game Name"] = contestModel.name;
      map["Buyin Amount"] = contestModel.entry.fee.value > 0
          ? contestModel.entry.fee.value ~/ 100
          : "Free";
      //map["Bonus Application"] = "";
      map["Prize Pool"] = "";
      map["Game Category"] = contestModel.name;
      map["BONUS_CASH"] = preJoinResponseModel.bonus.value ~/ 100;
      map["WINNING_CASH"] = preJoinResponseModel.winning.value ~/ 100;
      map["DEPOSITE_CASH"] = preJoinResponseModel.deposit.value ~/ 100;
      map["Game Id"] = contestModel.id;
      map["is_championship"] =
          contestModel.type.compareTo("championship") == 0 ? "yes" : "No";

      /* map["is_Affilate"] = _contestModel.affiliate != null ? "yes" : "No";
        map["is_championship"] =
            _contestModel.type.compareTo("championship") == 0 ? "yes" : "No";*/

      //calling CT&AF
      cleverTapController.logEventCT(
          EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
      cleverTapController.logEventCT(EventConstant.EVENT_Joined_Contest, map);
      FirebaseEvent().firebaseEvent(EventConstant.EVENT_CLEAVERTAB_Joined_Contest_F, map);

      FirebaseEvent().firebaseEvent(EventConstant.EVENT_Joined_Contest_F, map);

      map["Game_id"] = gameid;
      appsflyerController.logEventAf(
          EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);

      appsflyerController.logEventAf(
          EventConstant.EVENT_Joined_Contest, map); //for appsflyer only
      //FIREBASE EVENT
    } catch (e) {}
    //end event work
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

  void showInGameDialog(BuildContext context, String game_id) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Stack(
            children: [
              Container(
                height: 344,
                color: Colors.transparent,
                child: Image(
                  image: AssetImage(ImageRes().new_rectangle_box_blank),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                height: 344,
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
                              Fluttertoast.showToast(
                                  msg: "Updated successfully");
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
                              border: Border.all(
                                  color: AppColor().whiteColor, width: 2),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(
                                    0.0,
                                    5.0,
                                  ),
                                  blurRadius: 3.2,
                                  spreadRadius: 0.3,
                                  color: Color(0xFFA73804),
                                  inset: true,
                                ),
                              ],

                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  AppColor().button_bg_light,
                                  AppColor().button_bg_dark,
                                ],
                              ),

                              // color: AppColor().whiteColor
                            )

                            /* BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(ImageRes().submit_bg)),
                              // color: AppColor().colorPrimary,
                              borderRadius: new BorderRadius.circular(10.0),
                            )*/
                            ,
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
            ],
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
          child: Stack(
            children: [
              Container(
                height: 635,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Image(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(ImageRes().ludo_king_bg)),
              ),
              Container(
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
                            bool isInstalled = await DeviceApps.isAppInstalled(
                                'com.ludo.king');
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
            ],
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
        return Center(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/gmng_bg.png"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/gmng_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Card(
                  color: Colors.transparent,
                  child: WillPopScope(
                    onWillPop: _onWillPop,
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
                                  image: AssetImage(
                                      "assets/images/store_top.png"))),
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
                                    click_pay = true;
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
                                  Image(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      fit: BoxFit.fill,
                                      height: 700,
                                      image: AssetImage(
                                          "assets/images/ludo_king_info.png")),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              Utils.launchURLApp(
                                                  esportEventListModel1
                                                      .getClanLink());
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
                                            data: esportEventListModel1
                                                    .getRules() ??
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
                ),
                margin: EdgeInsets.symmetric(horizontal: 0),
              ),
            ],
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

  void showCustomDialogContestInfoChan(
      BuildContext context, ContestModel esportEventListModel1) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/gmng_bg.png"),
                  ),
                ),
                Card(
                  color: Colors.transparent,
                  child: WillPopScope(
                    onWillPop: _onWillPop,
                    child: Wrap(
                      children: [
                        /*  Container(
                          height: 30,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/store_top.png"))),
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
                                  "",
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
                                    click_pay = true;
                                    Navigator.pop(context);
                                  })
                            ],
                          ),
                        ),*/
                        Image(
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height,
                            image:
                                AssetImage("assets/images/ludo_king_info.png")),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 40),
                      child: GestureDetector(
                          child: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onTap: () {
                            click_pay = true;
                            Navigator.pop(context);
                          }),
                    )
                  ],
                )
              ],
            ),
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

  Future<bool> onWillPopMain() async {
    Get.offAll(() => DashBord(2, ""));
    return true;
  }
}
