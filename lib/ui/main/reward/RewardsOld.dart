import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppDimens.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/controller/BaseController.dart';
import 'package:gmng/ui/controller/RewardConntroller.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/wallet/OfferWallScreen.dart';
import 'package:gmng/utills/OnlyOff.dart';
import 'package:gmng/utills/Platfrom.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

import '../../../res/ImageRes.dart';
import '../../../utills/bridge.dart';
import '../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../utills/event_tracker/EventConstant.dart';
import '../../../webservices/ApiUrl.dart';
import 'ViewAllRewards.dart';

Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class RewardsOld extends StatefulWidget {
  @override
  RewardsOldState createState() => RewardsOldState();
}

class RewardsOldState extends State<RewardsOld> with WidgetsBindingObserver {
  RewardController _rewardController = Get.put(RewardController());
  UserController _userController = Get.put(UserController());
  UserPreferences userPreferences;
  TextEditingController SearchConrtoller = new TextEditingController();
  double height, width;
  BaseController base_controller = Get.put(BaseController());

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = Platfrom().isWeb()
        ? MediaQuery.of(context).size.width * AppDimens().screen_percentage_web
        : MediaQuery.of(context).size.width;
    _rewardController.type.value = "monthly";
    _rewardController.getReferalList();
   // if (ApiUrl().isPlayStore == false) {
      _userController.getForceUpdate(context);
  //  }
    Future<bool> _onWillPop() async {
      // SystemNavigator.pop();
      return true;
    }

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/store_back.png"))),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    if (_rewardController.bannerModelRV.value != null &&
                        _rewardController.bannerModelRV.value.data != null &&
                        _rewardController.bannerModelRV.value.data.length >=
                            1 &&
                        _rewardController.bannerModelRV.value.data[0].name
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
                  child: Obx(() => _rewardController.bannerModelRV.value !=
                              null &&
                          _rewardController.bannerModelRV.value.data != null
                      ? _rewardController.bannerModelRV.value.data.length > 0
                          ? _rewardController.bannerModelRV.value.data.length >
                                  1
                              ? CarouselSlider(
                                  items: _rewardController
                                      .bannerModelRV.value.data
                                      .map(
                                        (item) => GestureDetector(
                                          onTap: () {
                                            Map<String, Object> map =
                                                new Map<String, Object>();
                                            map["USER_ID"] =
                                                _userController.user_id;
                                            map[EventConstant.PARAM_BANNER_ID] =
                                                item.id;
                                            map[EventConstant
                                                .PARAM_BANNER_NAME] = item.name;
                                            map[EventConstant
                                                .PARAM_SCREEN_NAME] = "Reward";
                                            AppsflyerController
                                                appsflyerController =
                                                Get.put(AppsflyerController());
                                            CleverTapController
                                                cleverTapController =
                                                Get.put(CleverTapController());
                                            appsflyerController.logEventAf(
                                                EventConstant
                                                    .EVENT_CLEAVERTAB_BANNER_CLICK,
                                                map);
                                            //FaceBookEventController().logEventFacebook(EventConstant.EVENT_CLEAVERTAB_BANNER_CLICK, map);
                                            cleverTapController.logEventCT(
                                                EventConstant
                                                    .EVENT_CLEAVERTAB_BANNER_CLICK,
                                                map);

                                            FirebaseEvent().firebaseEvent(
                                                EventConstant
                                                    .EVENT_CLEAVERTAB_BANNER_CLICK_F,
                                                map);

                                            base_controller
                                                .launchURLApp(item.externalUrl);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
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
                                                    imageUrl: (item.image.url),
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
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Obx(
                                        () => Image(
                                          height: 120,
                                          fit: BoxFit.cover,
                                          image:
                                              _rewardController.bannerModelRV
                                                              .value.data !=
                                                          null &&
                                                      _rewardController
                                                              .bannerModelRV
                                                              .value
                                                              .data !=
                                                          null &&
                                                      _rewardController
                                                              .bannerModelRV
                                                              .value
                                                              .data
                                                              .length >=
                                                          1
                                                  ? NetworkImage(
                                                      _rewardController
                                                          .bannerModelRV
                                                          .value
                                                          .data[0]
                                                          .image
                                                          .url)
                                                  : AssetImage(ImageRes()
                                                      .store_banner_wallet),
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
                              height: 120,
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
                SizedBox(height: 10),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 280,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              left: AppDimens().padding,
                              top: AppDimens().avatarRadius +
                                  AppDimens().padding,
                              right: AppDimens().padding,
                              bottom: AppDimens().padding),
                          margin:
                              EdgeInsets.only(top: AppDimens().avatarRadius),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColor().reward_card_bg,
                            borderRadius:
                                BorderRadius.circular(AppDimens().padding),
                          ),
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              getCustomTextView("Share your referral code:".tr),
                              SizedBox(
                                height: 15,
                              ),
                              getCustomTextView("Share on :-".tr),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 45,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor().reward_grey_bg),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: Colors.white,
                                  radius: Radius.circular(10),
                                  strokeWidth: 1.0,
                                  dashPattern: [7, 4],
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            color: Colors.white),
                                        alignment: Alignment.centerLeft,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Obx(
                                            () => Text(
                                              _userController
                                                  .getUserReferalCode(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Inter",
                                                  color: AppColor()
                                                      .reward_card_bg),
                                            ),
                                          ),
                                        ),
                                        height: 45,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: _userController
                                                  .getUserReferalCode()));
                                          Fluttertoast.showToast(
                                              msg: "Code copied successfully");
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Text(
                                                  "Copy".tr,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Roboto",
                                                      color: AppColor()
                                                          .whiteColor),
                                                ),
                                              ),
                                              Image(
                                                height: 20,
                                                width: 20,
                                                color: Colors.white,
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  'assets/images/ic_copy.webp',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Map<String, Object> map =
                                          new Map<String, Object>();
                                      map["USER_ID"] =
                                          _rewardController.user_id;
                                      AppsflyerController appsflyerController =
                                          Get.put(AppsflyerController());
                                      CleverTapController cleverTapController =
                                          Get.put(CleverTapController());
                                      appsflyerController.logEventAf(
                                          EventConstant.EVENT_Refer_and_Earn,
                                          map);
                                      cleverTapController.logEventCT(
                                          EventConstant.EVENT_Refer_and_Earn,
                                          map);

                                      FirebaseEvent().firebaseEvent(
                                          EventConstant.EVENT_Refer_and_Earn_F,
                                          map);

                                      String urlCall =
                                          "https://gmng.onelink.me/GRb6?af_xp=app&pid=Cross_sale&c=Referral%20code%20pre-fill&is_retargeting=true&af_dp=gmng%3A%2F%2F&referral_code=${_userController.getUserReferalCode()}";
                                      var encoded = Uri.encodeFull(urlCall);

                                      await WhatsappShare.share(
                                          text:
                                              "Bro Mere link se GMNG app download kar  Hum dono ko 10-10 rs "
                                              "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${_userController.getUserReferalCode()}",
                                          linkUrl: encoded,
                                          phone: "9555775577");

/*

                                      base_controller.openwhatsapp(
                                          "Bro Mere link se GMNG app download kar $encoded Hum dono ko 10-10 rs "
                                          "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${_userController.getUserReferalCode()}");*/
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Image(
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/iv_whatsapp_new.png'),
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Map<String, Object> map =
                                          new Map<String, Object>();
                                      AppsflyerController appsflyerController =
                                          Get.put(AppsflyerController());
                                      CleverTapController cleverTapController =
                                          Get.put(CleverTapController());
                                      appsflyerController.logEventAf(
                                          EventConstant.EVENT_Refer_and_Earn,
                                          map);
                                      cleverTapController.logEventCT(
                                          EventConstant.EVENT_Refer_and_Earn,
                                          map);

                                      FirebaseEvent().firebaseEvent(
                                          EventConstant.EVENT_Refer_and_Earn_F,
                                          map);

                                      String urlCall =
                                          "https://gmng.onelink.me/GRb6?af_xp=app&pid=Cross_sale&c=Referral%20code%20pre-fill&is_retargeting=true&af_dp=gmng%3A%2F%2F&referral_code=${_userController.getUserReferalCode()}";
                                      var encoded = Uri.encodeFull(urlCall);
                                      Utils().shareTelegram(
                                          "Bro Mere link se GMNG app download kar $encoded Hum dono ko 10-10 rs "
                                          "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${_userController.getUserReferalCode()}");
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Image(
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/iv_telegram_new.png'),
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Map<String, Object> map =
                                          new Map<String, Object>();
                                      AppsflyerController appsflyerController =
                                          Get.put(AppsflyerController());
                                      CleverTapController cleverTapController =
                                          Get.put(CleverTapController());
                                      appsflyerController.logEventAf(
                                          EventConstant.EVENT_Refer_and_Earn,
                                          map);
                                      cleverTapController.logEventCT(
                                          EventConstant.EVENT_Refer_and_Earn,
                                          map);

                                      FirebaseEvent().firebaseEvent(
                                          EventConstant.EVENT_Refer_and_Earn_F,
                                          map);

                                      String urlCall =
                                          "https://gmng.onelink.me/GRb6?af_xp=app&pid=Cross_sale&c=Referral%20code%20pre-fill&is_retargeting=true&af_dp=gmng%3A%2F%2F&referral_code=${_userController.getUserReferalCode()}";
                                      var encoded = Uri.encodeFull(urlCall);

                                      NativeBridge().OpenInstagram(
                                          "Bro Mere link se GMNG app download kar $encoded Hum dono ko 10-10 rs "
                                          "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${_userController.getUserReferalCode()}");
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Image(
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/iv_instagram_new.png'),
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Map<String, Object> map =
                                          new Map<String, Object>();
                                      AppsflyerController appsflyerController =
                                          Get.put(AppsflyerController());
                                      CleverTapController cleverTapController =
                                          Get.put(CleverTapController());
                                      appsflyerController.logEventAf(
                                          EventConstant.EVENT_Refer_and_Earn,
                                          map);
                                      cleverTapController.logEventCT(
                                          EventConstant.EVENT_Refer_and_Earn,
                                          map);

                                      FirebaseEvent().firebaseEvent(
                                          EventConstant.EVENT_Refer_and_Earn_F,
                                          map);

                                      String urlCall =
                                          "https://gmng.onelink.me/GRb6?af_xp=app&pid=Cross_sale&c=Referral%20code%20pre-fill&is_retargeting=true&af_dp=gmng%3A%2F%2F&referral_code=${_userController.getUserReferalCode()}";
                                      var encoded = Uri.encodeFull(urlCall);

                                      Utils().funShareS(
                                          "Bro Mere link se GMNG app download kar $encoded Hum dono ko 10-10 rs "
                                          "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${_userController.getUserReferalCode()}");
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Image(
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/share_icon_new.png'),
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          left: AppDimens().padding,
                          right: AppDimens().padding,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: AppDimens().avatarRadius,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppDimens().avatarRadius)),
                              child: Image(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/reward_icon.webp'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 10),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      elevation: 5.0,
                      toolbarHeight: 40,
                      automaticallyImplyLeading: false,
                      flexibleSpace: Container(
                        alignment: Alignment.center,
                        color: AppColor().reward_card_bg,
                        child: Text(
                          "Top Referrals".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              color: AppColor().whiteColor),
                        ),
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            decoration: BoxDecoration(
                              //    border: Border.all(color: AppColor().colorPrimary, width: 1),

                              color: AppColor().colorPrimaryDark,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "User Rank".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                Text(
                                  "User Name".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                Text(
                                  "REFERRALS".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Roboto",
                                      color: Colors.white),
                                ),
                                Text(
                                  "PRIZES".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Roboto",
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              decoration: BoxDecoration(
                                  // color: AppColor().reward_grey_bg,
                                  borderRadius: BorderRadius.circular(5)),
                              alignment: Alignment.center,
                              child: Obx(() =>
                                  _rewardController.referlistModel.value != null
                                      ? (_rewardController.referlistModel.value
                                                      .data !=
                                                  null &&
                                              _rewardController.referlistModel
                                                      .value.data.length >
                                                  0)
                                          ? ListView.builder(
                                              itemCount: _rewardController
                                                          .referlistModel
                                                          .value
                                                          .data
                                                          .length >
                                                      3
                                                  ? 2
                                                  : _rewardController
                                                      .referlistModel
                                                      .value
                                                      .data
                                                      .length,
                                              //scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return getUserListWidget(
                                                    context, index);
                                              })
                                          : Container(
                                              height: 10,
                                            )
                                      : Container(
                                          alignment: Alignment.center,
                                          child: Container(
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
                                          )))),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ViewAllRewards());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor().colorPrimary, width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor().whiteColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Text(
                        "View All".tr,
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColor().colorPrimary,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            )),
            floatingActionButton: Obx(
              () => onlyOffi.countValuesAR.value != null &&
                      onlyOffi.countValuesAR.value >= 3
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 5, bottom: 20, right: 0, top: 0),
                      child: FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          Map<String, dynamic> map = {
                            "USER_ID": "${_userController.user_id}"
                          };

                          CleverTapController cleverTapController =
                              Get.put(CleverTapController());

                          cleverTapController.logEventCT(
                              EventConstant.User_Refer_Affiliate_Again, map);

                          FirebaseEvent().firebaseEvent(
                              EventConstant.EVENT_Refer_and_Earn_F, map);

                          Utils().alertaffiliatCongratulation();

                          // userController.SetFreshchatUser();
                          // Freshchat.showFAQ();
                        }, // Add your onPressed code here!
                        child: Container(
                            color: Colors.transparent,
                            child: Image.asset(
                                ImageRes().affiliate_floating_button)),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
            )),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Utils().customPrint(
        "didChangeAppLifecycleState  ===================================================");

    if (state == AppLifecycleState.resumed) {
      Utils().customPrint(
          "didChangeAppLifecycleState     ===================================================");
    } else if (state == AppLifecycleState.paused) {
      Utils().customPrint(
          "didChangeAppLifecycleState  AppLifecycleState.paused   ===================================================");
    } else if (state == AppLifecycleState.detached) {
      Utils().customPrint(
          "didChangeAppLifecycleState  AppLifecycleState.detached   ===================================================");
    }
    getAffiliatePopUp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loadWidget();

    _rewardController.type.value = "monthly";
    _rewardController.getReferalList();
    _userController.getProfileData();

    ApiCall();
  }

  Future<void> ApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //isPopUp banner
    Utils().getBannerAsPerPageType(
        prefs.getString("token"), AppString().appTypes, 'referral');
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      onlyOffi.countValuesAR.value = prefs.getInt("countValues");
    } catch (e) {}

    print("check count values ${onlyOffi.countValuesAR.value}");
    print("refferal code ${_userController.getUserReferalCode()}");

    /* if (onlyOffi.countValuesAR.value == null) {
      Utils().alertaffiliat(
          _userController.getUserReferalCode(), _userController.user_id);
    } else if (onlyOffi.countValuesAR.value < 3) {
      Utils().alertaffiliat(
          _userController.getUserReferalCode(), _userController.user_id);
    } else {}*/
  }

  Widget getUserListWidget(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "${index + 1}",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 14, fontFamily: "Inter", color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image(
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                      image: (_rewardController
                                      .referlistModel.value.data[index].photo !=
                                  null &&
                              _rewardController.referlistModel.value.data[index]
                                      .photo.url !=
                                  null)
                          ? NetworkImage(_rewardController
                              .referlistModel.value.data[index].photo.url)
                          : AssetImage('assets/images/images.png'),
                    ),
                  ),
                ),
                /*  CircleAvatar(
                  radius: 12,
                  child: Image.asset("assets/images/ic_link.webp"),
                  backgroundColor: AppColor().colorPrimaryDark,
                ),*/
                Container(
                  width: 5,
                ),
                Center(
                  child: Text(
                    "${_rewardController.referlistModel.value.data[index].username.length > 10 ? _rewardController.referlistModel.value.data[index].username.substring(0, 10) : _rewardController.referlistModel.value.data[index].username}"
                        .capitalize,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "Inter", color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${_rewardController.referlistModel.value.data[index].count}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Roboto",
                  color: AppColor().colorPrimaryDark),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${_rewardController.referlistModel.value.data[index].amount != null ? _rewardController.referlistModel.value.data[index].amount.getAmountValues() : "-"}",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 14, fontFamily: "Roboto", color: Colors.white),
            ),
          ),
        ],
      ),

      /*Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${index + 1}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, fontFamily: "Inter", color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image(
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                      image:(_rewardController.referlistModel.value.data[index].photo!=null &&
                    _rewardController.referlistModel.value.data[index].photo.url!=null)?
                    NetworkImage(_rewardController.referlistModel.value.data[index].photo.url):
                    AssetImage('assets/images/images.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "${_rewardController.referlistModel.value.data[index].username}"
                        .capitalize,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "Inter", color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${_rewardController.referlistModel.value.data[index].count}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Roboto",
                color: AppColor().colorPrimary),
          ),
          Text(
            "\u{20B9} ${_rewardController.referlistModel.value.data[index].amount.value}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, fontFamily: "Roboto", color: Colors.white),
          ),
        ],
      ),*/
    );
  }

  Widget getCustomTextView(String text) {
    return Container(
      margin: new EdgeInsets.all(1.0),
      child: Center(
          child: new Text(text.tr,
              style: TextStyle(
                  fontSize: 18,
                  color: AppColor().whiteColor,
                  fontWeight: FontWeight.bold))),
    );
  }



  Future<void> getAffiliatePopUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      onlyOffi.countValuesAR.value = prefs.getInt("countValues");
      bool affiliateCong = prefs.getBool("affiliateCong");
      if (affiliateCong) {
        if (onlyOffi.countValuesAR.value >= 3) {
          Map<String, dynamic> map = {"USER_ID": "${_userController.user_id}"};

          CleverTapController cleverTapController =
              Get.put(CleverTapController());

          cleverTapController.logEventCT(
              EventConstant.User_Refer_Affiliate_Final, map);

          FirebaseEvent()
              .firebaseEvent(EventConstant.EVENT_Refer_and_Earn_F, map);

          prefs.setBool("affiliateCong", false);
          Utils().alertaffiliatCongratulation();
        }
      }
    } catch (E) {}
  }
}

shareOnInstagram(String q) async {
  String result = await FlutterSocialContentShare.share(
      type: ShareType.instagramWithImageUrl,
      imageName: q,
      imageUrl: "https://www.instagram.com/gmngofficial/?hl=en");
  Utils().customPrint(result);
}
