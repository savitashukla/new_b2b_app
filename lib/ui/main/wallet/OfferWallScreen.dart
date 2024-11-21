import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_apps/device_apps.dart';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/ui/main/wallet/offerwall_details_screen.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../res/AppColor.dart';
import '../../controller/WalletPageController.dart';

class OfferWallScreen extends StatefulWidget {
  const OfferWallScreen({Key key}) : super(key: key);

  @override
  State<OfferWallScreen> createState() => _OfferWallScreenState();
}

class _OfferWallScreenState extends State<OfferWallScreen> {
  WalletPageController walletPageController = Get.put(WalletPageController());
  UserController _userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();

    ApiCall();
  }

  Future<void> ApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //isPopUp banner
    Utils().getBannerAsPerPageType(
        prefs.getString("token"), AppString().appTypes, 'offerWall');

    if (AppString.offerWallLoot == "inactive") {
      Utils().showLootBoxDown(context);
    }
  }

  //back press again to exit added!
  DateTime currentBackPressTime;
  Future<bool> onWillPop() async {
    //return true;
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit!".tr);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    _userController.getProfileData();
    _userController.getWalletAmount();
    return WillPopScope(
      onWillPop: onWillPop,
      child: RefreshIndicator(
        onRefresh: () async {
          await walletPageController.getAdvertisersDeals();
          await walletPageController.getUserDeals();
        },
        child: AppString.isClickFromHome
            ? Scaffold(
                backgroundColor: Colors.transparent,

                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),

                            Obx(() => walletPageController
                                            .bannerModelOfferWallRV.value !=
                                        null &&
                                    walletPageController
                                            .bannerModelOfferWallRV
                                            .value
                                            .data !=
                                        null
                                ? walletPageController.bannerModelOfferWallRV
                                            .value.data.length >
                                        0
                                    ? walletPageController
                                                .bannerModelOfferWallRV
                                                .value
                                                .data
                                                .length >
                                            1
                                        ? CarouselSlider(
                                            items: walletPageController
                                                .bannerModelOfferWallRV
                                                .value
                                                .data
                                                .map(
                                                  (item) => GestureDetector(
                                                    onTap: () {
                                                      //launchURLApp(item.externalUrl);
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 6),
                                                      child: Center(
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                CachedNetworkImage(
                                                              height: 120,
                                                              width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                              fit: BoxFit
                                                                  .cover,
                                                              imageUrl: (item
                                                                  .image.url),
                                                            )),
                                                      ),
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
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enableInfiniteScroll: true,
                                              autoPlayAnimationDuration:
                                                  Duration(
                                                      milliseconds: 1000),
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
                                                    BorderRadius.circular(
                                                        8.0),
                                                child: Obx(
                                                  () => Image(
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                    image: walletPageController.bannerModelOfferWallRV.value.data != null &&
                                                            walletPageController
                                                                    .bannerModelOfferWallRV
                                                                    .value
                                                                    .data !=
                                                                null &&
                                                            walletPageController
                                                                    .bannerModelOfferWallRV
                                                                    .value
                                                                    .data
                                                                    .length >=
                                                                1
                                                        ? NetworkImage(
                                                            walletPageController
                                                                .bannerModelOfferWallRV
                                                                .value
                                                                .data[0]
                                                                .image
                                                                .url)
                                                        : AssetImage(
                                                            "assets/images/offer_wall_banner.png"),
                                                  ),
                                                )

                                                /*Image(
                            height: 130,
                            fit: BoxFit.fitWidth,
                            image:


                            AssetImage('assets/images/spin_win_banner.webp'),
                          )*/
                                                ),
                                          )
                                    : Container(
                                        height: 0,
                                      )
                                : Shimmer.fromColors(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      width:
                                          MediaQuery.of(context).size.width,
                                    ),
                                    baseColor: Colors.grey.withOpacity(0.2),
                                    highlightColor:
                                        Colors.grey.withOpacity(0.4),
                                    enabled: true,
                                  )),

                            /* GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(msg: 'Banner clicked!');
                        },
                        child: Container(
                          height: 130,
                          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image(
                              height: 120,
                              fit: BoxFit.cover,
                              image: */ /* NetworkImage("url"):*/ /*
                                  AssetImage(
                                      "assets/images/offer_wall_banner.png" */ /*ImageRes().store_banner_wallet*/ /*),
                            ),
                          ),
                        ),
                      ),*/
                            Container(
                              //color: AppColor().clan_header_dark,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Utils().getWhatIsLootBox();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 38,
                                          margin: EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 10,
                                              bottom: 10),
                                          width: 150,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                AppColor().button_bg_grey,
                                                AppColor().button_bg_grey,
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
                                                color: Color(0xff505050),
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
                                          child: Text(
                                            "Learn More ?".tr,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat",
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            walletPageController
                                                .checkTrOfferWall
                                                .value = true;
                                            walletPageController
                                                .colorPrimaryOfferWall
                                                .value = Color(0xFFe55f19);
                                            walletPageController
                                                .colorwhiteOfferWall
                                                .value = Color(0xFFffffff);
                                            walletPageController
                                                .getAdvertisersDeals();
                                            walletPageController
                                                .getUserDeals();
                                            _userController.getWalletAmount();
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                "Offers".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              ),
                                              Obx(
                                                () => Container(
                                                  margin:
                                                      EdgeInsets.only(top: 5),
                                                  color: walletPageController
                                                      .colorPrimaryOfferWall
                                                      .value,
                                                  height: 3,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                        Expanded(
                                            child: InkWell(
                                          onTap: () async {
                                            walletPageController
                                                .checkTrOfferWall
                                                .value = false;
                                            walletPageController
                                                .colorPrimaryOfferWall
                                                .value = Color(0xFFffffff);
                                            walletPageController
                                                .colorwhiteOfferWall
                                                .value = Color(0xFFe55f19);
                                            walletPageController
                                                .getAdvertisersDeals();
                                            walletPageController
                                                .getUserDeals();
                                            _userController.getWalletAmount();
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                "History".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              ),
                                              Obx(
                                                () => Container(
                                                  margin:
                                                      EdgeInsets.only(top: 5),
                                                  color: walletPageController
                                                      .colorwhiteOfferWall
                                                      .value,
                                                  height: 3,
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() => Visibility(
                                  visible: walletPageController
                                      .checkTrOfferWall.value,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0.0, top: 10),
                                        child: Obx(() => walletPageController
                                                        .offerWallList
                                                        .value
                                                        .data !=
                                                    null &&
                                                walletPageController
                                                        .offerWallList
                                                        .value
                                                        .data
                                                        .length >
                                                    0
                                            ? ListView.builder(
                                                itemCount:
                                                    walletPageController
                                                                .offerWallList
                                                                .value
                                                                .data !=
                                                            null
                                                        ? walletPageController
                                                            .offerWallList
                                                            .value
                                                            .data
                                                            .length
                                                        : 0,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                scrollDirection:
                                                    Axis.vertical,
                                                itemBuilder:
                                                    (context, int index) {
                                                  return normalListView(
                                                      index);
                                                })
                                            : walletPageController
                                                        .isLoadingAdvertisersDeals
                                                        .value ==
                                                    false
                                                ? Shimmer.fromColors(
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      //height: MediaQuery.of(context).size.width * 0.3,
                                                      height: 450,
                                                      width: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width,
                                                    ),
                                                    baseColor: Colors.grey
                                                        .withOpacity(0.2),
                                                    highlightColor: Colors
                                                        .grey
                                                        .withOpacity(0.4),
                                                    enabled: true,
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Image(
                                                      height: 250,
                                                      width: 350,
                                                      image: AssetImage(
                                                          'assets/images/empty_lootbox.png'),
                                                      //fit: BoxFit.cover,
                                                    ),
                                                  )),
                                      ),
                                    ],
                                  ),
                                )),
                            Obx(() => Visibility(
                                  visible: !walletPageController
                                      .checkTrOfferWall.value,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0.0, top: 10),
                                        child: ListView.builder(
                                            itemCount: walletPageController
                                                        .offerWallHistoryList
                                                        .value
                                                        .data !=
                                                    null
                                                ? walletPageController
                                                    .offerWallHistoryList
                                                    .value
                                                    .data
                                                    .length
                                                : 0,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemBuilder:
                                                (context, int index) {
                                              return normalListViewHistory(
                                                  index);
                                            }),
                                      ),
                                    ],
                                  ),
                                )),
                            //just for testing
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 65,
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  flexibleSpace: Image(
                    image: AssetImage('assets/images/offerwall_header.png'),
                    fit: BoxFit.cover,
                  ),
                  backgroundColor: Colors.transparent,
                  title: /*Center(
                child: Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Text(
                "Loot Wall",
                style: TextStyle(
                  fontFamily: "Montserrat",
                ),
              ), //and Promotions
            )), */
                      Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Loot Box",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                            ),
                          ),
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
                              Get.to(() => DashBord(4, ""));
                              //Wallet().showBottomSheetAddAmount(context);
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                                fontFamily: "Montserrat",
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
                                                fontFamily: "Montserrat",
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5),
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
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(() => walletPageController
                                      .bannerModelOfferWallRV.value !=
                                  null &&
                              walletPageController
                                      .bannerModelOfferWallRV.value.data !=
                                  null
                          ? walletPageController.bannerModelOfferWallRV.value
                                      .data.length >
                                  0
                              ? walletPageController.bannerModelOfferWallRV
                                          .value.data.length >
                                      1
                                  ? CarouselSlider(
                                      items: walletPageController
                                          .bannerModelOfferWallRV.value.data
                                          .map(
                                            (item) => GestureDetector(
                                              onTap: () {
                                                //launchURLApp(item.externalUrl);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets
                                                    .symmetric(horizontal: 6),
                                                child: Center(
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(8.0),
                                                      child:
                                                          CachedNetworkImage(
                                                        height: 120,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            (item.image.url),
                                                      )),
                                                ),
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
                                              image: walletPageController
                                                              .bannerModelOfferWallRV
                                                              .value
                                                              .data !=
                                                          null &&
                                                      walletPageController
                                                              .bannerModelOfferWallRV
                                                              .value
                                                              .data !=
                                                          null &&
                                                      walletPageController
                                                              .bannerModelOfferWallRV
                                                              .value
                                                              .data
                                                              .length >=
                                                          1
                                                  ? NetworkImage(
                                                      walletPageController
                                                          .bannerModelOfferWallRV
                                                          .value
                                                          .data[0]
                                                          .image
                                                          .url)
                                                  : AssetImage(
                                                      "assets/images/offer_wall_banner.png"),
                                            ),
                                          )

                                          /*Image(
                      height: 130,
                      fit: BoxFit.fitWidth,
                      image:


                      AssetImage('assets/images/spin_win_banner.webp'),
                    )*/
                                          ),
                                    )
                              : Container(
                                  height: 0,
                                )
                          : Shimmer.fromColors(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                height:
                                    MediaQuery.of(context).size.width * 0.3,
                                width: MediaQuery.of(context).size.width,
                              ),
                              baseColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.grey.withOpacity(0.4),
                              enabled: true,
                            )),
                      /* GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: 'Banner clicked!');
                  },
                  child: Container(
                    height: 130,
                    margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(
                        height: 120,
                        fit: BoxFit.cover,
                        image: */ /* NetworkImage("url"):*/ /*
                            AssetImage(
                                "assets/images/offer_wall_banner.png" */ /*ImageRes().store_banner_wallet*/ /*),
                      ),
                    ),
                  ),
                ),*/
                      Container(
                        //color: AppColor().clan_header_dark,
                        padding: EdgeInsets.symmetric(
                            vertical: 25, horizontal: 40),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 0, bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      walletPageController
                                          .checkTrOfferWall.value = true;
                                      walletPageController
                                          .colorPrimaryOfferWall
                                          .value = Color(0xFFe55f19);
                                      walletPageController.colorwhiteOfferWall
                                          .value = Color(0xFFffffff);
                                      walletPageController
                                          .getAdvertisersDeals();
                                      walletPageController.getUserDeals();
                                      _userController.getWalletAmount();
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "Offers".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              color: Colors.white),
                                        ),
                                        Obx(
                                          () => Container(
                                            margin: EdgeInsets.only(top: 5),
                                            color: walletPageController
                                                .colorPrimaryOfferWall.value,
                                            height: 3,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () async {
                                      walletPageController
                                          .checkTrOfferWall.value = false;
                                      walletPageController
                                          .colorPrimaryOfferWall
                                          .value = Color(0xFFffffff);
                                      walletPageController.colorwhiteOfferWall
                                          .value = Color(0xFFe55f19);
                                      walletPageController
                                          .getAdvertisersDeals();
                                      walletPageController.getUserDeals();
                                      _userController.getWalletAmount();
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "History",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              color: Colors.white),
                                        ),
                                        Obx(
                                          () => Container(
                                            margin: EdgeInsets.only(top: 5),
                                            color: walletPageController
                                                .colorwhiteOfferWall.value,
                                            height: 3,
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Visibility(
                            visible:
                                walletPageController.checkTrOfferWall.value,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, top: 10),
                                  child: Obx(() => walletPageController
                                                  .offerWallList.value.data !=
                                              null &&
                                          walletPageController.offerWallList
                                                  .value.data.length >
                                              0
                                      ? ListView.builder(
                                          itemCount: walletPageController
                                                      .offerWallList
                                                      .value
                                                      .data !=
                                                  null
                                              ? walletPageController
                                                  .offerWallList
                                                  .value
                                                  .data
                                                  .length
                                              : 0,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, int index) {
                                            return normalListView(index);
                                          })
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Image(
                                            height: 250,
                                            width: 350,
                                            image: AssetImage(
                                                'assets/images/empty_lootbox.png'),
                                            //fit: BoxFit.cover,
                                          ),
                                        )),
                                ),
                              ],
                            ),
                          )),
                      Obx(() => Visibility(
                            visible:
                                !walletPageController.checkTrOfferWall.value,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, top: 10),
                                  child: ListView.builder(
                                      itemCount: walletPageController
                                                  .offerWallHistoryList
                                                  .value
                                                  .data !=
                                              null
                                          ? walletPageController
                                              .offerWallHistoryList
                                              .value
                                              .data
                                              .length
                                          : 0,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, int index) {
                                        return normalListViewHistory(index);
                                      }),
                                ),
                              ],
                            ),
                          )),
                      //just for testing
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  //offer
  Widget normalListView(int index) {
    return Container(
      height:
          walletPageController.offerWallList.value.data[index].banner != null
              ? 270
              : 75,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColor().button_bg_grey,
          // image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/images/gradient_rectangular.png")),
          /* color: Colors.transparent,*/
          borderRadius: BorderRadius.circular(10)),
      child: walletPageController.offerWallList.value.data[index].banner != null
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: walletPageController.offerWallList.value
                                        .data[index].logoUrl !=
                                    null &&
                                walletPageController.offerWallList.value
                                        .data[index].logoUrl !=
                                    ''
                            ? Image(
                                //color: AppColor().whiteColor,
                                width: 50,
                                height: 50,
                                //fit: BoxFit.cover,
                                image: NetworkImage(walletPageController
                                    .offerWallList.value.data[index].logoUrl))
                            : Image(
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/hotstar.png'),
                              ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showBottomSheetInfo(
                                context,
                                walletPageController
                                    .offerWallList.value.data[index].terms);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0, top: 0),
                                child: Text(
                                  "${walletPageController.offerWallList.value.data[index].name}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: AppColor().colorPrimary),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10, left: 5),
                                child: Image.asset(
                                  "assets/images/info.webp",
                                  color: Colors.blue,
                                  width: 13,
                                  height: 13,
                                  //color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, top: 5),
                          child: Text(
                            '${walletPageController.offerWallList.value.data[index].description}',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                walletPageController.offerWallList.value.data[index].banner !=
                            null &&
                        walletPageController
                                .offerWallList.value.data[index].banner.url !=
                            null
                    ? Image(
                        //color: AppColor().whiteColor,
                        //width: 50,
                        height: 140,
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(walletPageController
                            .offerWallList.value.data[index].banner.url))
                    : Image(
                        //height: 120,
                        fit: BoxFit.fitWidth,
                        image: /* NetworkImage("url"):*/
                            AssetImage(
                                'assets/images/offer_wall_middle_banner.png'),
                      ),

                Padding(
                    padding: EdgeInsets.only(left: 5, right: 5.0),
                    child: walletPageController
                                    .offerWallList.value.data[index].userDeal !=
                                null &&
                            walletPageController.subtractDate((DateTime.parse(
                                    "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) >
                                0
                        ? GestureDetector(
                            onTap: () async {
                              if (walletPageController.offerWallList.value
                                          .data[index].userDeal !=
                                      null &&
                                  walletPageController.subtractDate((DateTime.parse(
                                          "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) >
                                      0) {
                                isPopupPending(index);
                              }

                              //Event Calling
                              /* Map<String, Object> map =
                    new Map<String, Object>();
                    map["offer_name"] = walletPageController
                        .offerWallList.value.data[index].name;
                    map["offer_clicked"] = "Yes";
                    map["USER_ID"] = walletPageController.user_id;
                    map["deviceId"] =
                    await Utils().getUniqueDeviceId();
                    try {
                      if (walletPageController.offerWallList.value
                          .data[index].gmngEarning !=
                          null &&
                          walletPageController.offerWallList.value
                              .data[index].gmngEarning.value !=
                              null &&
                          walletPageController.offerWallList.value
                              .data[index].gmngEarning.value !=
                              '') {
                        int amt = walletPageController.offerWallList
                            .value.data[index].gmngEarning.value;
                        map["offer_gmngEarning"] = amt / 100;
                      }
                      if (walletPageController.offerWallList.value
                          .data[index].userEarning !=
                          null &&
                          walletPageController.offerWallList.value
                              .data[index].userEarning.value !=
                              null &&
                          walletPageController.offerWallList.value
                              .data[index].userEarning.value !=
                              '') {
                        int amt = walletPageController.offerWallList
                            .value.data[index].userEarning.value;
                        map["offer_userEarning"] = amt / 100;
                      }
                    } catch (e) {}
                    //appsflyer
                    AppsflyerController c =
                    Get.put(AppsflyerController());
                    c.logEventAf(
                        EventConstant.EVENT_Offerwall, map);
                    //clevertap
                    CleverTapController cleverTapController =
                    Get.put(CleverTapController());
                    cleverTapController.logEventCT(
                        EventConstant.EVENT_Offerwall, map);
                    //end

                    //app checking insalled or not
                    String appInstalled = "false";
                    if (walletPageController.offerWallList.value
                        .data[index].appPackage !=
                        null &&
                        walletPageController.offerWallList.value
                            .data[index].appPackage.android !=
                            null) {
                      Utils().customPrint(
                          "open App: ${await findAppByPkgName(
                              "${walletPageController.offerWallList.value
                                  .data[index].appPackage.android}")}");
                      appInstalled = await findAppByPkgName(
                          "${walletPageController.offerWallList.value
                              .data[index].appPackage.android}");
                    }

                    final param = {
                      "advertiserDealId":
                      "${walletPageController.offerWallList.value.data[index]
                          .id}",
                      "appInstalled": appInstalled,
                      "deviceId": await Utils().getUniqueDeviceId()
                    };
                    //return;

                    await walletPageController.createUserDeal(
                        context, param);
                    await _userController.getWalletAmount();*/
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 12),
                                Container(
                                    height: 35,
                                    // width: 64,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        // Where the linear gradient begins and ends
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,

                                        colors: [
                                          AppColor().button_bg_light,
                                          AppColor().special_bg_c,
                                        ],
                                      ),
                                      border: Border.all(
                                          color: AppColor().whiteColor,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: const Offset(
                                            0.0,
                                            3.0,
                                          ),
                                          blurRadius: 1.0,
                                          spreadRadius: .3,
                                          color: Color(0xFF4F4F4F),
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
                                    child: Obx(
                                      () => Center(
                                        child: walletPageController
                                                    .offerWallList
                                                    .value
                                                    .data[index]
                                                    .userDeal !=
                                                null
                                            ? walletPageController.subtractDate(
                                                        (DateTime.parse(
                                                            "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) >
                                                    0
                                                ? Text(
                                                    "Pending",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    "Expired",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.white),
                                                  )
                                            : ApiUrl().isPlayStore
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${walletPageController.offerWallList.value.data[index].buttonText.split("₹")[0]}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Container(
                                                        height: 10,
                                                        child: Image.asset(
                                                            "assets/images/winning_coin.webp"),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${walletPageController.offerWallList.value.data[index].buttonText.split("₹")[1]}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  )
                                                : Text(
                                                    "${walletPageController.offerWallList.value.data[index].buttonText}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                      ),
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'assets/lottie_files/timer_down_new.json',
                                      repeat: true,
                                      height: 25,
                                      width: 25,
                                    ),
                                    SizedBox(width: 1),
                                    TweenAnimationBuilder<Duration>(
                                        duration: Duration(
                                            seconds: walletPageController
                                                .subtractDate(DateTime.parse(
                                                    "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))),
                                        tween: Tween(
                                            begin: Duration(
                                                seconds: walletPageController
                                                    .subtractDate(DateTime.parse(
                                                        "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))),
                                            end: Duration.zero),
                                        onEnd: () {
                                          Utils().customPrint('Timer ended');
                                          //walletPageController.isExpired.value = true;
                                        },
                                        builder: (BuildContext context,
                                            Duration value, Widget child) {
                                          String seconds =
                                              (value.inSeconds % 60)
                                                  .toInt()
                                                  .toString()
                                                  .padLeft(2, '0');
                                          String minutes =
                                              ((value.inSeconds / 60) % 60)
                                                  .toInt()
                                                  .toString()
                                                  .padLeft(2, '0');
                                          String hours =
                                              (value.inSeconds ~/ 3600)
                                                  .toString()
                                                  .padLeft(2, '0');

                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Text("$hours\:$minutes hr",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  )));
                                        })
                                  ],
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              // pending status call

                              /*  if (walletPageController
                            .offerWallList.value.data[index].userDeal !=
                            null &&
                            walletPageController.subtractDate((DateTime.parse(
                                "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) >
                                0) {
                          if (walletPageController
                              .offerWallList.value.data[index].url !=
                              null &&
                              walletPageController
                                  .offerWallList.value.data[index].url !=
                                  '') {
                            String url = walletPageController
                                .offerWallList.value.data[index].url
                                .toString();
                            if (url.contains("{clickid}")) {
                              url = url.replaceAll(
                                  "{clickid}",
                                  walletPageController.offerWallList.value
                                      .data[index].userDeal.id);
                            }
                            Utils().customPrint('createUserDeal DATA:: ${url}');
                            //showProgress(context, '', true);
                            Utils.launchURLApp(url);

                            return;
                            //Utils.launchURLApp(url);
                            //Get.to(() => PokerHowToPlayWebview(url));
                            //Utils.launchURLApp('market://details?id=com.byjus.thelearningapp&referrer=af_tranid%3D5i2682Uzq617AoAU9pmImA%26af_sub1%3D1437%26af_c_id%3D8364262%26pid%3Dxyads_int%26af_click_lookback%3D7d%26af_prt%3Dxyadsagency%26expires%3D1682233927396%26signature%3DTuT4v-YmAFImt-eE9Fqx4VZy2AJMYc0NX432lrjkEdE%26af_sub2%3D%7Bsubid%7D%26af_web_id%3D2a4c51ee-ed67-469e-a6c0-5116263487e8-c%26clickid%3D026090E8FFEA21674457927394752%26af_siteid%3D15901%26af_sub_siteid%3D%7Bsubid%7D%26af_sub3%3D123472%26c%3DAffiliate_xyadsagency');
                            //api calling
                            //await getAdvertisersDeals();
                            //await getUserDeals();
                          } else {
                            Fluttertoast.showToast(msg: 'URL not found!');
                          }
                        }*/

                              //Event Calling

                              int checkPendingStatus = 0;

                              /*for (int indexM = 0;
                  indexM <
                      walletPageController
                          .offerWallList.value.data.length;
                  indexM++) {
                    if (walletPageController.offerWallList.value
                        .data[indexM].userDeal !=
                        null &&
                        walletPageController.offerWallList.value
                            .data[indexM].userDeal.status
                            .compareTo("pending") ==
                            0) {
                      checkPendingStatus = checkPendingStatus + 1;
                    }
                  }*/

                              Get.to(() => OfferWallDetail(
                                  lootBoxId: walletPageController
                                      .offerWallList.value.data[index].id));
                              return;

                              if (walletPageController
                                          .offerWallHistoryList.value !=
                                      null &&
                                  walletPageController
                                          .offerWallHistoryList.value.data !=
                                      null &&
                                  walletPageController.offerWallHistoryList
                                          .value.data.length <
                                      3) {
                                getAmountOfferWall(context, index);
                              } else {
                                Map<String, Object> map =
                                    new Map<String, Object>();
                                map["offer_name"] = walletPageController
                                    .offerWallList.value.data[index].name;
                                map["offer_clicked"] = "Yes";
                                map["USER_ID"] = walletPageController.user_id;
                                map["deviceId"] =
                                    await Utils().getUniqueDeviceId();
                                try {
                                  if (walletPageController.offerWallList.value
                                              .data[index].gmngEarning !=
                                          null &&
                                      walletPageController.offerWallList.value
                                              .data[index].gmngEarning.value !=
                                          null &&
                                      walletPageController.offerWallList.value
                                              .data[index].gmngEarning.value !=
                                          '') {
                                    int amt = walletPageController.offerWallList
                                        .value.data[index].gmngEarning.value;
                                    map["offer_gmngEarning"] = amt / 100;
                                  }
                                  if (walletPageController.offerWallList.value
                                              .data[index].userEarning !=
                                          null &&
                                      walletPageController.offerWallList.value
                                              .data[index].userEarning.value !=
                                          null &&
                                      walletPageController.offerWallList.value
                                              .data[index].userEarning.value !=
                                          '') {
                                    int amt = walletPageController.offerWallList
                                        .value.data[index].userEarning.value;
                                    map["offer_userEarning"] = amt / 100;
                                  }
                                } catch (e) {}
                                //appsflyer
                                AppsflyerController c =
                                    Get.put(AppsflyerController());
                                c.logEventAf(
                                    EventConstant.EVENT_Offerwall, map);
                                //clevertap
                                CleverTapController cleverTapController =
                                    Get.put(CleverTapController());
                                cleverTapController.logEventCT(
                                    EventConstant.EVENT_Offerwall, map);
                                //end

                                //app checking insalled or not
                                String appInstalled = "false";
                                if (walletPageController.offerWallList.value
                                            .data[index].appPackage !=
                                        null &&
                                    walletPageController.offerWallList.value
                                            .data[index].appPackage.android !=
                                        null) {
                                  Utils().customPrint(
                                      "open App: ${await findAppByPkgName("${walletPageController.offerWallList.value.data[index].appPackage.android}")}");
                                  appInstalled = await findAppByPkgName(
                                      "${walletPageController.offerWallList.value.data[index].appPackage.android}");
                                }

                                final param = {
                                  "advertiserDealId":
                                      "${walletPageController.offerWallList.value.data[index].id}",
                                  "appInstalled": appInstalled,
                                  "deviceId": await Utils().getUniqueDeviceId()
                                };
                                //return;

                                await walletPageController.createUserDeal(
                                    context, param);
                                await _userController.getWalletAmount();
                              }
                            },
                            child: Container(
                              height: 35,
                              // width: 64,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  // Where the linear gradient begins and ends
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,

                                  colors: [
                                    AppColor().green_color_light,
                                    AppColor().green_color,
                                  ],
                                ),
                                border: Border.all(
                                    color: AppColor().whiteColor, width: 1),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      3.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFF4F4F4F),
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
                              child: Obx(
                                () => Center(
                                  child: ApiUrl().isPlayStore
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${walletPageController.offerWallList.value.data[index].buttonText.split("₹")[0]}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Container(
                                              height: 10,
                                              child: Image.asset(
                                                  "assets/images/winning_coin.webp"),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${walletPageController.offerWallList.value.data[index].buttonText.split("₹")[1]}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      : Text(
                                          "${walletPageController.offerWallList.value.data[index].buttonText}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                          ))

                // get Event Call
                /*  GestureDetector(
            onTap: () async {
              if (walletPageController
                  .offerWallList.value.data[index].userDeal !=
                  null &&
                  walletPageController.subtractDate((DateTime.parse(
                      "${walletPageController.offerWallList.value.data[index]
                          .userDeal.expireDate}"))) >
                      0) {
                if (walletPageController
                    .offerWallList.value.data[index].url !=
                    null &&
                    walletPageController
                        .offerWallList.value.data[index].url !=
                        '') {
                  String url = walletPageController
                      .offerWallList.value.data[index].url
                      .toString();
                  if (url.contains("{clickid}")) {
                    url = url.replaceAll(
                        "{clickid}",
                        walletPageController
                            .offerWallList.value.data[index].userDeal.id);
                  }
                  Utils().customPrint('createUserDeal 1 DATA:: ${url}');
                  Utils.launchURLApp(url);
                  //showProgress(context, '', true);
                  //Utils().showCustomDialogWebViewInvible(context, url);
                  return;
                  //api calling
                  //await getAdvertisersDeals();
                  //await getUserDeals();
                } else {
                  Fluttertoast.showToast(msg: 'URL not found!');
                }
              }
              //Event Saving
              Map<String, Object> map = new Map<String, Object>();
              map["offer_name"] = walletPageController
                  .offerWallList.value.data[index].name;
              map["offer_clicked"] = "Yes";
              map["USER_ID"] = walletPageController.user_id;
              map["deviceId"] = await Utils().getUniqueDeviceId();
              try {
                if (walletPageController.offerWallList.value.data[index]
                    .gmngEarning !=
                    null &&
                    walletPageController.offerWallList.value.data[index]
                        .gmngEarning.value !=
                        null &&
                    walletPageController.offerWallList.value.data[index]
                        .gmngEarning.value !=
                        '') {
                  int amt = walletPageController
                      .offerWallList.value.data[index].gmngEarning.value;
                  map["offer_gmngEarning"] = amt / 100;
                }
                if (walletPageController.offerWallList.value.data[index]
                    .userEarning !=
                    null &&
                    walletPageController.offerWallList.value.data[index]
                        .userEarning.value !=
                        null &&
                    walletPageController.offerWallList.value.data[index]
                        .userEarning.value !=
                        '') {
                  int amt = walletPageController
                      .offerWallList.value.data[index].userEarning.value;
                  map["offer_userEarning"] = amt / 100;
                }
              } catch (e) {}
              //appsflyer
              AppsflyerController c = Get.put(AppsflyerController());
              c.logEventAf(EventConstant.EVENT_Offerwall, map);
              //clevertap
              CleverTapController cleverTapController =
              Get.put(CleverTapController());
              cleverTapController.logEventCT(
                  EventConstant.EVENT_Offerwall, map);
              //end
              //app checking insalled or not
              String appInstalled = "false";
              if (walletPageController
                  .offerWallList.value.data[index].appPackage !=
                  null &&
                  walletPageController.offerWallList.value.data[index]
                      .appPackage.android !=
                      null) {
                Utils().customPrint(
                    "open App: ${await findAppByPkgName(
                        "${walletPageController.offerWallList.value.data[index]
                            .appPackage.android}")}");
                appInstalled = await findAppByPkgName(
                    "${walletPageController.offerWallList.value.data[index]
                        .appPackage.android}");
              }
              //return;
              final param = {
                "advertiserDealId":
                "${walletPageController.offerWallList.value.data[index].id}",
                "appInstalled": appInstalled,
                "deviceId": await Utils().getUniqueDeviceId()
              };
              await walletPageController.createUserDeal(context, param);
              await _userController.getWalletAmount();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5.0),
              child: Container(
                  height: 40,
                  // width: 64,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 200,
                  margin: EdgeInsets.only(
                      left: 0, right: 0, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      //  stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        // Colors are easy thanks to Flutter's Colors class.
                        */ /*walletPageController.offerWallList.value
                                              .data[index].userDeal !=
                                          null &&
                                      walletPageController.subtractDate(
                                              (DateTime.parse(
                                                  "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) <
                                          0
                                  ? AppColor().clan_header_light
                                  :*/ /*
                        AppColor().button_bg_redlight,
                        */ /* walletPageController.offerWallList.value
                                              .data[index].userDeal !=
                                          null &&
                                      walletPageController.subtractDate(
                                              (DateTime.parse(
                                                  "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) <
                                          0
                                  ? AppColor().clan_header_dark
                                  :*/ /*
                        AppColor().button_bg_reddark,
                        //AppColor().green_color_light,
                        //AppColor().green_color,
                      ],
                    ),
                    border: Border.all(
                        color: AppColor().whiteColor, width: 1),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        offset: const Offset(
                          0.0,
                          3.0,
                        ),
                        blurRadius: 1.0,
                        spreadRadius: .3,
                        color: Color(0xFF333232),
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
                  child: Obx(
                        () =>
                        Center(
                          child: walletPageController.offerWallList.value
                              .data[index].userDeal !=
                              null
                              ? walletPageController.subtractDate(
                              (DateTime.parse(
                                  "${walletPageController.offerWallList.value
                                      .data[index].userDeal.expireDate}"))) >
                              0
                              ? TweenAnimationBuilder<Duration>(
                              duration: Duration(
                                  seconds: walletPageController.subtractDate(
                                      DateTime.parse(
                                          "${walletPageController.offerWallList
                                              .value.data[index].userDeal
                                              .expireDate}"))),
                              tween: Tween(
                                  begin: Duration(
                                      seconds: walletPageController
                                          .subtractDate(DateTime.parse(
                                          "${walletPageController.offerWallList
                                              .value.data[index].userDeal
                                              .expireDate}"))),
                                  end: Duration.zero),
                              onEnd: () {
                                Utils().customPrint('Timer ended');
                                //walletPageController.isExpired.value = true;
                              },
                              builder: (BuildContext context, Duration value,
                                  Widget child) {
                                String seconds =
                                (value.inSeconds % 60)
                                    .toInt()
                                    .toString()
                                    .padLeft(2, '0');
                                String minutes =
                                ((value.inSeconds / 60) % 60)
                                    .toInt()
                                    .toString()
                                    .padLeft(2, '0');
                                String hours =
                                (value.inSeconds ~/ 3600)
                                    .toString()
                                    .padLeft(2, '0');
                                return Text(
                                  "Pending",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ); */ /*Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: Text(
                                                            "${walletPageController.offerWallList.value.data[index].buttonText}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 11)),
                                                      ),
                                                      Text(
                                                          "(Time remaining: $hours\:$minutes\:$seconds)",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 9)),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        walletPageController
                                                            .isExpired.value,
                                                    child: Text(
                                                      "Expired",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Montserrat",
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ));*/ /*
                              })
                              : Text(
                            "Expired",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          )
                              : Text(
                            "${walletPageController.offerWallList.value
                                .data[index].buttonText}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                  )),
            ),
          ),*/
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: walletPageController
                                    .offerWallList.value.data[index].logoUrl !=
                                null &&
                            walletPageController
                                    .offerWallList.value.data[index].logoUrl !=
                                ''
                        ? Image(
                            //color: AppColor().whiteColor,
                            width: 50,
                            height: 50,
                            //fit: BoxFit.cover,
                            image: NetworkImage(walletPageController
                                .offerWallList.value.data[index].logoUrl))
                        : Image(
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/netflix.png'),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showBottomSheetInfo(
                              context,
                              walletPageController
                                  .offerWallList.value.data[index].terms);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 15),
                              child: Text(
                                "${walletPageController.offerWallList.value.data[index].name}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: AppColor().colorPrimary),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10, left: 5),
                              child: Image.asset(
                                "assets/images/info.webp",
                                color: Colors.blue,
                                width: 13,
                                height: 13,
                                //color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 5),
                        child: Text(
                          '${walletPageController.offerWallList.value.data[index].description}',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5.0),
                      child: /*walletPageController.offerWallList.value
                                      .data[index].userDeal !=
                                  null &&
                              walletPageController.subtractDate((DateTime.parse(
                                      "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) >
                                  0
                          ? GestureDetector(
                              onTap: () async {
                                if (walletPageController.offerWallList.value
                                            .data[index].userDeal !=
                                        null &&
                                    walletPageController.subtractDate(
                                            (DateTime.parse(
                                                "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) >
                                        0) {
                                  isPopupPending(index);
                                }

                                //Event Calling
                                */ /* Map<String, Object> map =
                    new Map<String, Object>();
                    map["offer_name"] = walletPageController
                        .offerWallList.value.data[index].name;
                    map["offer_clicked"] = "Yes";
                    map["USER_ID"] = walletPageController.user_id;
                    map["deviceId"] =
                    await Utils().getUniqueDeviceId();
                    try {
                      if (walletPageController.offerWallList.value
                          .data[index].gmngEarning !=
                          null &&
                          walletPageController.offerWallList.value
                              .data[index].gmngEarning.value !=
                              null &&
                          walletPageController.offerWallList.value
                              .data[index].gmngEarning.value !=
                              '') {
                        int amt = walletPageController.offerWallList
                            .value.data[index].gmngEarning.value;
                        map["offer_gmngEarning"] = amt / 100;
                      }
                      if (walletPageController.offerWallList.value
                          .data[index].userEarning !=
                          null &&
                          walletPageController.offerWallList.value
                              .data[index].userEarning.value !=
                              null &&
                          walletPageController.offerWallList.value
                              .data[index].userEarning.value !=
                              '') {
                        int amt = walletPageController.offerWallList
                            .value.data[index].userEarning.value;
                        map["offer_userEarning"] = amt / 100;
                      }
                    } catch (e) {}
                    //appsflyer
                    AppsflyerController c =
                    Get.put(AppsflyerController());
                    c.logEventAf(
                        EventConstant.EVENT_Offerwall, map);
                    //clevertap
                    CleverTapController cleverTapController =
                    Get.put(CleverTapController());
                    cleverTapController.logEventCT(
                        EventConstant.EVENT_Offerwall, map);
                    //end

                    //app checking insalled or not
                    String appInstalled = "false";
                    if (walletPageController.offerWallList.value
                        .data[index].appPackage !=
                        null &&
                        walletPageController.offerWallList.value
                            .data[index].appPackage.android !=
                            null) {
                      Utils().customPrint(
                          "open App: ${await findAppByPkgName(
                              "${walletPageController.offerWallList.value
                                  .data[index].appPackage.android}")}");
                      appInstalled = await findAppByPkgName(
                          "${walletPageController.offerWallList.value
                              .data[index].appPackage.android}");
                    }

                    final param = {
                      "advertiserDealId":
                      "${walletPageController.offerWallList.value.data[index]
                          .id}",
                      "appInstalled": appInstalled,
                      "deviceId": await Utils().getUniqueDeviceId()
                    };
                    //return;

                    await walletPageController.createUserDeal(
                        context, param);
                    await _userController.getWalletAmount();*/ /*
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 12),
                                  Container(
                                      height: 35,
                                      // width: 64,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          // Where the linear gradient begins and ends
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,

                                          colors: [
                                            AppColor().button_bg_light,
                                            AppColor().special_bg_c,
                                          ],
                                        ),
                                        border: Border.all(
                                            color: AppColor().whiteColor,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: const [
                                          BoxShadow(
                                            offset: const Offset(
                                              0.0,
                                              3.0,
                                            ),
                                            blurRadius: 1.0,
                                            spreadRadius: .3,
                                            color: Color(0xFF4F4F4F),
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
                                      child: Obx(
                                        () => Center(
                                          child: walletPageController
                                                      .offerWallList
                                                      .value
                                                      .data[index]
                                                      .userDeal !=
                                                  null
                                              ? walletPageController.subtractDate(
                                                          (DateTime.parse(
                                                              "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) >
                                                      0
                                                  ? Text(
                                                      "Pending",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    )
                                                  : Text(
                                                      "Expired",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: Colors.white),
                                                    )
                                              : ApiUrl().isPlayStore
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "${walletPageController.offerWallList.value.data[index].buttonText.split("₹")[0]}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Container(
                                                          height: 10,
                                                          child: Image.asset(
                                                              "assets/images/winning_coin.webp"),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "${walletPageController.offerWallList.value.data[index].buttonText.split("₹")[1]}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    )
                                                  : Text(
                                                      "${walletPageController.offerWallList.value.data[index].buttonText}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                        ),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'assets/lottie_files/timer_down_new.json',
                                        repeat: true,
                                        height: 25,
                                        width: 25,
                                      ),
                                      SizedBox(width: 1),
                                      TweenAnimationBuilder<Duration>(
                                          duration: Duration(
                                              seconds: walletPageController
                                                  .subtractDate(DateTime.parse(
                                                      "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))),
                                          tween: Tween(
                                              begin: Duration(
                                                  seconds: walletPageController
                                                      .subtractDate(DateTime.parse(
                                                          "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))),
                                              end: Duration.zero),
                                          onEnd: () {
                                            Utils().customPrint('Timer ended');
                                            //walletPageController.isExpired.value = true;
                                          },
                                          builder: (BuildContext context,
                                              Duration value, Widget child) {
                                            String seconds =
                                                (value.inSeconds % 60)
                                                    .toInt()
                                                    .toString()
                                                    .padLeft(2, '0');
                                            String minutes =
                                                ((value.inSeconds / 60) % 60)
                                                    .toInt()
                                                    .toString()
                                                    .padLeft(2, '0');
                                            String hours =
                                                (value.inSeconds ~/ 3600)
                                                    .toString()
                                                    .padLeft(2, '0');

                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2),
                                                child: Text(
                                                    "$hours\:$minutes hr",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "Montserrat",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    )));
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : */
                          GestureDetector(
                        onTap: () async {
                          Get.to(() => OfferWallDetail(
                              lootBoxId: walletPageController
                                  .offerWallList.value.data[index].id));
                          return;
                          // pending status call

                          /*  if (walletPageController
                            .offerWallList.value.data[index].userDeal !=
                            null &&
                            walletPageController.subtractDate((DateTime.parse(
                                "${walletPageController.offerWallList.value.data[index].userDeal.expireDate}"))) >
                                0) {
                          if (walletPageController
                              .offerWallList.value.data[index].url !=
                              null &&
                              walletPageController
                                  .offerWallList.value.data[index].url !=
                                  '') {
                            String url = walletPageController
                                .offerWallList.value.data[index].url
                                .toString();
                            if (url.contains("{clickid}")) {
                              url = url.replaceAll(
                                  "{clickid}",
                                  walletPageController.offerWallList.value
                                      .data[index].userDeal.id);
                            }
                            Utils().customPrint('createUserDeal DATA:: ${url}');
                            //showProgress(context, '', true);
                            Utils.launchURLApp(url);

                            return;
                            //Utils.launchURLApp(url);
                            //Get.to(() => PokerHowToPlayWebview(url));
                            //Utils.launchURLApp('market://details?id=com.byjus.thelearningapp&referrer=af_tranid%3D5i2682Uzq617AoAU9pmImA%26af_sub1%3D1437%26af_c_id%3D8364262%26pid%3Dxyads_int%26af_click_lookback%3D7d%26af_prt%3Dxyadsagency%26expires%3D1682233927396%26signature%3DTuT4v-YmAFImt-eE9Fqx4VZy2AJMYc0NX432lrjkEdE%26af_sub2%3D%7Bsubid%7D%26af_web_id%3D2a4c51ee-ed67-469e-a6c0-5116263487e8-c%26clickid%3D026090E8FFEA21674457927394752%26af_siteid%3D15901%26af_sub_siteid%3D%7Bsubid%7D%26af_sub3%3D123472%26c%3DAffiliate_xyadsagency');
                            //api calling
                            //await getAdvertisersDeals();
                            //await getUserDeals();
                          } else {
                            Fluttertoast.showToast(msg: 'URL not found!');
                          }
                        }*/

                          //Event Calling

                          /* int checkPendingStatus = 0;

                                for (int indexM = 0;
                                    indexM <
                                        walletPageController
                                            .offerWallList.value.data.length;
                                    indexM++) {
                                  if (walletPageController.offerWallList.value
                                              .data[indexM].userDeal !=
                                          null &&
                                      walletPageController.offerWallList.value
                                              .data[indexM].userDeal.status
                                              .compareTo("pending") ==
                                          0) {
                                    checkPendingStatus = checkPendingStatus + 1;
                                  }
                                }*/
                          if (walletPageController
                                      .offerWallHistoryList.value !=
                                  null &&
                              walletPageController
                                      .offerWallHistoryList.value.data !=
                                  null &&
                              walletPageController
                                      .offerWallHistoryList.value.data.length <
                                  3) {
                            getAmountOfferWall(context, index);
                          } else {
                            Map<String, Object> map = new Map<String, Object>();
                            map["offer_name"] = walletPageController
                                .offerWallList.value.data[index].name;
                            map["offer_clicked"] = "Yes";
                            map["USER_ID"] = walletPageController.user_id;
                            map["deviceId"] = await Utils().getUniqueDeviceId();
                            try {
                              if (walletPageController.offerWallList.value
                                          .data[index].gmngEarning !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].gmngEarning.value !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].gmngEarning.value !=
                                      '') {
                                int amt = walletPageController.offerWallList
                                    .value.data[index].gmngEarning.value;
                                map["offer_gmngEarning"] = amt / 100;
                              }
                              if (walletPageController.offerWallList.value
                                          .data[index].userEarning !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].userEarning.value !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].userEarning.value !=
                                      '') {
                                int amt = walletPageController.offerWallList
                                    .value.data[index].userEarning.value;
                                map["offer_userEarning"] = amt / 100;
                              }
                            } catch (e) {}
                            //appsflyer
                            AppsflyerController c =
                                Get.put(AppsflyerController());
                            c.logEventAf(EventConstant.EVENT_Offerwall, map);
                            //clevertap
                            CleverTapController cleverTapController =
                                Get.put(CleverTapController());
                            cleverTapController.logEventCT(
                                EventConstant.EVENT_Offerwall, map);
                            //end

                            //app checking insalled or not
                            String appInstalled = "false";
                            if (walletPageController.offerWallList.value
                                        .data[index].appPackage !=
                                    null &&
                                walletPageController.offerWallList.value
                                        .data[index].appPackage.android !=
                                    null) {
                              Utils().customPrint(
                                  "open App: ${await findAppByPkgName("${walletPageController.offerWallList.value.data[index].appPackage.android}")}");
                              appInstalled = await findAppByPkgName(
                                  "${walletPageController.offerWallList.value.data[index].appPackage.android}");
                            }

                            final param = {
                              "advertiserDealId":
                                  "${walletPageController.offerWallList.value.data[index].id}",
                              "appInstalled": appInstalled,
                              "deviceId": await Utils().getUniqueDeviceId()
                            };
                            //return;

                            await walletPageController.createUserDeal(
                                context, param);
                            await _userController.getWalletAmount();
                          }
                        },
                        child: Container(
                          height: 35,
                          // width: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,

                              colors: [
                                AppColor().green_color_light,
                                AppColor().green_color,
                              ],
                            ),
                            border: Border.all(
                                color: AppColor().whiteColor, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                offset: const Offset(
                                  0.0,
                                  3.0,
                                ),
                                blurRadius: 1.0,
                                spreadRadius: .3,
                                color: Color(0xFF4F4F4F),
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
                          child: Obx(
                            () => Center(
                              child: ApiUrl().isPlayStore
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${walletPageController.offerWallList.value.data[index].buttonText.split("₹")[0]}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Container(
                                          height: 10,
                                          child: Image.asset(
                                              "assets/images/winning_coin.webp"),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${walletPageController.offerWallList.value.data[index].buttonText.split("₹")[1]}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  : Text(
                                      "${walletPageController.offerWallList.value.data[index].buttonText}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
    );
  }

  //history
  Widget normalListViewHistory(int index) {
    return Container(
      height: walletPageController.offerWallHistoryList.value.data[index]
                  .advertiserDealId.banner !=
              null
          ? 220
          : 75,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColor().button_bg_grey,
          // image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/images/gradient_rectangular.png")),
          /* color: Colors.transparent,*/
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10, right: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: walletPageController.offerWallHistoryList.value
                                .data[index].advertiserDealId.logoUrl !=
                            null &&
                        walletPageController.offerWallHistoryList.value
                                .data[index].advertiserDealId.logoUrl !=
                            ''
                    ? Image(
                        //color: AppColor().whiteColor,
                        width: 50,
                        height: 50,
                        //fit: BoxFit.cover,
                        image: NetworkImage(walletPageController
                            .offerWallHistoryList
                            .value
                            .data[index]
                            .advertiserDealId
                            .logoUrl))
                    : Image(
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/netflix.png'),
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showBottomSheetInfo(
                          context,
                          walletPageController.offerWallHistoryList.value
                              .data[index].advertiserDealId.terms);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0, top: 5),
                          child: Text(
                            "${walletPageController.offerWallHistoryList.value.data[index].advertiserDealId.name}",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: AppColor().colorPrimary),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, left: 5),
                          child: Image.asset(
                            "assets/images/info.webp",
                            color: Colors.blue,
                            width: 13,
                            height: 13,
                            //color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 5),
                    child: Text(
                      '${walletPageController.offerWallHistoryList.value.data[index].advertiserDealId.description}',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  final param = {
                    "advertiserDealId":
                        "${walletPageController.offerWallHistoryList.value.data[index].id}",
                    "appInstalled": "false"
                  };
                  //await walletPageController.createUserDeal(context, param);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5.0, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 4),
                      Container(
                          height: 35,
                          // width: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              //  stops: [0.1, 0.5, 0.7, 0.9],
                              colors: [
                                // Colors are easy thanks to Flutter's Colors class.
                                walletPageController.offerWallHistoryList.value
                                            .data[index].status ==
                                        'completed'
                                    ? AppColor().green_color_light
                                    : AppColor().button_bg_redlight,
                                walletPageController.offerWallHistoryList.value
                                            .data[index].status ==
                                        'completed'
                                    ? AppColor().green_color
                                    : AppColor().button_bg_reddark,
                              ],
                            ),
                            border: Border.all(
                                color: AppColor().whiteColor, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                offset: const Offset(
                                  0.0,
                                  3.0,
                                ),
                                blurRadius: 1.0,
                                spreadRadius: .3,
                                color: Color(0xFF333232),
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
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Center(
                              child: Text(
                                "${walletPageController.offerWallHistoryList.value.data[index].status.toUpperCase()}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '${getStartTimeHHMMSS(walletPageController.offerWallHistoryList.value.data[index].dealDate)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 9,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        walletPageController.offerWallHistoryList.value.data[index]
                        .advertiserDealId.banner !=
                    null &&
                walletPageController.offerWallHistoryList.value.data[index]
                        .advertiserDealId.banner.url !=
                    null
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Image(
                    //color: AppColor().whiteColor,
                    //width: 50,
                    height: 140,
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(walletPageController
                        .offerWallHistoryList
                        .value
                        .data[index]
                        .advertiserDealId
                        .banner
                        .url)),
              )
            : Container()
      ]),
    );
  }

  void showBottomSheetInfo(BuildContext context, String terms) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 10,
                    right: 10),
                decoration: BoxDecoration(
                    color: AppColor().reward_card_bg,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            "Terms & Conditions",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new IconButton(
                              icon: new Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 5),
                      height: .5,
                      color: AppColor().colorGray,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /* Text(
                          "Complete following tasks",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 12),
                        ),*/
                        /* Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            "${terms}",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ),*/
                        Html(
                          data: terms,
                          /* onLinkTap: (url, _, __, ___) {
                           Utils().customPrint("Opening $url");
                          makeLaunch(url!);
                        },*/
                          style: {
                            "body": Style(
                              fontSize: FontSize(10.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            'h1': Style(
                              color: Colors.white,
                              textAlign: TextAlign.left,
                            ),
                            'p': Style(
                                textAlign: TextAlign.left,
                                color: Colors.white,
                                alignment: Alignment.topLeft,
                                fontSize: FontSize.small),
                            'ul': Style(
                              color: Colors.white,
                              textAlign: TextAlign
                                  .left, /*margin:  EdgeInsets.only(left: 10)*/
                            )
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                        width: MediaQuery.of(context).size.width - 200,
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
                              color: Color(0xFFED234B),
                              inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFEC8479),
                              inset: true,
                            ),
                          ],

                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Text(
                          "Close",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  findAppByPkgName(String pkgName) async {
    try {
      bool isInstalled = await DeviceApps.isAppInstalled(pkgName);
      if (isInstalled) {
        Utils().customPrint('open App...IF');
        return "true";
      } else {
        Utils().customPrint('open App...ELSE');
        return "false";
      }
    } catch (e) {
      Utils().customPrint('open App...E');
      return "false";
    }
  }

  OpenApp(var pkgName) async {
    try {
      ///checks if the app is installed on your mobile device
      bool isInstalled = await DeviceApps.isAppInstalled(pkgName);
      if (isInstalled) {
        Utils().customPrint('open ludo...IF');
        DeviceApps.openApp("com.ludo.king");
      } else {
        Utils().customPrint('open ludo...ELSE');

        ///if the app is not installed it lunches google play store so you can install it from there
        Utils.launchURLApp("market://details?id=" + pkgName);
      }
    } catch (e) {
      Utils().customPrint(e);
      Utils().customPrint('open ludo...E');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _userController.getWalletAmount();
  }

  void getAmountOfferWall(BuildContext context, int index) {
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
                  height: 220,
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().hole_popup_bg)),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(ImageRes().hole_popup_bg))),
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 210,
                child: Card(
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  elevation: 0,
                  //color: AppColor().wallet_dark_grey,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
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
                            /* Container(
                              padding: EdgeInsets.only(top: 5),
                              height: 60,
                              child: Lottie.asset(
                                'assets/lottie_files/waiting.json',
                                repeat: false,
                                height: 100,
                                width: 100,
                              ),
                              */ /*Image.asset("assets/images/rupee_gmng.png"),*/ /*
                            ),*/
                            InkWell(
                              onTap: () {
                                Navigator.pop(
                                    navigatorKey.currentState.context);
                              },
                              child: Container(
                                height: 22,
                                width: 22,
                                child: Image.asset(ImageRes().close_icon),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0, top: 8, bottom: 20),
                          child: Text(
                            'IMPORTANT \n Amount will not be credited if this App was downloaded in the last 6 months  \n *Please OPEN the app After Installing it*',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(navigatorKey.currentState.context);
                            Map<String, Object> map = new Map<String, Object>();
                            map["offer_name"] = walletPageController
                                .offerWallList.value.data[index].name;
                            map["offer_clicked"] = "Yes";
                            map["USER_ID"] = walletPageController.user_id;
                            map["deviceId"] = await Utils().getUniqueDeviceId();
                            try {
                              if (walletPageController.offerWallList.value
                                          .data[index].gmngEarning !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].gmngEarning.value !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].gmngEarning.value !=
                                      '') {
                                int amt = walletPageController.offerWallList
                                    .value.data[index].gmngEarning.value;
                                map["offer_gmngEarning"] = amt / 100;
                              }
                              if (walletPageController.offerWallList.value
                                          .data[index].userEarning !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].userEarning.value !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].userEarning.value !=
                                      '') {
                                int amt = walletPageController.offerWallList
                                    .value.data[index].userEarning.value;
                                map["offer_userEarning"] = amt / 100;
                              }
                            } catch (e) {}
                            //appsflyer
                            AppsflyerController c =
                                Get.put(AppsflyerController());
                            c.logEventAf(EventConstant.EVENT_Offerwall, map);
                            //clevertap
                            CleverTapController cleverTapController =
                                Get.put(CleverTapController());
                            cleverTapController.logEventCT(
                                EventConstant.EVENT_Offerwall, map);
                            //end

                            //app checking insalled or not
                            String appInstalled = "false";
                            if (walletPageController.offerWallList.value
                                        .data[index].appPackage !=
                                    null &&
                                walletPageController.offerWallList.value
                                        .data[index].appPackage.android !=
                                    null) {
                              Utils().customPrint(
                                  "open App: ${await findAppByPkgName("${walletPageController.offerWallList.value.data[index].appPackage.android}")}");
                              appInstalled = await findAppByPkgName(
                                  "${walletPageController.offerWallList.value.data[index].appPackage.android}");
                            }

                            final param = {
                              "advertiserDealId":
                                  "${walletPageController.offerWallList.value.data[index].id}",
                              "appInstalled": appInstalled,
                              "deviceId": await Utils().getUniqueDeviceId()
                            };
                            //return;

                            await walletPageController.createUserDeal(
                                context, param);
                            await _userController.getWalletAmount();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 38,
                            margin: EdgeInsets.only(
                                left: 0, right: 0, top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width - 250,
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
                                BoxShadow(
                                  offset: Offset(00, 00),
                                  blurRadius: 00,
                                  color: Color(0xFFffffff),
                                  //inset: true,
                                ),
                              ],

                              border: Border.all(
                                  color: AppColor().whiteColor, width: 2),
                              borderRadius: BorderRadius.circular(30),
                              // color: AppColor().whiteColor
                            ),
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Nunito",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  void isPopupPending(int index) {
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
                  width: MediaQuery.of(navigatorKey.currentState.context)
                      .size
                      .width,
                  height: 250,
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().hole_popup_bg)),
              Container(
                width:
                    MediaQuery.of(navigatorKey.currentState.context).size.width,
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
                          InkWell(
                            onTap: () {
                              Navigator.pop(navigatorKey.currentState.context);
                            },
                            child: Container(
                              height: 22,
                              width: 22,
                              child: Image.asset(ImageRes().close_icon),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 5, bottom: 10, right: 15),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "Verifying if you have completed the requirements \n Please wait \n Please OPEN the app After Installing it.",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(navigatorKey.currentState.context);

                              if (walletPageController.offerWallList.value
                                          .data[index].url !=
                                      null &&
                                  walletPageController.offerWallList.value
                                          .data[index].url !=
                                      '') {
                                String url = walletPageController
                                    .offerWallList.value.data[index].url
                                    .toString();
                                if (url.contains("{clickid}")) {
                                  url = url.replaceAll(
                                      "{clickid}",
                                      walletPageController.offerWallList.value
                                          .data[index].userDeal.id);
                                }
                                Utils().customPrint(
                                    'createUserDeal DATA:: ${url}');
                                //showProgress(context, '', true);
                                Utils.launchURLApp(url);

                                return;
                                //Utils.launchURLApp(url);
                                //Get.to(() => PokerHowToPlayWebview(url));
                                //Utils.launchURLApp('market://details?id=com.byjus.thelearningapp&referrer=af_tranid%3D5i2682Uzq617AoAU9pmImA%26af_sub1%3D1437%26af_c_id%3D8364262%26pid%3Dxyads_int%26af_click_lookback%3D7d%26af_prt%3Dxyadsagency%26expires%3D1682233927396%26signature%3DTuT4v-YmAFImt-eE9Fqx4VZy2AJMYc0NX432lrjkEdE%26af_sub2%3D%7Bsubid%7D%26af_web_id%3D2a4c51ee-ed67-469e-a6c0-5116263487e8-c%26clickid%3D026090E8FFEA21674457927394752%26af_siteid%3D15901%26af_sub_siteid%3D%7Bsubid%7D%26af_sub3%3D123472%26c%3DAffiliate_xyadsagency');
                                //api calling
                                //await getAdvertisersDeals();
                                //await getUserDeals();
                              } else {
                                Fluttertoast.showToast(msg: 'URL not found!');
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 38,
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              width: MediaQuery.of(
                                          navigatorKey.currentState.context)
                                      .size
                                      .width -
                                  270,
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
                                "Install",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(navigatorKey.currentState.context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 38,
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              width: MediaQuery.of(
                                          navigatorKey.currentState.context)
                                      .size
                                      .width -
                                  270,
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
                                "Close",
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

  String getStartTimeHHMMSS(String date_c) {
    return DateFormat("yyyy-MM-dd").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date_c, true).toLocal());
  }
}
