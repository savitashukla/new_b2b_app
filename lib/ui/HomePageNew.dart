import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/model/AppSettingResponse.dart';
import 'package:gmng/model/HomeModel/HomePageListModel.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wakelock/wakelock.dart';

import '../model/LoginModel/hash_rummy.dart';
import '../model/ProfileModel/ProfileDataR.dart';
import '../res/AppString.dart';
import '../res/FontSizeC.dart';
import '../res/firebase_events.dart';
import '../utills/OnlyOff.dart';
import '../utills/Utils.dart';
import '../utills/bridge.dart';
import '../utills/event_tracker/AppsFlyerController.dart';
import '../utills/event_tracker/CleverTapController.dart';
import '../utills/event_tracker/EventConstant.dart';
import '../utills/event_tracker/FaceBookEventController.dart';
import '../webservices/ApiUrl.dart';
import '../webservices/WebServicesHelper.dart';
import 'controller/BaseController.dart';
import 'controller/HomePageController.dart';
import 'controller/Pocket52_Controller.dart';
import 'controller/WalletPageController.dart';
import 'controller/user_controller.dart';
import 'main/Clan/Clan.dart';
import 'main/Freakx/FreakxList.dart';
import 'main/GameZop/GameZopList.dart';
import 'main/UnitEventList/UnityList.dart';
import 'main/cash_free/CashFreeController.dart';
import 'main/cash_free/CashFreeScreen.dart';
import 'main/dashbord/DashBord.dart';
import 'main/esports/ESports.dart';
import 'main/how_to_pay_rummy.dart';
import 'main/ludo_king/Ludo_King_Screen.dart';
import 'main/myteam11_ballabazzi/MyTeam11_Ballbazi_Controller.dart';
import 'main/profile/Profile.dart';
import 'main/store/Store.dart';
import 'main/tamasha_ludo/TamashaListing.dart';
import 'main/team_management/TeamManagementNew.dart';
import 'main/trago/Trago_Controller.dart';
import 'main/wallet/OfferWallScreen.dart';
import 'main/wallet/vip_program_screen.dart';

class HomePageNew extends StatefulWidget {
  @override
  State<HomePageNew> createState() => _GameCallState();
}

class _GameCallState extends State<HomePageNew> {
  HomePageController controller = Get.put(HomePageController());

  Pocket52LoginController _pocket52loginController =
      Get.put(Pocket52LoginController());

  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  UserController userController = Get.put(UserController());
  BaseController base_controller = Get.put(BaseController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool team11Clicked = true;
  DateTime currentBackPressTime;

  @override
  Future<void> initState() {
    super.initState();

    //checking for app update
    checkForUpdate(); //playstore update




    //new user journey
    Future.delayed(const Duration(milliseconds: 1000), () {
      Utils().customPrint('getAppSetting ::::: 1 ${AppString.isUserFTR}');
      if (AppString.isUserFTR == true) {
        userController.showCustomDialogConfettiNewFTD();

        Utils().customPrint('getAppSetting ::::: started');
        if (userController.appSettingReponse.value.newUserFlow != null &&
            userController.appSettingReponse.value.newUserFlow.length > 0) {
          Utils().customPrint('getAppSetting ::::: length>0');
          //showBottomSheetFTRpopup(context); //popup
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

  //back press again to exit added!
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
    Wakelock.enable();
    userController.getFavGmae();
    userController.getProfileData();
    userController.getUserProfileSummary();
    userController.getWalletAmount();
    userController.getForceUpdate(context);
    Future.delayed(const Duration(seconds: 0), () async {
      //for refresh we have put in future delay
      controller.getHomePage();
    });

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () async {
          setState(() {
            userController.getWalletAmount();
            controller.getHomePage();
            userController.getProfileData();
            // userController.getFavGmae();
            //_demoData.addAll(["", ""]);
          });
        });
      },
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top:30,left: 10, right: 10, bottom: 60),
              child: Column(
                children: [
                  Container(
                    height: 75,
                    color: Colors.transparent,
                  ),
                  Obx(
                    () => controller.homePageListModel.value != null &&
                            controller.AllGameCall.value.length > 0
                        ? InkWell(
                            hoverColor: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              if (isRedundentClick(DateTime.now())) {
                                Utils().customPrint(
                                    'ProgressBarClick: showProgress click');
                                return;
                              }
                              Utils().customPrint(
                                  'ProgressBarClick: showProgress run process 1');

                              if (onlyOffi.gamesMyFavSelected.value != null &&
                                  onlyOffi.gamesMyFavSelected.length > 0 &&
                                  onlyOffi.gamesMyFavSelected[0].name != null) {
                                if (onlyOffi.gamesMyFavSelected[0].thirdParty
                                        .name ==
                                    "Pocket52") {
                                  //checking whether is disable or not
                                  for (GameCategories objMain in controller
                                      .homePageListModel.value.gameCategories) {
                                    if (objMain.name == 'Cards And Fantasy') {
                                      for (Games objSub in objMain.games) {
                                        if (objSub.thirdParty.name ==
                                                'Pocket52' &&
                                            objSub.isClickable == true) {
                                          if (onlyOffi.gamesMyFavSelected[0]
                                              .isClickable) {
                                            _pocket52loginController
                                                .getLoginWithPocket52(context);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Under maintenance".tr);
                                          }
                                        }
                                      }
                                    }
                                  }
                                } else if (onlyOffi.gamesMyFavSelected[0]
                                        .thirdParty.name ==
                                    "Rummy") {
                                  //checking whether is disable or not
                                  for (GameCategories objMain in controller
                                      .homePageListModel.value.gameCategories) {
                                    if (objMain.name == 'Cards And Fantasy') {
                                      for (Games objSub in objMain.games) {
                                        if (objSub.thirdParty.name == 'Rummy' &&
                                            objSub.isClickable == true) {
                                          userController.currentIndex.value = 2;
                                          DashBord(2, "");
                                          if (AppString.rummyisClickable) {
                                            final param = {
                                              "state": "haryana",
                                              "country": "india"
                                            };

                                            Fluttertoast.showToast(msg: "Under Maintenance");

                                            //   getHashForRummy(param);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Under maintenance".tr);
                                          }
                                        }
                                      }
                                    }
                                  }
                                } else if (onlyOffi
                                        .gamesMyFavSelected[0].name ==
                                    "FANTASY") {
                                  //checking whether is disable or not
                                  for (GameCategories objMain in controller
                                      .homePageListModel.value.gameCategories) {
                                    if (objMain.name == 'Cards And Fantasy') {
                                      for (Games objSub in objMain.games) {
                                        if (objSub.name == 'FANTASY' &&
                                            objSub.isClickable == true) {
                                          if (onlyOffi.gamesMyFavSelected[0]
                                              .isClickable) {
                                            userController.currentIndex.value =
                                                2;
                                            DashBord(2, "");
                                            MyTeam11_Ballbazi_Controller
                                                team11Controller = Get.put(
                                                    MyTeam11_Ballbazi_Controller());

                                            await team11Controller
                                                .getLoginTeam11BB(context,
                                                    '62de6babd6fc1704f21b0ab4');
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Under maintenance".tr);
                                          }
                                        }
                                      }
                                    }
                                  }
                                } else if (onlyOffi
                                        .gamesMyFavSelected[0].name ==
                                    "Skill Ludo") {
                                  //checking whether is disable or not
                                  for (GameCategories objMain in controller
                                      .homePageListModel.value.gameCategories) {
                                    if (objMain.name == 'Casual Games') {
                                      for (Games objSub in objMain.games) {
                                        if (objSub.name == 'Skill Ludo' &&
                                            objSub.isClickable == true) {
                                          if (onlyOffi.gamesMyFavSelected[0]
                                              .isClickable) {
                                            userController.currentIndex.value =
                                                2;
                                            DashBord(2, "");
                                            Get.to(() => TamashaListing(
                                                onlyOffi
                                                    .gamesMyFavSelected[0].id,
                                                onlyOffi.gamesMyFavSelected[0]
                                                    .banner.url,
                                                onlyOffi.gamesMyFavSelected[0]
                                                    .name));
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Under maintenance".tr);
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              } else {
                                {
                                  userController.currentIndex.value = 2;
                                  DashBord(2, "");
                                  if (AppString.rummyisClickable) {
                                    final param = {
                                      "state": "haryana",
                                      "country": "india"
                                    };

                                    Fluttertoast.showToast(msg: "Under Maintenance");

                              //      getHashForRummy(param);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Under maintenance".tr);
                                  }
                                }
                              }
                            },
                            child: Obx(
                              () => Container(
                                margin: const EdgeInsets.all(3),
                                height: 365,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColor().reward_card_bg,
                                        width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    image: onlyOffi.gamesMyFavSelected.value != null &&
                                            onlyOffi.gamesMyFavSelected.length >
                                                0 &&
                                            onlyOffi.gamesMyFavSelected[0].name !=
                                                null
                                        ? onlyOffi.gamesMyFavSelected[0].name ==
                                                "POKER"
                                            ? DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    ImageRes().poker_icon))
                                            : onlyOffi.gamesMyFavSelected[0].name ==
                                                    "FANTASY"
                                                ? DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(ImageRes()
                                                        .fantasy_new_logo))
                                                : onlyOffi.gamesMyFavSelected[0]
                                                            .name ==
                                                        "Rummy"
                                                    ? DecorationImage(fit: BoxFit.fill, image: AssetImage(ImageRes().rummy_logo_chngs))
                                                    : DecorationImage(fit: BoxFit.fill, image: AssetImage(ImageRes().skill_ludo_colored))
                                        : DecorationImage(fit: BoxFit.fill, image: AssetImage(ImageRes().rummy_logo_chngs)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColor().colorPrimaryDark,
                                          offset: Offset(4, 4),
                                          blurRadius: 4,
                                          spreadRadius: 0)
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 5),
                                      height: 42,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Obx(
                                                () => onlyOffi.gamesMyFavSelected !=
                                                            null &&
                                                        onlyOffi.gamesMyFavSelected
                                                                .length >
                                                            0 &&
                                                        onlyOffi
                                                                .gamesMyFavSelected[
                                                                    0]
                                                                .name !=
                                                            null
                                                    ? Text(
                                                        onlyOffi
                                                                    .gamesMyFavSelected[
                                                                        0]
                                                                    .name ==
                                                                'POKER'
                                                            ? "POKER".tr
                                                            : onlyOffi
                                                                        .gamesMyFavSelected[
                                                                            0]
                                                                        .name ==
                                                                    'Rummy'
                                                                ? "Rummy".tr
                                                                : onlyOffi
                                                                            .gamesMyFavSelected[
                                                                                0]
                                                                            .name ==
                                                                        'FANTASY'
                                                                    ? "FANTASY"
                                                                        .tr
                                                                    : onlyOffi.gamesMyFavSelected[0].name ==
                                                                            'Skill Ludo'
                                                                        ? "Skill Ludo"
                                                                            .tr
                                                                        : onlyOffi
                                                                            .gamesMyFavSelected[0]
                                                                            .name,
                                                        //  "${onlyOffi.gamesMyFavSelected[0].name}",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color: AppColor()
                                                                .colorGray),
                                                      )
                                                    : Text(
                                                        "Rummy".tr,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color: AppColor()
                                                                .colorGray),
                                                      ),
                                              ),
                                              Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        ImageRes().win_crown),
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  Obx(() => onlyOffi
                                                                  .gamesMyFavSelected
                                                                  .value !=
                                                              null &&
                                                          onlyOffi.gamesMyFavSelected
                                                                  .length >
                                                              0 &&
                                                          onlyOffi
                                                                  .gamesMyFavSelected[
                                                                      0]
                                                                  .name !=
                                                              null
                                                      ? onlyOffi
                                                                  .gamesMyFavSelected[
                                                                      0]
                                                                  .name ==
                                                              "POKER"
                                                          ? Text(
                                                              " 5CR+ " +
                                                                  "Winnings".tr,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontFamily:
                                                                      "Montserrat",
                                                                  color: AppColor()
                                                                      .colorGray),
                                                            )
                                                          : onlyOffi
                                                                      .gamesMyFavSelected[
                                                                          0]
                                                                      .name ==
                                                                  "FANTASY"
                                                              ? Text(
                                                                  " 25L+ " +
                                                                      "Winnings"
                                                                          .tr,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontFamily:
                                                                          "Montserrat",
                                                                      color: AppColor()
                                                                          .colorGray),
                                                                )
                                                              : onlyOffi.gamesMyFavSelected[0]
                                                                          .name ==
                                                                      "Rummy"
                                                                  ? Text(
                                                                      " 1.5CR+ " +
                                                                          "Winnings"
                                                                              .tr,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontFamily:
                                                                              "Montserrat",
                                                                          color:
                                                                              AppColor().colorGray),
                                                                    )
                                                                  : Text(
                                                                      " 3L+ " +
                                                                          "Winnings"
                                                                              .tr,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontFamily:
                                                                              "Montserrat",
                                                                          color:
                                                                              AppColor().colorGray),
                                                                    )
                                                      : Text(
                                                          " 1.5CR+ " +
                                                              "Winnings".tr,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color: AppColor()
                                                                  .colorGray),
                                                        )),
                                                ],
                                              )
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 12,
                                                right: 12,
                                                bottom: 6,
                                                top: 5),
                                            child: Text(
                                              "Play".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Montserrat",
                                                  color: AppColor().whiteColor),
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  AppColor().button_bg_dark,
                                                  AppColor().button_bg_light,
                                                ],
                                              ),

                                              border: Border.all(
                                                  color: AppColor().whiteColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // color: AppColor().whiteColor
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Shimmer.fromColors(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 365,
                              width: MediaQuery.of(context).size.width,
                            ),
                            baseColor: Colors.grey.withOpacity(0.2),
                            highlightColor: Colors.grey.withOpacity(0.4),
                            enabled: true,
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Obx(
                    () => controller.homePageListModel.value != null &&
                            controller.AllGameCall.value.length > 0
                        ? GridView.count(
                            crossAxisCount: 3,
                            padding: EdgeInsets.all(0),
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 15,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: List.generate(3, (index) {
                              return getAllGame(context, index);
                            }),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Obx(
                        () =>
                            controller.homePageListModel.value != null &&
                                    controller
                                            .homePageListModel.value.banners !=
                                        null &&
                                    controller.homePageListModel.value.banners
                                            .length >
                                        0
                                ? Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: controller.ftdCheck.value
                                        ? CarouselSlider(
                                            items:
                                                controller.homePageListModel
                                                    .value.banners
                                                    .map(
                                                      (item) => InkWell(
                                                        hoverColor: Colors.grey
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
                                                                        right:
                                                                            6,
                                                                        left: 6,
                                                                        top:
                                                                            11),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .black,
                                                                        /* border: Border.all(
                                                      color: Colors.white,
                                                      width: 0),*/
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
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
                                                                              padding: const EdgeInsets.only(left: 15, top: 0, bottom: 0),
                                                                              child: Row(
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
                                                                              padding: const EdgeInsets.only(right: 10),
                                                                              child: Row(
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
                                                                                      Text("Expires in".tr,
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
                                                                              child: userController.ShowButton(""),
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
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
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
                                                            hoverColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
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
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            6,
                                                                        left: 6,
                                                                        top:
                                                                            11),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .black,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
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
                                                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: controller.collectAmtVipNextLevel.value != ""
                                                                                      ? Padding(
                                                                                          padding: const EdgeInsets.only(left: 10),
                                                                                          child: Text(controller.collectAmtVipNextLevel.value.contains("-") ? "" : "Collect".tr + " \u{20B9}${controller.collectAmtVipNextLevel.value}",
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
                                                                                                Text("Expires in".tr,
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
                                                                    child:
                                                                        Center(
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          child: CachedNetworkImage(
                                                                            height:
                                                                                100,
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            imageUrl:
                                                                                item.image.url,
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
                                                  onPageChanged:
                                                      (index, reason) {
                                                    controller
                                                        .currentIndexSlider
                                                        .value = index;
                                                  },
                                                ),
                                              )
                                            : CarouselSlider(
                                                items:
                                                    controller.homePageListModel
                                                        .value.banners
                                                        .map(
                                                          (item) => InkWell(
                                                            hoverColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            onTap: () async {
                                                              normalBannerClick(
                                                                  item);
                                                            },
                                                            child: Container(
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
                                                  onPageChanged:
                                                      (index, reason) {
                                                    controller
                                                        .currentIndexSlider
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
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    baseColor: Colors.grey.withOpacity(0.2),
                                    highlightColor:
                                        Colors.grey.withOpacity(0.4),
                                    enabled: true,
                                  ),
                      ),
                      Obx(
                        () => controller.homePageListModel.value != null &&
                                controller.homePageListModel.value.banners !=
                                    null &&
                                controller.homePageListModel.value.banners
                                        .length >
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
                                          color: controller.currentIndexSlider
                                                      .value ==
                                                  index
                                              ? controller.appBtnBgColor.value
                                              : controller
                                                  .appBtnTxtColor.value),
                                    );
                                  },
                                ).toList(), // this was the part the I  had to add
                              )
                            : Text(""),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => controller.homePageListModel.value != null &&
                            controller.AllGameCall.value.length > 0
                        ? GridView.count(
                            crossAxisCount: 3,
                            padding: EdgeInsets.all(0),
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 15,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: List.generate(
                                controller.AllGameCall.value.length - 3,
                                (index) {
                              return getAllGameAll(context, index);
                            }),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getAllGame(BuildContext context, int index) {
    return InkWell(
      hoverColor: Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        if (isRedundentClick(DateTime.now())) {
          Utils().customPrint('ProgressBarClick: showProgress click');
          return;
        }
        Utils().customPrint('ProgressBarClick: showProgress run process');

        updateEventGame(controller.AllGameCall[index].name);
        print("call here isRmg${controller.AllGameCall[index].isRMG}");

        if (!controller.AllGameCall[index].isRMG) {
          if (controller.AllGameCall[index].isClickable) {
            Get.to(() => ESports(
                  controller.AllGameCall[index].id,
                  controller.AllGameCall[index].banner.url,
                  controller.AllGameCall[index].howToPlayUrl,
                  "",
                ));
          }
        } else {
          if (controller.AllGameCall[index].thirdParty != null) {
            if (controller.AllGameCall[index].isClickable) {
              if (ApiUrl().isPlayStore == false) {
                bool stateR = await Utils().checkResLocation(context);
                if (stateR) {
                  return;
                }
              }

              if (controller.AllGameCall[index].name == 'FANTASY') {
                MyTeam11_Ballbazi_Controller team11Controller =
                    Get.put(MyTeam11_Ballbazi_Controller());
                await team11Controller.getLoginTeam11BB(
                    context, '62de6babd6fc1704f21b0ab4');
              } else if (controller.AllGameCall[index].thirdParty.name ==
                  'MyTeam11') {
                try {
                  if (team11Clicked) {
                    team11Clicked = false;
                    MyTeam11_Ballbazi_Controller team11Controller =
                        Get.put(MyTeam11_Ballbazi_Controller());

                    await team11Controller.getLoginTeam11BB(
                        context, controller.AllGameCall[index].id);
                    team11Clicked = true;
                  }
                } catch (A) {}

                //  ballbaziLoginController.getLoginBallabzi(context);
              } else if (controller.AllGameCall[index].thirdParty.name ==
                  'Trago') {
                Trago_Controller tragoController = Get.put(Trago_Controller());

                tragoController.getLoginTrago(
                    context, controller.AllGameCall[index].id);
              } else if (controller.AllGameCall[index].thirdParty.name ==
                  'Pocket52') {
                if (Platform.isIOS) {
                  Fluttertoast.showToast(msg: "Coming soon".tr);
                } else {
                  _pocket52loginController.getLoginWithPocket52(context);
                }
              } else if (controller.AllGameCall[index].thirdParty.name ==
                  'Rummy') {
                //Utils().customPrint('Rummy Starting...');

                final param = {"state": "haryana", "country": "india"};


                Fluttertoast.showToast(msg: "Under Maintenance");

              //  getHashForRummy(param);

                //Utils().customPrint('Rummy Launching...');
                //Fluttertoast.showToast(msg: 'Rummy Launching...');
              } else if (controller.AllGameCall[index].thirdParty.name ==
                  'Ludo King') {
                Get.to(() => LudoKingScreen(controller.AllGameCall[index].id,
                    "", controller.AllGameCall[index].howToPlayUrl));
              } else if (controller.AllGameCall[index].thirdParty.name ==
                  'Gamezop') {
                print("pool click values");

                Fluttertoast.showToast(msg: "Under Maintenance");


                /*   Get.to(() => GameJobList(
                    controller.AllGameCall[index].id,
                    controller.AllGameCall[index].banner.url,
                    controller.AllGameCall[index].name));*/
              } else if (controller.AllGameCall[index].thirdParty.name ==
                  'Freakx') {
                Get.to(() => FreakxList(
                    controller.AllGameCall[index].id,
                    controller.AllGameCall[index].banner.url,
                    controller.AllGameCall[index].name));
              } else if (controller.AllGameCall[index].thirdParty.name ==
                  'Ludot') {
                Get.to(() => TamashaListing(
                    controller.AllGameCall[index].id,
                    controller.AllGameCall[index].banner.url,
                    controller.AllGameCall[index].name));
                /*    Get.to(() => FreakxList(
                      controller.homePageListModel.value
                          .gameCategories[indexfirst].id,
                      controller.homePageListModel.value
                          .gameCategories[indexfirst].banner.url,
                      controller.homePageListModel.value
                          .gameCategories[indexfirst].name));*/
              }
            }

//  Remove when go live
            /*if (controller.homePageListModel.value.gameCategories[indexfirst]
                      .thirdParty.name ==
                  'Gamezop') {
                Get.to(() => GameJobList(
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].id,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].banner.url,
                    controller.homePageListModel.value
                        .gameCategories[indexfirst].name));
              }*/
          } else {
            if (controller.AllGameCall[index].isClickable) {
              Get.to(() => UnityList(
                  controller.AllGameCall[index].id,
                  controller.AllGameCall[index].banner.url,
                  controller.AllGameCall[index].name));
            }
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            width: 132,
            height: 132.998,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: "${controller.AllGameCall[index].banner.url}",
                placeholder: (context, url) =>
                    Container(color: Colors.black, child: Icon(Icons.error)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                //    borderRadius: const BorderRadius.all(Radius.circular(15)),

                /* image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImage(
                      height: 110,
                      width: 135,
                      fit: BoxFit.cover,
                      imageUrl: controller.homePageListModel.value
                          .trendingEvents[index].banner.url,
                    )


                  */ /*NetworkImage(
                        "${controller.AllGameCall[index].banner.url}")*/ /*),*/
                // image: DecorationImage(image: AssetImage(ImageRes().pool_logo)),
                boxShadow: [
                  BoxShadow(
                      color: AppColor().colorPrimaryDark,
                      offset: Offset(3, 3),
                      blurRadius: 4,
                      spreadRadius: 0)
                ])),
      ),
    );
  }

  Widget getAllGameAll(BuildContext context, int index) {
    return InkWell(
      hoverColor: Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        if (isRedundentClick(DateTime.now())) {
          Utils().customPrint('ProgressBarClick: showProgress click');
          return;
        }
        Utils().customPrint('ProgressBarClick: showProgress run process');

        updateEventGame(controller.AllGameCall[index + 3].name);
        print("call here isRmg${controller.AllGameCall[index].isRMG}");

        if (!controller.AllGameCall[index + 3].isRMG) {
          if (controller.AllGameCall[index + 3].isClickable) {
            Get.to(() => ESports(
                  controller.AllGameCall[index + 3].id,
                  controller.AllGameCall[index + 3].banner.url,
                  controller.AllGameCall[index + 3].howToPlayUrl,
                  "",
                ));
          }
        } else {
          if (controller.AllGameCall[index + 3].thirdParty != null) {
            if (controller.AllGameCall[index + 3].isClickable) {
              if (ApiUrl().isPlayStore == false) {
                bool stateR = await Utils().checkResLocation(context);
                if (stateR) {
                  return;
                }
              }

              if (controller.AllGameCall[index + 3].name == 'FANTASY') {
                MyTeam11_Ballbazi_Controller team11Controller =
                    Get.put(MyTeam11_Ballbazi_Controller());
                await team11Controller.getLoginTeam11BB(
                    context, '62de6babd6fc1704f21b0ab4');
              } else if (controller.AllGameCall[index + 3].thirdParty.name ==
                  'MyTeam11') {
                try {
                  if (team11Clicked) {
                    team11Clicked = false;
                    MyTeam11_Ballbazi_Controller team11Controller =
                        Get.put(MyTeam11_Ballbazi_Controller());

                    await team11Controller.getLoginTeam11BB(
                        context, controller.AllGameCall[index + 3].id);
                    team11Clicked = true;
                  }
                } catch (A) {}

                //  ballbaziLoginController.getLoginBallabzi(context);
              } else if (controller.AllGameCall[index + 3].thirdParty.name ==
                  'Trago') {
                Trago_Controller tragoController = Get.put(Trago_Controller());

                tragoController.getLoginTrago(
                    context, controller.AllGameCall[index + 3].id);
              } else if (controller.AllGameCall[index + 3].thirdParty.name ==
                  'Pocket52') {
                if (Platform.isIOS) {
                  Fluttertoast.showToast(msg: "Coming soon".tr);
                } else {
                  _pocket52loginController.getLoginWithPocket52(context);
                }
              } else if (controller.AllGameCall[index + 3].thirdParty.name ==
                  'Rummy') {
                //Utils().customPrint('Rummy Starting...');

                final param = {"state": "haryana", "country": "india"};

                Fluttertoast.showToast(msg: "Under Maintenance");
             //   getHashForRummy(param);

                //Utils().customPrint('Rummy Launching...');
                //Fluttertoast.showToast(msg: 'Rummy Launching...');
              } else if (controller.AllGameCall[index + 3].thirdParty.name ==
                  'Ludo King') {
                Get.to(() => LudoKingScreen(
                    controller.AllGameCall[index + 3].id,
                    "",
                    controller.AllGameCall[index + 3].howToPlayUrl));
              } else if (controller.AllGameCall[index + 3].thirdParty.name ==
                  'Gamezop') {
                print("pool click values");
                Fluttertoast.showToast(msg: "Under Maintenance");


                /*  Get.to(() => GameJobList(
                    controller.AllGameCall[index + 3].id,
                    controller.AllGameCall[index + 3].banner.url,
                    controller.AllGameCall[index + 3].name));*/
              } else if (controller.AllGameCall[index + 3].thirdParty.name ==
                  'Freakx') {
                Get.to(() => FreakxList(
                    controller.AllGameCall[index + 3].id,
                    controller.AllGameCall[index + 3].banner.url,
                    controller.AllGameCall[index + 3].name));
              } else if (controller.AllGameCall[index + 3].thirdParty.name ==
                  'Ludot') {
                Get.to(() => TamashaListing(
                    controller.AllGameCall[index + 3].id,
                    controller.AllGameCall[index + 3].banner.url,
                    controller.AllGameCall[index + 3].name));
              }
            }
          } else {
            if (controller.AllGameCall[index + 3].isClickable) {
              Get.to(() => UnityList(
                  controller.AllGameCall[index + 3].id,
                  controller.AllGameCall[index + 3].banner.url,
                  controller.AllGameCall[index + 3].name));
            }
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            width: 132,
            height: 132.998,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "${controller.AllGameCall[index + 3].banner.url}")),
                boxShadow: [
                  BoxShadow(
                      color: AppColor().colorPrimaryDark,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 0)
                ])),
      ),
    );
  }

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

  void updateEventGame(String game_name) {
    print("call here game name${game_name}");
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
                      Fluttertoast.showToast(msg: "Under Maintenance");

                      /*  Get.to(() => GameJobList(
                          item.gameId, objSub.banner.url, objSub.name));*/
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
                      Fluttertoast.showToast(msg: "Under Maintenance");

                      /* Get.to(() => GameJobList(
                          item.gameId, objSub.banner.url, objSub.name));*/
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
              Fluttertoast.showToast(msg: "Under Maintenance");

              // getHashForRummy(param);
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
                    Fluttertoast.showToast(msg: "Under Maintenance");

                    /*         Get.to(() => GameJobList(
                        item.gameId, objSub.banner.url, objSub.name));*/
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

                    Fluttertoast.showToast(msg: "Under Maintenance");

                    /*     Get.to(() => GameJobList(
                        item.gameId, objSub.banner.url, objSub.name));*/
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
            Fluttertoast.showToast(msg: "Under Maintenance");

            // getHashForRummy(param);
          }
        }
      } else {
        /*    Fluttertoast.showToast(
                                                msg: "Url not found!");*/
      }
    }

    //new banner click work
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
              .catchError((e) => Fluttertoast.showToast(msg: e.toString()));
        } else {
          //Fluttertoast.showToast(msg: "Update NOT Available");
        }
      });
    }).catchError((e) {
      print("checkForUpdate");
      print(e.toString());
      //showSnack(e.toString());
    });
  }

  //multi click issue manage
  DateTime loginClickTime;
  bool isRedundentClickNotUsed(DateTime currentTime) {
    //NOT USED
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      Utils().customPrint('ProgressBarClick: showProgress first click');
      return false;
    }
    print('diff is ${currentTime.difference(loginClickTime).inSeconds}');
    Utils().customPrint('ProgressBarClick: showProgress diff');
    if (currentTime.difference(loginClickTime).inSeconds < 2) {
      // set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
  }

  //isRedundentClick6times
  int clickCounter = 0;
  bool isRedundentClick(DateTime currentTime) {
    clickCounter++;
    Utils().customPrint('clickCounter : $clickCounter');
    if (clickCounter > 6) {
      Utils().customPrint('clickCounter exceeded : $clickCounter');
      Fluttertoast.showToast(
          msg: 'You have exceeded click limits, Please wait!'.tr);
      Future.delayed(const Duration(seconds: 5), () async {
        clickCounter = 0;
        Utils().customPrint('clickCounter reset : $clickCounter');
      });
      return true;
    }
    return false;
  }
}
