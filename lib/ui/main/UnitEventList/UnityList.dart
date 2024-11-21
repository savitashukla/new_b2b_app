import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/main/wallet/OfferWallScreen.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/ESportsEventList.dart';
import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../model/responsemodel/PreJoinUnityResponseModel.dart';
import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import '../../../utills/OnlyOff.dart';
import '../../../utills/Utils.dart';
import '../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../utills/event_tracker/EventConstant.dart';
import '../../../utills/event_tracker/FaceBookEventController.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/BaseController.dart';
import '../../controller/user_controller.dart';
import '../../dialog/helperProgressBar.dart';
import '../Arcade/ArcadeDetail.dart';
import '../dashbord/DashBord.dart';
import 'UnityController.dart';
import 'UnityDetails.dart';

class UnityList extends StatefulWidget {
  var gameid1;
  String url1;
  String name1 = "";

  UnityList(this.gameid1, this.url1, this.name1);

  UnityListS createState() => UnityListS(gameid1, url1, name1);
}

class UnityListS extends State<UnityList> with WidgetsBindingObserver {
  var gameid;
  String url;
  String name = "";
  var prefs;
  var token;
  bool unityGameCall = false;
  UnityListS(this.gameid, this.url, this.name);
  UnityController controller;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  PreJoinUnityResponseModel preJoinResponseModel;
  BaseController base_controller = Get.put(BaseController());
  ContestModel _contestModel = null;
  UserController _userController = Get.put(UserController());
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());
  WalletPageController walletPageController = Get.put(WalletPageController());

  @override
  Widget build(BuildContext context) {
    controller = Get.put(UnityController(gameid));
    _userController.getProfileData();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () async {
          controller.checkTr.value = true;
          controller.colorPrimary.value = Color(0xFFe55f19);
          controller.colorwhite.value = Color(0xFFffffff);
          controller.getESportsEventList();

          //game contest lootbox
          WalletPageController walletPageController =
              Get.put(WalletPageController());
          walletPageController.getWalletAmount();
          //_demoData.addAll(["", ""]);
        });
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                Text(""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: url != null && url.isNotEmpty
                          ? Image(
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              image: NetworkImage(url)

                              // AssetImage('assets/images/images.png'),
                              )
                          : name.compareTo("Ludo") == 0
                              ? Image(
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/unity_ludo.png'),
                                )
                              : Image(
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/images/carrom.png'),

                                  // AssetImage('assets/images/images.png'),
                                ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(name),
                    )
                  ],
                ),
                InkWell(
                  onTap: () async {
                    WalletPageController walletPageController =
                        Get.put(WalletPageController());
                    _userController.checkWallet_class_call.value = false;
                    _userController.getWalletAmount();
                    //await walletPageController.getPromoCodesData();
                    !ApiUrl().isPlayStore
                        ? _userController.wallet_s.value = true
                        : _userController.wallet_s.value = false;

                    if (!ApiUrl().isPlayStore) {
                      _userController.checkWallet_class_call.value = false;
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
                                        fontFamily: "Montserrat",
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/store_back.png"))),
          child: SingleChildScrollView(
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Center(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: CachedNetworkImage(
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                  imageUrl: (item.image.url),
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
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Obx(
                                        () => Image(
                                          height: 120,
                                          fit: BoxFit.cover,
                                          image: controller.bannerModelRV.value
                                                          .data !=
                                                      null &&
                                                  controller.bannerModelRV.value
                                                          .data !=
                                                      null &&
                                                  controller.bannerModelRV.value
                                                          .data.length >=
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
                            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                              controller.colorPrimary.value = Color(0xFFe55f19);
                              controller.colorwhite.value = Color(0xFFffffff);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "All Battles".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
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
                                    controller.unity_history_userRegistrations
                                            .length >
                                        0) {
                                  controller.unity_history_userRegistrations
                                      .clear();
                                }
                              } catch (E) {}
                              controller.currentpage.value = 0;
                              controller.getUnityHistoryOnly(gameid);
                              controller.checkTr.value = false;
                              controller.colorPrimary.value = Color(0xFFffffff);
                              controller.colorwhite.value = Color(0xFFe55f19);
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
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => controller.checkTr.value
                          ? Text(
                              "Contest".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            )
                          : Text(""),
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
                                itemCount:
                                    controller.unityEventList.value.data.length,
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
                    child: controller.unity_history_userRegistrations != null
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
        ),
      ),
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      controller.getESportsEventList();
      _userController.getWalletAmount();
      prefs = await SharedPreferences.getInstance();
      unityGameCall = prefs.getBool("unityGameCall");
      //Fluttertoast.showToast(msg: "lun.. $unityGameCall");

      if (unityGameCall != null && unityGameCall) {
        prefs.setBool("unityGameCall", false);
        /*String depositeBalnace = _userController.getDepositeBalnace();
        int getBonuse = _userController.getBonuseCashBalanceInt();
        var totalBaI = double.parse(depositeBalnace);
        double depositeBalnaceSum = totalBaI + getBonuse;*/
        double total = double.parse(_userController.getTotalBalnace());

        if (total < 5) {
          WalletPageController walletPageController =
              Get.put(WalletPageController());
          walletPageController.alertLookBox("zero_amount");
        }
      } else {}
      walletPageController.getWalletAmount();
    } catch (E) {}
    Utils().customPrint(
        "didChangeAppLifecycleState UnityListS ===================================================");

    if (state == AppLifecycleState.resumed) {
      Utils().customPrint(
          "didChangeAppLifecycleState  UnityListS   ===================================================");

      /*  Future.delayed(const Duration(seconds: 3), () async {
        try{
          var  instantCashAdded=prefs.getBool("instantCashAdded");
          print("get notification done  instantCashAdded $instantCashAdded");
          if(instantCashAdded!=null && instantCashAdded)
          {
         //   _userController.showCustomDialogConfettiNew();
          }
        }
        catch(A)
        {

        }

      });*/

    }
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    //checking for app update

    Utils().customPrint("initState call ");
    WidgetsBinding.instance.addObserver(this);
    //for updatation list of lootbox //game contest
    walletPageController.getAdvertisersDeals();
  }

  Widget triviaList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ArcadeDetails());
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10, top: 10, right: 10, left: 10),
          decoration: BoxDecoration(
              border: Border.all(color: AppColor().colorPrimary, width: 2),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)),
          child: Wrap(
            children: [
              Stack(
                children: [
                  /*    Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                        child: Image(
                          height: 40,
                          fit: BoxFit.cover,
                          color: AppColor().colorPrimary,
                          image: AssetImage('assets/images/v_battel.png'),
                        )),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        controller.unityEventList.value.data[index].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                            color: AppColor().colorPrimary),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 2,
                color: AppColor().colorPrimary,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Prizepool",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().colorPrimary),
                            ),
                            GestureDetector(
                              onTap: () {
                                showWinningBreakupDialog(
                                    context,
                                    controller
                                        .unityEventList.value.data[index]);
                              },
                              child: Container(
                                width: 13,
                                alignment: Alignment.topCenter,
                                child:
                                    Image.asset("assets/images/arrow_down.png"),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: AppColor().color_side_menu_header),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Text(
                                "\u{20B9} ${controller.unityEventList.value.data[index].winner.prizeAmount.value ~/ 100}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    color: AppColor().colorPrimary),
                              ),
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Entry Fee",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Montserrat",
                              color: AppColor().colorPrimary),
                        ),
                        Container(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            if (ApiUrl().isPlayStore == false) {
                              bool stateR =
                                  await Utils().checkResLocation(context);
                              if (stateR) {
                                Utils().customPrint(
                                    "LOCATION 11: ---------FAILED");
                                return;
                              } /*else {
                                if (Utils.stateV.value.isEmpty ||
                                    Utils.stateV.value == null) {
                                  Fluttertoast.showToast(
                                      msg:
                                      "Please Allow Location Permission From Settings.");
                                 Utils().customPrint(
                                      "LOCATION 9: ---------Please Allow Location Permission From Settings.");
                                  return;
                                }
                              }*/
                            }

                            _contestModel =
                                controller.unityEventList.value.data[index];
                            getPreJoinEvent(
                                controller.unityEventList.value.data[index].id,
                                context,
                                controller.unityEventList.value.data[index]
                                            .entry.fee.type ==
                                        'bonus'
                                    ? controller.unityEventList.value
                                        .data[index].entry.fee.value
                                    : controller.unityEventList.value
                                            .data[index].entry.fee.value ~/
                                        100);
                          },
                          child: Container(
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: AppColor().colorPrimary,
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                child: controller.unityEventList.value
                                            .data[index].entry.fee.value >
                                        0
                                    ? Text(
                                        "${controller.unityEventList.value.data[index].entry.fee.value ~/ 100}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Montserrat",
                                            color: AppColor().whiteColor),
                                      )
                                    : Text(
                                        "Free".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Montserrat",
                                            color: AppColor().whiteColor),
                                      ),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 2,
                color: AppColor().colorPrimary,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  // color: AppColor().whiteColor,
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bonus cash Used ".tr,
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Montserrat",
                          color: AppColor().colorPrimary),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 0, right: 0, top: 10, bottom: 10),
                      child: Image.asset("assets/images/bonus_coin.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 5),
                      child: Text(
                        "0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat",
                            color: AppColor().colorPrimary),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget triviaListother(BuildContext context, int index) {
    return Obx(
      () => controller
                  .unityEventList.value.data[index].entry.feeBonusPercentage >=
              100
          ? GestureDetector(
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
                _contestModel = controller.unityEventList.value.data[index];
                getPreJoinEvent(
                    controller.unityEventList.value.data[index].id,
                    context,
                    controller.unityEventList.value.data[index].entry.fee
                                .type ==
                            'bonus'
                        ? controller
                            .unityEventList.value.data[index].entry.fee.value
                        : controller.unityEventList.value.data[index].entry.fee
                                .value ~/
                            100);
              },
              child: Stack(
                children: [
                  Container(
                      height: 130,
                      margin: EdgeInsets.only(
                          bottom: 5, top: 30, right: 5, left: 5),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().game_list_bg))),
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
                                        controller.unityEventList.value
                                            .data[index].name
                                            .toUpperCase(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
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
                                          bool stateR = await Utils()
                                              .checkResLocation(context);
                                          if (stateR) {
                                            Utils().customPrint(
                                                "LOCATION 11: ---------FAILED");
                                            return;
                                          }
                                        }

                                        _contestModel = controller
                                            .unityEventList.value.data[index];
                                        getPreJoinEvent(
                                            controller.unityEventList.value
                                                .data[index].id,
                                            context,
                                            controller
                                                        .unityEventList
                                                        .value
                                                        .data[index]
                                                        .entry
                                                        .fee
                                                        .type ==
                                                    'bonus'
                                                ? controller
                                                    .unityEventList
                                                    .value
                                                    .data[index]
                                                    .entry
                                                    .fee
                                                    .value
                                                : controller
                                                        .unityEventList
                                                        .value
                                                        .data[index]
                                                        .entry
                                                        .fee
                                                        .value ~/
                                                    100);
                                      },
                                      child: Container(
                                        width: 120,
                                        margin: EdgeInsets.only(right: 10),
                                        height: 35,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(ImageRes()
                                                    .full_bonus_play_now)
                                                /* image: AssetImage(
                                              "assets/images/orange_gradient_back.png")*/
                                                ),
                                            /*        border: Border.all(
                                          width: 2, color: AppColor().whiteColor),*/
                                            //color: AppColor().colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 10,
                                            ),
                                            Text(
                                              "Play",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Montserrat",
                                                  color: AppColor().whiteColor),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (ApiUrl().isPlayStore ==
                                                    false) {
                                                  bool stateR = await Utils()
                                                      .checkResLocation(
                                                          context);
                                                  if (stateR) {
                                                    Utils().customPrint(
                                                        "LOCATION 11: ---------FAILED");
                                                    return;
                                                  }
                                                }
                                                _contestModel = controller
                                                    .unityEventList
                                                    .value
                                                    .data[index];
                                                getPreJoinEvent(
                                                    controller.unityEventList
                                                        .value.data[index].id,
                                                    context,
                                                    controller
                                                                .unityEventList
                                                                .value
                                                                .data[index]
                                                                .entry
                                                                .fee
                                                                .type ==
                                                            'bonus'
                                                        ? controller
                                                            .unityEventList
                                                            .value
                                                            .data[index]
                                                            .entry
                                                            .fee
                                                            .value
                                                        : controller
                                                                .unityEventList
                                                                .value
                                                                .data[index]
                                                                .entry
                                                                .fee
                                                                .value ~/
                                                            100);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    right: 10, left: 10),
                                                child: controller
                                                            .unityEventList
                                                            .value
                                                            .data[index]
                                                            .entry
                                                            .fee
                                                            .value >
                                                        0
                                                    ? Text(
                                                        controller
                                                                    .unityEventList
                                                                    .value
                                                                    .data[index]
                                                                    .entry
                                                                    .fee
                                                                    .type ==
                                                                'bonus'
                                                            ? controller
                                                                .unityEventList
                                                                .value
                                                                .data[index]
                                                                .entry
                                                                .fee
                                                                .value
                                                                .toString()
                                                            : "${AppString().txt_currency_symbole} ${controller.unityEventList.value.data[index].entry.fee.value ~/ 100}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color: AppColor()
                                                                .whiteColor),
                                                      )
                                                    : Text(
                                                        "Free",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color: AppColor()
                                                                .whiteColor),
                                                      ),
                                              ),
                                            )
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
                                          /* Container(
                                    width: 60,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: AppColor().color_side_menu_header),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                    child:*/
                                          Center(
                                            child: Text(
                                              "\u{20B9} ${controller.unityEventList.value.data[index].winner.prizeAmount.value ~/ 100}",
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
                                        "Bonus cash Used ".tr,
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
                                        child: _userController
                                                    .getBonuseCashBalanceInt() >=
                                                controller.unityEventList.value
                                                    .data[index].entry
                                                    .getBonuse()
                                            ? Text(
                                                "${controller.unityEventList.value.data[index].entry.getBonuse()}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Montserrat",
                                                  color: Colors.white70,
                                                ),
                                              )
                                            : Text(
                                                "${_userController.getBonuseCashBalanceInt()}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Montserrat",
                                                  color: Colors.white70,
                                                ),
                                              ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        height: 50,
                        width: MediaQuery.of(context).size.width - 165,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(ImageRes().list_game_top))),
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
                  )
                ],
              ),
            )
          : controller.unityEventList.value.data[index].lootBoxEvent == true &&
                  double.parse(_userController.getTotalBalnace()) < 5
              ? GestureDetector(
                  onTap: () async {
                    if (AppString.joinContest.value == 'inactive') {
                      Fluttertoast.showToast(msg: 'Join contest disable!');
                      return;
                    }
                    //WalletPageController walletPageController = Get.put(WalletPageController());
                    //walletPageController.alertLookBoxGameContest(controller.unityEventList.value.data[index].id); //zero_amount

                    alertLookBoxGameContest(
                        index, controller.unityEventList.value.data[index].id);
                  },
                  child: Stack(
                    children: [
                      Container(
                          height: 130,
                          margin: EdgeInsets.only(
                              bottom: 5, top: 30, right: 5, left: 5),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(ImageRes().game_list_bg))),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            //controller.unityEventList.value.data[index].name.toUpperCase(),
                                            "FREE MONEY",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: "Montserrat",
                                                color: AppColor()
                                                    .pink_game_contest),
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
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(ImageRes()
                                                        .full_bonus_play_now)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                left: 10),
                                                        child: controller
                                                                    .unityEventList
                                                                    .value
                                                                    .data[index]
                                                                    .entry
                                                                    .fee
                                                                    .value >
                                                                0
                                                            ? Text(
                                                                controller
                                                                            .unityEventList
                                                                            .value
                                                                            .data[
                                                                                index]
                                                                            .entry
                                                                            .fee
                                                                            .type ==
                                                                        'bonus'
                                                                    ? controller
                                                                        .unityEventList
                                                                        .value
                                                                        .data[
                                                                            index]
                                                                        .entry
                                                                        .fee
                                                                        .value
                                                                        .toString()
                                                                    : "${AppString().txt_currency_symbole}${controller.unityEventList.value.data[index].entry.fee.value ~/ 100}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
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
                                                        padding:
                                                            EdgeInsets.only(
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: AppColor()
                                                          .whiteColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 25, left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: AppColor()
                                                            .whiteColor),
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
                                                  "\u{20B9} ${controller.unityEventList.value.data[index].winner.prizeAmount.value ~/ 100}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: "Montserrat",
                                                      color: AppColor()
                                                          .whiteColor),
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
                                  padding: EdgeInsets.only(
                                      bottom: 8, left: 10, top: 5),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Bonus cash Used ".tr,
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
                                            child: _userController
                                                        .getBonuseCashBalanceInt() >=
                                                    controller.unityEventList
                                                        .value.data[index].entry
                                                        .getBonuse()
                                                ? Text(
                                                    "${controller.unityEventList.value.data[index].entry.getBonuse()}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Montserrat",
                                                      color: Colors.white70,
                                                    ),
                                                  )
                                                : Text(
                                                    "${_userController.getBonuseCashBalanceInt()}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Montserrat",
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 165,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image:
                                        AssetImage(ImageRes().list_game_top))),
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
                      )
                    ],
                  ),
                )
              : GestureDetector(
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
                    _contestModel = controller.unityEventList.value.data[index];
                    getPreJoinEvent(
                        controller.unityEventList.value.data[index].id,
                        context,
                        controller.unityEventList.value.data[index].entry.fee
                                    .type ==
                                'bonus'
                            ? controller.unityEventList.value.data[index].entry
                                .fee.value
                            : controller.unityEventList.value.data[index].entry
                                    .fee.value ~/
                                100);
                  },
                  child: Container(
                      height: 120,
                      margin: EdgeInsets.only(
                          bottom: 5, top: 10, right: 10, left: 10),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      controller
                                          .unityEventList.value.data[index].name
                                          .toUpperCase(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
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
                                        bool stateR = await Utils()
                                            .checkResLocation(context);
                                        if (stateR) {
                                          Utils().customPrint(
                                              "LOCATION 11: ---------FAILED");
                                          return;
                                        }
                                      }

                                      _contestModel = controller
                                          .unityEventList.value.data[index];
                                      Utils().customPrint(
                                          'contestAmount unity: ${controller.unityEventList.value.data[index].entry.fee.value}');
                                      getPreJoinEvent(
                                          controller.unityEventList.value
                                              .data[index].id,
                                          context,
                                          controller
                                                      .unityEventList
                                                      .value
                                                      .data[index]
                                                      .entry
                                                      .fee
                                                      .type ==
                                                  'bonus'
                                              ? controller.unityEventList.value
                                                  .data[index].entry.fee.value
                                              : controller
                                                      .unityEventList
                                                      .value
                                                      .data[index]
                                                      .entry
                                                      .fee
                                                      .value ~/
                                                  100);
                                    },
                                    child: Container(
                                      width: 120,
                                      margin: EdgeInsets.only(right: 10),
                                      height: 35,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  ImageRes().new_pay_now)
                                              /* image: AssetImage(
                                        "assets/images/orange_gradient_back.png")*/
                                              ),
                                          /*        border: Border.all(
                                    width: 2, color: AppColor().whiteColor),*/
                                          //color: AppColor().colorPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 10,
                                          ),
                                          Text(
                                            "Play",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: AppColor().whiteColor),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (ApiUrl().isPlayStore ==
                                                  false) {
                                                bool stateR = await Utils()
                                                    .checkResLocation(context);
                                                if (stateR) {
                                                  Utils().customPrint(
                                                      "LOCATION 11: ---------FAILED");
                                                  return;
                                                }
                                              }
                                              _contestModel = controller
                                                  .unityEventList
                                                  .value
                                                  .data[index];
                                              getPreJoinEvent(
                                                  controller.unityEventList
                                                      .value.data[index].id,
                                                  context,
                                                  controller
                                                              .unityEventList
                                                              .value
                                                              .data[index]
                                                              .entry
                                                              .fee
                                                              .type ==
                                                          'bonus'
                                                      ? controller
                                                          .unityEventList
                                                          .value
                                                          .data[index]
                                                          .entry
                                                          .fee
                                                          .value
                                                      : controller
                                                              .unityEventList
                                                              .value
                                                              .data[index]
                                                              .entry
                                                              .fee
                                                              .value ~/
                                                          100);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  right: 10, left: 10),
                                              child: controller
                                                          .unityEventList
                                                          .value
                                                          .data[index]
                                                          .entry
                                                          .fee
                                                          .value >
                                                      0
                                                  ? Text(
                                                      controller
                                                                  .unityEventList
                                                                  .value
                                                                  .data[index]
                                                                  .entry
                                                                  .fee
                                                                  .type ==
                                                              'bonus'
                                                          ? controller
                                                              .unityEventList
                                                              .value
                                                              .data[index]
                                                              .entry
                                                              .fee
                                                              .value
                                                              .toString()
                                                          : "${AppString().txt_currency_symbole} ${controller.unityEventList.value.data[index].entry.fee.value ~/ 100}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: AppColor()
                                                              .whiteColor),
                                                    )
                                                  : Text(
                                                      "Free",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: AppColor()
                                                              .whiteColor),
                                                    ),
                                            ),
                                          )
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
                                        /* Container(
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: AppColor().color_side_menu_header),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                              child:*/
                                        Center(
                                          child: Text(
                                            "\u{20B9} ${controller.unityEventList.value.data[index].winner.prizeAmount.value ~/ 100}",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showWinningBreakupDialog(
                                        context,
                                        controller
                                            .unityEventList.value.data[index]);
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
                                      "Bonus cash Used ".tr,
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
                                      child: _userController
                                                  .getBonuseCashBalanceInt() >=
                                              controller.unityEventList.value
                                                  .data[index].entry
                                                  .getBonuse()
                                          ? Text(
                                              "${controller.unityEventList.value.data[index].entry.getBonuse()}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: Colors.white70,
                                              ),
                                            )
                                          : Text(
                                              "${_userController.getBonuseCashBalanceInt()}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: Colors.white70,
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
                                fontFamily: "Montserrat",
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
                    Text(
                      "\u{20B9} ${(model.winner.prizeAmount.value ~/ 100)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        color: AppColor().colorPrimary,
                      ),
                    ),
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
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      color: Colors.white),
                ),
                Text(
                  list[index].amount.isBonuseType()
                      ? "\u{20B9} ${list[index].amount.value}"
                      : "\u{20B9} ${(list[index].amount.value ~/ 100)}",
                  //"${list[index].amount.isBonuseType()?list[index].amount.value :"\u{20B9} ${(list[index].amount.value ~/ 100)}"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      color: Colors.white),
                ),
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

  Widget listHistoryUnity(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Utils().customPrint("--------> clicked");
        Get.to(() => UnityDetails(url != null ? url : "",
            controller.unity_history_userRegistrations.value, index));
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
                        fontFamily: "Montserrat",
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
                                .rounds[0].result !=
                            null
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
                                fontFamily: "Montserrat",
                                color: AppColor().whiteColor),
                          )
                        : Text(
                            "You Lost",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Montserrat",
                                color: AppColor().whiteColor),
                          )
                    : Text(
                        "Pending",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: url != null && url.isNotEmpty
                              ? Image(
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(url)

                                  // AssetImage('assets/images/images.png'),
                                  )
                              : name.compareTo("Ludo") == 0
                                  ? Image(
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/unity_ludo.png'),
                                    )
                                  : Image(
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/carrom.png'),

                                      // AssetImage('assets/images/images.png'),
                                    ),
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

  Future<Map> getPreJoinEvent(
      String event_id, BuildContext context, int amount) async {
    // Utils().customPrint("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${controller.user_id}");
    final param = {"userId": controller.user_id};
    showProgressUnity(context, '', true);

    Map<String, dynamic> response = await WebServicesHelper()
        .getPreEventJoin(param, controller.token, event_id);
    //print(' respone is finaly ${response}');
    hideProgress(context);
    if (response != null && response['statusCode'] == null) {
      //print(' respone is finaly1 ${response}');
      preJoinResponseModel = PreJoinUnityResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount1 deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          AppString.contestAmount = amount;
          Utils().customPrint('contestAmount unity ${AppString.contestAmount}');
          Utils().alertInsufficientBalance(context);
        } else {
          //  show_winning_breakup(context, event_id, preJoinResponseModel);

          if (amount <= 0) {
            controller.showPreJoinBoxFree(
                name,
                gameid,
                _contestModel,
                preJoinResponseModel,
                _contestModel.entry.fee.type == "bonus"
                    ? _contestModel.entry.fee.value.toString()
                    : "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} "
                        "${_contestModel.entry.fee.value > 0 ? _contestModel.entry.fee.value ~/ 100 : "Free".tr}");
          } else {
            showPreJoinBox(context, event_id, preJoinResponseModel);
          }
        }
      } else {
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(response);
        Utils().showErrorMessage("", appBaseErrorModel.error);
      }
    } else if (response != null &&
        response['statusCode'] != null &&
        response['statusCode'] != 400) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else if (response != null &&
        response['statusCode'] != null &&
        response['statusCode'] != 500) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else {
      Utils().customPrint('respone is finaly2${response}');
      //hideLoader();
    }
  }

  /*void show_winning_breakup(BuildContext context, String event_id,
      PreJoinResponseModel preJoinResponseModel) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 350,
            child: Card(
              color: AppColor().wallet_dark_grey,
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
                              fontFamily: "Montserrat",
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
                    Container(
                      height: 5,
                    ),
                    Text(
                      "CONFIRM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Roboto",
                          color: AppColor().colorPrimary),
                    ),
                    Container(
                      height: 2,
                    ),
                    Text(
                      "CHARGES",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          color: AppColor().whiteColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("ENTRY FEE",
                              style: TextStyle(
                                  color: AppColor().whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: "Roboto")),
                        ),
                        Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 20,
                              child:
                                  Image.asset("assets/images/bonus_coin.png"),
                            ),
                            Text("\u{20B9} ${'0'}",
                                style: TextStyle(color: AppColor().whiteColor))
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("You are paying",
                              style: TextStyle(
                                  color: AppColor().color_side_menu_header,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: "Roboto")),
                        ),
                        Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 20,
                              child:
                                  Image.asset("assets/images/bonus_coin.png"),
                            ),
                            Text(
                              "\u{20B9} ${preJoinResponseModel.deposit.value ~/ 100} ",
                              style: TextStyle(
                                  color: AppColor().color_side_menu_header),
                            )
                          ],
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
                        Container(
                          child: Text("From Bonus Cash",
                              style: TextStyle(
                                  color: AppColor().whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: "Roboto")),
                        ),
                        Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 20,
                              child:
                                  Image.asset("assets/images/bonus_coin.png"),
                            ),
                            Text(
                                "\u{20B9} ${preJoinResponseModel.bonus.value ~/ 100}",
                                style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: "Roboto"))
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Expanded(
                            child: Text("From Deposited Cash & Winning Cash",
                                maxLines: 2,
                                style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: "Roboto")),
                          ),
                        ),
                        Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 20,
                              child:
                                  Image.asset("assets/images/bonus_coin.png"),
                            ),
                            Text(
                                "\u{20B9} ${preJoinResponseModel.deposit.value ~/ 100}",
                                style: TextStyle(color: AppColor().whiteColor))
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    _Button(context, "CONFIRM"),
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
  }*/

  void showPreJoinBox(BuildContext context, String event_id,
      PreJoinUnityResponseModel preJoinResponseModel) {
    var areYouPaying =
        "${((preJoinResponseModel.deposit.value + preJoinResponseModel.winning.value) / 100) + preJoinResponseModel.bonus.value}";
    showGeneralDialog(
      context: context,
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
                            fontFamily: "Montserrat",
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
                            Navigator.pop(navigatorKey.currentState.context);
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
                        fontFamily: "Montserrat",
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
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 20,
                              child:
                                  Image.asset("assets/images/bonus_coin.png"),
                            ),
                            Text(
                                _contestModel.entry.fee.value > 0 &&
                                        _contestModel.entry.fee.type == 'bonus'
                                    ? _contestModel.entry.fee.value.toString()
                                    : "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${_contestModel.entry.fee.value > 0 ? _contestModel.entry.fee.value ~/ 100 : "Free".tr}",
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
                          child: Text("You are paying".tr,
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
                              areYouPaying,
                              style: TextStyle(
                                  color: AppColor().color_side_menu_header),
                            )

                            /* Text(
                              "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${preJoinResponseModel.deposit.value / 100} ",
                              style: TextStyle(
                                  color: AppColor().color_side_menu_header),
                            )*/
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
                          child: Text("From Deposited Cash & Winning Cash".tr,
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
                                "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(preJoinResponseModel.deposit.value / 100 + preJoinResponseModel.winning.value / 100)}",
                                style: TextStyle(color: AppColor().whiteColor))
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _Button(context, "CONFIRM_SAVE".tr),
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

  Widget _Button(BuildContext context, String values) {
    return GestureDetector(
      onTap: () async {
        Utils().customPrint("LOCATION 10: ---------SUCCESS");

        Map<String, Object> map = new Map<String, Object>();
        map["USER_ID"] = controller.user_id;
        map["Game Name"] = _contestModel.name;
        map["Buyin Amount"] = _contestModel.entry.fee.value > 0
            ? _contestModel.entry.fee.value ~/ 100
            : "Free";
        //map["Bonus Application"] = "";
        map["Prize Pool"] = "";
        map["Game Category"] = _contestModel.name;
        map["BONUS_CASH"] = preJoinResponseModel.bonus.value ~/ 100;
        map["WINNING_CASH"] = preJoinResponseModel.winning.value ~/ 100;
        map["DEPOSITE_CASH"] = preJoinResponseModel.deposit.value ~/ 100;
        map["Game Id"] = _contestModel.id;
        map["is_championship"] =
            _contestModel.type.compareTo("championship") == 0 ? "yes" : "No";
        /* map["is_Affilate"] = _contestModel.affiliate != null ? "yes" : "No";
        map["is_championship"] =
            _contestModel.type.compareTo("championship") == 0 ? "yes" : "No";*/

        //calling CT
        cleverTapController.logEventCT(
            EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
        cleverTapController.logEventCT(EventConstant.EVENT_Joined_Contest, map);
        FirebaseEvent()
            .firebaseEvent(EventConstant.EVENT_Joined_Contest_F, map);

        FirebaseEvent().firebaseEvent(
            EventConstant.EVENT_CLEAVERTAB_Joined_Contest_F, map);

        map["Game_id"] = gameid;
        appsflyerController.logEventAf(
            EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);

        appsflyerController.logEventAf(
            EventConstant.EVENT_Joined_Contest, map); //for appsflyer only
        FaceBookEventController().logEventFacebook(
            EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
        //FIREBASE EVENT
        Navigator.pop(navigatorKey.currentState.context);
        controller.OpenUnityGame(
          _contestModel,
          gameid,
          name,
          false,
          _userController.profileDataRes.value.mobile.number.toString(),
          _userController.profileDataRes.value.username,
          _userController.profileDataRes.value.photo != null
              ? _userController.profileDataRes.value.photo.url
              : "",
          _userController.profileDataRes.value.id,
          _userController.profileDataRes.value.email != null
              ? _userController.profileDataRes.value.email.address
              : "",
        );
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

  String getStartTimeHHMMSS(String date_c) {
    return DateFormat("yyyy-MM-dd' 'HH:mm:ss").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date_c, true).toLocal());
  }

  //game contest lootbox
  //new game contest flow loot box

  void alertLookBoxGameContest(int index, String eventID) {
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
                                    _contestModel = controller
                                        .unityEventList.value.data[index];

                                    open_game();
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

  void open_game() {
    Utils().customPrint("LOCATION 10: ---------SUCCESS");

    Map<String, Object> map = new Map<String, Object>();
    map["USER_ID"] = controller.user_id;
    map["Game Name"] = _contestModel.name;
    map["Buyin Amount"] = _contestModel.entry.fee.value > 0
        ? _contestModel.entry.fee.value ~/ 100
        : "Free";
    //map["Bonus Application"] = "";
    map["Prize Pool"] = "";
    map["Game Category"] = _contestModel.name;
    //map["BONUS_CASH"] = preJoinResponseModel.bonus.value ~/ 100;
    //map["WINNING_CASH"] = preJoinResponseModel.winning.value ~/ 100;
    //map["DEPOSITE_CASH"] = preJoinResponseModel.deposit.value ~/ 100;
    map["Game Id"] = _contestModel.id;
    map["is_championship"] =
        _contestModel.type.compareTo("championship") == 0 ? "yes" : "No";

    //calling CT
    cleverTapController.logEventCT(
        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
    cleverTapController.logEventCT(EventConstant.EVENT_Joined_Contest, map);
    FirebaseEvent().firebaseEvent(EventConstant.EVENT_Joined_Contest_F, map);

    FirebaseEvent()
        .firebaseEvent(EventConstant.EVENT_CLEAVERTAB_Joined_Contest_F, map);

    map["Game_id"] = gameid;
    appsflyerController.logEventAf(
        EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);

    appsflyerController.logEventAf(
        EventConstant.EVENT_Joined_Contest, map); //for appsflyer only
    FaceBookEventController()
        .logEventFacebook(EventConstant.EVENT_CLEAVERTAB_Joined_Contest, map);
    //FIREBASE EVENT
    Navigator.pop(navigatorKey.currentState.context);
    controller.OpenUnityGame(
      _contestModel,
      gameid,
      name,
      false,
      _userController.profileDataRes.value.mobile.number.toString(),
      _userController.profileDataRes.value.username,
      _userController.profileDataRes.value.photo != null
          ? _userController.profileDataRes.value.photo.url
          : "",
      _userController.profileDataRes.value.id,
      _userController.profileDataRes.value.email != null
          ? _userController.profileDataRes.value.email.address
          : "",
    );
  }
}
