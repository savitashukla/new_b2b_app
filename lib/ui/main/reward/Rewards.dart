import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class Rewards extends StatefulWidget {
  @override
  RewardsState createState() => RewardsState();
}

//old code
/*class RewardsState extends State<Rewards> with WidgetsBindingObserver {
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

  Widget _Button(String text, BuildContext context, OnMoveNext) {
    return SizedBox(
      width: 100,
      height: 40,
      child: new RaisedButton(
          onPressed: OnMoveNext,
          textColor: Colors.white,
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
            //    side: BorderSide(color: Colors.black)
          ),
          padding: const EdgeInsets.all(2.0),
          child: new Text(
            text,
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.normal),
          )),
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
}*/

//new code
class RewardsState extends State<Rewards> with WidgetsBindingObserver {
  RewardController _rewardController = Get.put(RewardController());
  UserController _userController = Get.put(UserController());
  UserPreferences userPreferences;
  TextEditingController SearchConrtoller = new TextEditingController();
  double height, width;
  BaseController base_controller = Get.put(BaseController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loadWidget();

    _rewardController.type.value = "monthly";
    ApiCall();

    /* Utils().customPrint(
        'appSettingReponse referal: userValue ${_userController.appSettingReponse.value.signupCreditPolicy.user.value}');
    Utils().customPrint(
        'appSettingReponse referal: MIN ${_userController.appSettingReponse.value.signupCreditPolicy.referrerDepositBenefit.minDeposit.value}');
    Utils().customPrint(
        'appSettingReponse referal: BENEFIT  ${_userController.appSettingReponse.value.signupCreditPolicy.referrerDepositBenefit.benefitAmount.value}');*/
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = Platfrom().isWeb()
        ? MediaQuery.of(context).size.width * AppDimens().screen_percentage_web
        : MediaQuery.of(context).size.width;
    _rewardController.type.value = "monthly";
    _rewardController.getReferalList();
    if (ApiUrl().isPlayStore == false) {
      _userController.getForceUpdate(context);
    }
    /*Future<bool> _onWillPop() async {
      // SystemNavigator.pop();
      return true;
    }*/
    //back press again to exit added!
    DateTime currentBackPressTime;
    Future<bool> _onWillPop() async {
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

    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(height: 100),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (_rewardController.bannerModelRV.value != null &&
                            _rewardController.bannerModelRV.value.data !=
                                null &&
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
                          ? _rewardController.bannerModelRV.value.data.length >
                                  0
                              ? _rewardController
                                          .bannerModelRV.value.data.length >
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
                                                map[EventConstant
                                                    .PARAM_BANNER_ID] = item.id;
                                                map[EventConstant
                                                        .PARAM_BANNER_NAME] =
                                                    item.name;
                                                map[EventConstant
                                                        .PARAM_SCREEN_NAME] =
                                                    "Reward";
                                                AppsflyerController
                                                    appsflyerController =
                                                    Get.put(
                                                        AppsflyerController());
                                                CleverTapController
                                                    cleverTapController =
                                                    Get.put(
                                                        CleverTapController());
                                                appsflyerController.logEventAf(
                                                    EventConstant
                                                        .EVENT_CLEAVERTAB_BANNER_CLICK,
                                                    map);
                                                cleverTapController.logEventCT(
                                                    EventConstant
                                                        .EVENT_CLEAVERTAB_BANNER_CLICK,
                                                    map);

                                                FirebaseEvent().firebaseEvent(
                                                    EventConstant
                                                        .EVENT_CLEAVERTAB_BANNER_CLICK_F,
                                                    map);

                                                base_controller.launchURLApp(
                                                    item.externalUrl);
                                              },
                                              child: Container(
                                                //margin: const EdgeInsets.symmetric(horizontal: 6),
                                                child: Center(
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: CachedNetworkImage(
                                                        height: 250,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        fit: BoxFit.fill,
                                                        imageUrl:
                                                            (item.image.url),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      options: CarouselOptions(
                                        height: 250,
                                        autoPlay: true,
                                        disableCenter: true,
                                        viewportFraction: 1,
                                        aspectRatio: 3,
                                        enlargeCenterPage: false,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enableInfiniteScroll: true,
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 1000),
                                        onPageChanged: (index, reason) {},
                                      ),
                                    )
                                  : Container(
                                      height: 200,
                                      margin: EdgeInsets.only(
                                          top: 0,
                                          right: 0,
                                          left: 0,
                                          bottom: 40),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Obx(
                                            () => Image(
                                              height: 200,
                                              fit: BoxFit.fill,
                                              image: _rewardController
                                                              .bannerModelRV
                                                              .value
                                                              .data !=
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
                                          )),
                                    )
                              : Container(
                                  height: 120,
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
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 150),
                      child: Container(
                        height: 90,
                        // margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                        padding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 0, right: 0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border:
                                Border.all(color: Color(0xFF393838), width: 2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))
                            // color: AppColor().whiteColor
                            ),
                        child: Container(
                          padding: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top: 0),
                                    child: CircleAvatar(
                                      radius: 25.0,
                                      child: Image.asset(
                                          "assets/images/refferal_coin.png"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        //"Total Money Earned".toUpperCase(),
                                        "Total Money Earned".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                            color: Color(0xFF999595)),
                                      ),
                                      Obx(() => Text(
                                            _rewardController
                                                            .referTotalMoney !=
                                                        null &&
                                                    _rewardController
                                                            .referTotalMoney
                                                            .value !=
                                                        null &&
                                                    _rewardController
                                                            .referTotalMoney
                                                            .value
                                                            .total !=
                                                        null &&
                                                    _rewardController
                                                            .referTotalMoney
                                                            .value
                                                            .total
                                                            .value !=
                                                        null
                                                ? "${AppString().txt_currency_symbole} ${_rewardController.referTotalMoney.value.total.value ~/ 100}"
                                                : "${AppString().txt_currency_symbole} 0",
                                            style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Inter",
                                                color: AppColor().whiteColor),
                                          ))
                                    ],
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
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: AppColor().vip_gray_refferal,
                        border: Border.all(
                            color: Color(
                                0xFF1C1C1C) /*AppColor().gray_vip_button*/,
                            width: 2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))
                        // color: AppColor().whiteColor
                        ),
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 15),
                            child: Text(
                              "What you get?".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Montserrat",
                                  color: AppColor().yellow_vip_button),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 20),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor().vip_button,
                                      border: Border.all(
                                          color: AppColor().gray_vip_button,
                                          width: 2)),
                                  child: Text(
                                    _userController.appSettingReponse != null &&
                                            _userController.appSettingReponse
                                                    .value.signupCreditPolicy !=
                                                null &&
                                            _userController
                                                    .appSettingReponse
                                                    .value
                                                    .signupCreditPolicy
                                                    .user
                                                    .value !=
                                                null
                                        ? ""
                                            "${AppString().txt_currency_symbole}${_userController.appSettingReponse.value.signupCreditPolicy.user.value ~/ 100}"
                                        : "${AppString().txt_currency_symbole}0",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Montserrat",
                                        color: AppColor().vip_green),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Friend Installs".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 30, bottom: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor().vip_button,
                                      border: Border.all(
                                          color: AppColor().gray_vip_button,
                                          width: 2)),
                                  child: Text(
                                    _userController.appSettingReponse != null &&
                                            _userController.appSettingReponse
                                                    .value.signupCreditPolicy !=
                                                null &&
                                            _userController
                                                    .appSettingReponse
                                                    .value
                                                    .signupCreditPolicy
                                                    .referrerDepositBenefit !=
                                                null &&
                                            _userController
                                                    .appSettingReponse
                                                    .value
                                                    .signupCreditPolicy
                                                    .referrerDepositBenefit
                                                    .benefitAmount !=
                                                null &&
                                            _userController
                                                    .appSettingReponse
                                                    .value
                                                    .signupCreditPolicy
                                                    .referrerDepositBenefit
                                                    .benefitAmount
                                                    .value !=
                                                null
                                        ? ""
                                            "${AppString().txt_currency_symbole}${_userController.appSettingReponse.value.signupCreditPolicy.referrerDepositBenefit.benefitAmount.value ~/ 100}"
                                        : "${AppString().txt_currency_symbole}0",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Montserrat",
                                        color: AppColor().vip_green),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _userController.appSettingReponse != null &&
                                          _userController.appSettingReponse
                                                  .value.signupCreditPolicy !=
                                              null &&
                                          _userController
                                                  .appSettingReponse
                                                  .value
                                                  .signupCreditPolicy
                                                  .referrerDepositBenefit !=
                                              null &&
                                          _userController
                                                  .appSettingReponse
                                                  .value
                                                  .signupCreditPolicy
                                                  .referrerDepositBenefit
                                                  .minDeposit
                                                  .value !=
                                              null
                                      ? ""
                                                  "Friend Deposits Min"
                                              .tr +
                                          " ${AppString().txt_currency_symbole}${_userController.appSettingReponse.value.signupCreditPolicy.referrerDepositBenefit.minDeposit.value ~/ 100}"
                                      : "Friend Deposits Min".tr + " ₹0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Tap the buttons below to share referral link".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        color: AppColor().optional_payment),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Map<String, Object> map = new Map<String, Object>();
                          map["USER_ID"] = _rewardController.user_id;
                          AppsflyerController appsflyerController =
                              Get.put(AppsflyerController());
                          CleverTapController cleverTapController =
                              Get.put(CleverTapController());
                          appsflyerController.logEventAf(
                              EventConstant.EVENT_Refer_and_Earn, map);
                          cleverTapController.logEventCT(
                              EventConstant.EVENT_Refer_and_Earn, map);

                          FirebaseEvent().firebaseEvent(
                              EventConstant.EVENT_Refer_and_Earn_F, map);

                          String urlCall =
                              "https://gmng.onelink.me/GRb6?af_xp=app&pid=Cross_sale&c=Referral%20code%20pre-fill&is_retargeting=true&af_dp=gmng%3A%2F%2F&referral_code=${_userController.getUserReferalCode()}";
                          var encoded = Uri.encodeFull(urlCall);

                          await WhatsappShare.share(
                              text:
                                  "Bro Mere link se GMNG app download kar  Hum dono ko 10-10 rs "
                                  "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${_userController.getUserReferalCode()}",
                              linkUrl: encoded,
                              phone: "9555775577");
                        },
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Image(
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/whatsapp_circle.png'),
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color:
                                Color(0xFF1C1C1C), //AppColor().gray_vip_button,
                            border: Border.all(
                                color: AppColor().colorPrimary, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Obx(
                                  () => Text(
                                    _userController.getUserReferalCode(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
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
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Image(
                                    height: 20,
                                    width: 20,
                                    color: Colors.white,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/referal_copy.png',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Map<String, Object> map = new Map<String, Object>();
                          AppsflyerController appsflyerController =
                              Get.put(AppsflyerController());
                          CleverTapController cleverTapController =
                              Get.put(CleverTapController());
                          appsflyerController.logEventAf(
                              EventConstant.EVENT_Refer_and_Earn, map);
                          cleverTapController.logEventCT(
                              EventConstant.EVENT_Refer_and_Earn, map);

                          FirebaseEvent().firebaseEvent(
                              EventConstant.EVENT_Refer_and_Earn_F, map);

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
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/images/referal_share.png'),
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Frequently Asked Questions".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Montserrat",
                          color: AppColor().whiteColor),
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 10, bottom: 20),
                    child: ListView.builder(
                        itemCount: _rewardController.data_list.value.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, int index) {
                          return faq_design(index);
                        }),
                  ),
                ),
                SizedBox(height: 65),
              ],
            )),
            floatingActionButton: Obx(
              () => onlyOffi.countValuesAR.value != null &&
                      onlyOffi.countValuesAR.value >= 3
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 5, bottom: 45, right: 0, top: 0),
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

  Future<void> ApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //isPopUp banner
    Utils().getBannerAsPerPageType(
        prefs.getString("token"), AppString().appTypes, 'referral');

    _rewardController.getReferalList();
    _userController.getProfileData();
    //new API for totalMoneyEarned
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

  //new code for design
  Widget faq_design(int index) {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (_rewardController.data_list[index].isShow == false) {
                    _rewardController.data_list[index].isShow = true;
                  } else {
                    _rewardController.data_list[index].isShow = false;
                  }
                  setState(() {});
                },
                child: Container(
                  //height: 50,
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: AppColor().vip_gray_refferal,
                      border: Border.all(
                          color:
                              Color(0xFF1C1C1C) /*AppColor().gray_vip_button*/,
                          width: 2),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))
                      // color: AppColor().whiteColor
                      ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              "${_rewardController.data_list[index].question}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ), // _rewardController.data_list[index].isShow
                          _rewardController.data_list[index].isShow
                              ? Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Image(
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/referal_up_arrow.png'),
                                  ))
                              : Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Image(
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/referal_down_arrow.png'),
                                  )),
                        ],
                      ),
                      Visibility(
                        visible: _rewardController.data_list[index].isShow,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 0, right: 25, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "${_rewardController.data_list[index].answer}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Montserrat",
                                        color: AppColor().vip_light_gray),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

shareOnInstagram(String q) async {
  String result = await FlutterSocialContentShare.share(
      type: ShareType.instagramWithImageUrl,
      imageName: q,
      imageUrl: "https://www.instagram.com/gmngofficial/?hl=en");
  Utils().customPrint(result);
}
