/*
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/LoginModel/hash_rummy.dart';
import 'package:gmng/model/ProfileModel/ProfileDataR.dart';
import 'package:gmng/model/UserModel.dart';
import 'package:gmng/model/responsemodel/DashboardResposeModel.dart';
import 'package:gmng/model/responsemodel/PreJoinUnityResponseModel.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/common/Progessbar.dart';
import 'package:gmng/ui/controller/BaseController.dart';
import 'package:gmng/ui/controller/Pocket52_Controller.dart';
import 'package:gmng/ui/dialog/helperProgressBar.dart';
import 'package:gmng/ui/main/Clan/Clan.dart';
import 'package:gmng/ui/main/Freakx/FreakxList.dart';
import 'package:gmng/ui/main/GameZop/GameZopList.dart';
import 'package:gmng/ui/main/cash_free/CashFreeScreen.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/ui/main/dashbord/TrendingEvent/ViewAllTrendingEvent.dart';
import 'package:gmng/ui/main/dashbord/ViewAllHomePage.dart';
import 'package:gmng/ui/main/ludo_king/Ludo_King_Screen.dart';
import 'package:gmng/ui/main/profile/Profile.dart';
import 'package:gmng/ui/main/team_management/TeamManagementNew.dart';
import 'package:gmng/ui/main/trago/Trago_Controller.dart';
import 'package:gmng/ui/main/wallet/vip_program_screen.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/FacebookEventApi.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:gmng/webservices/WebServicesHelper.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wakelock/wakelock.dart';

import '../../../../app.dart';
import '../../../../model/AppSettingResponse.dart';
import '../../../../model/HomeModel/HomePageListModel.dart';
import '../../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../../res/FontSizeC.dart';
import '../../../../res/firebase_events.dart';
import '../../../../utills/OnlyOff.dart';
import '../../../../utills/bridge.dart';
import '../../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../../utills/event_tracker/CleverTapController.dart';
import '../../../../utills/event_tracker/EventConstant.dart';
import '../../../../utills/event_tracker/FaceBookEventController.dart';
import '../../../controller/FreshChatController.dart';
import '../../../controller/HomePageController.dart';
import '../../../controller/WalletPageController.dart';
import '../../../controller/user_controller.dart';
import '../../Freakx/FreakxWebview.dart';
import '../../GameZop/GameZopWebview.dart';
import '../../UnitEventList/UnityController.dart';
import '../../UnitEventList/UnityList.dart';
import '../../cash_free/CashFreeController.dart';
import '../../esports/ESports.dart';
import '../../how_to_pay_rummy.dart';
import '../../myteam11_ballabazzi/MyTeam11_Ballbazi_Controller.dart';
import '../../store/Store.dart';
import '../../tamasha_ludo/TamashaListing.dart';
import '../../wallet/OfferWallScreen.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

class _HomeState extends State<Home> with WidgetsBindingObserver {
  //List<String> _demoData;
  UserPreferences userPreferences;
  UserController userController = Get.put(UserController());
  HomePageController controller = Get.put(HomePageController());

  //BallbaziLoginController ballbaziLoginController = Get.put(BallbaziLoginController());
  Pocket52LoginController _pocket52loginController =
      Get.put(Pocket52LoginController());
  BaseController base_controller = Get.put(BaseController());
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  UserModel userModel;
  ProgessDialog progessbar;

  //AppUpdateInfo _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;

  //new code
  PreJoinUnityResponseModel preJoinResponseModel;
  UnityController unity_controller;

  bool team11Clicked = true;

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  bool become_vip_yes = false;
  var prefs;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("get notification done ");
    //  userController.showCustomDialogConfettiNew();

    /*   try {
      print("check call instanc${onlyOffi.instancePoP.value}");

      if (onlyOffi.instancePoP.value) {
        userController.showCustomDialogConfettiNew();
        onlyOffi.instancePoP.value = false;
      } else {
        var instantCashAdded = prefs.getBool("instantCashAdded");
        print("get notification done  instantCashAdded $instantCashAdded");
        if (instantCashAdded != null && instantCashAdded) {
          prefs.setBool("instantCashAdded", false);
          onlyOffi.instancePoP.value = false;
          userController.showCustomDialogConfettiNew();
        }

      }
    } catch (A) {}

      else
        {
          var instantCashAdded = prefs.getBool("instantCashAdded");
          print("get notification done  instantCashAdded $instantCashAdded");
          if (instantCashAdded != null && instantCashAdded) {
            prefs.setBool("instantCashAdded", false);
            onlyOffi.instancePoP.value=false;
            userController.showCustomDialogConfettiNew();


          }
        }

    } catch (A) {}*/

    /*   try {
      if (userController.profileDataRes.value!=null && userController.profileDataRes.value.level.value > 0) {
        prefs = await SharedPreferences.getInstance();
        become_vip_yes = prefs.getBool("become_vip_yes");

        if (become_vip_yes == null || become_vip_yes) {
          prefs.setBool("become_vip_yes", false);
          Utils().VIPCongratulation();
        } else {}
      }
    } catch (E) {}*/
  }

  @override
  Future<void> initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    //checking for app update
    checkForUpdate(); //playstore update

    // Utils().customPrint("initState call ");

    Utils().customPrint('Home initState call');

    progessbar = new ProgessDialog(context);
    userPreferences = new UserPreferences(context);

    //new user journey
    Future.delayed(const Duration(milliseconds: 1000), () {
      Utils().customPrint('getAppSetting ::::: 1 ${AppString.isUserFTR}');
      if (AppString.isUserFTR == true) {
        userController.showCustomDialogConfettiNewFTD();

        Utils().customPrint('getAppSetting ::::: started');
        if (userController.appSettingReponse.value.newUserFlow != null &&
            userController.appSettingReponse.value.newUserFlow.length > 0) {
          Utils().customPrint('getAppSetting ::::: length>0');
          showBottomSheetFTRpopup(context); //popup
        } else {
          Utils().customPrint('getAppSetting ::::: 0');
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 8000), () {
      Utils().customPrint('getAppSetting ::::: 1 ${AppString.isUserFTR}');
      if (AppString.isUserFTR == true) {
        Navigator.pop(navigatorKey.currentState.context);
        AppString.isUserFTR = false;
      }
    });

    //set 0 at initial time
    AppString.contestAmount = 0;
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    userController.getFavGmae();
    /*if (ApiUrl().isPlayStore) {
      Utils().checkLocationEsportS();
    }*/

    userController.getProfileData();
    userController.getUserProfileSummary();
    userController.getWalletAmount();
    //  if (ApiUrl().isPlayStore == false) {
    userController.getForceUpdate(context);
    //}
    Utils().customPrint("build call ");
    Utils().customPrint(
        "gamesMyFavSelected values call ${onlyOffi.gamesMyFavSelected.value != null ? onlyOffi.gamesMyFavSelected.value.length : "ca"}");

    /*  if (Utils.stateV.value == null || Utils.stateV.value.isEmpty) {
      Utils().getLocationPer().then((value) => Utils().getCurrentLocation());
    }*/
    Future<bool> _onWillPop() async {
      return true;
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () async {
          setState(() {
            userController.getWalletAmount();
            controller.getHomePage();
            // userController.getFavGmae();
            //_demoData.addAll(["", ""]);
          });
        });
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Column(
                  children: [
                    Obx(
                      () =>
                          controller.homePageListModel.value != null &&
                                  controller.homePageListModel.value.banners !=
                                      null &&
                                  controller.homePageListModel.value.banners
                                          .length >
                                      0
                              ? Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: controller.ftdCheck.value
                                      ? CarouselSlider(
                                          items:
                                              controller.homePageListModel.value
                                                  .banners
                                                  .map(
                                                    (item) => InkWell(
                                                      onTap: () async {
                                                        vipBannerClick(item);
                                                      },
                                                      child: controller
                                                                  .currentIndexSlider
                                                                  .value ==
                                                              0
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 6,
                                                                      left: 6,
                                                                      top: 11),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      /* border: Border.all(
                                                        color: Colors.white,
                                                        width: 0),*/
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 15,
                                                                                top: 0,
                                                                                bottom: 0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text("${AppString().txt_currency_symbole}",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                      fontSize: 48,
                                                                                      fontFamily: "Inter",
                                                                                      height: 1.0,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Colors.white,
                                                                                    )),
                                                                                Text("${controller.selectAmount.value}",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                      fontSize: 48,
                                                                                      fontFamily: "Montserrat",
                                                                                      height: 1.0,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Colors.white,
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                0,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 15,
                                                                                top: 0,
                                                                                bottom: 0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text("+ ",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                      fontSize: 24,
                                                                                      fontFamily: "Montserrat",
                                                                                      height: 1.0,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: AppColor().banner_cash,
                                                                                    )),
                                                                                Text("${controller.youWillGet.value}",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                      fontSize: 24,
                                                                                      fontFamily: "Montserrat",
                                                                                      height: 1.0,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: AppColor().banner_cash,
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )),
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Image.asset(
                                                                                  ImageRes().stopwatch,
                                                                                  width: 23,
                                                                                  height: 23,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Column(
                                                                                  children: [
                                                                                    Text("Expires in",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          fontSize: FontSizeC().front_very_small_S_9,
                                                                                          color: AppColor().whiteColor,
                                                                                          fontFamily: "Montserrat",
                                                                                          fontWeight: FontWeight.w500,
                                                                                        )),
                                                                                    TweenAnimationBuilder<Duration>(
                                                                                        duration: Duration(seconds: Utils().subtractDate()),
                                                                                        tween: Tween(begin: Duration(seconds: Utils().subtractDate()), end: Duration.zero),
                                                                                        onEnd: () {
                                                                                          Utils().customPrint('Timer ended');
                                                                                          //walletPageController.isExpired.value = true;
                                                                                        },
                                                                                        builder: (BuildContext context, Duration value, Widget child) {
                                                                                          String seconds = (value.inSeconds % 60).toInt().toString().padLeft(2, '0');
                                                                                          String minutes = ((value.inSeconds / 60) % 60).toInt().toString().padLeft(2, '0');
                                                                                          String hours = (value.inSeconds ~/ 3600).toString().padLeft(2, '0');

                                                                                          return Padding(
                                                                                              padding: const EdgeInsets.symmetric(vertical: 2),
                                                                                              child: Text("$hours\:$minutes\:$seconds",
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 13,
                                                                                                    fontFamily: "Montserrat",
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: AppColor().banner_timer,
                                                                                                  )));
                                                                                        }),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 16),
                                                                            child:
                                                                                userController.ShowButton(""),
                                                                          )
                                                                        ],
                                                                      ))
                                                                ],
                                                              ),
                                                            )
                                                          : Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      6),
                                                              child: Center(
                                                                child:
                                                                    ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          height:
                                                                              100,
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          imageUrl: item
                                                                              .image
                                                                              .url,
                                                                          errorWidget: (context, url, error) =>
                                                                              Icon(Icons.error),
                                                                        )),
                                                              ),
                                                            ),
                                                    ),
                                                  )
                                                  .toList(),
                                          options: CarouselOptions(
                                            height: 120.0,
                                            autoPlay: controller
                                                        .currentIndexSlider
                                                        .value ==
                                                    0
                                                ? false
                                                : true,
                                            disableCenter: true,
                                            viewportFraction: 1,
                                            aspectRatio: 3,
                                            enlargeCenterPage: false,
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enableInfiniteScroll: true,
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 1000),
                                            onPageChanged: (index, reason) {
                                              controller.currentIndexSlider
                                                  .value = index;
                                            },
                                          ),
                                        )
                                      : controller.vipCheck.value
                                          ? CarouselSlider(
                                              items:
                                                  controller.homePageListModel
                                                      .value.banners
                                                      .map(
                                                        (item) => InkWell(
                                                          onTap: () async {
                                                            if (controller
                                                                    .collectAmtVipNextLevel
                                                                    .value !=
                                                                "") {
                                                              Get.to(() =>
                                                                  VipProgramScreen());
                                                            } else {
                                                              vipBannerClick(
                                                                  item);
                                                            }
                                                          },
                                                          child: controller
                                                                      .currentIndexSlider
                                                                      .value ==
                                                                  0
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              6,
                                                                          left:
                                                                              6,
                                                                          top:
                                                                              11),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 15, top: 0, bottom: 0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Text("${AppString().txt_currency_symbole}",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          fontSize: 45,
                                                                                          fontFamily: "Inter",
                                                                                          height: 1.0,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.white,
                                                                                        )),
                                                                                    Text("${controller.selectAmount.value}",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          fontSize: 45,
                                                                                          fontFamily: "Montserrat",
                                                                                          height: 1.0,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.white,
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 0,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 15, top: 0, bottom: 0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Text("+ ",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          fontSize: 18,
                                                                                          fontFamily: "Montserrat",
                                                                                          height: 1.0,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: AppColor().banner_cash,
                                                                                        )),
                                                                                    Text("${controller.youWillGet.value}",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          fontSize: 15,
                                                                                          fontFamily: "Montserrat",
                                                                                          height: 1.0,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: AppColor().banner_cash,
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                      Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.center,
                                                                                child: controller.collectAmtVipNextLevel.value != ""
                                                                                    ? Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Text(controller.collectAmtVipNextLevel.value.contains("-") ? "" : "Collect \u{20B9}${controller.collectAmtVipNextLevel.value}",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                              fontSize: 14,
                                                                                              fontFamily: "Montserrat",
                                                                                              fontWeight: FontWeight.w700,
                                                                                              color: AppColor().banner_timer,
                                                                                            )))
                                                                                    : Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: 10,
                                                                                          ),
                                                                                          Image.asset(
                                                                                            ImageRes().stopwatch,
                                                                                            width: 23,
                                                                                            height: 23,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 5,
                                                                                          ),
                                                                                          Column(
                                                                                            children: [
                                                                                              Text("Expires in",
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: TextStyle(
                                                                                                    fontSize: FontSizeC().front_very_small_S_9,
                                                                                                    color: AppColor().whiteColor,
                                                                                                    fontFamily: "Montserrat",
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  )),
                                                                                              TweenAnimationBuilder<Duration>(
                                                                                                  duration: Duration(seconds: Utils().subtractDate()),
                                                                                                  tween: Tween(begin: Duration(seconds: Utils().subtractDate()), end: Duration.zero),
                                                                                                  onEnd: () {
                                                                                                    Utils().customPrint('Timer ended');
                                                                                                    //walletPageController.isExpired.value = true;
                                                                                                  },
                                                                                                  builder: (BuildContext context, Duration value, Widget child) {
                                                                                                    String seconds = (value.inSeconds % 60).toInt().toString().padLeft(2, '0');
                                                                                                    String minutes = ((value.inSeconds / 60) % 60).toInt().toString().padLeft(2, '0');
                                                                                                    String hours = (value.inSeconds ~/ 3600).toString().padLeft(2, '0');

                                                                                                    return Padding(
                                                                                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                                                                                        child: Text("$hours\:$minutes\:$seconds",
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 13,
                                                                                                              fontFamily: "Montserrat",
                                                                                                              fontWeight: FontWeight.w700,
                                                                                                              color: AppColor().banner_timer,
                                                                                                            )));
                                                                                                  }),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: 16),
                                                                                child: userController.ShowButton(controller.collectAmtVipNextLevel.value),
                                                                              )
                                                                            ],
                                                                          ))
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(
                                                                  margin: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          6),
                                                                  child: Center(
                                                                    child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                        child: CachedNetworkImage(
                                                                          height:
                                                                              100,
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          imageUrl: item
                                                                              .image
                                                                              .url,
                                                                          errorWidget: (context, url, error) =>
                                                                              Icon(Icons.error),
                                                                        )),
                                                                  ),
                                                                ),
                                                        ),
                                                      )
                                                      .toList(),
                                              options: CarouselOptions(
                                                height: 120.0,
                                                autoPlay: controller
                                                            .currentIndexSlider
                                                            .value ==
                                                        0
                                                    ? false
                                                    : true,
                                                disableCenter: true,
                                                viewportFraction: 1,
                                                aspectRatio: 3,
                                                enlargeCenterPage: false,
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                enableInfiniteScroll: true,
                                                autoPlayAnimationDuration:
                                                    Duration(
                                                        milliseconds: 1000),
                                                onPageChanged: (index, reason) {
                                                  controller.currentIndexSlider
                                                      .value = index;
                                                },
                                              ),
                                            )
                                          : CarouselSlider(
                                              items: controller
                                                  .homePageListModel
                                                  .value
                                                  .banners
                                                  .map(
                                                    (item) => InkWell(
                                                      onTap: () async {
                                                        normalBannerClick(item);
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
                                                                height: 100,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                fit:
                                                                    BoxFit.fill,
                                                                imageUrl: item
                                                                    .image.url,
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
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
                                                  controller.currentIndexSlider
                                                      .value = index;
                                                },
                                              ),
                                            ),
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
                                ),
                    ),
                    Obx(
                      () => controller.homePageListModel.value != null &&
                              controller.homePageListModel.value.banners !=
                                  null &&
                              controller
                                      .homePageListModel.value.banners.length >
                                  0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: controller
                                  .homePageListModel.value.banners
                                  .map(
                                (image) {
                                  int index = controller
                                      .homePageListModel.value.banners
                                      .indexOf(image);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: controller
                                                    .currentIndexSlider.value ==
                                                index
                                            ? controller.appBtnBgColor.value
                                            : controller.appBtnTxtColor.value),
                                  );
                                },
                              ).toList(), // this was the part the I had to add
                            )
                          : Text(""),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 140),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Show fav game List here

                        /*    Obx(
                              () => onlyOffi.gamesMyFavSelected.value !=
                              null &&
                                  onlyOffi.gamesMyFavSelected.length > 0
                              ? Padding(
                              padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15.0),
                                    child: new Text(
                                      "My Favourite Games",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize:
                                        FontSizeC().front_medium,
                                        fontFamily: "Montserrat",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                        () => (onlyOffi.gamesMyFavSelected
                                        .value !=
                                        null &&
                                            onlyOffi.gamesMyFavSelected
                                            .length >
                                            0)
                                        ? InkWell(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                            msg: 'No Data!');
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 10),
                                        padding:
                                        const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 5,
                                            left: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(5),
                                            border: Border.all(
                                                color: AppColor()
                                                    .whiteColor,
                                                width: .8)),
                                        child: Text(
                                          "View All".tr,
                                          textAlign:
                                          TextAlign.center,
                                          style: TextStyle(
                                            //  decoration: TextDecoration.underline,
                                            fontSize: FontSizeC()
                                                .front_very_small,
                                            color: AppColor()
                                                .whiteColor,
                                            fontFamily:
                                            "Montserrat",

                                            fontWeight:
                                            FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    )
                                        : SizedBox(
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ))
                              : Container(),
                        ),
                        Obx(
                              () => (onlyOffi.gamesMyFavSelected.value != null &&
                                  onlyOffi.gamesMyFavSelected.length > 0)
                              ? Container(
                              height: 120,
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child:
                              onlyOffi.gamesMyFavSelected.value !=
                                  null &&
                                  onlyOffi.gamesMyFavSelected
                                      .length >
                                      0
                                  ? ListView.builder(
                                  scrollDirection:
                                  Axis.horizontal,
                                  itemCount: onlyOffi
                                      .gamesMyFavSelected
                                      .length,
                                  itemBuilder:
                                      (BuildContext context,
                                      index) {
                                    return listGameShowPopUpList(
                                        context, index);
                                  })
                                  : Shimmer.fromColors(
                                child: Container(
                                  margin: const EdgeInsets
                                      .symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(
                                        8),
                                  ),
                                  height: 120,
                                  width:
                                  MediaQuery.of(context)
                                      .size
                                      .width,
                                ),
                                baseColor: Colors.grey
                                    .withOpacity(0.2),
                                highlightColor: Colors.grey
                                    .withOpacity(0.4),
                                enabled: true,
                              ))
                              : Container(),
                        ),
                        SizedBox(height: 10),*/
                        Column(
                          children: [
                            Obx(
                              () => controller.homePageListModel.value !=
                                          null &&
                                      controller.homePageListModel.value
                                              .trendingEvents !=
                                          null &&
                                      controller.homePageListModel.value
                                              .trendingEvents.length >
                                          0
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(15.0),
                                            child: new Text(
                                              "Trending Events".tr,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize:
                                                    FontSizeC().front_medium,
                                                fontFamily: "Montserrat",
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => (controller
                                                            .homePageListModel !=
                                                        null &&
                                                    controller.homePageListModel
                                                            .value !=
                                                        null &&
                                                    controller
                                                            .homePageListModel
                                                            .value
                                                            .trendingEvents !=
                                                        null &&
                                                    controller
                                                            .homePageListModel
                                                            .value
                                                            .trendingEvents
                                                            .length >
                                                        3)
                                                ? InkWell(
                                                    onTap: () {
                                                      // showBottomSheetInfo(context);
                                                      if (userController
                                                              .showProgressDownloade ==
                                                          false) {
                                                        if (userController
                                                                .showProgressDownloade ==
                                                            false) {
                                                          Get.to(() =>
                                                              ViewAllTrendingEvent(
                                                                  controller
                                                                      .homePageListModel
                                                                      .value
                                                                      .trendingEvents));
                                                        }
                                                      } else {}
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5,
                                                              right: 5,
                                                              left: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: AppColor()
                                                                  .whiteColor,
                                                              width: .8)),
                                                      child: Text(
                                                        "View All".tr,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          //  decoration: TextDecoration.underline,
                                                          fontSize: FontSizeC()
                                                              .front_very_small,
                                                          color: AppColor()
                                                              .whiteColor,
                                                          fontFamily:
                                                              "Montserrat",

                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 0,
                                                  ),
                                          ),
                                        ],
                                      ))
                                  : Container(),
                            ),
                            Obx(
                              () => (controller.homePageListModel != null &&
                                      controller.homePageListModel.value !=
                                          null &&
                                      controller.homePageListModel.value.trendingEvents !=
                                          null &&
                                      controller.homePageListModel.value
                                              .trendingEvents.length >
                                          0)
                                  ? Container(
                                      height: 200,
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: controller.homePageListModel.value !=
                                              null
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: (controller.homePageListModel != null &&
                                                      controller
                                                              .homePageListModel
                                                              .value !=
                                                          null &&
                                                      controller
                                                              .homePageListModel
                                                              .value
                                                              .trendingEvents !=
                                                          null &&
                                                      controller
                                                              .homePageListModel
                                                              .value
                                                              .trendingEvents
                                                              .length >
                                                          0)
                                                  ? controller
                                                      .homePageListModel
                                                      .value
                                                      .trendingEvents
                                                      .length
                                                  : 0,
                                              itemBuilder:
                                                  (BuildContext context, index) {
                                                return trendingEventList(
                                                    context, index);
                                              })
                                          : Shimmer.fromColors(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                height: 200,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                              baseColor:
                                                  Colors.grey.withOpacity(0.2),
                                              highlightColor:
                                                  Colors.grey.withOpacity(0.4),
                                              enabled: true,
                                            ))
                                  : Container(),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Obx(
                          () => controller.homePageListModel.value != null
                              ? ListView.builder(
                                  //physics: const NeverScrollableScrollPhysics(),
                                  //  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: (controller.homePageListModel !=
                                              null &&
                                          controller.homePageListModel.value !=
                                              null &&
                                          controller.homePageListModel.value
                                                  .gameCategories !=
                                              null &&
                                          controller.homePageListModel.value
                                                  .gameCategories.length >
                                              0)
                                      ? controller.homePageListModel.value
                                          .gameCategories.length
                                      : 0,
                                  itemBuilder: (context, index) {
                                    return gameCategoryCall(context, index);
                                  })
                              : Shimmer.fromColors(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: 6,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return listShimmer();
                                      }),
                                  baseColor: Colors.grey.withOpacity(0.2),
                                  highlightColor: Colors.grey.withOpacity(0.4),
                                  enabled: true,
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> getUserDetails() async {
    await userPreferences.getUserModel().then((data) => {
          this.userModel = data,
          requestForGetDashboard(),
        });
  }

  _printLatestValue(String values) {
    Utils().customPrint("Second text field: ${values}");
  }

  _showProgessBar() {
    progessbar.setMessage("please wait ..");
    progessbar.show();
  }

  _hideProgessBar() {
    progessbar.hide();
  }

  Future<void> requestForGetDashboard() async {
    try {
      final param = {
        'data': {
          "userid": userModel.Userid.toString(),
        },
        "method": "dashboard",
      };

      String auth = Utils().genrateBasicAuth(
          userModel.Userid.toString(), userModel.authenticationkey);
      Map<String, dynamic> responsestr =
          await WebServicesHelper.requestForGetDashboard(param, auth);
      DashboardResposeModel responseModel =
          DashboardResposeModel.fromMap(responsestr);

      if (responseModel != null &&
          responseModel.error == false &&
          responseModel.data != null) {
        _hideProgessBar();
        Utils.showCustomTosst(responsestr['message']);
      } else {
        Utils.showCustomTosst(responsestr['message']);
      }
    } catch (e) {
      Utils().customPrint(e.toString());
      _hideProgessBar();
    }
  }

  Widget ESportList(BuildContext context, int index) {
    return Obx(
      () => GestureDetector(
          onTap: () {
            Utils().customPrint("------------------1------------------");
            Get.to(() => ESports(
                controller.esports_model_v.value.data[index].id,
                controller.esports_model_v.value.data[index].banner.url,
                controller.esports_model_v.value.data[index].howToPlayUrl,
                ""));
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  imageUrl:
                      controller.esports_model_v.value.data[index].banner.url,
                )),
          )),
    );
  }

  Widget gameCategoryCall(BuildContext context, int indexfirst) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => controller.homePageListModel.value != null &&
                          controller.homePageListModel.value
                                  .gameCategories[indexfirst].games.length >
                              0
                      ? Container(
                          padding: const EdgeInsets.only(
                              top: 5, left: 15, bottom: 8),
                          child: new Text(
                            "${controller.homePageListModel.value.gameCategories[indexfirst].name}"
                                .tr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: FontSizeC().front_medium,
                              fontFamily: "Montserrat",
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      : Container(
                          height: 0,
                        ),
                ),
                /* Obx(
                  () => controller.homePageListModel.value
                              .gameCategories[indexfirst].games.length >
                          3
                      ? GestureDetector(
                          onTap: () {
                            */ /*  userController. getLocationPer()
                                .then((value) => userController.getCurrentLocation());*/ /*
                            // showBottomSheetInfo( context);
                            if (userController.showProgressDownloade == false) {
                              Get.to(() => ViewAllHomePages(
                                  controller.homePageListModel.value
                                      .gameCategories[indexfirst],
                                  controller.homePageListModel.value
                                      .gameCategories[indexfirst].name));
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, right: 5, left: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: AppColor().whiteColor, width: .8)),
                            child: new Text(
                              "View All".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                //  decoration: TextDecoration.underline,
                                fontSize: FontSizeC().front_very_small,
                                color: AppColor().whiteColor,
                                fontFamily: "Montserrat",

                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ),*/
              ],
            )),
        Container(
          //height: 320,
          padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
          child: controller.homePageListModel.value != null
              ? controller.homePageListModel.value.gameCategories[indexfirst]
                          .games.length >
                      0
                  ? /*ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.homePageListModel.value
                          .gameCategories[indexfirst].games.length,
                      itemBuilder: (BuildContext context, index) {
                        return listGameShow(context, indexfirst, index);
                      })*/

                  GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 20,
                      children: List.generate(
                          controller
                              .homePageListModel
                              .value
                              .gameCategories[indexfirst]
                              .games
                              .length, (index) {
                        return listGameShow(context, indexfirst, index);
                      }))
                  : Container(
                      height: 0,
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
                      image: AssetImage("assets/images/progresbar_images.gif")),
                )),
        ),
      ],
    );
  }

  listGameShow(BuildContext context, int indexfirst, int index) {
    return InkWell(
      onTap: () async {
        print("click check");
        final params = {
          "event_name": controller.homePageListModel.value
              .gameCategories[indexfirst].games[index].name,
          "event_time": "${DateTime.now().millisecondsSinceEpoch}",
          "event_id": controller.homePageListModel.value
              .gameCategories[indexfirst].games[index].id,
          "action_source": "App",
          "user_data": {
            "client_ip_address": "",
            "client_user_agent": "",
            "external_id": [userController.user_id],
          },
          "custom_data": {}
        };
        FacebookEventApi().FacebookEventC(params);

        /*    AppString.gameName = controller.homePageListModel.value
              .gameCategories[indexfirst].games[index].name;*/
        /* Utils().customPrint(
              "game cateroy name===>${controller.homePageListModel.value.gameCategories[indexfirst].name}");
          Utils().customPrint(
              "game name===>${controller.homePageListModel.value.gameCategories[indexfirst].games[index].name}");

          Utils().customPrint(
              "isRMG===>${controller.homePageListModel.value.gameCategories[indexfirst].isRMG}");*/

        if (!controller
            .homePageListModel.value.gameCategories[indexfirst].isRMG) {
          //Esport
          updateEventGame(controller.homePageListModel.value
              .gameCategories[indexfirst].games[index].name);

          if (controller.homePageListModel.value.gameCategories[indexfirst]
              .games[index].isClickable) {
            /*  Utils().customPrint("------------------2------------------");
              Utils().customPrint(
                  "------------------ ${controller.esports_model_v.value.data[index].howToPlayUrl}");*/
            Get.to(() => ESports(
                  controller.homePageListModel.value.gameCategories[indexfirst]
                      .games[index].id,
                  controller.homePageListModel.value.gameCategories[indexfirst]
                      .games[index].banner.url,
                  controller.homePageListModel.value.gameCategories[indexfirst]
                      .games[index].howToPlayUrl,
                  "",
                ));
          }
        } else {
          if (controller.homePageListModel.value.gameCategories[indexfirst]
                  .games[index].thirdParty !=
              null) {
            updateEventGame(controller.homePageListModel.value
                .gameCategories[indexfirst].games[index].name);

            /*        Utils().customPrint(
                  '${controller.homePageListModel.value.gameCategories[indexfirst].games[index].thirdParty.name}');*/

            if (controller.homePageListModel.value.gameCategories[indexfirst]
                .games[index].isClickable) {
              /*  debugPrint(
                    "object call data name ${controller.homePageListModel.value.gameCategories[indexfirst].games[index].thirdParty.name}");*/

              if (ApiUrl().isPlayStore == false) {
                bool stateR = await Utils().checkResLocation(context);
                if (stateR) {
                  return;
                }
              }

              if (controller.homePageListModel.value.gameCategories[indexfirst]
                      .games[index].name ==
                  'FANTASY') {
                MyTeam11_Ballbazi_Controller team11Controller =
                    Get.put(MyTeam11_Ballbazi_Controller());
                await team11Controller.getLoginTeam11BB(
                    context, '62de6babd6fc1704f21b0ab4');
              } else if (controller
                      .homePageListModel
                      .value
                      .gameCategories[indexfirst]
                      .games[index]
                      .thirdParty
                      .name ==
                  'MyTeam11') {
                try {
                  if (team11Clicked) {
                    team11Clicked = false;
                    MyTeam11_Ballbazi_Controller team11Controller =
                        Get.put(MyTeam11_Ballbazi_Controller());

                    await team11Controller.getLoginTeam11BB(
                        context,
                        controller.homePageListModel.value
                            .gameCategories[indexfirst].games[index].id);
                    team11Clicked = true;
                  }
                } catch (A) {}

                //  ballbaziLoginController.getLoginBallabzi(context);
              } else if (controller
                      .homePageListModel
                      .value
                      .gameCategories[indexfirst]
                      .games[index]
                      .thirdParty
                      .name ==
                  'Trago') {
                Trago_Controller tragoController = Get.put(Trago_Controller());

                tragoController.getLoginTrago(
                    context,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].id);
              } else if (controller
                      .homePageListModel
                      .value
                      .gameCategories[indexfirst]
                      .games[index]
                      .thirdParty
                      .name ==
                  'Pocket52') {
                if (Platform.isIOS) {
                  Fluttertoast.showToast(msg: "Coming soon");
                } else {
                  _pocket52loginController.getLoginWithPocket52(context);
                }
              } else if (controller
                      .homePageListModel
                      .value
                      .gameCategories[indexfirst]
                      .games[index]
                      .thirdParty
                      .name ==
                  'Rummy') {
                //Utils().customPrint('Rummy Starting...');

                final param = {"state": "haryana", "country": "india"};
                getHashForRummy(param);

                //Utils().customPrint('Rummy Launching...');
                //Fluttertoast.showToast(msg: 'Rummy Launching...');
              } else if (controller
                      .homePageListModel
                      .value
                      .gameCategories[indexfirst]
                      .games[index]
                      .thirdParty
                      .name ==
                  'Ludo King') {
                Get.to(() => LudoKingScreen(
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].id,
                    "",
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].howToPlayUrl));
              } else if (controller
                      .homePageListModel
                      .value
                      .gameCategories[indexfirst]
                      .games[index]
                      .thirdParty
                      .name ==
                  'Gamezop') {
                print("pool click values");

                Get.to(() => GameJobList(
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].id,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].banner.url,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].name));
              } else if (controller
                      .homePageListModel
                      .value
                      .gameCategories[indexfirst]
                      .games[index]
                      .thirdParty
                      .name ==
                  'Freakx') {
                Get.to(() => FreakxList(
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].id,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].banner.url,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].name));
              } else if (controller
                      .homePageListModel
                      .value
                      .gameCategories[indexfirst]
                      .games[index]
                      .thirdParty
                      .name ==
                  'Ludot') {
                Get.to(() => TamashaListing(
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].id,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].banner.url,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].name));
                /*    Get.to(() => FreakxList(
                      controller.homePageListModel.value
                          .gameCategories[indexfirst].games[index].id,
                      controller.homePageListModel.value
                          .gameCategories[indexfirst].games[index].banner.url,
                      controller.homePageListModel.value
                          .gameCategories[indexfirst].games[index].name));*/
              }
            }

//  Remove when go live
            /*if (controller.homePageListModel.value.gameCategories[indexfirst]
                      .games[index].thirdParty.name ==
                  'Gamezop') {
                Get.to(() => GameJobList(
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].id,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].banner.url,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].name));
              }*/
          } else {
            Utils().customPrint('Unity App ');
            updateEventGame(controller.homePageListModel.value
                .gameCategories[indexfirst].games[index].name);
            if (controller.homePageListModel.value.gameCategories[indexfirst]
                .games[index].isClickable) {
              Get.to(() => UnityList(
                  controller.homePageListModel.value.gameCategories[indexfirst]
                      .games[index].id,
                  controller.homePageListModel.value.gameCategories[indexfirst]
                      .games[index].banner.url,
                  controller.homePageListModel.value.gameCategories[indexfirst]
                      .games[index].name));
            }
          }
        }
      },
      child: Container(
          padding: const EdgeInsets.only(right: 10, left: 4, top: 4, bottom: 4),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                height: 100,
                width: 110,
                fit: BoxFit.fill,
                imageUrl: controller.homePageListModel.value
                    .gameCategories[indexfirst].games[index].banner.url,
                /*    placeholder: (context, url) => Image(
                  image: NetworkImage(controller.homePageListModel.value
                      .gameCategories[indexfirst].games[index].banner.url),
                ),*/
                errorWidget: (context, url, error) => Icon(Icons.error),
              )

              /*Image(
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                image: NetworkImage(
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].games[index].banner.url),
              )*/
              )),
    );
  }

  /*"${ApiUrl.API_URLB}" +*/
  Widget trendingEventList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (userController.showProgressDownloade == false) {
          String gameid = controller
              .homePageListModel.value.trendingEvents[index].gameId.id;
          if (controller.homePageListModel.value.gameCategories != null &&
              controller.homePageListModel.value.gameCategories.length > 0) {
            for (int i = 0;
                i < controller.homePageListModel.value.gameCategories.length;
                i++) {
              for (int j = 0;
                  j <
                      controller.homePageListModel.value.gameCategories[i].games
                          .length;
                  j++) {
                Games game = controller
                    .homePageListModel.value.gameCategories[i].games[i];

                if (game.id == gameid) {
                  Utils().customPrint("Found game ${game.name}");
                  Utils().customPrint("------------------3------------------");
                  Get.to(() => ESports(
                        game.id,
                        game.banner != null ? game.banner.url : "",
                        game.howToPlayUrl,
                        controller
                            .homePageListModel.value.trendingEvents[index].id,
                      ));
                  break;
                }
              }
            }
          }
        }
      },
      child: Container(
        width: 135,
        padding: const EdgeInsets.only(right: 10, left: 4, top: 4, bottom: 0),
        child: Column(
          children: [
            Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: controller.homePageListModel.value
                                .trendingEvents[index].banner !=
                            null
                        ? CachedNetworkImage(
                            height: 110,
                            width: 135,
                            fit: BoxFit.cover,
                            imageUrl: controller.homePageListModel.value
                                .trendingEvents[index].banner.url,
                          )
                        : Image(
                            height: 110,
                            width: 135,
                            fit: BoxFit.cover,
                            image:
                                AssetImage(ImageRes().logo_login_tranparnt)))),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Container(
                // width: 100,
                padding:
                    const EdgeInsets.only(right: 0, left: 7, top: 0, bottom: 0),
                color: AppColor().blackColor,
                margin: EdgeInsets.only(left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Win",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              color: AppColor().whiteColor,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300,
                            )),
                        Text(
                            " ${AppString().txt_currency_symbole} ${controller.homePageListModel.value.trendingEvents[index].winner.prizeAmount.value ~/ 100}",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              color: AppColor().whiteColor,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text("Entry",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              // color: AppColor().whiteColor,
                              fontFamily: "Montserrat",
                              color: AppColor().whiteColor,
                              fontWeight: FontWeight.w300,
                            )),
                        Text(
                            " ${AppString().txt_currency_symbole} ${controller.homePageListModel.value.trendingEvents[index].entry.fee.value}",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              // color: AppColor().whiteColor,
                              fontFamily: "Montserrat",
                              color: AppColor().whiteColor,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Image(
                          height: 20,
                          width: 15,
                          fit: BoxFit.cover,
                          color: Colors.white70,
                          image: AssetImage(ImageRes().trophy_dash),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                            "${controller.homePageListModel.value.trendingEvents[index].gameId.name}",
                            style: TextStyle(
                              color: AppColor().colorPrimary,
                              fontSize: FontSizeC().front_very_small,
                              // color: AppColor().whiteColor,
                              fontFamily: "Montserrat",

                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 13,
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

  Widget listShimmer() {
    return Column(
      children: [
        Container(
          height: 50,
        ),
        Container(
          height: 120,
        )
      ],
    );
  }

  void updateEventGame(String game_name) {
    Map<String, dynamic> map;
    map = {"Game_Name": game_name};
    appsflyerController.logEventAf(
        EventConstant.EVENT_CLEAVERTAB_GAME_CLICKED, map);
    FaceBookEventController()
        .logEventFacebook(EventConstant.EVENT_CLEAVERTAB_GAME_CLICKED, map);
    cleverTapController.logEventCT(
        EventConstant.EVENT_CLEAVERTAB_GAME_CLICKED, map);
    FirebaseEvent()
        .firebaseEvent(EventConstant.EVENT_CLEAVERTAB_GAME_CLICKED_F, map);
  }

  void clickOnBanner(BannersDashBoard banner) {
    Map<String, Object> map = new Map<String, Object>();
    map["USER_ID"] = userController.user_id;

    cleverTapController.logEventCT(
        EventConstant.EVENT_CLEAVERTAB_BANNER_CLICK, map);
    FirebaseEvent()
        .firebaseEvent(EventConstant.EVENT_CLEAVERTAB_BANNER_CLICK_F, map);

    map[EventConstant.PARAM_BANNER_ID] = banner.id;
    map[EventConstant.PARAM_BANNER_NAME] = banner.name;
    map[EventConstant.PARAM_SCREEN_NAME] = "HOME";

    appsflyerController.logEventAf(
        EventConstant.EVENT_CLEAVERTAB_BANNER_CLICK, map);
  }

  //new pop-up for FTR user
/*
  Widget showBottomSheetFTRpopup(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration:  BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageRes().new_user_bottom_bg),
                    fit: BoxFit.fitWidth,
                  ),
                    color: Colors.black,
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
                        Text("     "),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Quick Play",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
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
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Container(
                        height: 160,
                        child: ListView.builder(
                            itemCount: userController
                                .appSettingReponse.value.newUserFlow.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              //return Obx(() => pop_up_ftr(index));
                              return pop_up_ftr(index);
                            }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("     "),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "Play free with BONUS!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                        ),
                        Text("     "),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
*/
  Widget showBottomSheetFTRpopup(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageRes().new_user_bottom_bg),
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                    ),
                    Row(
                      children: [
                        userController.appSettingReponse.value.newUserFlow
                                    .length >
                                0
                            ? Expanded(
                                child: Column(
                                children: [
                                  Container(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                              bottomLeft: Radius.circular(8)),
                                          child: userController
                                                      .appSettingReponse
                                                      .value
                                                      .newUserFlow[0]
                                                      .img !=
                                                  null
                                              ? CachedNetworkImage(
                                                  height: 110,
                                                  width: 135,
                                                  fit: BoxFit.cover,
                                                  imageUrl: userController
                                                      .appSettingReponse
                                                      .value
                                                      .newUserFlow[0]
                                                      .img,
                                                )
                                              : Image(
                                                  height: 110,
                                                  width: 135,
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      ImageRes().team_img)))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      for (GameCategories objMain in controller
                                          .homePageListModel
                                          .value
                                          .gameCategories) {
                                        if (objMain.name == 'Esports') {
                                          for (Games objSub in objMain.games) {
                                            if (objSub.id ==
                                                userController
                                                    .appSettingReponse
                                                    .value
                                                    .newUserFlow[0]
                                                    .gameId) {
                                              Map<String, String> map = {
                                                "Game Name": "ESports",
                                                "USER_ID":
                                                    userController.user_id
                                              };
                                              cleverTapController.logEventCT(
                                                  EventConstant
                                                      .EVENT_New_User_Game,
                                                  map);
                                              appsflyerController.logEventAf(
                                                  EventConstant
                                                      .EVENT_New_User_Game,
                                                  map);

                                              Utils().customPrint(
                                                  'getAppSetting ::::: Esports');

                                              Navigator.pop(context);

                                              Get.to(() => ESports(
                                                  userController
                                                      .appSettingReponse
                                                      .value
                                                      .newUserFlow[0]
                                                      .gameId,
                                                  objSub.banner.url,
                                                  objSub.howToPlayUrl,
                                                  userController
                                                              .appSettingReponse
                                                              .value
                                                              .newUserFlow[0]
                                                              .eventIds !=
                                                          null
                                                      ? userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[0]
                                                          .eventIds
                                                      : ""));

                                              break;
                                            }
                                          }
                                        } else if (objMain.name ==
                                            'GMNG Originals') {
                                          for (Games objSub in objMain.games) {
                                            if (objSub.id ==
                                                userController
                                                    .appSettingReponse
                                                    .value
                                                    .newUserFlow[0]
                                                    .gameId) {
                                              if (objSub.thirdParty != null) {
                                                if (objSub.thirdParty.name ==
                                                    'Gamezop') {
                                                  Map<String, String> map = {
                                                    "Game Name": "Gamezop",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);

                                                  Utils().customPrint(
                                                      'getAppSetting ::::: Gamezop');

                                                  //pre join event
                                                  getPreJoinEventGameZob(
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[0]
                                                          .eventIds,
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[0]
                                                          .gameId,
                                                      context);
                                                  // isMatched = true;
                                                  break;
                                                } else if (objSub
                                                        .thirdParty.name ==
                                                    'Freakx') {
                                                  Map<String, String> map = {
                                                    "Game Name": "Freakx",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  Utils().customPrint(
                                                      'getAppSetting ::::: Freakx');
                                                  getPreJoinEventFreakx(
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[0]
                                                          .eventIds,
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[0]
                                                          .gameId,
                                                      context,
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[0]
                                                          .name);
                                                  //isMatched = true;
                                                  break;
                                                }
                                              } else {
                                                Map<String, String> map = {
                                                  "Game Name": "Unity",
                                                  "USER_ID":
                                                      userController.user_id
                                                };
                                                cleverTapController.logEventCT(
                                                    EventConstant
                                                        .EVENT_New_User_Game,
                                                    map);
                                                appsflyerController.logEventAf(
                                                    EventConstant
                                                        .EVENT_New_User_Game,
                                                    map);
                                                Utils().customPrint(
                                                    'getAppSetting ::::: Unity');
                                                getPreJoinEvent(
                                                    userController
                                                        .appSettingReponse
                                                        .value
                                                        .newUserFlow[0]
                                                        .eventIds,
                                                    userController
                                                        .appSettingReponse
                                                        .value
                                                        .newUserFlow[0]
                                                        .gameId,
                                                    objSub.name,
                                                    context);
                                                // isMatched = true;
                                                break;
                                              }
                                            }
                                          }
                                        } else if (objMain.name ==
                                            'Cards And Fantasy') {
                                          for (Games objSub in objMain.games) {
                                            if (objSub.id ==
                                                userController
                                                    .appSettingReponse
                                                    .value
                                                    .newUserFlow[0]
                                                    .gameId) {
                                              if (objSub.thirdParty != null) {
                                                if (objSub.thirdParty.name ==
                                                    'Rummy') {
                                                  Map<String, String> map = {
                                                    "Game Name": "Rummy",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  Utils().customPrint(
                                                      'getAppSetting ::::: Rummy');
                                                  //pre join event
                                                  final param = {
                                                    "state": "haryana",
                                                    "country": "india"
                                                  };
                                                  getHashForRummy(param);
                                                  //  isMatched = true;
                                                  break;
                                                } else if (objSub
                                                        .thirdParty.name ==
                                                    'Pocket52') {
                                                  Map<String, String> map = {
                                                    "Game Name": "Pocket52",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  Utils().customPrint(
                                                      'getAppSetting ::::: Pocker');
                                                  //Pocker
                                                  _pocket52loginController
                                                      .getLoginWithPocket52(
                                                          context);
                                                  //   isMatched = true;
                                                  break;
                                                } else if (objSub.name ==
                                                    'FANTASY') {
                                                  Map<String, String> map = {
                                                    "Game Name": "MyTeam11",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  Utils().customPrint(
                                                      'getAppSetting ::::: MyTeam11');
                                                  /*       BallbaziLoginController
                                                      ballbaziLoginController =
                                                      Get.put(
                                                          BallbaziLoginController());
                                                  ballbaziLoginController
                                                      .getLoginBallabzi(
                                                          context);*/
                                                  MyTeam11_Ballbazi_Controller
                                                      team11Controller =
                                                      Get.put(
                                                          MyTeam11_Ballbazi_Controller());

                                                  await team11Controller
                                                      .getLoginTeam11BB(context,
                                                          '62de6babd6fc1704f21b0ab4');
                                                  //  isMatched = true;
                                                  break;
                                                }
                                              }
                                            }
                                          }
                                        }

                                        /* if (isMatched == false) {
            if (userController
                        .appSettingReponse.value.newUserFlow[index].gameId !=
                    null &&
                userController
                        .appSettingReponse.value.newUserFlow[index].gameId ==
                    '62de6babd6fc1704f21b0ab4') {
              Utils().customPrint('getAppSetting ::::: Fantasy');
              //BalleBazi || Fantasy
              BallbaziLoginController ballbaziLoginController =
                  Get.put(BallbaziLoginController());
              ballbaziLoginController.getLoginBallabzi(context);
            } else if (userController.appSettingReponse.value.newUserFlow[index].gameId !=
                    null &&
                userController
                        .appSettingReponse.value.newUserFlow[index].gameId ==
                    '62de6babd6fc1704f21b0ab5') {
              Utils().customPrint('getAppSetting ::::: Pocker');
              //Pocker
              _pocket52loginController.getLoginWithPocket52(context);
            }else{
              */ /*Utils().customPrint('getAppSetting ::::: Rummy');
              Utils().customPrint('Rummy Starting...');
              final param = {"state": "haryana", "country": "india"};
              getHashForRummy(param);*/ /*
            }
          }*/
                                      }
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      height: 50,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(ImageRes()
                                                .give_me_money_button)),
                                      ),
                                    ),
                                  )
                                ],
                              ))
                            : Container(),
                        userController.appSettingReponse.value.newUserFlow
                                    .length >
                                1
                            ? Expanded(
                                child: Column(
                                children: [
                                  Container(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                              bottomLeft: Radius.circular(8)),
                                          child: userController
                                                      .appSettingReponse
                                                      .value
                                                      .newUserFlow[1]
                                                      .img !=
                                                  null
                                              ? CachedNetworkImage(
                                                  height: 110,
                                                  width: 135,
                                                  fit: BoxFit.cover,
                                                  imageUrl: userController
                                                      .appSettingReponse
                                                      .value
                                                      .newUserFlow[1]
                                                      .img,
                                                )
                                              : Image(
                                                  height: 110,
                                                  width: 135,
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      ImageRes().team_img)))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      for (GameCategories objMain in controller
                                          .homePageListModel
                                          .value
                                          .gameCategories) {
                                        if (objMain.name == 'Esports') {
                                          for (Games objSub in objMain.games) {
                                            if (objSub.id ==
                                                userController
                                                    .appSettingReponse
                                                    .value
                                                    .newUserFlow[1]
                                                    .gameId) {
                                              Map<String, String> map = {
                                                "Game Name": "Esports",
                                                "USER_ID":
                                                    userController.user_id
                                              };
                                              cleverTapController.logEventCT(
                                                  EventConstant
                                                      .EVENT_New_User_Game,
                                                  map);
                                              appsflyerController.logEventAf(
                                                  EventConstant
                                                      .EVENT_New_User_Game,
                                                  map);

                                              Utils().customPrint(
                                                  'getAppSetting ::::: Esports');

                                              Get.to(() => ESports(
                                                  userController
                                                      .appSettingReponse
                                                      .value
                                                      .newUserFlow[1]
                                                      .gameId,
                                                  objSub.banner.url,
                                                  objSub.howToPlayUrl,
                                                  userController
                                                              .appSettingReponse
                                                              .value
                                                              .newUserFlow[1]
                                                              .eventIds !=
                                                          null
                                                      ? userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[1]
                                                          .eventIds
                                                      : ""));

                                              break;
                                            }
                                          }
                                        } else if (objMain.name ==
                                            'GMNG Originals') {
                                          for (Games objSub in objMain.games) {
                                            if (objSub.id ==
                                                userController
                                                    .appSettingReponse
                                                    .value
                                                    .newUserFlow[1]
                                                    .gameId) {
                                              if (objSub.thirdParty != null) {
                                                if (objSub.thirdParty.name ==
                                                    'Gamezop') {
                                                  Map<String, String> map = {
                                                    "Game Name": "Gamezop",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  Utils().customPrint(
                                                      'getAppSetting ::::: Gamezop');
                                                  //pre join event
                                                  getPreJoinEventGameZob(
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[1]
                                                          .eventIds,
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[1]
                                                          .gameId,
                                                      context);
                                                  // isMatched = true;
                                                  break;
                                                } else if (objSub
                                                        .thirdParty.name ==
                                                    'Freakx') {
                                                  Map<String, String> map = {
                                                    "Game Name": "Freakx",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);

                                                  Utils().customPrint(
                                                      'getAppSetting ::::: Freakx');
                                                  getPreJoinEventFreakx(
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[1]
                                                          .eventIds,
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[1]
                                                          .gameId,
                                                      context,
                                                      userController
                                                          .appSettingReponse
                                                          .value
                                                          .newUserFlow[0]
                                                          .name);
                                                  //isMatched = true;
                                                  break;
                                                }
                                              } else {
                                                Map<String, String> map = {
                                                  "Game Name": "Unity",
                                                  "USER_ID":
                                                      userController.user_id
                                                };
                                                cleverTapController.logEventCT(
                                                    EventConstant
                                                        .EVENT_New_User_Game,
                                                    map);
                                                appsflyerController.logEventAf(
                                                    EventConstant
                                                        .EVENT_New_User_Game,
                                                    map);

                                                Utils().customPrint(
                                                    'getAppSetting ::::: Unity');
                                                getPreJoinEvent(
                                                    userController
                                                        .appSettingReponse
                                                        .value
                                                        .newUserFlow[1]
                                                        .eventIds,
                                                    userController
                                                        .appSettingReponse
                                                        .value
                                                        .newUserFlow[1]
                                                        .gameId,
                                                    objSub.name,
                                                    context);
                                                // isMatched = true;
                                                break;
                                              }
                                            }
                                          }
                                        } else if (objMain.name ==
                                            'Cards And Fantasy') {
                                          for (Games objSub in objMain.games) {
                                            if (objSub.id ==
                                                userController
                                                    .appSettingReponse
                                                    .value
                                                    .newUserFlow[1]
                                                    .gameId) {
                                              if (objSub.thirdParty != null) {
                                                if (objSub.thirdParty.name ==
                                                    'Rummy') {
                                                  Map<String, String> map = {
                                                    "Game Name": "Rummy",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);

                                                  Utils().customPrint(
                                                      'getAppSetting ::::: Rummy');
                                                  //pre join event
                                                  final param = {
                                                    "state": "haryana",
                                                    "country": "india"
                                                  };
                                                  getHashForRummy(param);
                                                  //  isMatched = true;
                                                  break;
                                                } else if (objSub
                                                        .thirdParty.name ==
                                                    'Pocket52') {
                                                  Map<String, String> map = {
                                                    "Game Name": "Pocker52",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);

                                                  Utils().customPrint(
                                                      'getAppSetting ::::: Pocker');
                                                  //Pocker
                                                  _pocket52loginController
                                                      .getLoginWithPocket52(
                                                          context);
                                                  //   isMatched = true;
                                                  break;
                                                } else if (objSub.name ==
                                                    'FANTASY') {
                                                  Map<String, String> map = {
                                                    "Game Name": "MyTeam11",
                                                    "USER_ID":
                                                        userController.user_id
                                                  };
                                                  cleverTapController.logEventCT(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);
                                                  appsflyerController.logEventAf(
                                                      EventConstant
                                                          .EVENT_New_User_Game,
                                                      map);

                                                  Utils().customPrint(
                                                      'getAppSetting ::::: BalleBaazi');
                                                  /*  BallbaziLoginController
                                                      ballbaziLoginController =
                                                      Get.put(
                                                          BallbaziLoginController());
                                                  ballbaziLoginController
                                                      .getLoginBallabzi(
                                                          context);*/
                                                  MyTeam11_Ballbazi_Controller
                                                      team11Controller =
                                                      Get.put(
                                                          MyTeam11_Ballbazi_Controller());

                                                  await team11Controller
                                                      .getLoginTeam11BB(context,
                                                          '62de6babd6fc1704f21b0ab4');
                                                  //  isMatched = true;
                                                  break;
                                                }
                                              }
                                            }
                                          }
                                        }

                                        /* if (isMatched == false) {
            if (userController
                        .appSettingReponse.value.newUserFlow[index].gameId !=
                    null &&
                userController
                        .appSettingReponse.value.newUserFlow[index].gameId ==
                    '62de6babd6fc1704f21b0ab4') {
              Utils().customPrint('getAppSetting ::::: Fantasy');
              //BalleBazi || Fantasy
              BallbaziLoginController ballbaziLoginController =
                  Get.put(BallbaziLoginController());
              ballbaziLoginController.getLoginBallabzi(context);
            } else if (userController.appSettingReponse.value.newUserFlow[index].gameId !=
                    null &&
                userController
                        .appSettingReponse.value.newUserFlow[index].gameId ==
                    '62de6babd6fc1704f21b0ab5') {
              Utils().customPrint('getAppSetting ::::: Pocker');
              //Pocker
              _pocket52loginController.getLoginWithPocket52(context);
            }else{
              */ /*Utils().customPrint('getAppSetting ::::: Rummy');
              Utils().customPrint('Rummy Starting...');
              final param = {"state": "haryana", "country": "india"};
              getHashForRummy(param);*/ /*
            }
          }*/
                                      }
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      height: 50,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(ImageRes()
                                                .give_me_money_button)),
                                      ),
                                    ),
                                  )
                                ],
                              ))
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        Map<String, Object> map = new Map<String, Object>();
                        map["Skip  Game"] = "Yes";
                        map["USER_ID"] = userController.user_id;
                        AppString.isUserFTR = false;
                        Utils().customPrint(
                            'getAppSetting ::::: TRUE/FALSE ${AppString.isUserFTR}');
                        //calling
                        cleverTapController.logEventCT(
                            EventConstant.EVENT_New_User_Game_Skip, map);
                        appsflyerController.logEventAf(
                            EventConstant.EVENT_New_User_Game_Skip, map);
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 30,
                            width: 20,
                            child: Image(
                                color: AppColor().whiteColor,
                                image: AssetImage(
                                    "assets/images/ludo_king_play_icon.png")),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 35),
                            child: Text(
                              "No, I'll Pass",
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "*These events can be accessed in GMNG Originals",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor().whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  //ListView FTR pop-up design
  Widget pop_up_ftr(int index) {
    return GestureDetector(
      onTap: () async {
        //complex check
        bool isMatched = false;

        for (GameCategories objMain
            in controller.homePageListModel.value.gameCategories) {
          if (objMain.name == 'Esports') {
            for (Games objSub in objMain.games) {
              if (objSub.id ==
                  userController
                      .appSettingReponse.value.newUserFlow[index].gameId) {
                Utils().customPrint('getAppSetting ::::: Esports');

                Get.to(() => ESports(
                    userController
                        .appSettingReponse.value.newUserFlow[index].gameId,
                    objSub.banner.url,
                    objSub.howToPlayUrl,
                    userController.appSettingReponse.value.newUserFlow[index]
                                .eventIds !=
                            null
                        ? userController
                            .appSettingReponse.value.newUserFlow[index].eventIds
                        : ""));

                isMatched = true;
                break;
              }
            }
          } else if (objMain.name == 'GMNG Originals') {
            for (Games objSub in objMain.games) {
              if (objSub.id ==
                  userController
                      .appSettingReponse.value.newUserFlow[index].gameId) {
                if (objSub.thirdParty != null) {
                  if (objSub.thirdParty.name == 'Gamezop') {
                    Utils().customPrint('getAppSetting ::::: Gamezop');
                    //pre join event
                    getPreJoinEventGameZob(
                        userController.appSettingReponse.value
                            .newUserFlow[index].eventIds,
                        userController
                            .appSettingReponse.value.newUserFlow[index].gameId,
                        context);
                    isMatched = true;
                    break;
                  } else if (objSub.thirdParty.name == 'Freakx') {
                    Utils().customPrint('getAppSetting ::::: Freakx');
                    getPreJoinEventFreakx(
                        userController.appSettingReponse.value
                            .newUserFlow[index].eventIds,
                        userController
                            .appSettingReponse.value.newUserFlow[index].gameId,
                        context,
                        userController
                            .appSettingReponse.value.newUserFlow[0].name);
                    isMatched = true;
                    break;
                  }
                } else {
                  Utils().customPrint('getAppSetting ::::: Unity');
                  getPreJoinEvent(
                      userController
                          .appSettingReponse.value.newUserFlow[index].eventIds,
                      userController
                          .appSettingReponse.value.newUserFlow[index].gameId,
                      objSub.name,
                      context);
                  isMatched = true;
                  break;
                }
              }
            }
          } else if (objMain.name == 'Cards And Fantasy') {
            for (Games objSub in objMain.games) {
              if (objSub.id ==
                  userController
                      .appSettingReponse.value.newUserFlow[index].gameId) {
                if (objSub.thirdParty != null) {
                  if (objSub.thirdParty.name == 'Rummy') {
                    Utils().customPrint('getAppSetting ::::: Rummy');
                    //pre join event
                    final param = {"state": "haryana", "country": "india"};
                    getHashForRummy(param);
                    isMatched = true;
                    break;
                  } else if (objSub.thirdParty.name == 'Pocket52') {
                    Utils().customPrint('getAppSetting ::::: Pocker');
                    //Pocker
                    _pocket52loginController.getLoginWithPocket52(context);
                    isMatched = true;
                    break;
                  } else if (objSub.name == 'FANTASY') {
                    Utils().customPrint('getAppSetting ::::: MyTeam11');
                    /*BallbaziLoginController ballbaziLoginController =
                        Get.put(BallbaziLoginController());
                    ballbaziLoginController.getLoginBallabzi(context);*/
                    MyTeam11_Ballbazi_Controller team11Controller =
                        Get.put(MyTeam11_Ballbazi_Controller());

                    await team11Controller.getLoginTeam11BB(
                        context, '62de6babd6fc1704f21b0ab4');
                    isMatched = true;
                    break;
                  }
                }
              }
            }
          }

          /* if (isMatched == false) {
            if (userController
                        .appSettingReponse.value.newUserFlow[index].gameId !=
                    null &&
                userController
                        .appSettingReponse.value.newUserFlow[index].gameId ==
                    '62de6babd6fc1704f21b0ab4') {
              Utils().customPrint('getAppSetting ::::: Fantasy');
              //BalleBazi || Fantasy
              BallbaziLoginController ballbaziLoginController =
                  Get.put(BallbaziLoginController());
              ballbaziLoginController.getLoginBallabzi(context);
            } else if (userController.appSettingReponse.value.newUserFlow[index].gameId !=
                    null &&
                userController
                        .appSettingReponse.value.newUserFlow[index].gameId ==
                    '62de6babd6fc1704f21b0ab5') {
              Utils().customPrint('getAppSetting ::::: Pocker');
              //Pocker
              _pocket52loginController.getLoginWithPocket52(context);
            }else{
              */ /*Utils().customPrint('getAppSetting ::::: Rummy');
              Utils().customPrint('Rummy Starting...');
              final param = {"state": "haryana", "country": "india"};
              getHashForRummy(param);*/ /*
            }
          }*/
        }

        Fluttertoast.showToast(msg: 'Clicked');
      },
      child: Container(
        width: 135,
        padding: const EdgeInsets.only(right: 10, left: 4, top: 4, bottom: 0),
        child: Column(
          children: [
            Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: userController.appSettingReponse.value
                                .newUserFlow[index].img !=
                            null
                        ? CachedNetworkImage(
                            height: 110,
                            width: 135,
                            fit: BoxFit.cover,
                            imageUrl: userController
                                .appSettingReponse.value.newUserFlow[index].img,
                          )
                        : Image(
                            height: 110,
                            width: 135,
                            fit: BoxFit.cover,
                            image: AssetImage(ImageRes().team_img)))),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Container(
                // width: 100,
                padding:
                    const EdgeInsets.only(right: 0, left: 7, top: 0, bottom: 0),
                color: AppColor().blackColor,
                margin: EdgeInsets.only(left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("PLAY",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              color: AppColor().whiteColor,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                            )),
                        Text("",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              color: AppColor().whiteColor,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
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

  //pre join event gameZop
  Future<Map> getPreJoinEventGameZob(
      String event_id, String gameid, BuildContext context) async {
    //print("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${controller.user_id}");
    final param = {
      "userId": controller.user_id,
      "thirdParty": {"type": "gameZop", "gameCode": "SJRX12TXcRH"}
      /*  "gameZopGameCode": "SkhljT2fdgb"*/
    };

    if (controller.token == null || controller.token.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      controller.token = prefs.getString("token");
    }

    Utils().customPrint("bear token ${controller.token}");

    showProgressUnity(context, '', true);

    Map<String, dynamic> response = await WebServicesHelper()
        .getPreEventJoinGameJob(param, controller.token, event_id);
    //print(' respone is finaly ${response}');
    hideProgress(context);
    if (response != null && response['statusCode'] == null) {
      //print(' respone is finaly1 ${response}');
      preJoinResponseModel = PreJoinUnityResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount1 deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          //Fluttertoast.showToast(msg: "Please add Amount.");
          //Get.offAll(() => DashBord(4, ""));
          Utils().alertInsufficientBalance(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GameJobWebview(
                  preJoinResponseModel.webViewUrl,
                  gameid,
                  event_id,
                  "Free",
                  "url"),
            ),
          );
        }
      } else {
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(response);
        Utils().showErrorMessage("", appBaseErrorModel.error);
      }
    } else if (response['statusCode'] == 401) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
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
      //hideLoader();
    }
  }

  //pre join event freakX
  Future<Map> getPreJoinEventFreakx(String event_id, String gameid,
      BuildContext context, String gameName) async {
    // Utils().customPrint("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${controller.user_id}");
    final param = {
      "userId": controller.user_id,
      "thirdParty": {"type": "freakx", "gameCode": ""}
      /*  "gameZopGameCode": "SkhljT2fdgb"*/
    };

    if (controller.token == null || controller.token.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      controller.token = prefs.getString("token");
    }

    Utils().customPrint("bear token ${controller.token}");

    showProgressUnity(context, '', true);

    Map<String, dynamic> response = await WebServicesHelper()
        .getPreEventJoinGameJob(param, controller.token, event_id);
    //print(' respone is finaly ${response}');
    hideProgress(context);
    if (response != null && response['statusCode'] == null) {
      //print(' respone is finaly1 ${response}');
      preJoinResponseModel = PreJoinUnityResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount1 deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          //Fluttertoast.showToast(msg: "Please add Amount.");
          //Get.offAll(() => DashBord(4, ""));
          Utils().alertInsufficientBalance(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => FreakxWebview(
                  preJoinResponseModel.webViewUrl,
                  gameid,
                  event_id,
                  "Free",
                  "url",
                  "$gameName"),
            ),
          );
        }
      } else {
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(response);
        Utils().showErrorMessage("", appBaseErrorModel.error);
      }
    } else if (response['statusCode'] == 401) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
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
      //hideLoader();
    }
  }

  //pre join event unity
  Future<Map> getPreJoinEvent(String event_id, String gameid, String game_name,
      BuildContext context) async {
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
          //Fluttertoast.showToast(msg: "Please add Amount.");
          //Get.offAll(() => DashBord(4, ""));
          Utils().alertInsufficientBalance(context);
        } else {
          final Map<String, String> data = {
            "event_id": event_id,
            "game_id": gameid,
            "game_name": game_name,
            "is_test": "false",
            "mobile":
                userController.profileDataRes.value.mobile.number.toString(),
            "name": userController.profileDataRes.value.username,
            "profile": userController.profileDataRes.value.photo != null
                ? userController.profileDataRes.value.photo.url
                : "",
            "user_id": userController.profileDataRes.value.id,
            "email": userController.profileDataRes.value.email != null
                ? userController.profileDataRes.value.email.address
                : "",
            "winning_type": "[]", //WinningWallet,BonusWallet
            "winning_type_amount": "[]",
          };
          String reposnenative = await NativeBridge.OpenUnityGames(data);
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
      //hideLoader();
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        AppUpdateInfo _updateInfo = info;
        /*  InAppUpdate.startFlexibleUpdate().then((_) {
          setState(() {
            _flexibleUpdateAvailable = true;
          });
        }).catchError((e) {
          showSnack(e.toString());
        });*/
        if (_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          InAppUpdate.performImmediateUpdate()
              .catchError((e) => showSnack(e.toString()));
          //Fluttertoast.showToast(msg: "Update Available");
        } else {
          //Fluttertoast.showToast(msg: "Update NOT Available");
        }
      });
    }).catchError((e) {
      print("checkForUpdate");
      print(e.toString());
      showSnack(e.toString());
    });
  }

  var gameListSelectedColor = 1000.obs;

  void vipBannerClickPromoCode(BuildContext context) {
    WalletPageController walletPageController = Get.find();

    //code checking for offline codes
    bool temp = false;
    for (int i = 0; i < controller.walletModelPromo.data.length; i++) {
      if (walletPageController.promocode.value.toLowerCase() ==
          controller.walletModelPromo.data[i].code.toLowerCase()) {
        Utils().customPrint(
            "PROMOCODE Loop code home ${controller.walletModelPromo.data[i].code}");
        //validation
        double enterAmtInt =
            double.parse(walletPageController.selectAmount.value);
        double fromValue =
            double.parse(controller.walletModelPromo.data[i].fromValue);
        double toValue =
            double.parse(controller.walletModelPromo.data[i].toValue);
        Utils().customPrint('Offer Valid Enter Amt ${enterAmtInt}');
        Utils().customPrint('Offer Valid F ${fromValue}');
        Utils().customPrint('Offer Valid T ${toValue}');

        if (enterAmtInt < fromValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${controller.walletModelPromo.data[i].fromValue} - ${controller.walletModelPromo.data[i].toValue} Rs!');
          return;
        } else if (enterAmtInt > toValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${controller.walletModelPromo.data[i].fromValue} - ${controller.walletModelPromo.data[i].toValue} Rs!');
          return;
        }

        //promo code
        promo_code_not_visible1(
            walletPageController.selectAmount.value, i, context);
        Utils().customPrint(
            "PROMOCODE Applied: ${walletPageController.promocode.value}");
        temp = true;
        break;
      } else {
        Utils().customPrint(
            "PROMOCODE Invalid: loop ${walletPageController.promocode.value}");
        temp = false;
      }
    }
  }

  void promo_code_not_visible1(
      var entered_amount, int index_promo, BuildContext context) {
    WalletPageController walletPageController = Get.find();

    if (index_promo != null) {
      try {
        if (controller.walletModelPromo.data[index_promo].benefit[0].wallet[0]
                    .percentage !=
                '' &&
            controller.walletModelPromo.data[index_promo].benefit[0].wallet[0]
                    .maximumAmount !=
                '') {
          double maxAmtFixed = double.parse(controller.walletModelPromo
              .data[index_promo].benefit[0].wallet[0].maximumAmount);

          double percentage = double.parse(controller.walletModelPromo
              .data[index_promo].benefit[0].wallet[0].percentage);
          Utils().customPrint('Offer enterAmtInt F ');
          Utils().customPrint('Offer calcValuePerc T ');
          double enterAmtInt = double.parse(entered_amount);
          double calcValuePerc = ((percentage / 100) * enterAmtInt);

          //conditions
          if (controller.walletModelPromo.data[index_promo].benefit[0].wallet[0]
                  .type ==
              'bonus') {
            //bonus
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${enterAmtInt} Deposit & ${maxAmtFixed} Bonus';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit & ${calcValuePerc.floor()} Bonus';
            }
          } else if (controller.walletModelPromo.data[index_promo].benefit[0]
                  .wallet[0].type ==
              'coin') {
            //coin

            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${enterAmtInt} Deposit & ${maxAmtFixed} Coin';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit & ${calcValuePerc.floor()} Coin';
            }
          } else if (controller.walletModelPromo.data[index_promo].benefit[0]
                  .wallet[0].type ==
              'instantCash') {
            //coin

            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${enterAmtInt} Deposit & ${maxAmtFixed} Instant Cash';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit & ${calcValuePerc.floor()} Instant Cash';
            }
          } else {
            //deposit
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
            }
          }

          //for cleverTap use
          walletPageController.percentagePromocode = percentage.toString();
          walletPageController.walletTypePromocode = controller
              .walletModelPromo.data[index_promo].benefit[0].wallet[0].type;
          Utils().customPrint(
              'applied promo code: ${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")}');
          walletPageController.buttonApplyText.value = "Remove";
          //showCustomDialog(context);

          /////

          //saving values for UI
          //layout hide work & show deposit get UI
          CashFreeController cashFreeController = Get.put(CashFreeController());
          cashFreeController.promocodeValue = int.parse(
              controller.walletModelPromo.data[index_promo].fromValue);

          walletPageController.applyPress.value = true;
          walletPageController.boolEnterCode.value = false;
          cashFreeController.click_remove_code = true;
          if (cashFreeController.promocodeValue >
              int.parse(walletPageController.selectAmount.value)) {
            walletPageController.selectAmount.value =
                cashFreeController.promocodeValue.toStringAsFixed(0);
          } else {
            walletPageController.selectAmount.value =
                enterAmtInt.toStringAsFixed(0);
          }
          /////////

          walletPageController.promo_type.value = controller
              .walletModelPromo.data[index_promo].benefit[0].wallet[0].type;

          walletPageController.promo_minus_amt.value =
              cashFreeController.promocodeValue - int.parse(entered_amount);
          ;
          int max_per = int.parse(controller.walletModelPromo.data[index_promo]
              .benefit[0].wallet[0].percentage);
          walletPageController.promo_amt.value =
              (enterAmtInt * (max_per / 100));

          walletPageController.typeTextCheck.value = 2; //eqauls
          /*   walletPageController.profitAmt.value =
                                              enteredValue +
                                                  walletPageController
                                                      .promo_amt.value;*/
          cashFreeController.promocodeHelper.value =
              controller.walletModelPromo.data[index_promo].code;

          walletPageController.promo_maximumAmt.value = int.parse(controller
              .walletModelPromo
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .maximumAmount);
          if (walletPageController.promo_amt.value >
              walletPageController.promo_maximumAmt.value) {
            walletPageController.profitAmt.value = int.parse(entered_amount) +
                double.parse(
                    walletPageController.promo_maximumAmt.value.toString());
          } else {
            walletPageController.profitAmt.value = int.parse(entered_amount) +
                walletPageController.promo_amt.value;
          }
        }
      } catch (e) {
        //print('applied amount: $e');
        Utils().customPrint('Offer calcValuePerc T $e');
        Fluttertoast.showToast(msg: 'Offer calcValuePerc T $e');
      }
    } else {
      //for dynamic showing value in 'You'll get' place.
      walletPageController.amtAfterPromoApplied.value =
          double.parse(entered_amount);
      walletPageController.youWillGet.value =
          '${entered_amount.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
    }
  }

  Future<void> normalBannerClick(var item) async {
    if (ApiUrl().isPlayStore == false) {
      bool stateR = await Utils().checkResLocation(context);
      if (stateR) {
        return;
      }
    }

    print("click banner${item.type}");

    clickOnBanner(item);
    if (item.type.compareTo("internalScreen") == 0) {
      if (item.screen.compareTo("addMoney") == 0) {
        Get.to(() => CashFreeScreen());
      } else if (item.screen.compareTo("wallet") == 0) {
        Get.to(() => CashFreeScreen());
      } else if (item.screen.compareTo("teamManagement") == 0) {
        Get.to(() => TeamManagementNew());
      } else if (item.screen.compareTo("referral") == 0) {
        Get.to(() => Referral());
      } else if (item.screen.compareTo("store") == 0) {
        Get.to(() => Store());
      } else if (item.screen.compareTo("profile") == 0) {
        Get.to(() => Profile(""));
      } else if (item.screen.compareTo("clan") == 0) {
        Get.to(() => Clan());
      } else if (item.screen.compareTo("offerWall") == 0) {
        Get.to(() => OfferWallScreen());
      } else if (item.screen.compareTo("esportGame") == 0) {
        for (GameCategories objMain
            in controller.homePageListModel.value.gameCategories) {
          if (objMain.name == 'Esports') {
            for (Games objSub in objMain.games) {
              if (objSub.id == item.gameId) {
                AppString.gameName = objSub.name;
                Get.to(() => ESports(
                    item.gameId,
                    objSub.banner.url,
                    objSub.howToPlayUrl,
                    item.eventId != null ? item.eventId : ""));

                break;
              }
            }
          } else if (objMain.name == 'GMNG Originals') {
            for (Games objSub in objMain.games) {
              if (objSub.id == item.gameId) {
                if (objSub.thirdParty != null) {
                  if (objSub.thirdParty.name == 'Gamezop') {
                    Get.to(() => GameJobList(
                        item.gameId, objSub.banner.url, objSub.name));
                  } else if (objSub.thirdParty.name == 'Freakx') {
                    Get.to(() => FreakxList(
                        item.gameId, objSub.banner.url, objSub.name));
                  }
                } else {
                  Get.to(() =>
                      UnityList(item.gameId, objSub.banner.url, objSub.name));
                }
                break;
              }
            }
          }
        }
      } else {}
    } else {
      Utils().customPrint('Click Banner : ${item.gameId}');
      //print('Click Banner : ${item.gameId}');

      Utils().customPrint("banner url ${item.externalUrl}");
      if (item.externalUrl != null && !item.externalUrl.isEmpty) {
        base_controller
            .launchURLApp(item.externalUrl); //need to comment for new work
      } else if (item.gameId != null) {
        Utils().customPrint('Click Banner : TEST ${item.gameId}');
        bool isMatched = false;

        for (GameCategories objMain
            in controller.homePageListModel.value.gameCategories) {
          if (objMain.name == 'Esports') {
            for (Games objSub in objMain.games) {
              if (objSub.id == item.gameId) {
                AppString.gameName = objSub.name;
                Get.to(() => ESports(
                    item.gameId,
                    objSub.banner.url,
                    objSub.howToPlayUrl,
                    item.eventId != null ? item.eventId : ""));
                isMatched = true;
                break;
              }
            }
          } else if (objMain.name == 'GMNG Originals') {
            for (Games objSub in objMain.games) {
              if (objSub.id == item.gameId) {
                if (objSub.thirdParty != null) {
                  if (objSub.thirdParty.name == 'Gamezop') {
                    Get.to(() => GameJobList(
                        item.gameId, objSub.banner.url, objSub.name));
                    isMatched = true;
                  } else if (objSub.thirdParty.name == 'Freakx') {
                    Get.to(() => FreakxList(
                        item.gameId, objSub.banner.url, objSub.name));
                    isMatched = true;
                  } else if (objSub.thirdParty.name == 'Ludot') {
                    Get.to(() => TamashaListing(
                        item.gameId, objSub.banner.url, objSub.name));
                    isMatched = true;
                  }
                } else {
                  Get.to(() =>
                      UnityList(item.gameId, objSub.banner.url, objSub.name));
                  isMatched = true;
                }
                break;
              }
            }
          }
        }

        if (isMatched == false) {
          if (item.gameId != null &&
              item.gameId == '62de6babd6fc1704f21b0ab4') {
            //BalleBazi || Fantasy

            /* BallbaziLoginController
                                                      ballbaziLoginController =
                                                      Get.put(
                                                          BallbaziLoginController());
                                                  ballbaziLoginController
                                                      .getLoginBallabzi(
                                                          context);*/
            MyTeam11_Ballbazi_Controller team11Controller =
                Get.put(MyTeam11_Ballbazi_Controller());

            await team11Controller.getLoginTeam11BB(
                context, '62de6babd6fc1704f21b0ab4');
          } else if (item.gameId != null &&
              item.gameId == '62de6babd6fc1704f21b0ab5') {
            //Pocker

            /*  Pocket52LoginController     _pocket52loginController = Get.put(
                                                    Pocket52LoginController());*/
            /*   _pocket52loginController
                                                      .getLoginWithPocket52(
                                                          context);*/
            //    Get.offAll(DashBord(2, ''));
            MyTeam11_Ballbazi_Controller team11Controller =
                Get.put(MyTeam11_Ballbazi_Controller());

            await team11Controller.getLoginTeam11BB(
                context, '62de6babd6fc1704f21b0ab4');
          } else if (item.gameId != null &&
              item.gameId == '62e7d76654628211b0e49d25') {
            final param = {"state": "haryana", "country": "india"};
            getHashForRummy(param);
          }
        }
      } else {
        /*    Fluttertoast.showToast(
                                                msg: "Url not found!");*/
      }
    }

    //new banner click work
  }

  Future<void> vipBannerClick(var item) async {
    if (ApiUrl().isPlayStore == false) {
      bool stateR = await Utils().checkResLocation(context);
      if (stateR) {
        return;
      }
    }
    clickOnBanner(item);
    if (controller.currentIndexSlider.value == 0) {
      //for (int i = 0; i < controller.walletModelPromo.data.length; i++) {
      //print('response promo code ftd ${controller.walletModelPromo.data[i].ftd}');
      //if (controller.walletModelPromo.data[i].ftd == true) {
      print('PROMOCODE Loop code loop ${controller.selectAmount.value}');
      print('PROMOCODE Loop code loop ${controller.promocode.value}');
      WalletPageController walletPageController =
          Get.put(WalletPageController());

      if (userController.appSettingReponse.value.featuresStatus != null &&
          userController.appSettingReponse.value.featuresStatus.length > 0) {
        for (FeaturesStatus obj
            in userController.appSettingReponse.value.featuresStatus) {
          if (obj.id == 'addMoney' && obj.status == 'inactive') {
            Utils().showWalletDown(context);
            return;
          }
        }
      }

      //await walletPageController.getPromoCodesData();

      walletPageController.gameListSelectedColor.value = 1000; //initialisation
      walletPageController.amtAfterPromoApplied.value = 0;
      //showBottomSheetAddAmount(context);
      //promocode api call again for refreshing the data

      walletPageController.gameAmtSelectedColor.value = 0;
      walletPageController.selectAmount.value = "0";
      walletPageController.amountTextController.value.text = "";
      walletPageController.youWillGet.value = '';
      walletPageController.click = false;
      walletPageController.promocode.value = '';
      walletPageController.walletTypePromocode = '';
      walletPageController.percentagePromocode = '';
      walletPageController.boolEnterCode.value = false;
      walletPageController.havCodeController.value.text = '';
      walletPageController.buttonApplyText.value = 'Apply';

      //new promocode work
      CashFreeController cashFreeController = Get.put(CashFreeController());
      cashFreeController.amountCashTextController.value.text = "";
      walletPageController.promo_type = "".obs;
      walletPageController.promo_amt = 0.0.obs;
      walletPageController.promo_minus_amt = 0.obs;
      walletPageController.typeTextCheck = 0.obs;
      walletPageController.applyPress = false.obs;
      walletPageController.profitAmt = 0.0.obs;
      AppString.contestAmount = 0; //newly added

      //Get.to(() => CashFreeScreen());
      cashFreeController.amountCashTextController.value.text =
          controller.selectAmount.value;
      walletPageController.selectAmount.value = controller.selectAmount.value;
      //await cashFreeController.haveCodeApplied(item.fromValue.toString());
      walletPageController.applyPress.value = true;
      walletPageController.buttonApplyText.value = 'Apply';
      walletPageController.boolEnterCode.value = false;
      cashFreeController.click_remove_code = true;
      walletPageController.promocode.value = controller.promocode.value;
      vipBannerClickPromoCode(context);
      //promoCodeFTD = true;

      Get.to(() => CashFreeScreen());
      // break;
      // }
      // }
    } else {
      print("click banner${item.type}");

      if (item.type.compareTo("internalScreen") == 0) {
        if (item.screen.compareTo("addMoney") == 0) {
          Get.to(() => CashFreeScreen());
        } else if (item.screen.compareTo("wallet") == 0) {
          Get.to(() => CashFreeScreen());
        } else if (item.screen.compareTo("teamManagement") == 0) {
          Get.to(() => TeamManagementNew());
        } else if (item.screen.compareTo("referral") == 0) {
          Get.to(() => Referral());
        } else if (item.screen.compareTo("store") == 0) {
          Get.to(() => Store());
        } else if (item.screen.compareTo("profile") == 0) {
          Get.to(() => Profile(""));
        } else if (item.screen.compareTo("clan") == 0) {
          Get.to(() => Clan());
        } else if (item.screen.compareTo("offerWall") == 0) {
          Get.to(() => OfferWallScreen());
        } else if (item.screen.compareTo("esportGame") == 0) {
          for (GameCategories objMain
              in controller.homePageListModel.value.gameCategories) {
            if (objMain.name == 'Esports') {
              for (Games objSub in objMain.games) {
                if (objSub.id == item.gameId) {
                  AppString.gameName = objSub.name;
                  Get.to(() => ESports(
                      item.gameId,
                      objSub.banner.url,
                      objSub.howToPlayUrl,
                      item.eventId != null ? item.eventId : ""));

                  break;
                }
              }
            } else if (objMain.name == 'GMNG Originals') {
              for (Games objSub in objMain.games) {
                if (objSub.id == item.gameId) {
                  if (objSub.thirdParty != null) {
                    if (objSub.thirdParty.name == 'Gamezop') {
                      Get.to(() => GameJobList(
                          item.gameId, objSub.banner.url, objSub.name));
                    } else if (objSub.thirdParty.name == 'Freakx') {
                      Get.to(() => FreakxList(
                          item.gameId, objSub.banner.url, objSub.name));
                    }
                  } else {
                    Get.to(() =>
                        UnityList(item.gameId, objSub.banner.url, objSub.name));
                  }
                  break;
                }
              }
            }
          }
        } else {}
      } else {
        Utils().customPrint('Click Banner : ${item.gameId}');
        //print('Click Banner : ${item.gameId}');

        Utils().customPrint("banner url ${item.externalUrl}");
        if (item.externalUrl != null && !item.externalUrl.isEmpty) {
          base_controller
              .launchURLApp(item.externalUrl); //need to comment for new work
        } else if (item.gameId != null) {
          Utils().customPrint('Click Banner : TEST ${item.gameId}');
          bool isMatched = false;

          for (GameCategories objMain
              in controller.homePageListModel.value.gameCategories) {
            if (objMain.name == 'Esports') {
              for (Games objSub in objMain.games) {
                if (objSub.id == item.gameId) {
                  AppString.gameName = objSub.name;
                  Get.to(() => ESports(
                      item.gameId,
                      objSub.banner.url,
                      objSub.howToPlayUrl,
                      item.eventId != null ? item.eventId : ""));
                  isMatched = true;
                  break;
                }
              }
            } else if (objMain.name == 'GMNG Originals') {
              for (Games objSub in objMain.games) {
                if (objSub.id == item.gameId) {
                  if (objSub.thirdParty != null) {
                    if (objSub.thirdParty.name == 'Gamezop') {
                      Get.to(() => GameJobList(
                          item.gameId, objSub.banner.url, objSub.name));
                      isMatched = true;
                    } else if (objSub.thirdParty.name == 'Freakx') {
                      Get.to(() => FreakxList(
                          item.gameId, objSub.banner.url, objSub.name));
                      isMatched = true;
                    } else if (objSub.thirdParty.name == 'Ludot') {
                      Get.to(() => TamashaListing(
                          item.gameId, objSub.banner.url, objSub.name));
                      isMatched = true;
                    }
                  } else {
                    Get.to(() =>
                        UnityList(item.gameId, objSub.banner.url, objSub.name));
                    isMatched = true;
                  }
                  break;
                }
              }
            }
          }

          if (isMatched == false) {
            if (item.gameId != null &&
                item.gameId == '62de6babd6fc1704f21b0ab4') {
              //BalleBazi || Fantasy

              /* BallbaziLoginController
                                                      ballbaziLoginController =
                                                      Get.put(
                                                          BallbaziLoginController());
                                                  ballbaziLoginController
                                                      .getLoginBallabzi(
                                                          context);*/
              MyTeam11_Ballbazi_Controller team11Controller =
                  Get.put(MyTeam11_Ballbazi_Controller());

              await team11Controller.getLoginTeam11BB(
                  context, '62de6babd6fc1704f21b0ab4');
            } else if (item.gameId != null &&
                item.gameId == '62de6babd6fc1704f21b0ab5') {
              //Pocker

              /*  Pocket52LoginController     _pocket52loginController = Get.put(
                                                    Pocket52LoginController());*/
              /*   _pocket52loginController
                                                      .getLoginWithPocket52(
                                                          context);*/
              //    Get.offAll(DashBord(2, ''));
              MyTeam11_Ballbazi_Controller team11Controller =
                  Get.put(MyTeam11_Ballbazi_Controller());

              await team11Controller.getLoginTeam11BB(
                  context, '62de6babd6fc1704f21b0ab4');
            } else if (item.gameId != null &&
                item.gameId == '62e7d76654628211b0e49d25') {
              final param = {"state": "haryana", "country": "india"};
              getHashForRummy(param);
            }
          }
        } else {
          /*    Fluttertoast.showToast(
                                                msg: "Url not found!");*/
        }
      }
    }

    //new banner click work
  }

  //rummy api
  Future<void> getHashForRummy(Map<String, dynamic> param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Map<String, dynamic> response =
        await WebServicesHelper().getHashForRummy(token, param);

    Utils().customPrint('rummy response $response');
    if (response != null) {
      //print("rummy exhausted ${response["isThirdPartyLimitExhausted"]}");

      if (response["isThirdPartyLimitExhausted"] != null &&
          response['isThirdPartyLimitExhausted']) {
        Utils.alertLimitExhausted();
        return true;
      } else {
        Utils().customPrint('response ${response['loginRequest']['params']}');
        RummyModel rummyModel =
            RummyModel.fromJson(response['loginRequest']['params']);
        Utils().customPrint('LoginResponseLoginResponse ${rummyModel}');

        final Map<String, String> data = {
          "user_id": rummyModel.user_id,
          "name": rummyModel.name,
          "state": rummyModel.state,
          "country": rummyModel.country,
          "session_key": rummyModel.session_key,
          "timestamp": rummyModel.timestamp,
          "client_id": rummyModel.client_id,
          "hash": rummyModel.hash,
        };

        String reposnenative = await NativeBridge().OpenRummy(data);
        Utils().customPrint("data====> ${reposnenative}");
        try {
          switch (reposnenative) {
            case "click_add_amount":
              UserController controller = Get.find();
              controller.currentIndex.value = 4;
              controller.getWalletAmount();
              Get.offAll(() => DashBord(4, ""));
              break;
            case "topBarClicked":
              Get.to(() => how_to_play_rummy());
              break;
            default:
              Utils().customPrint("click_buyin_success=====================>");
              break;
          }
        } catch (e) {
          //error
        }
      }
    } else {
      Utils().customPrint('response promo code ERROR');
    }
  }
}
*/
