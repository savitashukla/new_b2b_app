import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:get/get.dart';
import 'package:gmng/model/HomeModel/Game.dart';
import 'package:gmng/model/LoginModel/hash_rummy.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/changes_language/ChangesLanguage.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/toolbar/form16_webview.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/login/Login.dart';
import 'package:gmng/ui/main/leaderboard/LeaderBoard.dart';
import 'package:gmng/ui/main/profile/EditProfile.dart';
import 'package:gmng/ui/main/profile/Profile.dart';
import 'package:gmng/ui/main/team_management/TeamManagementNew.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/bridge.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:onetaplogin/onetaplogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../preferences/UserPreferences.dart';
import '../res/ImageRes.dart';
import '../ui/HomePageNew.dart';
import '../ui/controller/BaseController.dart';
import '../ui/controller/FreshChatController.dart';
import '../ui/main/dashbord/DashBord.dart';
import '../ui/main/dashbord/favourite_game/FavouriteGame.dart';
import '../ui/main/store/Store.dart';
import '../utills/event_tracker/AppsFlyerController.dart';
import '../utills/event_tracker/CleverTapController.dart';
import '../utills/event_tracker/EventConstant.dart';
import '../webservices/WebServicesHelper.dart';
import 'TopBarNew.dart';

class SliderBarCus extends StatelessWidget {
  UserController controller = Get.put(UserController());
  UserPreferences userPreferences;

  SliderBarCus({Key key}) : super(key: key);
  CleverTapController cleverTapController = Get.put(CleverTapController());
  AppsflyerController c = Get.put(AppsflyerController());
  WalletPageController walle = Get.put(WalletPageController());
  @override
  Widget build(BuildContext context) {
    userPreferences = new UserPreferences(context);

    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Stack(
            children: [
              SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 10,
                        ),
                        Container(
                          height: 207,
                          child: Column(
                            children: [
                              Obx(
                                () => controller.profileDataRes.value != null &&
                                        controller.profileDataRes.value.level !=
                                            null &&
                                        controller.profileDataRes.value.level
                                                .value >
                                            0
                                    ? Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(
                                                          () => EditProfile());
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          AppColor()
                                                              .colorPrimary,
                                                      radius:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            15.5,
                                                        child: Obx(
                                                          () => controller.profileDataRes
                                                                          .value !=
                                                                      null &&
                                                                  controller
                                                                          .profileDataRes
                                                                          .value
                                                                          .photo !=
                                                                      null
                                                              ? ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            52),
                                                                  ),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    height: 107,
                                                                    width: 107,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    imageUrl:
                                                                        ("${controller.profileDataRes.value.photo.url}"),
                                                                    /*height: 20,
                                                            width: 20*/
                                                                  ),
                                                                )
                                                              : Center(
                                                                  child: Image(
                                                                  height: 30,
                                                                  image: AssetImage(
                                                                      ImageRes()
                                                                          .team_group),
                                                                )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 12.5,
                                                    right: 0,
                                                    //right: MediaQuery.of(context).size.width / 2 + 32.5,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            EditProfile());
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            AppColor()
                                                                .colorPrimary,
                                                        radius: 12.5,
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(0),
                                            height: 33,
                                            child: Image.asset(
                                                "assets/images/ic_cron.png"),
                                          ),
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => EditProfile());
                                            },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  AppColor().colorPrimary,
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  15,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    15.5,
                                                child: Obx(
                                                  () => controller.profileDataRes
                                                                  .value !=
                                                              null &&
                                                          controller
                                                                  .profileDataRes
                                                                  .value
                                                                  .photo !=
                                                              null
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(52),
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            height: 107,
                                                            width: 107,
                                                            fit: BoxFit.fill,
                                                            imageUrl:
                                                                ("${controller.profileDataRes.value.photo.url}"),
                                                            /*height: 20,
                                                            width: 20*/
                                                          ),
                                                        )
                                                      : Center(
                                                          child: Image(
                                                          height: 30,
                                                          image: AssetImage(
                                                              ImageRes()
                                                                  .team_group),
                                                        )),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 12.5,
                                            right: 0,
                                            //right: MediaQuery.of(context).size.width / 2 + 32.5,
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(() => EditProfile());
                                              },
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    AppColor().colorPrimary,
                                                radius: 12.5,
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              Obx(
                                () => controller.profileDataRes.value != null
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(() => EditProfile());
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${controller.profileDataRes.value.username != null ? controller.profileDataRes.value.username : ""}"
                                                  .capitalize,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: "Montserrat",
                                                  color: AppColor().whiteColor),
                                            ),
                                            Text(
                                              "${controller.profileDataRes.value.mobile.getFullNumber()}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: "Montserrat",
                                                  color: AppColor().colorGray),
                                            ),
                                            /*  Obx(
                                              ()=> controller.profileDataRes.value!=null && controller.profileDataRes.value.level!=null && controller.profileDataRes.value.level.value > 0?  Padding(
                                                padding: const EdgeInsets.only(top: 3),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [

                                                    SmoothStarRating(
                                                      rating: 0.0,
                                                      size: 45,
                                                      filledIconData: Icons.star,
                                                      halfFilledIconData: Icons.star_half,
                                                      defaultIconData: Icons.star_border,
                                                      starCount: 5,
                                                      allowHalfRating: true,
                                                      onRated: (v) async {

                                                        //      rating = v;
                                                        print("get rested values $v ");
                                                      },
                                                      spacing: 2.0,
                                                    )

                                                  */ /*  Image(
                                                        height:19,
                                                        width: 19,
                                                        fit: BoxFit.fill,
                                                        image: AssetImage("assets/images/star_icon.png")),

                                                    SizedBox(width: 1,),
                                                    Image(
                                                        height: 19,
                                                        width: 19,
                                                        fit: BoxFit.fill,
                                                        image: AssetImage("assets/images/star_icon.png"))
                                                    ,
                                                    SizedBox(width: 1,),
                                                    Image(
                                                        height:19,
                                                        width: 19,
                                                        fit: BoxFit.fill,
                                                        image: AssetImage("assets/images/star_icon.png"))
                                                    ,
                                                    SizedBox(width: 1,),
                                                    Image(
                                                        height: 19,
                                                        width: 19,
                                                        fit: BoxFit.fill,
                                                        image: AssetImage("assets/images/star_icon.png"))
                                                    ,

                                                    SizedBox(width: 1,),
                                                    Image(
                                                        height: 19,
                                                        width: 19,
                                                        fit: BoxFit.fill,
                                                        image: AssetImage("assets/images/star_icon.png"))
                                                    ,
*/ /*
                                                  ],
                                                ),
                                              ):SizedBox(height: 0,),
                                            ),*/
                                            Obx(
                                              () => controller.profileDataRes
                                                              .value !=
                                                          null &&
                                                      controller.profileDataRes
                                                              .value.level !=
                                                          null &&
                                                      controller
                                                              .profileDataRes
                                                              .value
                                                              .level
                                                              .value >
                                                          0
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        closeDrawer(context);
                                                        controller
                                                            .showBottomSheetInfoInstantVIP();
                                                      },
                                                      child: Text(
                                                        "VIP Level".tr +
                                                            " ${controller.profileDataRes.value.level.value}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color: AppColor()
                                                                .whiteColor),
                                                      ),
                                                    )
                                                  : Container(),
                                            )
                                          ],
                                        ),
                                      )
                                    : Text(""),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible:
                              AppString.joinClan == 'active' ? true : false,
                          child: ListTile(
                            leading: Image.asset(
                              ImageRes().clan_icon,
                              height: 21,
                              width: 23,
                              //   color: AppColor().whiteColor,
                            ),
                            title: Text(
                              "txt_clan".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () async {
                              //Utils().showLootBoxDown(context);
                              /*Utils().customPrint('Bureau ID Implementations');
                              var transactionID = controller.user_id +
                                  Utils().getRandomString(10);
                              var status = await Onetaplogin.submitDeviceIntelligence(
                                  ApiUrl.BUREAU_CLIENT_ID,
                                  transactionID, //this need to be change everytime
                                  controller.user_id,
                                  env: "Sandbox"); //Sandbox//Production
                              print("status this is call $status");*/
                              //return;
                              Navigator.pop(context);
                              //appsflyer
                              Map<String, dynamic> map_appsflyer = {
                                "pages_call": "Clan",
                                "USER_ID": controller.user_id
                              };
                              c = await Get.put(AppsflyerController());
                              c.logEventAf(EventConstant.bottom_click_event,
                                  map_appsflyer);

                              //clevertap
                              Map<String, dynamic> map_clevertap = {
                                "pages_call": "Clan",
                                "USER_ID": controller.user_id
                              };
                              CleverTapController cleverTapController =
                                  Get.put(CleverTapController());
                              cleverTapController.logEventCT(
                                  EventConstant.bottom_click_event,
                                  map_clevertap);
                              Map<String, dynamic> map_clevertapv1 = {
                                "USER_ID": controller.user_id
                              };
                              cleverTapController.logEventCT(
                                  EventConstant.EVENT_CLEAVERTAB_Clan_Screen,
                                  map_clevertapv1);

                              FirebaseEvent().firebaseEvent(
                                  EventConstant.EVENT_CLEAVERTAB_Clan_Screen_F,
                                  map_clevertapv1);

                              //facebook
                              //Map<String, dynamic> map_fb = {"pages_call": "Clan"};
                              //FaceBookEventController().logEventFacebook(EventConstant.bottom_click_event, map_fb);

                              UserController userController =
                                  Get.put(UserController());

                              if (userController.showProgressDownloade.value ==
                                  false) {
                                userController.currentIndex.value = 3;
                                DashBord(3, "");
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible:
                              AppString.createTeam == 'active' ? true : false,
                          child: ListTile(
                            leading: Image.asset(
                              ImageRes().teammanagement,
                              height: 22,
                              width: 22,
                              fit: BoxFit.fill,
                              //   color: AppColor().whiteColor,
                            ),
                            title: Text(
                              "Team Management".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () => {
                              closeDrawer(context),
                              Get.to(() => TeamManagementNew())
                              //goToMypropery(context)
                            },
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: ListTile(
                            leading: Image.asset(
                              ImageRes().leaderboard,
                              height: 23,
                              width: 20,
                              fit: BoxFit.fill,
                              //   color: AppColor().whiteColor,
                            ),
                            title: Text(
                              "LeaderBoard".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              Map<String, dynamic> map_appsflyer = {
                                "pages_call": "Leaderboard",
                                "USER_ID": controller.user_id
                              };
                              c = await Get.put(AppsflyerController());
                              c.logEventAf(EventConstant.bottom_click_event,
                                  map_appsflyer);

                              //clevertap
                              Map<String, dynamic> map_clevertap = {
                                "pages_call": "Leaderboard",
                                "USER_ID": controller.user_id
                              };
                              Map<String, dynamic> map_clevertapv1 = {
                                "USER_ID": controller.user_id
                              };
                              CleverTapController cleverTapController =
                                  Get.put(CleverTapController());
                              cleverTapController.logEventCT(
                                  EventConstant.bottom_click_event,
                                  map_clevertap);
                              cleverTapController.logEventCT(
                                  EventConstant
                                      .EVENT_CLEAVERTAB_Leaderboard_Screen,
                                  map_clevertapv1); //new

                              FirebaseEvent().firebaseEvent(
                                  EventConstant
                                      .EVENT_CLEAVERTAB_Leaderboard_Screen_F,
                                  map_clevertapv1);

                              Get.to(() => LeaderBoard());
                            },
                          ),
                        ),
                        Visibility(
                          visible:
                              AppString.buyStoreItem == 'active' ? true : false,
                          child: ListTile(
                            leading: Image.asset(
                              ImageRes().store_icon,
                              height: 25,
                              width: 25,
                              fit: BoxFit.fill,
                              //   color: AppColor().whiteColor,
                            ),
                            title: Text(
                              "store".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () {
                              closeDrawer(context);
                              //   Get.to(() => SplashScreenS());
                              Get.to(() => Store());
                            },
                          ),
                        ),
                        Obx(
                          () => cleverTapController.inboxCount > 0
                              ? Visibility(
                                  visible: false,
                                  child: ListTile(
                                    leading: Image.asset(
                                      ImageRes().have_notification_show,
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.fill,
                                      //   color: AppColor().whiteColor,
                                    ),
                                    title: Text(
                                      "Notification".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Montserrat",
                                          color: AppColor().whiteColor),
                                    ),
                                    onTap: () {
                                      var styleConfig = {
                                        'noMessageTextColor': '#ff6600',
                                        'noMessageText':
                                            'No message(s) to show.',
                                        'navBarTitle': 'Notification',
                                        'navBarTitleColor': '#000000',
                                        'navBarColor': '#e55f19',
                                        'tabs': ["Offers"]
                                      };
                                      CleverTapPlugin.showInbox(styleConfig);
                                    },
                                  ),
                                )
                              : Visibility(
                                  visible: false,
                                  child: ListTile(
                                    leading: Image.asset(
                                      ImageRes().notification_show,
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.fill,
                                      //   color: AppColor().whiteColor,
                                    ),
                                    title: Text(
                                      "Notification".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Montserrat",
                                          color: AppColor().whiteColor),
                                    ),
                                    onTap: () {
                                      var styleConfig = {
                                        'noMessageTextColor': '#ff6600',
                                        'noMessageText':
                                            'No message(s) to show.',
                                        'navBarTitle': 'Notification',
                                        'navBarTitleColor': '#000000',
                                        'navBarColor': '#e55f19',
                                        'tabs': ["Offers"]
                                      };
                                      CleverTapPlugin.showInbox(styleConfig);
                                    },
                                  ),
                                ),
                        ),
                        ListTile(
                          leading: Image.asset(
                            ImageRes().profile_icon,
                            height: 22,
                            width: 25,
                            fit: BoxFit.fill,
                            //   color: AppColor().whiteColor,
                          ),
                          title: Text(
                            "profile".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: AppColor().whiteColor),
                          ),
                          onTap: () {
                            //clevertap events
                            Map<String, Object> map_clevertap =
                                new Map<String, Object>();
                            map_clevertap["USER_ID"] = controller.user_id;
                            CleverTapController cleverTapController =
                                Get.put(CleverTapController());
                            cleverTapController.logEventCT(
                                EventConstant.EVENT_CLEAVERTAB_Profile_Screen,
                                map_clevertap); //new

                            FirebaseEvent().firebaseEvent(
                                EventConstant.EVENT_CLEAVERTAB_Profile_Screen_F,
                                map_clevertap);
                            closeDrawer(context);
                            Get.to(() => Profile(""));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            ImageRes().form16,
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                            //   color: AppColor().whiteColor,
                          ),
                          title: Text(
                            "Form 16 Request".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: AppColor().whiteColor),
                          ),
                          onTap: () {
                            closeDrawer(context);

                            try {
                              Map<String, dynamic> map =
                                  new Map<String, dynamic>();
                              map["user_id"] = controller.user_id;
                              cleverTapController =
                                  Get.put(CleverTapController());
                              cleverTapController.logEventCT(
                                  EventConstant.EVENT_Form16Requested, map);

                              FirebaseEvent().firebaseEvent(
                                  EventConstant.EVENT_Form16Requested_F, map);
                              c = Get.put(AppsflyerController());
                              c.logEventAf(
                                  EventConstant.EVENT_Form16Requested, map);
                            } catch (e) {}
                            //Get.to(() => FavouriteGame());
                            Utils.launchURLApp(
                                "https://forms.gle/frniwqygMM46NifR7");
                            //Get.to(() => Form16WebView());
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Form16WebView(),
                              ),
                            );*/
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            ImageRes().favorite_game,
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                            //   color: AppColor().whiteColor,
                          ),
                          title: Text(
                            "Favourite Game".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: AppColor().whiteColor),
                          ),
                          onTap: () {
                            closeDrawer(context);
                            Get.to(() => FavouriteGame());
                          },
                        ),
                        Visibility(
                          visible: true,
                          child: ListTile(
                            leading: Image.asset(
                              ImageRes().changelanguage,
                              height: 25,
                              width: 25,
                              fit: BoxFit.fill,
                              //   color: AppColor().whiteColor,
                            ),
                            title: Text(
                              "changelang".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () => {
                              closeDrawer(context),
                              //Get.to(() => ChanagesLanguages())
                              Get.to(() => FavouriteGame())
                            },
                          ),
                        ),
                        ListTile(
                          leading: Image.asset(
                            ImageRes().support,
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            "txt_support".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: AppColor().whiteColor),
                          ),
                          onTap: () async {
                            //clevertap events

                            if (ApiUrl().isPlayStore) {
                              WalletPageController walletPageController =
                                  Get.put(WalletPageController());
                              if (walletPageController.user_mobileNo ==
                                  '9829953786') {
                                Fluttertoast.showToast(
                                    msg: "Under Maintenance");
                                return;
                              }
                            }
                            Map<String, Object> map_clevertap =
                                new Map<String, Object>();
                            map_clevertap["USER_ID"] = controller.user_id;
                            CleverTapController cleverTapController =
                                Get.put(CleverTapController());
                            cleverTapController.logEventCT(
                                EventConstant
                                    .EVENT_CLEAVERTAB_Support_button_clicked,
                                map_clevertap); //new

                            FirebaseEvent().firebaseEvent(
                                EventConstant
                                    .EVENT_CLEAVERTAB_Support_button_clicked_F,
                                map_clevertap);

                            closeDrawer(context);
                            FreshChatController freshChatController =
                                Get.put(FreshChatController());
                            /* FreshchatUser freshchatUser =
                                await Freshchat.getUser;*/

                            controller.SetFreshchatUser();
                            Freshchat.showFAQ();
                          },
                        ),
                        Visibility(
                          visible: false,
                          child: ListTile(
                            leading: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(
                                    "assets/images/become_affiliate_handshake.png")),
                            title: Text(
                              "Become Affiliate".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () => {
                              closeDrawer(context),
                              BaseController()
                                  .alertBecomeAffiliate(controller.user_id),
                            },
                          ),
                        ),
                        Visibility(
                          visible: !ApiUrl().isPlayStore,
                          child: ListTile(
                            leading: Image.asset(
                              ImageRes().responsiblegaming,
                              height: 25,
                              width: 25,
                              fit: BoxFit.fill,
                            ),
                            title: Text(
                              "responsible_gaming".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () {
                              //https://gmng.pro/resonsible-gaming/ for PRO APP
                              //https://gmng.co.in/responsible-gaming/ for Fantasy
                              Utils.launchURLApp(
                                  "https://gmng.pro/resonsible-gaming/");
                            },
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: ListTile(
                            leading: Image.asset(
                              ImageRes().ic_logout,
                              height: 25,
                              width: 25,
                              fit: BoxFit.fill,
                            ),
                            title: Text(
                              "Bureau ID",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () async {
                              Utils().customPrint('Bureau ID Implementations');
                              var status =
                                  await Onetaplogin.submitDeviceIntelligence(
                                      "78f6b887-da58-4d73-9c74-a81aedde23e8",
                                      "wertre222rr552", //this need to be change everytime
                                      controller.user_id,
                                      env: "Sandbox");
                              print("status this is call $status");

                              if (status.toString() == "Success") {}
                            },
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: ListTile(
                            leading: Image.asset(
                              ImageRes().ic_logout,
                              height: 25,
                              width: 25,
                              fit: BoxFit.fill,
                            ),
                            /* Container(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(
                                    ImageRes().ic_logout,
                                  )) */
                            title: Text(
                              "txt_logout".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            onTap: () {
                              Map<String, Object> map_clevertap =
                                  new Map<String, Object>();
                              map_clevertap["USER_ID"] = controller.user_id;
                              CleverTapController cleverTapController =
                                  Get.put(CleverTapController());
                              cleverTapController.logEventCT(
                                  EventConstant.EVENT_CLEAVERTAB_Logout,
                                  map_clevertap); //new

                              FirebaseEvent().firebaseEvent(
                                  EventConstant.EVENT_CLEAVERTAB_Logout_F,
                                  map_clevertap); //new
                              showAlertDialog(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        child: Text(
                            "Version- ${controller.version}(${controller.code})",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: AppColor().version_bg)),
                        transformAlignment: Alignment.center,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void closeDrawer(BuildContext context) {
    Navigator.pop(context);
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "No".tr,
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Yes".tr),
      onPressed: () async {
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        /*  String token = prefs.getString("token");
        prefs.setString("token", "");*/
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');

        await preferences.clear();
        userPreferences.removeValues();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Login(),
          ),
          (route) => false,
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "txt_logout".tr,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
      ),
      content: Text("txt_are_you_sure_logout".tr),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> getHashForRummy(Map<String, dynamic> param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Map<String, dynamic> response =
        await WebServicesHelper().getHashForRummy(token, param);

    Utils().customPrint('response $response');
    if (response != null) {
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

      NativeBridge().OpenRummy(data);
    } else {
      Utils().customPrint('response promo code ERROR');
    }
  }
}
