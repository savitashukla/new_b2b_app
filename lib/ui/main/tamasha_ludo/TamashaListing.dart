import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/controller/BaseController.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/ui/main/tamasha_ludo/TamashaListingController.dart';
import 'package:gmng/ui/main/tamasha_ludo/TamashaWebView.dart';
import 'package:gmng/ui/main/wallet/OfferWallScreen.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';
import 'package:gmng/utills/event_tracker/FaceBookEventController.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'TamashaWebView.dart';

class TamashaListing extends StatefulWidget {
  var gameid1;
  String url1;
  String name1 = "";

  TamashaListing(this.gameid1, this.url1, this.name1);

  TamashaListingState createState() =>
      TamashaListingState(gameid1, url1, name1);
}

class TamashaListingState extends State<TamashaListing>
    with WidgetsBindingObserver {
  var gameid;
  String gameImageUrl;
  String gameName = "";

  TamashaListingState(this.gameid, this.gameImageUrl, this.gameName);

  TamashaListingController controller;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  BaseController base_controller = Get.put(BaseController());
  UserController _userController = Get.put(UserController());
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());
  Timer _timer;
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)'); //used in removing 0 after decimal
  //int _start = 0;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(TamashaListingController(gameid));
    _userController.getProfileData();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () async {
          controller.checkTr.value = true;
          controller.colorPrimary.value = Color(0xFFe55f19);
          controller.colorwhite.value = Color(0xFFffffff);
          controller.getESportsEventList();
          //_demoData.addAll(["", ""]);
        });
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          // backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Image(
              image: AssetImage('assets/images/store_top.png'),
              fit: BoxFit.cover,
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: gameImageUrl != null && gameImageUrl.isNotEmpty
                            ? Image(
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                image: NetworkImage(gameImageUrl)

                                // AssetImage('assets/images/images.png'),
                                )
                            : Image(
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                                image:
                                    AssetImage(ImageRes().tamasha_game_image),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(gameName),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _userController.checkWallet_class_call.value = false;
                      _userController.getWalletAmount();
                      !ApiUrl().isPlayStore
                          ? _userController.wallet_s.value = true
                          : _userController.wallet_s.value = false;

                      if (!ApiUrl().isPlayStore) {
                        _userController.checkWallet_class_call.value = false;
                        _userController.currentIndex.value = 4;
                        Get.to(() => DashBord(4, ""));
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
                                mainAxisAlignment: MainAxisAlignment.start,
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
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: !ApiUrl().isPlayStore
                              ? Image(
                                  height: 30,
                                  //width: 40,
                                  fit: BoxFit.fill,
                                  image: AssetImage(ImageRes().plus_new_icon))
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              Image(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/store_back.png")),
              SingleChildScrollView(
                controller: controller.scrollcontroller,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(msg: 'banner click!');
                        Utils().customPrint('banner click!');
                        if (controller.bannerModelRV.value != null &&
                            controller.bannerModelRV.value.data != null &&
                            controller.bannerModelRV.value.data.length >= 1 &&
                            controller.bannerModelRV.value.data[0].name
                                    .compareTo("lootbox_refferal") ==
                                0) {
                          WalletPageController walletPageController =
                              Get.put(WalletPageController());
                          walletPageController.getAdvertisersDeals();
                          AppString.isClickFromHome = false;
                          Get.to(() => OfferWallScreen());
                          await walletPageController.getUserDeals();
                        }
                      },
                      child: Obx(() => controller.bannerModelRV.value != null &&
                              controller.bannerModelRV.value.data != null
                          ? controller.bannerModelRV.value.data.length > 0
                              ? controller.bannerModelRV.value.data.length > 1
                                  ? CarouselSlider(
                                      items: controller.bannerModelRV.value.data
                                          .map(
                                            (item) => Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Center(
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: CachedNetworkImage(
                                                      height: 100,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          (item.image.url),
                                                    )),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      options: CarouselOptions(
                                        height: 120.0,
                                        autoPlay: true,
                                        disableCenter: true,
                                        viewportFraction: .9,
                                        aspectRatio: 3,
                                        enlargeCenterPage: false,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enableInfiniteScroll: true,
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 1000),
                                        onPageChanged: (index, reason) {
                                          // controller.currentIndexSlider.value = index;
                                        },
                                      ),
                                    )
                                  : Container(
                                      height: 130,
                                      margin: EdgeInsets.only(
                                          top: 10, right: 10, left: 10),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Obx(
                                            () => Image(
                                              height: 120,
                                              fit: BoxFit.cover,
                                              image: controller.bannerModelRV
                                                              .value.data !=
                                                          null &&
                                                      controller.bannerModelRV
                                                              .value.data !=
                                                          null &&
                                                      controller
                                                              .bannerModelRV
                                                              .value
                                                              .data
                                                              .length >=
                                                          1
                                                  ? NetworkImage(controller
                                                      .bannerModelRV
                                                      .value
                                                      .data[0]
                                                      .image
                                                      .url)
                                                  : AssetImage(ImageRes()
                                                      .store_banner_wallet),
                                            ),
                                          )),
                                    )
                              : Container(
                                  height: 0,
                                )
                          : Shimmer.fromColors(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                height: MediaQuery.of(context).size.width * 0.3,
                                width: MediaQuery.of(context).size.width,
                              ),
                              baseColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.grey.withOpacity(0.4),
                              enabled: true,
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35, bottom: 15),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
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
                                        margin: EdgeInsets.only(top: 5),
                                        color: controller.colorPrimary.value,
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
                                  try {
                                    if (controller
                                                .unity_history_userRegistrations !=
                                            null &&
                                        controller
                                                .unity_history_userRegistrations
                                                .length >
                                            0) {
                                      controller.unity_history_userRegistrations
                                          .clear();
                                    }
                                  } catch (E) {}
                                  controller.currentpage.value = 0;
                                  controller.getUnityHistoryOnly(gameid);
                                  controller.checkTr.value = false;
                                  controller.colorPrimary.value =
                                      Color(0xFFffffff);
                                  controller.colorwhite.value =
                                      Color(0xFFe55f19);
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "History".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          color: Colors.white),
                                    ),
                                    Obx(
                                      () => Container(
                                        margin: EdgeInsets.only(top: 5),
                                        color: controller.colorwhite.value,
                                        height: 3,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: Obx(
                          () => controller.checkTr.value
                              ? Text(
                                  "Contest".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                )
                              : InkWell(
                                  onTap: () {
                                    Utils().tamashaLHistoryPending();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                          height: 20,
                                          color: Colors.red,
                                          width: 20,
                                          image: AssetImage(
                                              ImageRes().warning_tl)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Don't see your result here?",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Inter",
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.checkTr.value,
                        child: controller.unityEventList.value != null
                            ? controller.unityEventList.value.data != null
                                ? ListView.builder(
                                    itemCount: controller
                                        .unityEventList.value.data.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {
                                      return triviaListother(context, index);
                                    })
                                : Text("")
                            : Container(
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
                      ),
                    ),
                    Obx(
                      () => Offstage(
                        offstage: controller.checkTr.value,
                        child: controller.unity_history_userRegistrations !=
                                null
                            ? controller.unity_history_userRegistrations != null
                                ? ListView.builder(
                                    itemCount: controller
                                        .unity_history_userRegistrations.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return listHistoryUnity(context, index);
                                    })
                                : SizedBox(
                                    height: 0,
                                  )
                            : Container(
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
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /*   Future.delayed(const Duration(seconds: 3), () async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var instantCashAdded = prefs.getBool("instantCashAdded");
        print("get notification done  instantCashAdded $instantCashAdded");
        if (instantCashAdded) {
          prefs.setBool("instantCashAdded", false);
          //Utils().showOfferWaleFeedBack(0);
          _userController.showCustomDialogConfettiNew();
        }
      } catch (A) {}
    });*/

    Utils().customPrint(
        "didChangeAppLifecycleState UnityListS ===================================================");
    if (state == AppLifecycleState.resumed) {
      Utils().customPrint(
          "didChangeAppLifecycleState  UnityListS   ===================================================");
      //controller.getESportsEventList();
      _userController.getWalletAmount();
    }
  }

  @override
  Future<void> initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  Widget triviaListother(BuildContext context, int index) {
    return Obx(
      () => controller.unityEventList.value.data[index].lootBoxEvent == true &&
              double.parse(_userController.getTotalBalnace()) < 5
          ? GestureDetector(
              onTap: () async {
                if (AppString.joinContest.value == 'inactive') {
                  Fluttertoast.showToast(msg: 'Join contest disable!');
                  return;
                }

                alertLookBoxGameContest(
                    index, controller.unityEventList.value.data[index].id);
              },
              child: Stack(
                children: [
                  Container(
                      height: 130,
                      margin: EdgeInsets.only(
                          bottom: 5, top: 30, right: 5, left: 5),
                      /*decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().game_list_bg))),*/
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, right: 10, left: 10),
                        child: Wrap(
                          children: [
                            Container(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        //controller.unityEventList.value.data[index].name.toUpperCase(),
                                        "FREE MONEY",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: "Montserrat",
                                            color:
                                                AppColor().pink_game_contest),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (AppString.joinContest.value ==
                                            'inactive') {
                                          Fluttertoast.showToast(
                                              msg: 'Join contest disable!');
                                          return;
                                        }
                                        alertLookBoxGameContest(
                                            index,
                                            controller.unityEventList.value
                                                .data[index].id);
                                      },
                                      child: Container(
                                        width: 120,
                                        margin: EdgeInsets.only(right: 10),
                                        height: 35,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              AppColor().button_bg_light,
                                              AppColor().button_bg_dark,
                                            ],
                                          ),

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

                                          border: Border.all(
                                              color: AppColor().whiteColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          // color: AppColor().whiteColor
                                        ),
                                        /*decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(ImageRes()
                                                    .full_bonus_play_now)),
                                            borderRadius:
                                                BorderRadius.circular(10)),*/
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10, left: 10),
                                                    child: controller
                                                                .unityEventList
                                                                .value
                                                                .data[index]
                                                                .entryFee
                                                                .value >
                                                            0
                                                        ? Text(
                                                            "${AppString().txt_currency_symbole} ${controller.unityEventList.value.data[index].entryFee.value.toString().replaceAll(regex, '')}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: AppColor()
                                                                    .whiteColor),
                                                          )
                                                        : Text(
                                                            "FREE",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                color: AppColor()
                                                                    .whiteColor),
                                                          ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    height: 45,
                                                    width: 45,
                                                    child: Image.asset(
                                                        "assets/images/cross_over_price.png"),
                                                  ),
                                                ]),
                                            Text(
                                              "FREE",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColor().whiteColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 25, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Win",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Montserrat",
                                                    color:
                                                        AppColor().whiteColor),
                                              ),
                                              Container(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Text(
                                              "\u{20B9} ${controller.unityEventList.value.data[index].reward.amount.value.toString().replaceAll(regex, '')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Montserrat",
                                                  color: AppColor().whiteColor),
                                            ),
                                          ),
                                          Container(
                                            height: 45,
                                          ),
                                          Container(
                                            width: 60,
                                          ),
                                          /*))*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(bottom: 8, left: 10, top: 5),
                              height: 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                // color: AppColor().whiteColor,
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showWinningBreakupDialog(
                                          context,
                                          controller.unityEventList.value
                                              .data[index]);
                                    },
                                    child: Container(
                                      child: Image.asset(
                                        ImageRes().iv_info,
                                        width: 15,
                                        height: 15,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Bonus cash Used ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Montserrat",
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Container(
                                          child: CircleAvatar(
                                        radius: 8.0,
                                        child: Image.asset(
                                            "assets/images/bonus_coin.png"),
                                        // child: Image.asset("assets/images/bonuscoin.webp"),
                                        backgroundColor: Colors.transparent,
                                      )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, left: 5),
                                          child: Text(
                                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} 0",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              color: Colors.white70,
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Container(
                      height: 130,
                      margin: EdgeInsets.only(
                          bottom: 5, top: 30, right: 0, left: 0),
                      child: Image(
                          //width: 35,
                          fit: BoxFit.fill,
                          image: AssetImage(ImageRes().game_list_bg)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 165,
                            child: Image(
                                //width: 35,
                                fit: BoxFit.cover,
                                image: AssetImage(ImageRes().list_game_top)),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 165,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 0),
                                  height: 60,
                                  width: 65,
                                  child: Lottie.asset(
                                    'assets/lottie_files/lottie_fire.json',
                                    repeat: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text(
                                  "Match Of The Day",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                ),
                                Text(
                                  "      ",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          : InkWell(
              onTap: () async {
                if (AppString.joinContest.value == 'inactive') {
                  Fluttertoast.showToast(msg: 'Join contest disable!');
                  return;
                }
                if (ApiUrl().isPlayStore == false) {
                  bool stateR = await Utils().checkResLocation(context);
                  if (stateR) {
                    Utils().customPrint("LOCATION 11: ---------FAILED");
                    return;
                  }
                }
                //API CALL
                preJoinAPI(index);
              },
              child: Container(
                  height: 120,
                  margin:
                      EdgeInsets.only(bottom: 5, top: 10, right: 5, left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor().colorPrimary, width: 1.5),
                      // color: AppColor().whiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Wrap(
                    children: [
                      Container(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  controller.unityEventList.value.data[index]
                                      .contestName
                                      .toUpperCase(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Inter",
                                      color: AppColor().whiteColor),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (AppString.joinContest.value ==
                                      'inactive') {
                                    Fluttertoast.showToast(
                                        msg: 'Join contest disable!');
                                    return;
                                  }
                                  if (ApiUrl().isPlayStore == false) {
                                    bool stateR =
                                        await Utils().checkResLocation(context);
                                    if (stateR) {
                                      Utils().customPrint(
                                          "LOCATION 11: ---------FAILED");
                                      return;
                                    }
                                  }

                                  //API CALL
                                  preJoinAPI(index);
                                },
                                child: Container(
                                  width: 120,
                                  margin: EdgeInsets.only(right: 10),
                                  height: 35,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        AppColor().button_bg_light,
                                        AppColor().button_bg_dark,
                                      ],
                                    ),

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

                                    border: Border.all(
                                        color: AppColor().whiteColor, width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                    // color: AppColor().whiteColor
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 10,
                                      ),
                                      Text(
                                        "Play",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: AppColor().whiteColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: controller
                                                    .unityEventList
                                                    .value
                                                    .data[index]
                                                    .entryFee
                                                    .value >
                                                0
                                            ? Text(
                                                "${AppString().txt_currency_symbole} ${controller.unityEventList.value.data[index].entryFee.value.toString().replaceAll(regex, '')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color:
                                                        AppColor().whiteColor),
                                              )
                                            : Text(
                                                "Free",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color:
                                                        AppColor().whiteColor),
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Win",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Inter",
                                              color: AppColor().whiteColor),
                                        ),
                                        Container(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        "\u{20B9} ${controller.unityEventList.value.data[index].reward.amount.value.toString().replaceAll(regex, '')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Inter",
                                            color: AppColor().whiteColor),
                                      ),
                                    ),
                                    Container(
                                      height: 45,
                                    ),
                                    Container(
                                      width: 60,
                                    ),
                                    /*))*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 8, left: 10, top: 5),
                        height: 33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          // color: AppColor().whiteColor,
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showWinningBreakupDialog(
                                    context,
                                    controller.unityEventList.value.data[index]
                                        .reward.amount.value);
                              },
                              child: Container(
                                child: Image.asset(
                                  ImageRes().iv_info,
                                  width: 15,
                                  height: 15,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    child: CircleAvatar(
                                  radius: 8.0,
                                  child: Image.asset(ImageRes().team_group,
                                      color: Colors.white),
                                  // child: Image.asset("assets/images/bonuscoin.webp"),
                                  backgroundColor: Colors.transparent,
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 10),
                                  child: Text(
                                    "${controller.unityEventList.value.data[index].onlinePlayers}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
    );
  }

  void showWinningBreakupDialog(BuildContext context, var amountWIN) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.all(10),
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
                              Navigator.pop(navigatorKey.currentState.context);
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
                    Text(
                      "\u{20B9} ${amountWIN}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        color: AppColor().colorPrimary,
                      ),
                    ),
                    getWeightView(amountWIN)
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget listHistoryUnity(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        print("game  id data comming $gameid");

        /*  Navigator.push(
          navigatorKey.currentState.context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                Tamasha_Game_Over(gameid, "", 5, "Ludo", "", true, 0),
          ),
        );*/
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 5, top: 10, right: 10, left: 10),
        decoration: BoxDecoration(
            border: Border.all(color: AppColor().colorPrimary, width: 1),
            // color: AppColor().whiteColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (controller.unity_history_userRegistrations[index]
                                    .opponents !=
                                null &&
                            controller.unity_history_userRegistrations[index]
                                    .opponents.length >
                                0)
                        ? controller.unity_history_userRegistrations[index]
                                    .opponents[0].housePlayerName !=
                                null
                            ? controller.unity_history_userRegistrations[index]
                                .opponents[0].housePlayerName
                            : controller.unity_history_userRegistrations[index]
                                        .opponents[0].userId !=
                                    null
                                ? controller
                                                .unity_history_userRegistrations[
                                                    index]
                                                .opponents[0]
                                                .userId
                                                .username !=
                                            null &&
                                        controller
                                                .unity_history_userRegistrations[
                                                    index]
                                                .opponents[0]
                                                .userId
                                                .username !=
                                            null
                                    ? controller
                                        .unity_history_userRegistrations[index]
                                        .opponents[0]
                                        .userId
                                        .username
                                    : ""
                                : ""
                        : "",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        color: AppColor().whiteColor),
                  ),
                  Text(
                    "Entry Fee \u{20B9} ${controller.unity_history_userRegistrations[index].eventId != null && controller.unity_history_userRegistrations[index].eventId.entry != null && controller.unity_history_userRegistrations[index].eventId.entry.fee != null && controller.unity_history_userRegistrations[index].eventId.entry.fee.value > 0 ? controller.unity_history_userRegistrations[index].eventId.entry.fee.value ~/ 100 : "Free"}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontSize: 12),
                  )
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 13),
                child: controller.unity_history_userRegistrations[index].rounds
                                .length >
                            0 &&
                        controller.unity_history_userRegistrations[index]
                                .status !=
                            null &&
                        controller.unity_history_userRegistrations[index]
                                .status ==
                            "completed"
                    ? controller.unity_history_userRegistrations[index]
                                    .isWinner !=
                                null &&
                            controller
                                .unity_history_userRegistrations[index].isWinner
                        ? Text(
                            "You Won",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          )
                        : Text(
                            "You Lost",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          )
                    : Text(
                        "Pending",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Inter",
                            color: AppColor().whiteColor),
                      ),
              ),
            ),
            Container(
              height: 12,
            ),

            /* Container(
              height: 12,
            ),*/
            GestureDetector(
              onTap: () async {},
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 12, top: 12),
                alignment: Alignment.center,
                /* decoration: BoxDecoration(
                    color: AppColor().colorPrimary,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),*/
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 0,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            height: 20,
                            width: 20,
                            color: Colors.white,
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/ic_vs.png'),
                          ),
                        ),
                        Container(
                          width: 5,
                        ),
                        gameImageUrl != null && gameImageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                    height: 35,
                                    width: 35,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(gameImageUrl)

                                    // AssetImage('assets/images/images.png'),
                                    ),
                              )
                            : Image(
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                                image:
                                    AssetImage('assets/images/quick_ludo.png'),
                              ),
                        Container(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: (controller.unity_history_userRegistrations !=
                                      null &&
                                  controller.unity_history_userRegistrations
                                          .length >
                                      0 &&
                                  controller
                                          .unity_history_userRegistrations[
                                              index]
                                          .opponents !=
                                      null &&
                                  controller
                                          .unity_history_userRegistrations[
                                              index]
                                          .opponents
                                          .length >
                                      0)
                              ? Text(
                                  controller
                                              .unity_history_userRegistrations[
                                                  index]
                                              .opponents[0]
                                              .housePlayerName !=
                                          null
                                      ? controller
                                          .unity_history_userRegistrations[
                                              index]
                                          .opponents[0]
                                          .housePlayerName
                                      : controller
                                                      .unity_history_userRegistrations[
                                                          index]
                                                      .opponents[0]
                                                      .userId !=
                                                  null &&
                                              controller
                                                      .unity_history_userRegistrations[
                                                          index]
                                                      .opponents[0]
                                                      .userId
                                                      .username !=
                                                  null
                                          ? controller
                                              .unity_history_userRegistrations[
                                                  index]
                                              .opponents[0]
                                              .userId
                                              .username
                                          : ""
                                              "",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(""),
                        ),
                      ],
                    ),
                    Text(
                      controller.unity_history_userRegistrations[index]
                                      .opponents !=
                                  null &&
                              controller.unity_history_userRegistrations[index]
                                      .opponents.length >
                                  0 &&
                              controller.unity_history_userRegistrations[index]
                                      .opponents[0].createdAt !=
                                  null
                          ? getStartTimeHHMMSS(controller
                              .unity_history_userRegistrations[index]
                              .opponents[0]
                              .createdAt)
                          : "",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getStartTimeHHMMSS(String date_c) {
    return DateFormat("yyyy-MM-dd' 'HH:mm:ss").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date_c, true).toLocal());
  }

  Widget getWeightView(var amountWIN) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rank 1",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, fontFamily: "Inter", color: Colors.white),
            ),
            Text(
              "\u{20B9} ${amountWIN}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, fontFamily: "Inter", color: Colors.white),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          height: 1,
          color: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rank 2",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, fontFamily: "Inter", color: Colors.white),
            ),
            Text(
              "\u{20B9} 0",
              //"${list[index].amount.isBonuseType()?list[index].amount.value :"\u{20B9} ${(list[index].amount.value)}"}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, fontFamily: "Inter", color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  //when amt>0 pop-up
  void showPreJoinBox(BuildContext context, int index, var webViewUrl) {
    //var areYouPaying = "${((preJoinResponseModel.deposit.value + preJoinResponseModel.winning.value) / 100) + preJoinResponseModel.bonus.value}";
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Image(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg)),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(ImageRes().new_rectangle_box_blank)),
                  ),
                  height: 400,
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Roboto",
                              color: AppColor().colorPrimary),
                        ),
                        Text(
                          "CHARGES".tr,
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
                                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} "
                                      "${controller.unityEventList.value.data[index].entryFee.value > 0 ? controller.unityEventList.value.data[index].entryFee.value : "Free"}",
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
                                    '\u{20B9} ${controller.unityEventList.value.data[index].entryFee.value}',
                                    style: TextStyle(
                                        color:
                                            AppColor().color_side_menu_header),
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
                                child: Text("From Bonus Cash".tr,
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
                                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} 0",
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
                                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.unityEventList.value.data[index].entryFee.value > 0 ? controller.unityEventList.value.data[index].entryFee.value : "0.0"}",
                                      style: TextStyle(
                                          color: AppColor().whiteColor))
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                              "*Amount will not be refunded if you exit during match making."
                                  .tr,
                              style: TextStyle(
                                  color: AppColor().red,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: "Roboto")),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _Button(context, "CONFIRM_SAVE".tr, index, webViewUrl),
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
          ),
        );
      },
    );
  }

  Widget _Button(
      BuildContext context, String values, int index, var webViewUrl) {
    return GestureDetector(
      onTap: () async {
        Utils().customPrint("LOCATION 10: ---------SUCCESS");

        Map<String, Object> map = new Map<String, Object>();
        map["USER_ID"] = controller.user_id;
        map["Game Name"] =
            controller.unityEventList.value.data[index].contestName;
        map["Buyin Amount"] =
            controller.unityEventList.value.data[index].entryFee.value > 0
                ? controller.unityEventList.value.data[index].entryFee.value
                : "Free";
        //map["Bonus Application"] = "";
        map["Prize Pool"] = "";
        map["Game Category"] =
            controller.unityEventList.value.data[index].contestName;
        map["BONUS_CASH"] = 0;
        map["WINNING_CASH"] = 0;
        map["DEPOSITE_CASH"] =
            controller.unityEventList.value.data[index].entryFee.value > 0
                ? controller.unityEventList.value.data[index].entryFee.value
                : "Free";
        map["Game Id"] = controller.unityEventList.value.data[index].contestId;
        map["is_championship"] = "No";

        /* map["is_Affilate"] = _contestModel.affiliate != null ? "yes" : "No";
        map["is_championship"] =
            _contestModel.type.compareTo("championship") == 0 ? "yes" : "No";*/

        //calling CT
        cleverTapController.logEventCT(
            EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
        cleverTapController.logEventCT(EventConstant.EVENT_Joined_Contest, map);

        FirebaseEvent().firebaseEvent(
            EventConstant.EVENT_CLEAVERTAB_Joined_Contest_F, map);

        FirebaseEvent()
            .firebaseEvent(EventConstant.EVENT_Joined_Contest_F, map);

        map["Game_id"] = gameid;
        appsflyerController.logEventAf(
            EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);

        appsflyerController.logEventAf(
            EventConstant.EVENT_Joined_Contest, map); //for appsflyer only
        FaceBookEventController().logEventFacebook(
            EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
        //FIREBASE EVENT

        Navigator.pop(context);
        //webView Launching
        Utils().customPrint(
            'CODE IS RUNNING...1 ${controller.unityEventList.value.data[index].contestId}');
        Utils().customPrint('CODE IS RUNNING...2 ${AppString.helperContestId}');
        if (AppString.helperTimer == 0 ||
            controller.unityEventList.value.data[index].contestId ==
                AppString.helperContestId) {
          //_start = 60;
          _timer = Timer.periodic(Duration(seconds: 1), (timer) {
            //code to run on every 5 seconds
            if (AppString.helperTimer == 0) {
              if (_timer != null) _timer.cancel();
            } else {
              Utils()
                  .customPrint('CODE IS RUNNING...3 ${AppString.helperTimer}');
              AppString.helperTimer--;
              /* setState(() {

        });*/
            }
          });
          AppString.helperContestName.value =
              controller.unityEventList.value.data[index].contestName;
          AppString.helperContestId =
              controller.unityEventList.value.data[index].contestId;

          //API Call
          //controller.getCallGameUrlTamasha(controller.unityEventList.value.data[index].contestId);
          if (webViewUrl != null && webViewUrl != '') {
            Navigator.push(
              navigatorKey.currentState.context,
              MaterialPageRoute(
                builder: (BuildContext context) => TamashaWebview(
                    webViewUrl,
                    gameid,
                    controller.unityEventList.value.data[index].contestId,
                    controller.unityEventList.value.data[index].entryFee.value >
                            0
                        ? controller
                            .unityEventList.value.data[index].entryFee.value
                        : "Free",
                    gameImageUrl,
                    gameName),
              ),
            );
          }
        } else {
          showAlertDialogOneMint(navigatorKey.currentState.context,
              AppString.helperContestName.value);
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 34),
          height: 50,
          width: 180,
          /*  decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(ImageRes().submit_bg)),
            // color: AppColor().colorPrimary,
          ),*/
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColor().button_bg_light,
                AppColor().button_bg_dark,
              ],
            ),

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

            border: Border.all(color: AppColor().whiteColor, width: 2),
            borderRadius: BorderRadius.circular(30),
            // color: AppColor().whiteColor
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

  //when amt == 0 pop-up
  void showPreJoinBoxFree(
      String gameZopWebViewUrl,
      String gameid,
      String gameImageUrl,
      String gameName,
      String freeVa,
      int index,
      webViewUrl) {
    var areYouPaying =
        controller.unityEventList.value.data[index].entryFee.value;
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
                                  child: Text("ENTRY FEE",
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
                                      '\u{20B9} ${areYouPaying.toString()}',
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
                                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} 0",
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
                                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(controller.unityEventList.value.data[index].entryFee.value)}",
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
                                  map["USER_ID"] = controller.user_id;
                                  map["Game Name"] = controller.unityEventList
                                      .value.data[index].contestName;
                                  map["Buyin Amount"] = controller
                                              .unityEventList
                                              .value
                                              .data[index]
                                              .entryFee
                                              .value >
                                          0
                                      ? controller.unityEventList.value
                                          .data[index].entryFee.value
                                      : "Free";
                                  //map["Bonus Application"] = "";
                                  map["Prize Pool"] = "";
                                  map["Game Category"] = controller
                                      .unityEventList
                                      .value
                                      .data[index]
                                      .contestName;
                                  map["BONUS_CASH"] = 0;
                                  map["WINNING_CASH"] = 0;
                                  map["DEPOSITE_CASH"] = controller
                                              .unityEventList
                                              .value
                                              .data[index]
                                              .entryFee
                                              .value >
                                          0
                                      ? controller.unityEventList.value
                                          .data[index].entryFee.value
                                      : "Free";
                                  map["Game Id"] = controller.unityEventList
                                      .value.data[index].contestId;
                                  map["is_championship"] = "No";

                                  /* map["is_Affilate"] = _contestModel.affiliate != null ? "yes" : "No";
        map["is_championship"] =
            _contestModel.type.compareTo("championship") == 0 ? "yes" : "No";*/

                                  //calling CT
                                  cleverTapController.logEventCT(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Joined_Contest,
                                      map);
                                  cleverTapController.logEventCT(
                                      EventConstant.EVENT_Joined_Contest, map);

                                  FirebaseEvent().firebaseEvent(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Joined_Contest_F,
                                      map);
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

                                  Navigator.pop(context);
                                  //webView Launching
                                  Utils().customPrint(
                                      'CODE IS RUNNING...1 ${controller.unityEventList.value.data[index].contestId}');
                                  Utils().customPrint(
                                      'CODE IS RUNNING...2 ${AppString.helperContestId}');

                                  if (AppString.helperTimer == 0 ||
                                      controller.unityEventList.value
                                              .data[index].contestId ==
                                          AppString.helperContestId) {
                                    //_start = 60;
                                    _timer = Timer.periodic(
                                        Duration(seconds: 1), (timer) {
                                      //code to run on every 5 seconds
                                      if (AppString.helperTimer == 0) {
                                        if (_timer != null) _timer.cancel();
                                      } else {
                                        Utils().customPrint(
                                            'CODE IS RUNNING...3 ${AppString.helperTimer}');
                                        AppString.helperTimer--;
                                        /* setState(() {

        });*/
                                      }
                                    });
                                    AppString.helperContestName.value =
                                        controller.unityEventList.value
                                            .data[index].contestName;
                                    AppString.helperContestId = controller
                                        .unityEventList
                                        .value
                                        .data[index]
                                        .contestId;

                                    //API Call
                                    //controller.getCallGameUrlTamasha(controller.unityEventList.value.data[index].contestId);
                                    if (webViewUrl != null &&
                                        webViewUrl != '') {
                                      Navigator.push(
                                        navigatorKey.currentState.context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              TamashaWebview(
                                                  webViewUrl,
                                                  gameid,
                                                  controller
                                                      .unityEventList
                                                      .value
                                                      .data[index]
                                                      .contestId,
                                                  controller
                                                              .unityEventList
                                                              .value
                                                              .data[index]
                                                              .entryFee
                                                              .value >
                                                          0
                                                      ? controller
                                                          .unityEventList
                                                          .value
                                                          .data[index]
                                                          .entryFee
                                                          .value
                                                      : 0,
                                                  gameImageUrl,
                                                  gameName),
                                        ),
                                      );
                                    }
                                  } else {
                                    showAlertDialogOneMint(
                                        navigatorKey.currentState.context,
                                        AppString.helperContestName.value);
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
                    map["USER_ID"] = controller.user_id;
                    map["Game Name"] =
                        controller.unityEventList.value.data[index].contestName;
                    map["Buyin Amount"] = controller.unityEventList.value
                                .data[index].entryFee.value >
                            0
                        ? controller
                            .unityEventList.value.data[index].entryFee.value
                        : "Free";
                    //map["Bonus Application"] = "";
                    map["Prize Pool"] = "";
                    map["Game Category"] =
                        controller.unityEventList.value.data[index].contestName;
                    map["BONUS_CASH"] = 0;
                    map["WINNING_CASH"] = 0;
                    map["DEPOSITE_CASH"] = controller.unityEventList.value
                                .data[index].entryFee.value >
                            0
                        ? controller
                            .unityEventList.value.data[index].entryFee.value
                        : "Free";
                    map["Game Id"] =
                        controller.unityEventList.value.data[index].contestId;
                    map["is_championship"] = "No";

                    /* map["is_Affilate"] = _contestModel.affiliate != null ? "yes" : "No";
        map["is_championship"] =
            _contestModel.type.compareTo("championship") == 0 ? "yes" : "No";*/

                    //calling CT
                    cleverTapController.logEventCT(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
                    cleverTapController.logEventCT(
                        EventConstant.EVENT_Joined_Contest, map);
                    FirebaseEvent().firebaseEvent(
                        EventConstant.EVENT_Joined_Contest_F, map);
                    FirebaseEvent().firebaseEvent(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest_F, map);

                    map["Game_id"] = gameid;
                    appsflyerController.logEventAf(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);

                    appsflyerController.logEventAf(
                        EventConstant.EVENT_Joined_Contest,
                        map); //for appsflyer only
                    FaceBookEventController().logEventFacebook(
                        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
                    //FIREBASE EVENT

                    Navigator.pop(context);
                    //webView Launching
                    Utils().customPrint(
                        'CODE IS RUNNING...1 ${controller.unityEventList.value.data[index].contestId}');
                    Utils().customPrint(
                        'CODE IS RUNNING...2 ${AppString.helperContestId}');

                    if (AppString.helperTimer == 0 ||
                        controller.unityEventList.value.data[index].contestId ==
                            AppString.helperContestId) {
                      //_start = 60;
                      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                        //code to run on every 5 seconds
                        if (AppString.helperTimer == 0) {
                          if (_timer != null) _timer.cancel();
                        } else {
                          Utils().customPrint(
                              'CODE IS RUNNING...3 ${AppString.helperTimer}');
                          AppString.helperTimer--;
                          /* setState(() {

        });*/
                        }
                      });
                      AppString.helperContestName.value = controller
                          .unityEventList.value.data[index].contestName;
                      AppString.helperContestId =
                          controller.unityEventList.value.data[index].contestId;

                      //API Call
                      //controller.getCallGameUrlTamasha(controller.unityEventList.value.data[index].contestId);
                      if (webViewUrl != null && webViewUrl != '') {
                        Navigator.push(
                          navigatorKey.currentState.context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => TamashaWebview(
                                webViewUrl,
                                gameid,
                                controller
                                    .unityEventList.value.data[index].contestId,
                                controller.unityEventList.value.data[index]
                                            .entryFee.value >
                                        0
                                    ? controller.unityEventList.value
                                        .data[index].entryFee.value
                                    : 0,
                                gameImageUrl,
                                gameName),
                          ),
                        );
                      }
                    } else {
                      showAlertDialogOneMint(navigatorKey.currentState.context,
                          AppString.helperContestName.value);
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

  //pop-up for 1mint when user already clicks other events
  void showAlertDialogOneMint(BuildContext context, var contestName) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Stack(
            children: [
              Image(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().hole_popup_bg)),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(ImageRes().hole_popup_bg))),
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 250,
                child: Card(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 0, right: 0),
                  elevation: 0,
                  //color: AppColor().wallet_dark_grey,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "         ",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: 60,
                            child: Lottie.asset(
                              'assets/lottie_files/waiting.json',
                              repeat: false,
                              height: 100,
                              width: 100,
                            ),
                            /*Image.asset("assets/images/rupee_gmng.png"),*/
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 18,
                              width: 18,
                              child: Image.asset(ImageRes().close_icon),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 5, bottom: 10, right: 20),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "You are still in matchmaking in the event :".tr +
                                  " \"${contestName}\" , " +
                                  "please wait for that to end.".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColor().whiteColor,
                                fontFamily: "Montserrat",
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                            "*Any Amount deducted will not be refunded.",
                            style: TextStyle(
                                color: AppColor().red,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: "Roboto")),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: false,
                            child: GestureDetector(
                              onTap: () {
                                //Navigator.pop(context);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 43,
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width - 300,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      AppColor().green_color_light,
                                      AppColor().green_color,
                                    ],
                                  ),

                                  boxShadow: const [
                                    BoxShadow(
                                      offset: const Offset(
                                        0.0,
                                        5.0,
                                      ),
                                      blurRadius: 1.0,
                                      spreadRadius: .3,
                                      color: Color(0xFF02310A),
                                      inset: true,
                                    ),
                                  ],

                                  border: Border.all(
                                      color: AppColor().whiteColor, width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                  // color: AppColor().whiteColor
                                ),
                                child: Text(
                                  "Confirm",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //Navigator.pop(context);
                              Navigator.pop(navigatorKey.currentState.context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 43,
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 10, bottom: 10),
                              width: 150,
                              //MediaQuery.of(context).size.width - 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().button_bg_light,
                                    AppColor().button_bg_dark,
                                  ],
                                ),

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

                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Text(
                                "Go to lobby",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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

  Future<void> preJoinAPI(int index) async {
    //API Call
    await controller.getCallGameUrlTamasha(
        controller.unityEventList.value.data[index].contestId);
    Utils().customPrint(
        '["webViewUrl"]: ${controller.webViewData.value.webViewUrl}');
    if (controller.webViewData.value != null) {
      if (controller.webViewData.value.deficitAmount.value > 0) {
        Utils().customPrint(
            '["webViewUrl"]: ${controller.unityEventList.value.data[index].entryFee.value.toString().replaceAll(regex, '')}');
        AppString.contestAmount = int.parse(controller
            .unityEventList.value.data[index].entryFee.value
            .toString()
            .replaceAll(regex, ''));
        Utils().customPrint(
            'contestAmount Tamasha ludo ${AppString.contestAmount}');
        Utils().alertInsufficientBalance(context);
      } else {
        if (controller.unityEventList.value.data[index].entryFee.value <= 0) {
          showPreJoinBoxFree(
              controller.webViewData.value.webViewUrl,
              gameid,
              gameImageUrl,
              gameName,
              "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} "
              "${controller.unityEventList.value.data[index].entryFee.value > 0 ? controller.unityEventList.value.data[index].entryFee.value : "Free"}",
              index,
              controller.webViewData.value.webViewUrl);
        } else {
          showPreJoinBox(navigatorKey.currentState.context, index,
              controller.webViewData.value.webViewUrl);
        }
      }
    }
  }

  Future<bool> _onWillPop() async {
    Get.offAll(() => DashBord(2, ""));
    // SystemNavigator.pop();
    return false;
  }

  //game contest work
  void alertLookBoxGameContest(int index, String eventID) {
    // Utils().customPrint('eventID eventID ${eventID}');
    WalletPageController walletPageController = Get.put(WalletPageController());
    walletPageController.isclickpopup = false.obs;
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Stack(
            children: [
              Image(
                  height: 600,
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().hole_popup_bg)),
              Container(
                width:
                    MediaQuery.of(navigatorKey.currentState.context).size.width,
                decoration: BoxDecoration(
                    color: AppColor().button_bg_grey,
                    border: Border.all(
                      width: 4,
                      color: AppColor().border_outside,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(
                          0.0,
                          5.0,
                        ),
                        blurRadius: 1.0,
                        spreadRadius: .3,
                        color: AppColor().border_outside_Dark,
                        //inset: true,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: 610,
                child: Card(
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  elevation: 0,
                  //  color: AppColor().wallet_dark_grey,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'INSTALL AND JOIN FREE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2, right: 2, bottom: 7, top: 10),
                            child: Obx(() => walletPageController
                                            .offerWallList.value.data !=
                                        null &&
                                    walletPageController
                                            .offerWallList.value.data.length >
                                        0
                                ? Container(
                                    height: 450,
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(top: 0),
                                        itemCount: walletPageController
                                            .offerWallList.value.data.length,
                                        shrinkWrap: true,
                                        //physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, int index) {
                                          return walletPageController
                                              .normalListView(index, eventID);
                                        }),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      height: 250,
                                      width: 350,
                                      child: Image.asset(
                                          'assets/images/empty_lootbox.png'),
                                      //fit: BoxFit.cover,
                                    ),
                                  )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Obx(
                            () => Visibility(
                              visible: walletPageController.isclickpopup.value,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  '*Your offer is still awaiting confirmation. Please wait!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Obx(() => GestureDetector(
                                onTap: () {
                                  if (walletPageController
                                          .totalAmountD_W.value <
                                      5) {
                                    walletPageController.isclickpopup.value =
                                        true;
                                    walletPageController
                                        .getAdvertisersDealsPopUp(
                                            navigatorKey.currentState.context);
                                    walletPageController.getWalletAmount();
                                  } else {
                                    //game open
                                    walletPageController.isclickpopup.value =
                                        false;

                                    //API CALL
                                    preJoinAPI(index);
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  height: 42,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: const Offset(
                                          0.0,
                                          5.0,
                                        ),
                                        blurRadius: 3.2,
                                        spreadRadius: 0.3,
                                        //color: Color(0xFF02310A),
                                        color: Color(0xFF333232),
                                        //inset: true,
                                      ),
                                    ],
                                    gradient: walletPageController
                                                .totalAmountD_W.value <
                                            5
                                        ? LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColor().vip_button,
                                              AppColor().vip_button_light,
                                            ],
                                          )
                                        : LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColor().banner_cash_g,
                                              AppColor().vip_green,
                                            ],
                                          ),
                                    border: Border.all(
                                        color: AppColor().whiteColor, width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                    // color: AppColor().whiteColor
                                  ),
                                  child: Text(
                                    "START GAME",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      //viewMore.value = false;
                      Navigator.pop(navigatorKey.currentState.context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20, right: 30),
                      height: 18,
                      width: 18,
                      child: Image.asset(ImageRes().close_icon),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
