import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/LoginModel/hash_rummy.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/toolbar/SliderBar.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/main/Clan/Clan.dart';
import 'package:gmng/ui/main/how_to_pay_rummy.dart';
import 'package:gmng/ui/main/reward/Rewards.dart';
import 'package:gmng/ui/main/wallet/OfferWallScreen.dart';
import 'package:gmng/ui/main/wallet/Wallet.dart';
import 'package:gmng/utills/Platfrom.dart';
import 'package:gmng/utills/bridge.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBarNew.dart';
import '../../../utills/OnlyOff.dart';
import '../../../utills/Utils.dart';
import '../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../utills/event_tracker/EventConstant.dart';
import '../../../utills/event_tracker/FaceBookEventController.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../HomePageNew.dart';
import '../../controller/EditProfileController.dart';
import '../../controller/Pocket52_Controller.dart';
import '../../controller/user_controller.dart';
import '../myteam11_ballabazzi/MyTeam11_Ballbazi_Controller.dart';
import '../tamasha_ludo/TamashaListing.dart';

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class DashBord extends StatefulWidget {
  int indexShow;
  String game_call;

  DashBord(this.indexShow, this.game_call);

  DashBordState createState() => DashBordState(indexShow, game_call);
}

class DashBordState extends State<DashBord> with WidgetsBindingObserver {
  UserController userController = Get.put(UserController());
  int indexCus;
  String game_call;
  EditProfileController controller = Get.put(EditProfileController());

  DashBordState(this.indexCus, this.game_call);

  UserPreferences userPreferences;

  String titile = "Home";
  double height, width;
  final List<Widget> _children = [
    //LeaderBoard(),
    OfferWallScreen(),
    Rewards(),
    HomePageNew(),
    Clan(),
    Wallet(),
  ];

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //internet check
    getConnectivity();
    controller.getProfileData();
    userController.currentIndex.value = indexCus;
    userController.iswalletCheck.value = indexCus;

    if (game_call.isNotEmpty &&
        game_call.compareTo("62de6babd6fc1704f21b0ab5") == 0) {
      if (Platform.isIOS) {
        Fluttertoast.showToast(msg: "Coming soon");
      } else {
        Pocket52LoginController _pocket52loginController;
        _pocket52loginController = Get.put(Pocket52LoginController());

        _pocket52loginController.getLoginWithPocket52(context);
      }
    } else if (game_call.isNotEmpty &&
        game_call.compareTo("62de6babd6fc1704f21b0ab4") == 0) {
      /* BallbaziLoginController ballbaziLoginController;
      ballbaziLoginController = Get.put(BallbaziLoginController());
      ballbaziLoginController.getLoginBallabzi(context);*/
      MyTeam11_Ballbazi_Controller team11Controller =
          Get.put(MyTeam11_Ballbazi_Controller());

      team11Controller.getLoginTeam11BB(context, '62de6babd6fc1704f21b0ab4');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //   controller.getProfileData();
    userController.checkWallet_class_call.value = false;
    height = MediaQuery.of(context).size.height;
    width = Platfrom().isWeb()
        ? MediaQuery.of(context).size.width * FontSizeC().screen_percentage_web
        : MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
          width: width,
          child: Obx(
            () => Container(
              width: width,
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.black,
                resizeToAvoidBottomInset: false,
                drawer: userController.showProgressDownloade.value == false
                    ? SliderBarCus()
                    : SizedBox(),
                body: Stack(children: [
                  Obx(() => Padding(
                        padding: const EdgeInsets.only(top: 00),
                        child: _children[userController.currentIndex.value],
                      )),
                  Obx(
                    () => Container(
                      height: 60 + AppString.appBarHeight.value,
                      color: Colors.transparent,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                              height: 60,
                              padding: EdgeInsets.only(
                                  top: AppString.appBarHeight.value - 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: topBarSec()),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 58,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: Obx(
                                () => Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        //  behavior: HitTestBehavior.translucent,
                                        onTap: () async {
                                          if (!await InternetConnectionChecker()
                                              .hasConnection) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'INTERNET CONNECTIVITY LOST');
                                            return null;
                                          }
                                          if (userController
                                                  .showProgressDownloade
                                                  .value ==
                                              false) {
                                            WalletPageController
                                                walletPageController =
                                                Get.put(WalletPageController());
                                            if (ApiUrl().isPlayStore) {
                                              if (walletPageController
                                                      .user_mobileNo ==
                                                  '9829953786') {
                                                Fluttertoast.showToast(
                                                    msg: "Under maintenance");
                                                return;
                                              }
                                            }
                                            userController.currentIndex.value =
                                                0;
                                            AppString.isClickFromHome = true;
                                            DashBord(0, "");

                                            walletPageController
                                                .getAdvertisersDeals();
                                            //Get.to(() => OfferWallScreen());
                                            await walletPageController
                                                .getUserDeals();
                                          }
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Image(
                                                  width: 35,
                                                  height: 25,
                                                  /*  color: userController
                                                            .currentIndex.value ==
                                                        0
                                                    ? AppColor().colorPrimary
                                                    : const Color(0x0000000),*/
                                                  image: AssetImage(
                                                      "assets/images/lootbox_new1.png")),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "Lootbox".tr,
                                              style: TextStyle(
                                                color: userController
                                                            .currentIndex
                                                            .value ==
                                                        0
                                                    ? AppColor().colorPrimary
                                                    : const Color(0xffFFFFFF),
                                                fontFamily: "Montserrat",
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        /* behavior:
                                            HitTestBehavior.translucent,*/
                                        onTap: () async {
                                          if (!await InternetConnectionChecker()
                                              .hasConnection) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'INTERNET CONNECTIVITY LOST');
                                            return null;
                                          }
                                          //appsflyer
                                          Map<String, dynamic> map_appsflyer = {
                                            "pages_call": "Reward",
                                            "USED_ID": userController.user_id
                                          };
                                          AppsflyerController c = await Get.put(
                                              AppsflyerController());
                                          c.logEventAf(
                                              EventConstant.bottom_click_event,
                                              map_appsflyer);
                                          //clevertap
                                          Map<String, dynamic> map_clevertap = {
                                            "pages_call": "Reward",
                                            "USED_ID": userController.user_id
                                          };
                                          CleverTapController
                                              cleverTapController =
                                              Get.put(CleverTapController());
                                          cleverTapController.logEventCT(
                                              EventConstant.bottom_click_event,
                                              map_clevertap);
                                          Map<String, dynamic> map_clevertapv1 =
                                              {
                                            "USED_ID": userController.user_id
                                          };
                                          cleverTapController.logEventCT(
                                              EventConstant
                                                  .EVENT_CLEAVERTAB_Reward_Screen,
                                              map_clevertapv1);

                                          FirebaseEvent().firebaseEvent(
                                              EventConstant
                                                  .EVENT_CLEAVERTAB_Reward_Screen_F,
                                              map_clevertapv1);
                                          //new
                                          //facebook
                                          //Map<String, dynamic> map_fb = {"pages_call": "Reward"};
                                          //FaceBookEventController().logEventFacebook(EventConstant.bottom_click_event, map_fb);

                                          if (userController
                                                  .showProgressDownloade
                                                  .value ==
                                              false) {
                                            userController.currentIndex.value =
                                                1;
                                            DashBord(1, "");
                                          }
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 19),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ImageIcon(
                                                const AssetImage(
                                                    "assets/images/reward_new.png"),
                                                color: userController
                                                            .currentIndex
                                                            .value ==
                                                        1
                                                    ? AppColor().colorPrimary
                                                    : const Color(0xffFFFFFF),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                "reward".tr,
                                                style: TextStyle(
                                                  color: userController
                                                              .currentIndex
                                                              .value ==
                                                          1
                                                      ? AppColor().colorPrimary
                                                      : const Color(0xffFFFFFF),
                                                  fontFamily: "Montserrat",
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 25),
                                      child: Text(
                                        "play_now".tr,
                                        style: TextStyle(
                                          color: userController
                                                      .currentIndex.value ==
                                                  2
                                              ? AppColor().colorPrimary
                                              : const Color(0xffFFFFFF),
                                          // fontFamily: "Montserrat",
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    onlyOffi.gamesMyFavSelected.value != null &&
                                            onlyOffi.gamesMyFavSelected
                                                    .length >=
                                                1
                                        ? Expanded(
                                            child: InkWell(
                                              /*behavior: HitTestBehavior
                                                  .translucent,*/
                                              onTap: () async {
                                                if (!await InternetConnectionChecker()
                                                    .hasConnection) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'INTERNET CONNECTIVITY LOST');
                                                  return null;
                                                }
                                                if (isRedundentClick(
                                                    DateTime.now())) {
                                                  Utils().customPrint(
                                                      'ProgressBarClick: showProgress click');
                                                  return;
                                                }
                                                Utils().customPrint(
                                                    'ProgressBarClick: showProgress run process');

                                                if (onlyOffi
                                                            .gamesMyFavSelected[
                                                                0]
                                                            .thirdParty !=
                                                        null &&
                                                    onlyOffi
                                                            .gamesMyFavSelected[
                                                                0]
                                                            .thirdParty
                                                            .name !=
                                                        null) {
                                                  if (onlyOffi
                                                          .gamesMyFavSelected[0]
                                                          .thirdParty
                                                          .name ==
                                                      "Pocket52") {
                                                    if (onlyOffi
                                                        .gamesMyFavSelected[0]
                                                        .isClickable) {
                                                      userController
                                                          .currentIndex
                                                          .value = 2;
                                                      DashBord(2, "");
                                                      Pocket52LoginController
                                                          _pocket52loginController =
                                                          Get.put(
                                                              Pocket52LoginController());
                                                      _pocket52loginController
                                                          .getLoginWithPocket52(
                                                              context);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Under maintenance");
                                                    }
                                                  } else if (onlyOffi
                                                          .gamesMyFavSelected[0]
                                                          .thirdParty
                                                          .name ==
                                                      "Rummy") {
                                                    userController
                                                        .currentIndex.value = 2;
                                                    DashBord(2, "");
                                                    if (AppString
                                                        .rummyisClickable) {
                                                      final param = {
                                                        "state": "haryana",
                                                        "country": "india"
                                                      };


                                                      Fluttertoast.showToast(msg: "Under Maintenance");

                                                      //    getHashForRummy(param);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Under maintenance");
                                                    }
                                                  } else if (onlyOffi
                                                          .gamesMyFavSelected[0]
                                                          .name ==
                                                      "FANTASY") {
                                                    if (onlyOffi
                                                        .gamesMyFavSelected[0]
                                                        .isClickable) {
                                                      userController
                                                          .currentIndex
                                                          .value = 2;
                                                      DashBord(2, "");
                                                      MyTeam11_Ballbazi_Controller
                                                          team11Controller =
                                                          Get.put(
                                                              MyTeam11_Ballbazi_Controller());

                                                      await team11Controller
                                                          .getLoginTeam11BB(
                                                              context,
                                                              '62de6babd6fc1704f21b0ab4');
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Under maintenance");
                                                    }
                                                  } else if (onlyOffi
                                                          .gamesMyFavSelected[0]
                                                          .name ==
                                                      "Skill Ludo") {
                                                    if (onlyOffi
                                                        .gamesMyFavSelected[0]
                                                        .isClickable) {
                                                      userController
                                                          .currentIndex
                                                          .value = 2;
                                                      DashBord(2, "");
                                                      Get.to(() => TamashaListing(
                                                          onlyOffi
                                                              .gamesMyFavSelected[
                                                                  0]
                                                              .id,
                                                          onlyOffi
                                                              .gamesMyFavSelected[
                                                                  0]
                                                              .banner
                                                              .url,
                                                          onlyOffi
                                                              .gamesMyFavSelected[
                                                                  0]
                                                              .name));
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Under maintenance"
                                                                  .tr);
                                                    }
                                                  }
                                                }

                                                // old click
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 19),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Obx(() => onlyOffi
                                                                    .gamesMyFavSelected
                                                                    .value !=
                                                                null &&
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
                                                            ? ImageIcon(
                                                                AssetImage(
                                                                    "assets/images/rummy_new.png"),
                                                                color: const Color(
                                                                    0xffFFFFFF),
                                                              )
                                                            : onlyOffi
                                                                        .gamesMyFavSelected[
                                                                            0]
                                                                        .name ==
                                                                    "FANTASY"
                                                                ? ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/fantasy_word_c.png"),
                                                                    color: const Color(
                                                                        0xffFFFFFF),
                                                                  )
                                                                : onlyOffi.gamesMyFavSelected[0]
                                                                            .name ==
                                                                        "Rummy"
                                                                    ? ImageIcon(
                                                                        AssetImage(
                                                                            "assets/images/rummy_new.png"),
                                                                        color: const Color(
                                                                            0xffFFFFFF),
                                                                      )
                                                                    : ImageIcon(
                                                                        AssetImage(
                                                                            "assets/images/dice_cube_outline.png"),
                                                                        color: const Color(
                                                                            0xffFFFFFF),
                                                                      )
                                                        : ImageIcon(
                                                            AssetImage(
                                                                "assets/images/dice_cube_outline.png"),
                                                            color: const Color(
                                                                0xffFFFFFF),
                                                          )),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Obx(
                                                      () => onlyOffi.gamesMyFavSelected[
                                                                      0] !=
                                                                  null &&
                                                              onlyOffi
                                                                      .gamesMyFavSelected[
                                                                          0]
                                                                      .name !=
                                                                  null
                                                          ? Text(
                                                              //"${onlyOffi.gamesMyFavSelected[0].name}",
                                                              onlyOffi
                                                                          .gamesMyFavSelected[
                                                                              0]
                                                                          .name ==
                                                                      'POKER'
                                                                  ? "POKER".tr
                                                                  : onlyOffi.gamesMyFavSelected[0].name ==
                                                                          'Rummy'
                                                                      ? "Rummy"
                                                                          .tr
                                                                      : onlyOffi.gamesMyFavSelected[0].name ==
                                                                              'FANTASY'
                                                                          ? "FANTASY"
                                                                              .tr
                                                                          : onlyOffi.gamesMyFavSelected[0].name == 'Skill Ludo'
                                                                              ? "Skill Ludo".tr
                                                                              : onlyOffi.gamesMyFavSelected[0].name,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xffFFFFFF),
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontSize: 10,
                                                              ),
                                                            )
                                                          : Text(
                                                              "Rummy".tr,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xffFFFFFF),
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : ApiUrl().isPlayStore == true
                                            ? Expanded(
                                                child: InkWell(
                                                  /*behavior: HitTestBehavior
                                                      .translucent,*/
                                                  onTap: () async {
                                                    if (!await InternetConnectionChecker()
                                                        .hasConnection) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'INTERNET CONNECTIVITY LOST');
                                                      return null;
                                                    }
                                                    //appsflyer
                                                    Map<String, dynamic>
                                                        map_appsflyer = {
                                                      "pages_call": "Clan",
                                                      "USED_ID":
                                                          userController.user_id
                                                    };
                                                    AppsflyerController c =
                                                        await Get.put(
                                                            AppsflyerController());
                                                    c.logEventAf(
                                                        EventConstant
                                                            .bottom_click_event,
                                                        map_appsflyer);

                                                    //clevertap
                                                    Map<String, dynamic>
                                                        map_clevertap = {
                                                      "pages_call": "Clan",
                                                      "USED_ID":
                                                          userController.user_id
                                                    };
                                                    CleverTapController
                                                        cleverTapController =
                                                        Get.put(
                                                            CleverTapController());
                                                    cleverTapController.logEventCT(
                                                        EventConstant
                                                            .bottom_click_event,
                                                        map_clevertap);
                                                    Map<String, dynamic>
                                                        map_clevertapv1 = {
                                                      "USED_ID":
                                                          userController.user_id
                                                    };
                                                    cleverTapController.logEventCT(
                                                        EventConstant
                                                            .EVENT_CLEAVERTAB_Clan_Screen,
                                                        map_clevertapv1);

                                                    //facebook
                                                    Map<String, dynamic>
                                                        map_fb = {
                                                      "pages_call": "Clan",
                                                      "USED_ID":
                                                          userController.user_id
                                                    };
                                                    FaceBookEventController()
                                                        .logEventFacebook(
                                                            EventConstant
                                                                .bottom_click_event,
                                                            map_fb);

                                                    if (userController
                                                            .showProgressDownloade
                                                            .value ==
                                                        false) {
                                                      userController
                                                          .currentIndex
                                                          .value = 3;
                                                      DashBord(3, "");
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 19),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        ImageIcon(
                                                          AssetImage(ImageRes()
                                                              .clan_new),
                                                          color: userController
                                                                      .currentIndex
                                                                      .value ==
                                                                  3
                                                              ? AppColor()
                                                                  .colorPrimary
                                                              : const Color(
                                                                  0xffFFFFFF),
                                                        ),
                                                        /*    Icon(
                                              Icons.history_edu,
                                              color: _currentIndex == 3
                                                  ? AppColor().colorPrimary
                                                  : const Color(0xffFFFFFF),
                                            ), */
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "txt_clan".tr,
                                                          style: TextStyle(
                                                            color: userController
                                                                        .currentIndex
                                                                        .value ==
                                                                    3
                                                                ? AppColor()
                                                                    .colorPrimary
                                                                : const Color(
                                                                    0xffFFFFFF),
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: InkWell(
                                                  /*behavior: HitTestBehavior
                                                      .translucent,*/
                                                  onTap: () async {
                                                    if (!await InternetConnectionChecker()
                                                        .hasConnection) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'INTERNET CONNECTIVITY LOST');
                                                      return null;
                                                    }
                                                    if (ApiUrl().isPlayStore ==
                                                        false) {
                                                      bool stateR =
                                                          await Utils()
                                                              .checkResLocation(
                                                                  context);
                                                      if (stateR) {
                                                        return;
                                                      }
                                                    }
                                                    userController
                                                        .currentIndex.value = 2;
                                                    DashBord(2, "");

                                                    if (AppString
                                                        .rummyisClickable) {
                                                      final param = {
                                                        "state": "haryana",
                                                        "country": "india"
                                                      };

                                                      Fluttertoast.showToast(msg: "Under Maintenance");

                                                      //   getHashForRummy(param);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Under maintenance"
                                                                  .tr);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 19),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        ImageIcon(
                                                          AssetImage(
                                                              "assets/images/rummy_new.png"),
                                                          color: const Color(
                                                              0xffFFFFFF),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "Rummy".tr,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                    // e wallet call
                                    Expanded(
                                      child: InkWell(
                                        //  behavior: HitTestBehavior.translucent,
                                        onTap: () async {
                                          if (!await InternetConnectionChecker()
                                              .hasConnection) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'INTERNET CONNECTIVITY LOST');
                                            return null;
                                          }
                                          //appsflyer
                                          Map<String, dynamic> map_appsflyer = {
                                            "pages_call": "Wallet",
                                            "USED_ID": userController.user_id
                                          };
                                          AppsflyerController c = await Get.put(
                                              AppsflyerController());
                                          c.logEventAf(
                                              EventConstant.bottom_click_event,
                                              map_appsflyer);

                                          //clevertap
                                          Map<String, dynamic> map_clevertap = {
                                            "pages_call": "Wallet",
                                            "USED_ID": userController.user_id
                                          };
                                          CleverTapController
                                              cleverTapController =
                                              Get.put(CleverTapController());
                                          cleverTapController.logEventCT(
                                              EventConstant.bottom_click_event,
                                              map_clevertap);
                                          Map<String, dynamic> map_clevertapv1 =
                                              {
                                            "USED_ID": userController.user_id
                                          };
                                          cleverTapController.logEventCT(
                                              EventConstant
                                                  .EVENT_CLEAVERTAB_Wallet_Screen,
                                              map_clevertapv1);

                                          FirebaseEvent().firebaseEvent(
                                              EventConstant
                                                  .EVENT_CLEAVERTAB_Wallet_Screen_F,
                                              map_clevertapv1);

                                          //facebook
                                          //Map<String, dynamic> map_fb = {"pages_call": "Wallet"};
                                          //FaceBookEventController().logEventFacebook(EventConstant.bottom_click_event, map_fb);

                                          if (userController
                                                  .showProgressDownloade
                                                  .value ==
                                              false) {
                                            userController.getWalletAmount();
                                            userController.currentIndex.value =
                                                4;
                                            DashBord(4, "");
                                          }
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ImageIcon(
                                              const AssetImage(
                                                  "assets/images/wallet_new.png"),
                                              color: userController
                                                          .currentIndex.value ==
                                                      4
                                                  ? AppColor().colorPrimary
                                                  : const Color(0xffFFFFFF),
                                            ),
                                            /* Im(
                                            Icons.account_circle,
                                            color: _currentIndex == 4
                                                ? AppColor().colorPrimary
                                                : const Color(0xffFFFFFF),
                                          ),*/
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "e_wallet".tr,
                                              style: TextStyle(
                                                color: userController
                                                            .currentIndex
                                                            .value ==
                                                        4
                                                    ? AppColor().colorPrimary
                                                    : const Color(0xffFFFFFF),
                                                fontFamily: "Montserrat",
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: GestureDetector(
                            //backgroundColor: Colors.transparent,
                            onTap: () async {
                              if (!await InternetConnectionChecker()
                                  .hasConnection) {
                                Fluttertoast.showToast(
                                    msg: 'INTERNET CONNECTIVITY LOST');
                                return null;
                              }
                              Map<String, dynamic> map = {
                                "pages_call": "Home Pages",
                                "USED_ID": userController.user_id
                              };
                              AppsflyerController c =
                                  await Get.put(AppsflyerController());
                              c.logEventAf(
                                  EventConstant.bottom_click_event, map);
                              CleverTapController cleverTapController =
                                  Get.put(CleverTapController());
                              cleverTapController.logEventCT(
                                  EventConstant.bottom_click_event, map);
                              userController.currentIndex.value = 2;
                              DashBord(2, "");
                              userController.getWalletAmount();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Obx(
                                () => userController.currentIndex.value == 2
                                    ? Image.asset(
                                        "assets/images/s_play_now.webp",
                                        height: 55,
                                        fit: BoxFit.fill,
                                        width: 55,
                                      )
                                    : new Image.asset(
                                        "assets/images/us_play_now.webp",
                                        height: 55,
                                        fit: BoxFit.fill,
                                        width: 55,
                                      ),
                              ),
                            )),
                      )
                    ],
                  )
                ]),
              ),
            ),
          )),
    );
  }

  Widget backgroudImage() {
    return Container(
      width: width,
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.black, Colors.black12],
          begin: Alignment.bottomCenter,
          end: Alignment.center,
        ).createShader(bounds),
        blendMode: BlendMode.darken,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home_bg_full.webp'),
            ),
          ),
        ),
      ),
    );
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            //showDialogBox();
            cupertinoDialog(context);
            setState(() => isAlertSet = true);
            //Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
          } else {
            //Fluttertoast.showToast(msg: 'INTERNET RECOVERED');
          }
        },
      );

  //not used
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  Future<void> cupertinoDialog(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'No Connection!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'Please check your internet connectivity',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                  color: AppColor().clan_header_dark,
                ),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                  setState(() => isAlertSet = false);
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected && isAlertSet == false) {
                    cupertinoDialog(context);
                    setState(() => isAlertSet = true);
                  }
                },
                child: Text('OK',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    )),
              ),
            ],
          );
        })) {
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  //rummy api
  Future<void> getHashForRummy(Map<String, dynamic> param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Map<String, dynamic> response =
        await WebServicesHelper().getHashForRummy(token, param);

    Utils().customPrint('response $response');
    if (response != null) {
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

  //multi click issue manage
  DateTime loginClickTime;
  bool isRedundentClick(DateTime currentTime) {
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

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("get notification done ");

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      print("check oriantation portrait");
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      // is portrait
    } else {
      print("check oriantation portrait");

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

// is landscape
    }
  }
}

class CircleBlurPainter extends CustomPainter {
  CircleBlurPainter({@required this.circleWidth, this.blurSigma});

  double circleWidth;
  double blurSigma;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = Colors.lightBlue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
