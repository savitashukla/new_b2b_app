import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:gmng/model/AppSettingResponse.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/cash_free/CashFreeController.dart';
import 'package:gmng/ui/main/wallet/OfferWallScreen.dart';
import 'package:gmng/ui/main/wallet/PaymentOption.dart';
import 'package:gmng/ui/main/wallet/ViewAllPromoCodes.dart';
import 'package:gmng/ui/main/wallet/vip_program_screen.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/FaceBookEventController.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../../res/firebase_events.dart';
import '../../../utills/event_tracker/AppsFlyerController.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../utills/event_tracker/EventConstant.dart';
import '../../../utills/event_tracker/FacebookEventApi.dart';
import '../cash_free/CashFreeScreen.dart';

class Wallet extends StatelessWidget {
  WalletPageController walletPageController = Get.put(WalletPageController());
  UserController userController = Get.put(UserController());
  CleverTapController cleverTapController = Get.put(CleverTapController());
  BuildContext context;
  var splashDelay = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  //Login_Controller login_controller = Get.find(); //new code
  SharedPreferences prefs;
  bool click = false;
  var index_promo = null;
  var click_index = 0;
  var whatsAppNo = "0".obs;
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)'); //used in removing 0 after decimal
  /*Future<bool> _onWillPop() async {
    SystemNavigator.pop();
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

  @override
  Widget build(BuildContext context) {
    walletPageController.isLoadingProfileAPI.value = false;
    userController.getForceUpdate(context);
    userController.checkWallet_class_call.value = true;
    this.context = context;
    getWhNumber(context);

    if (userController.wallet_s.value == false) {
      userController.wallet_s.value = false;
    } else {
      userController.wallet_s.value = false;
    }
    //new code for guided tour
    walletPageController.createTutorial();
    walletPageController.showTutorial(context);

    //handle KYC swipe widget
    Timer(Duration(seconds: 0), () async {
      if (!await InternetConnectionChecker().hasConnection) {
        //Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
        return null;
      }
      await walletPageController.getProfileData();
      //walletPageController.varTimerForKycHelper.value = 4;
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: RefreshIndicator(
          key: _refreshIndicatorKey,
          // color: Colors.white,
          // backgroundColor: Colors.yellow,
          // strokeWidth: 4.0,
          onRefresh: () async {
            // Replace this delay with the code to be executed during refresh
            // and return a Future when code finishs execution.
            // return Future<void>.delayed(const Duration(seconds: 3));
            return Future.delayed(const Duration(seconds: 1), () async {
              walletPageController.currentpage.value = 0;

              if (walletPageController.sliderTrue.value) {
                walletPageController.sliderTrue.value = true;
                walletPageController.result.value = "";
              } else {
                walletPageController.sliderTrue.value = false;
                walletPageController.result.value = "Slide to complete KYC";
              }

              if (walletPageController.profileDataRes.value
                  .isPennyDropFaild()) {
                walletPageController.pennyDropLockCon.value = false;
              }

              try {
                if (walletPageController.transtsionlist.value.length > 0) {
                  walletPageController.transtsionlist.clear();
                }
              } catch (E) {}
              // await walletPageController.getWithdrawRequest();
              await walletPageController.getTransaction();
              await userController.getProfileData();
            });
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: walletPageController.scrollcontroller,
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 75,
                      color: Colors.transparent,
                    ),
                    Container(
                      color: Colors.black,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                      child: Column(
                        children: [
                          Obx(() => walletPageController.result.value ==
                                  "KYC Pending"
                              ? SlidableButton(
                                  initialPosition: SlidableButtonPosition.right,
                                  isRestart: true,
                                  width: MediaQuery.of(context).size.width,
                                  //buttonWidth: 0.0,
                                  height: 50,

                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: AppColor().colorPrimary, width: 2),
                                  color: AppColor().whiteColor,
                                  buttonColor: Colors.transparent,
                                  dismissible: false,
                                  label: CircleAvatar(
                                    //radius: 20.0,
                                    child: Image.asset(
                                        ImageRes().ic_kyc_completed),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      walletPageController.result.value.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                  onChanged: (position) {
                                    /* if (position ==
                                        SlidableButtonPosition.right) {
                                      walletPageController.result.value =
                                          'KYC IN Progress';
                                      showKycDialog(context);
                                    } else {
                                      walletPageController.result.value =
                                          'Slide to complete KYC';
                                    }*/
                                  },
                                )
                              : walletPageController.sliderTrue.value == true
                                  ? Container(
                                      height: 0,
                                    )
                                  // : walletPageController.varTimerForKycHelper > 3
                                  : walletPageController
                                              .isLoadingProfileAPI.value ==
                                          true
                                      ? Obx(
                                          () => Column(
                                            children: [
                                              SlidableButton(
                                                initialPosition:
                                                    walletPageController
                                                                .result.value ==
                                                            "Slide to complete KYC"
                                                        ? SlidableButtonPosition
                                                            .left
                                                        : SlidableButtonPosition
                                                            .right,
                                                isRestart: true,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                //buttonWidth: 0.0,
                                                height: 50,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                    color:
                                                        AppColor().colorPrimary,
                                                    width: 2),
                                                color: AppColor().whiteColor,
                                                buttonColor: Colors.transparent,
                                                dismissible: false,
                                                label: CircleAvatar(
                                                  //radius: 20.0,
                                                  child: Obx(() =>
                                                      walletPageController
                                                                  .result
                                                                  .value ==
                                                              "KYC IN Progress"
                                                          ? Image.asset(
                                                              ImageRes()
                                                                  .ic_kyc_apply)
                                                          : Image.asset(ImageRes()
                                                              .ic_kyc_completed)),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    walletPageController
                                                        .result.value.tr,
                                                    //'TEST',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                onChanged: (position) {
                                                  if (position ==
                                                      SlidableButtonPosition
                                                          .right) {
                                                    walletPageController
                                                            .result.value =
                                                        "KYC IN Progress";
                                                    showKycDialog(context);
                                                  } else {
                                                    walletPageController
                                                            .result.value =
                                                        "Slide to complete KYC";
                                                  }
                                                },
                                              ),
                                              Container(
                                                  child: Obx(
                                                () => (userController
                                                                    .profileDataRes
                                                                    .value !=
                                                                null &&
                                                            userController
                                                                    .profileDataRes
                                                                    .value
                                                                    .kyc !=
                                                                null &&
                                                            userController
                                                                .profileDataRes
                                                                .value
                                                                .kyc
                                                                .isrejected() ??
                                                        false)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Note :".tr,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: AppColor()
                                                                      .colorPrimary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(
                                                              userController
                                                                          .profileDataRes
                                                                          .value
                                                                          .kyc
                                                                          .message ==
                                                                      'Your KYC is rejected, please try again.'
                                                                  ? "Your KYC is rejected, please try again."
                                                                      .tr
                                                                  : "  ${userController.profileDataRes.value.kyc.message}",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: AppColor()
                                                                      .whiteColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 0,
                                                      ),
                                              )),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: 0,
                                        )),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, bottom: 0, left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    walletPageController.checkTr.value = true;
                                    walletPageController.colorPrimary.value =
                                        Color(0xFFe55f19);
                                    walletPageController.colorwhite.value =
                                        Color(0xFFffffff);
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        "Current Balance".tr,
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
                                              .colorPrimary.value,
                                          height: 3,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                                Visibility(
                                  visible: ApiUrl().isPlayStore &&
                                          walletPageController.user_mobileNo ==
                                              '9829953786'
                                      ? false
                                      : true,
                                  child: Expanded(
                                      child: InkWell(
                                    onTap: () async {
                                      walletPageController.currentpage.value =
                                          0;
                                      if (walletPageController
                                              .transtsionlist.value.length >
                                          0) {
                                        walletPageController.transtsionlist
                                            .clear();
                                      }

                                      //   await walletPageController.getWithdrawRequest();

                                      walletPageController.getTransaction();

                                      walletPageController.checkTr.value =
                                          false;
                                      walletPageController.colorPrimary.value =
                                          Color(0xFFffffff);
                                      walletPageController.colorwhite.value =
                                          Color(0xFFe55f19);
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "Transactions".tr,
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
                                                .colorwhite.value,
                                            height: 3,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0),
                    Obx(() => Visibility(
                        visible: walletPageController.checkTr.value,
                        child: currentBalanceCall(context))),
                    SizedBox(height: 15),
                    /*  Obx(() => Offstage(
                          offstage: walletPageController.checkTr.value,
                          child: walletPageController.checkRealMoneyOrGMNG.value ==
                                  false
                              ? walletPageController
                                          .withdrawRequestModelR.value !=
                                      null
                                  ? walletPageController
                                              .withdrawRequestModelR
                                              .value
                                              .data
                                              .length >
                                          0
                                      ? ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: walletPageController
                                              .withdrawRequestModelR
                                              .value
                                              .data
                                              .length,
                                          shrinkWrap: true,
                                          itemBuilder:
                                              (context, index_int) {
                                            return listWithdrawal(context, index_int);
                                          })
                                      : Container(
                                          height: 0,
                                          width: 0,
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
                                    )
                              : null,
                        )),*/
                    SizedBox(height: 5),
                    Obx(() => Offstage(
                          offstage: walletPageController.checkTr.value,
                          child: walletPageController
                                      .checkRealMoneyOrGMNG.value ==
                                  false
                              ? walletPageController.transtsionlist != null
                                  ? walletPageController.transtsionlist.length >
                                          0
                                      ? ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: walletPageController
                                              .transtsionlist.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index_int) {
                                            return listTransaction(
                                                context, index_int);
                                          })
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        )
                                  : Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.transparent,
                                      child: Image(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              "assets/images/progresbar_images.gif")),
                                    )
                              : null,
                        )),
                    SizedBox(height: 50),
                  ],
                ),
              ),
              floatingActionButton:

                  Padding(
                padding: const EdgeInsets.only(
                    left: 5, bottom: 50, right: 0, top: 0),
                child: FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: Colors.transparent,
                  // Add your onPressed code here!
                  child: Container(
                      //color: Colors.transparent,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            offset: const Offset(
                              0.0,
                              1.0,
                            ),
                            blurRadius: 7,
                            spreadRadius: .1,
                            color: Color(0xFFF14812),
                            inset: false,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                        // color: AppColor().whiteColor
                      ),
                      child: Image.asset(
                          //whatsapp_circle
                          /*userController.profileDataRes != null &&
                                          userController
                                                  .profileDataRes.value !=
                                              null &&
                                          userController.profileDataRes.value
                                                  .stats !=
                                              null &&
                                          userController
                                                  .profileDataRes
                                                  .value
                                                  .stats
                                                  .depositFromBank
                                                  .value !=
                                              null &&
                                          userController
                                                  .profileDataRes
                                                  .value
                                                  .stats
                                                  .depositFromBank
                                                  .value ==
                                              0
                                      ? */
                          ImageRes().wallet_support
                          //: ImageRes().whatsapp_circle,
                          )),
                ),
              ))


      ),
    );
  }

  currentBalanceCall(BuildContext context) {
    try {
      return Column(
        key: walletPageController.keyButton1,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 5, top: 0),
                      child: CircleAvatar(
                        radius: 20.0,
                        child: Image.asset("assets/images/deposited.webp"),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showBottomSheetInfo(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                ApiUrl().isPlayStore
                                    ? "Deposited Coin".tr
                                    : "Deposited Cash".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //Utils().customPrint('object>>>>>>>>> ${login_controller.only_number}');
                                  showBottomSheetInfo(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Image.asset("assets/images/info.webp",
                                      width: 15, height: 15),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  ApiUrl().isPlayStore
                                      ? ""
                                      : AppString().txt_currency_symbole,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: AppColor().colorPrimaryDark),
                                ),
                              ),
                              Text(
                                "${double.parse(userController.getDepositeBalnace())}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    color: AppColor().colorPrimaryDark),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*!ApiUrl().isPlayStore
                ? GestureDetector(
                    onTap: () async {
                      //await walletPageController.getAdvertisersDeals();
                      //await walletPageController.getUserDeals();
                      //Get.to(() => OfferWallScreen());
                    },
                    child: Lottie.asset(
                      'assets/lottie_files/free_lottie.json',
                      repeat: true,
                      height: 40,
                      width: 40,
                    ),
                  )
                : Container(),*/
              !ApiUrl().isPlayStore
                  ? InkWell(
                      onTap: () async {
                        if (!await InternetConnectionChecker().hasConnection) {
                          Fluttertoast.showToast(
                              msg: 'INTERNET CONNECTIVITY LOST');
                          return null;
                        }
                        if (userController
                                    .appSettingReponse.value.featuresStatus !=
                                null &&
                            userController.appSettingReponse.value
                                    .featuresStatus.length >
                                0) {
                          for (FeaturesStatus obj in userController
                              .appSettingReponse.value.featuresStatus) {
                            if (obj.id == 'addMoney' &&
                                obj.status == 'inactive') {
                              Utils().showWalletDown(context);
                              return;
                            }
                          }
                        }

                        await walletPageController.getPromoCodesData();

                        walletPageController.gameListSelectedColor.value =
                            1000; //initialisation
                        walletPageController.amtAfterPromoApplied.value = 0;
                        //showBottomSheetAddAmount(context);
                        //promocode api call again for refreshing the data
                        index_promo = null;

                        walletPageController.gameAmtSelectedColor.value = 0;
                        walletPageController.selectAmount.value = "0";
                        walletPageController.amountTextController.value.text =
                            "";
                        walletPageController.youWillGet.value = '';
                        walletPageController.click = false;
                        walletPageController.promocode.value = '';
                        walletPageController.walletTypePromocode = '';
                        walletPageController.percentagePromocode = '';
                        walletPageController.boolEnterCode.value = false;
                        walletPageController.havCodeController.value.text = '';
                        walletPageController.buttonApplyText.value = 'Apply';

                        //new promocode work
                        CashFreeController cashFreeController =
                            Get.put(CashFreeController());
                        cashFreeController.amountCashTextController.value.text =
                            "";
                        walletPageController.promo_type = "".obs;
                        walletPageController.promo_amt = 0.0.obs;
                        walletPageController.promo_minus_amt = 0.obs;
                        walletPageController.typeTextCheck = 0.obs;
                        walletPageController.applyPress = false.obs;
                        walletPageController.profitAmt = 0.0.obs;
                        AppString.contestAmount = 0; //newly added

                        //FTD work
                        //var promoCodeFTD = false;
                        if (walletPageController.walletModelPromo.data !=
                                null &&
                            walletPageController.walletModelPromo.data.length >
                                0) {
                          for (int i = 0;
                              i <
                                  walletPageController
                                      .walletModelPromo.data.length;
                              i++) {
                            print(
                                'response promo code ftd ${walletPageController.walletModelPromo.data[i].ftd}');
                            if (walletPageController
                                    .walletModelPromo.data[i].ftd ==
                                true) {
                              //Get.to(() => CashFreeScreen());
                              cashFreeController
                                      .amountCashTextController.value.text =
                                  walletPageController
                                      .walletModelPromo.data[i].fromValue;
                              walletPageController.selectAmount.value =
                                  walletPageController
                                      .walletModelPromo.data[i].fromValue;
                              //await cashFreeController.haveCodeApplied(item.fromValue.toString());
                              walletPageController.applyPress.value = true;
                              walletPageController.buttonApplyText.value =
                                  'Apply';
                              walletPageController.boolEnterCode.value = false;
                              cashFreeController.click_remove_code = true;
                              walletPageController.promocode.value =
                                  walletPageController
                                      .walletModelPromo.data[i].code;
                              vipBannerClickPromoCode(context);
                              //promoCodeFTD = true;
                              break;
                            }
                          }
                        }
                        Get.to(() => CashFreeScreen());
                        //new
                        //CashFreeController cashFreeController = Get.put(CashFreeController());
                      },
                      child: Container(
                        width: 125,
                        height: 42,
                        margin: EdgeInsets.only(right: 10),
                        /*  padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),*/
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: const Offset(
                                0.0,
                                5.0,
                              ),
                              blurRadius: 3.2,
                              spreadRadius: 0.3,
                              color: Color(0xFF02310A),
                              inset: true,
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColor().green_color_light,
                              AppColor().green_color,
                            ],
                          ),
                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 15,
                                width: 15,
                                child: SvgPicture.asset(
                                  "assets/images/plus_sv.svg",
                                  color: AppColor().whiteColor,
                                )

                                /*Image.asset(
                              "assets/images/plus_o.png",
                              color: Colors.white,
                            ),*/
                                ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Add Money".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ApiUrl().isPlayStore &&
                          AppString.esportPaymentEnable.value == 'active'
                      ? InkWell(
                          //  mini look  box
                          /*           onTap: () {
                      try {
                        String depositeBalnace =
                            userController.getDepositeBalnace();
                        int getBonuse =
                            userController.getBonuseCashBalanceInt();
                        var totalBaI = double.parse(depositeBalnace);
                        double depositeBalnaceSum = totalBaI + getBonuse;

                        if (depositeBalnaceSum <= 0) {
                          walletPageController.alertLookBox();
                        }
                      } catch (E) {
                        print("comming ex$E");
                      }
                    },*/
                          onTap: () async {
                            if (!await InternetConnectionChecker()
                                .hasConnection) {
                              Fluttertoast.showToast(
                                  msg: 'INTERNET CONNECTIVITY LOST');
                              return null;
                            }
                            if (userController.appSettingReponse.value
                                        .featuresStatus !=
                                    null &&
                                userController.appSettingReponse.value
                                        .featuresStatus.length >
                                    0) {
                              for (FeaturesStatus obj in userController
                                  .appSettingReponse.value.featuresStatus) {
                                if (obj.id == 'addMoney' &&
                                    obj.status == 'inactive') {
                                  Utils().showWalletDown(context);
                                  return;
                                }
                              }
                            }

                            await walletPageController.getPromoCodesData();

                            walletPageController.gameListSelectedColor.value =
                                1000; //initialisation
                            walletPageController.amtAfterPromoApplied.value = 0;
                            //showBottomSheetAddAmount(context);
                            //promocode api call again for refreshing the data
                            index_promo = null;

                            walletPageController.gameAmtSelectedColor.value = 0;
                            walletPageController.selectAmount.value = "0";
                            walletPageController
                                .amountTextController.value.text = "";
                            walletPageController.youWillGet.value = '';
                            walletPageController.click = false;
                            walletPageController.promocode.value = '';
                            walletPageController.walletTypePromocode = '';
                            walletPageController.percentagePromocode = '';
                            walletPageController.boolEnterCode.value = false;
                            walletPageController.havCodeController.value.text =
                                '';
                            walletPageController.buttonApplyText.value =
                                'Apply';

                            //new promocode work
                            Get.to(() => CashFreeScreen());
                            walletPageController.promo_type = "".obs;
                            walletPageController.promo_amt = 0.0.obs;
                            walletPageController.promo_minus_amt = 0.obs;
                            walletPageController.typeTextCheck = 0.obs;
                            walletPageController.applyPress = false.obs;
                            walletPageController.profitAmt = 0.0.obs;
                            AppString.contestAmount = 0; //newly added
                          },
                          child: Container(
                            width: 125,
                            height: 42,
                            margin: EdgeInsets.only(right: 10),
                            /*  padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),*/
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  offset: const Offset(
                                    0.0,
                                    5.0,
                                  ),
                                  blurRadius: 3.2,
                                  spreadRadius: 0.3,
                                  color: Color(0xFF02310A),
                                  inset: true,
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  AppColor().green_color_light,
                                  AppColor().green_color,
                                ],
                              ),
                              border: Border.all(
                                  color: AppColor().whiteColor, width: 2),
                              borderRadius: BorderRadius.circular(30),
                              // color: AppColor().whiteColor
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 15,
                                    width: 15,
                                    child: SvgPicture.asset(
                                      "assets/images/plus_sv.svg",
                                      color: AppColor().whiteColor,
                                    )

                                    /*Image.asset(
                              "assets/images/plus_o.png",
                              color: Colors.white,
                            ),*/
                                    ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Add Money".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.white24,
              //  dashGradient: [Colors.red, Colors.blue],
              dashRadius: 0.0,
              dashGapLength: 4.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 5, top: 0),
                    child: CircleAvatar(
                      radius: 20.0,
                      child: Image.asset("assets/images/winning_coin.webp"),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showBottomSheetInfo(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Winning Cash".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                showBottomSheetInfo(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Image.asset("assets/images/info.webp",
                                    width: 15, height: 15),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                ApiUrl().isPlayStore
                                    ? ""
                                    : AppString().txt_currency_symbole,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimaryDark),
                              ),
                            ),
                            Text(
                              "${userController.getWinningBalance().replaceAll(regex, '')}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().colorPrimaryDark),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (!await InternetConnectionChecker().hasConnection) {
                    Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
                    return null;
                  }
                  if (walletPageController.isLoadingProfileAPI.value == false) {
                    return;
                  }
                  if (isRedundentClick(DateTime.now())) {
                    Utils().customPrint('ProgressBarClick: showProgress click');
                    return;
                  }
                  Utils().customPrint(
                      'ProgressBarClick: showProgress run process');
                  //Utils().customPrint('test123: ${userController.profileDataRes.value.kyc.isApporved()}');
                  if (userController.appSettingReponse.value.featuresStatus !=
                          null &&
                      userController
                              .appSettingReponse.value.featuresStatus.length >
                          0) {
                    for (FeaturesStatus obj in userController
                        .appSettingReponse.value.featuresStatus) {
                      if (obj.id == 'withdraw' && obj.status == 'inactive') {
                        //Fluttertoast.showToast(msg: 'INACTIVE');
                        Utils().showWalletDown(context);
                        return;
                      }
                    }
                  }
                  /* if (ApiUrl().isPlayStore == false) {
                    bool stateR = await Utils().checkResLocation(context);
                    if (stateR) {
                      return;
                    }
                  }*/ //Fluttertoast.showToast(msg: "call values${Utils.stateV.value}");

                  /*if (walletPageController.profileDataRes.value != null &&
                      walletPageController.profileDataRes.value.withdrawMethod != null &&
                      walletPageController.profileDataRes.value.withdrawMethod.length > 0 &&
                      walletPageController.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus != null) {
                    if (walletPageController.profileDataRes.value.isPennyDropFaild() != null &&
                        !walletPageController.profileDataRes.value.isPennyDropFaild()) {
                      Get.to(() => PaymentOption(walletPageController.wallet_id_winning));
                    } else if (walletPageController.profileDataRes.value.isPennyDropFaild() != null &&
                        walletPageController.profileDataRes.value.isPennyDropFaild()) {
                      if (walletPageController.profileDataRes.value.settings.withdrawRequest.maxLimit >
                          walletPageController.pennyDropSummaryAmount.value) {
                        Get.to(() => PaymentOption(
                            walletPageController.wallet_id_winning));
                      } else {
                        walletPageController.pennyDropLockCon.value = false;
                        walletPageController.sliderTrue.value = false;
                        showKycDialogPennyDropCheckStatus(context);

                        //Utils().showErrorMessage("", "Please complete your kyc");
                      }
                    } else if (walletPageController.profileDataRes.value
                        .isPennyDropnotPerformed()) {
                      if (userController.profileDataRes.value != null &&
                          userController.profileDataRes.value.kyc != null &&
                          userController.profileDataRes.value.kyc
                              .isApporved()) {
                        Get.to(() => PaymentOption(
                            walletPageController.wallet_id_winning));
                      } else {
                        showKycDialog(context);

                        //Utils().showErrorMessage("", "Please complete your kyc");
                      }
                    } else {
                      if (userController.profileDataRes.value != null &&
                          userController.profileDataRes.value.kyc != null &&
                          userController.profileDataRes.value.kyc
                              .isApporved()) {
                        Get.to(() => PaymentOption(
                            walletPageController.wallet_id_winning));
                      } else {
                        showKycDialog(context);
                      }
                    }
                  } else {*/
                  if (walletPageController.profileDataRes.value != null &&
                      walletPageController.profileDataRes.value.kyc != null &&
                      walletPageController.profileDataRes.value.kyc
                          .isApporved()) {
                    Get.to(() =>
                        PaymentOption(walletPageController.wallet_id_winning));
                  } else {
                    // Utils().showErrorMessage("", "Please complete your kyc");
                    showKycDialog(context);
                  }
                  //}
                },
                child: Stack(
                  children: [
                    Container(
                      width: 125,
                      height: 42,
                      margin: EdgeInsets.only(right: 10),
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

                        border:
                            Border.all(color: AppColor().whiteColor, width: 2),
                        borderRadius: BorderRadius.circular(30),
                        // color: AppColor().whiteColor
                      ),
                      child: Obx(
                        () => walletPageController.sliderTrue.value == true
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    " Withdraw  ".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 17,
                                    width: 17,
                                    child: Obx(
                                      () => walletPageController
                                                  .sliderTrue.value ==
                                              true
                                          ? Text("")
                                          : SvgPicture.asset(
                                              "assets/images/padlock.svg",
                                              color: AppColor().whiteColor,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Withdraw".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.white24,
              //  dashGradient: [Colors.red, Colors.blue],
              dashRadius: 0.0,
              dashGapLength: 4.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 5, top: 0),
                    child: CircleAvatar(
                      radius: 20.0,
                      child: Image.asset("assets/images/bonus_coin.png"),
                      // child: Image.asset("assets/images/bonuscoin.webp"),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showBottomSheetInfo(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Bonus Cash".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                showBottomSheetInfo(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Image.asset("assets/images/info.webp",
                                    width: 15, height: 15),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                ApiUrl().isPlayStore
                                    ? ""
                                    : AppString().txt_currency_symbole,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimaryDark),
                              ),
                            ),
                            Obx(
                              () => Text(
                                "${userController.getBonuseCashBalance().replaceAll(regex, '')}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    color: AppColor().colorPrimaryDark),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  String urlCall =
                      "https://gmng.onelink.me/GRb6?af_xp=app&pid=Cross_sale&c=Referral%20code%20pre-fill&is_retargeting=true&af_dp=gmng%3A%2F%2F&referral_code=${userController.getUserReferalCode()}";
                  var encoded = Uri.encodeFull(urlCall);

                  Utils().funShareS(
                      "Bro Mere link se GMNG app download kar $encoded Hum dono ko 10-10 rs "
                      "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${userController.getUserReferalCode()}");
                },
                child: Container(
                  width: 125,
                  height: 42,
                  margin: EdgeInsets.only(right: 10),
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
                    border: Border.all(color: AppColor().whiteColor, width: 2),
                    borderRadius: BorderRadius.circular(30),

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
                    // color: AppColor().whiteColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " Refer & Earn  ".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat",
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
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.white24,
              //  dashGradient: [Colors.red, Colors.blue],
              dashRadius: 0.0,
              dashGapLength: 4.0,
            ),
          ),

          /*      Padding(
          padding:
              const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 15),
          child: DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: Colors.white,
            //  dashGradient: [Colors.red, Colors.blue],
            dashRadius: 0.0,
            dashGapLength: 4.0,
            // dashGapColor: Colors.transparent,
            //  dashGapGradient: [Colors.red, Colors.blue],
            // dashGapRadius: 0.0,
          ),
        ),*/
          //Start New VIP Module 5, June 2023
          Container(
            key: walletPageController.keyButton2,
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 0, right: 0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  offset: const Offset(
                    0,
                    2.0,
                  ),
                  blurRadius: 2,
                  spreadRadius: -1,
                  color: Color(0xFFF19812),
                  inset: false,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor().scratch_card,
                  AppColor().border_outside,
                  AppColor().border_outside,
                  AppColor().scratch_card,
                ],
              ),
              border: Border.all(color: AppColor().border_inside, width: 1),
              borderRadius: BorderRadius.circular(20),
              // color: AppColor().whiteColor
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        userController.profileDataRes.value != null &&
                                userController.profileDataRes.value.level !=
                                    null &&
                                userController
                                        .profileDataRes.value.level.value >
                                    0
                            ? Container(
                                margin:
                                    EdgeInsets.only(left: 3, right: 5, top: 0),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  child: Image.asset(
                                      "assets/images/instant_coin.png"),
                                  // child: Image.asset("assets/images/bonuscoin.webp"),
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            : Container(
                                margin:
                                    EdgeInsets.only(left: 7, right: 5, top: 0),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  child: Image.asset(
                                      "assets/images/vip_lock_coin.png"),
                                  // child: Image.asset("assets/images/bonuscoin.webp"),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                        InkWell(
                          onTap: () {
                            //Event Call
                            Map<String, dynamic> map = {
                              "USER_ID": userController.user_id
                            };
                            AppsflyerController af =
                                Get.put(AppsflyerController());
                            CleverTapController ct =
                                Get.put(CleverTapController());

                            af.logEventAf(
                                EventConstant.Instant_Cash_Clicked, map);
                            ct.logEventCT(
                                EventConstant.Instant_Cash_Clicked, map);

                            FirebaseEvent().firebaseEvent(
                                EventConstant.Instant_Cash_Clicked_F, map);
                            //end
                            if (userController.profileDataRes.value.level !=
                                    null &&
                                userController
                                        .profileDataRes.value.level.value >
                                    0) {
                              userController.showBottomSheetInfoInstantVIP();
                            } else {
                              if (userController.appSettingReponse.value
                                      .instantCash.featureDescription !=
                                  null) {
                                showBottomSheetInfoInstant(context);
                              }
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Instant Cash".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //Event Call
                                      Map<String, dynamic> map = {
                                        "USER_ID": userController.user_id
                                      };
                                      AppsflyerController af =
                                          Get.put(AppsflyerController());
                                      CleverTapController ct =
                                          Get.put(CleverTapController());

                                      af.logEventAf(
                                          EventConstant.Instant_Cash_Clicked,
                                          map);
                                      ct.logEventCT(
                                          EventConstant.Instant_Cash_Clicked,
                                          map);

                                      FirebaseEvent().firebaseEvent(
                                          EventConstant.Instant_Cash_Clicked_F,
                                          map);
                                      //end
                                      if (userController
                                                  .profileDataRes.value.level !=
                                              null &&
                                          userController.profileDataRes.value
                                                  .level.value >
                                              0) {
                                        userController
                                            .showBottomSheetInfoInstantVIP();
                                      } else {
                                        if (userController
                                                .appSettingReponse
                                                .value
                                                .instantCash
                                                .featureDescription !=
                                            null) {
                                          showBottomSheetInfoInstant(context);
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Image.asset(
                                          "assets/images/info.webp",
                                          width: 15,
                                          height: 15),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Text(
                                      ApiUrl().isPlayStore
                                          ? ""
                                          : AppString().txt_currency_symbole,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          color: AppColor().colorPrimaryDark),
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      "${userController.getInstantCashInt().toStringAsFixed(2).replaceAll(regex, '')}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Montserrat",
                                          color: AppColor().colorPrimaryDark),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          //Event Call
                          AppsflyerController af =
                              Get.put(AppsflyerController());
                          CleverTapController ct =
                              Get.put(CleverTapController());
                          Map<String, dynamic> map = {
                            "USER_ID": userController.user_id
                          };
                          af.logEventAf(EventConstant.Redeem_clicked, map);
                          ct.logEventCT(EventConstant.Redeem_clicked, map);
                          FirebaseEvent().firebaseEvent(
                              EventConstant.Redeem_clicked_F, map);

                          //__________________________________________________________
                          if (userController.profileDataRes.value.level !=
                                  null &&
                              userController.profileDataRes.value.level.value >
                                  0) {
                            if (userController.getInstantCashInt() >
                                userController.appSettingReponse.value
                                    .instantCash.unlockLimit) {
                              alertInstantCashWithdraw(context);
                            } else {
                              Utils().insufficientInstant();
                            }
                            //place above in this popup
                          } else {
                            if (userController.appSettingReponse.value
                                    .instantCash.featureDescription !=
                                null) {
                              if (userController.profileDataRes.value.level !=
                                      null &&
                                  userController
                                          .profileDataRes.value.level.value >
                                      0) {
                                userController.showBottomSheetInfoInstantVIP();
                              } else {
                                if (userController.appSettingReponse.value
                                        .instantCash.featureDescription !=
                                    null) {
                                  showBottomSheetInfoInstant(context);
                                }
                              }
                            } else {
                              Map<String, dynamic> map4 = {
                                "featureDescription":
                                    "featureDescription may be null}"
                              };
                              ct.logEventCT("TEST_REDEEM", map4);
                              FirebaseEvent()
                                  .firebaseEvent("TEST_REDEEM", map4);
                              //Fluttertoast.showToast(msg: "Error: featureDescription may be null!");
                            }
                          }
                        } catch (e) {
                          CleverTapController ct =
                              Get.put(CleverTapController());
                          Map<String, dynamic> map_catch = {
                            "CATCH": "error: ${e.toString()}"
                          };
                          ct.logEventCT("TEST_REDEEM", map_catch);
                          //Fluttertoast.showToast(msg: "Error: ${e.toString()}");
                        }
                      },
                      child: userController.profileDataRes.value != null &&
                              userController.profileDataRes.value.level !=
                                  null &&
                              userController.profileDataRes.value.level.value >
                                  0
                          ? Container(
                              width: 125,
                              height: 42,
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 3.2,
                                    spreadRadius: 0.3,
                                    color: Color(0xFF02310A),
                                    inset: true,
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().green_color_light,
                                    AppColor().green_color,
                                  ],
                                ),
                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Redeem".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: 125,
                              height: 42,
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  // Where the linear gradient begins and ends
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  // Add one stop for each color. Stops should increase from 0 to 1
                                  //  stops: [0.1, 0.5, 0.7, 0.9],
                                  colors: [
                                    // Colors are easy thanks to Flutter's Colors class.
                                    AppColor().vip_button_light,
                                    AppColor().vip_button,
                                  ],
                                ),
                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),

                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFF242424),
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
                                  Container(
                                    height: 22,
                                    width: 22,
                                    child: Image.asset(
                                      "assets/images/redeem_lock.png",
                                      //   color: AppColor().whiteColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Redeem".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor),
                                  ),
                                ],
                              ),
                            ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (!await InternetConnectionChecker().hasConnection) {
                      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
                      return null;
                    }
                    //Fluttertoast.showToast(msg: 'Redirection....');
                    if (userController.profileDataRes.value.level != null) {
                      Get.to(() => VipProgramScreen());
                    } else {
                      Fluttertoast.showToast(
                          msg: "Some thing went wrong, please restart App!");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      // margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                      //padding: EdgeInsets.only(top: 25, bottom: 15, left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColor().scratch_card,
                            AppColor().border_outside,
                            AppColor().border_outside,
                            AppColor().scratch_card,
                          ],
                        ),
                        border: Border.all(
                            color: AppColor().border_inside, width: 1),
                        borderRadius: BorderRadius.circular(15),
                        // color: AppColor().whiteColor
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, right: 10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                backgroundColor: AppColor().vip_button,
                                radius: 10,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: AppColor().yellow_vip_button,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Total Cashback Earned".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    color: AppColor().yellow_vip_button),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, top: 5, bottom: 10, right: 5),
                            child: LinearPercentIndicator(
                              //width: 140.0,
                              lineHeight: 10.0,
                              percent: walletPageController
                                  .percentageVipProgressCircularBar.value,
                              //center: Text("50.0%", style: new TextStyle(fontSize: 12.0),),
                              trailing: Row(
                                children: [
                                  userController.profileDataRes.value != null &&
                                          userController
                                                  .profileDataRes.value.stats !=
                                              null &&
                                          userController.profileDataRes.value
                                                  .stats.instantCash !=
                                              null
                                      ? Text(
                                          "\u{20B9}${(userController.profileDataRes.value.stats.instantCash.value / 100).toStringAsFixed(2).replaceAll(regex, '')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Inter",
                                              color: AppColor().vip_green),
                                        )
                                      : Text(""),
                                  Text(
                                    userController.instantCashLimitNextLevel
                                                .value ==
                                            0
                                        ? "/Max"
                                        : "/${(userController.instantCashLimitNextLevel.value / 100).toStringAsFixed(0)}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor),
                                  ),
                                ],
                              ),
                              barRadius: Radius.circular(8),
                              backgroundColor: AppColor().gray_vip_button,
                              progressColor: AppColor().yellow_vip_button,
                              animationDuration: 2000,
                              animation: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //End New VIP Module 5, June 2023
          /* Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
          child: DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: Colors.white,
            //  dashGradient: [Colors.red, Colors.blue],
            dashRadius: 0.0,
            dashGapLength: 4.0,
            // dashGapColor: Colors.transparent,
            //  dashGapGradient: [Colors.red, Colors.blue],
            // dashGapRadius: 0.0,
          ),
        ),*/
          //OLD BANNER
          /* Padding(
          padding: const EdgeInsets.only(top: 30),
          child: GestureDetector(
            onTap: () async {
              //offer wall test

              //Utils().alertInsufficientBalance(context);//insufficient amt popup
              //return;
              //end
              if (walletPageController.bannerModelRV.value != null &&
                  walletPageController.bannerModelRV.value.data != null &&
                  walletPageController.bannerModelRV.value.data.length >= 1 &&
                  walletPageController.bannerModelRV.value.data[0].name
                          .compareTo("whatsapp") ==
                      0) {
                if (whatsAppNo.value != null && whatsAppNo.value != "0") {
                  BaseController base_controller = Get.put(BaseController());
                  base_controller.openwhatsappOTPV();
                }
              } else if (walletPageController.bannerModelRV.value != null &&
                  walletPageController.bannerModelRV.value.data != null &&
                  walletPageController.bannerModelRV.value.data.length >= 1 &&
                  walletPageController.bannerModelRV.value.data[0].name
                          .compareTo("lootbox") ==
                      0) {
                await walletPageController.getAdvertisersDeals();
                await walletPageController.getUserDeals();
                //  AppString.isClickFromHome = false;
                Get.to(() => OfferWallScreen());
              } else if (walletPageController.bannerModelRV.value != null &&
                  walletPageController.bannerModelRV.value.data != null &&
                  walletPageController.bannerModelRV.value.data.length >= 1 &&
                  walletPageController.bannerModelRV.value.data[0].name
                          .compareTo("store") ==
                      0) {
                Get.to(() => Store());
              } else {
                //  Get.to(() => Store());
              }
            },
            child: Container(
              height: 130,
              margin: EdgeInsets.only(top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Obx(
                    () => Image(
                      height: 120,
                      fit: BoxFit.cover,
                      image: walletPageController.bannerModelRV.value != null &&
                              walletPageController.bannerModelRV.value.data !=
                                  null &&
                              walletPageController
                                      .bannerModelRV.value.data.length >=
                                  1
                          ? NetworkImage(walletPageController
                              .bannerModelRV.value.data[0].image.url)
                          : AssetImage(ImageRes().store_banner_wallet),
                    ),
                  )

                  */ /*Image(
                    height: 130,
                    fit: BoxFit.fitWidth,
                    image:
                    AssetImage('assets/images/spin_win_banner.webp'),
                  )*/ /*
                  ),
            ),
          ),
        ),*/
          //NEW VIP BANNER
          /*Obx(() => walletPageController.walletModelPromoBanner.value.data !=
                      null &&
                  walletPageController
                          .walletModelPromoBanner.value.data.length >
                      0
              ? Padding(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  child: Container(
                    height: 140,
                    //color: Colors.red,
                    //margin: EdgeInsets.only(top: 20, left: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CarouselSlider(
                        items: walletPageController
                            .walletModelPromoBanner.value.data
                            .map((item) => item.banner != null &&
                                    item.banner != '' &&
                                    item.isVIP == true
                                ? Stack(children: [
                                    GestureDetector(
                                      onTap: () async {
                                        walletPageController
                                            .gameListSelectedColor
                                            .value = 1000; //initialisation
                                        walletPageController
                                            .amtAfterPromoApplied.value = 0;
                                        //showBottomSheetAddAmount(context);
                                        //promocode api call again for refreshing the data
                                        index_promo = null;

                                        walletPageController
                                            .gameAmtSelectedColor.value = 0;
                                        walletPageController
                                            .selectAmount.value = "0";
                                        walletPageController
                                            .amountTextController
                                            .value
                                            .text = "";
                                        walletPageController.youWillGet.value =
                                            '';
                                        walletPageController.click = false;
                                        walletPageController.promocode.value =
                                            '';
                                        walletPageController
                                            .walletTypePromocode = '';
                                        walletPageController
                                            .percentagePromocode = '';
                                        walletPageController
                                            .boolEnterCode.value = false;
                                        walletPageController
                                            .havCodeController.value.text = '';
                                        walletPageController
                                            .buttonApplyText.value = 'Apply';

                                        //new promocode work
                                        walletPageController.promo_type =
                                            "".obs;
                                        walletPageController.promo_amt =
                                            0.0.obs;
                                        walletPageController.promo_minus_amt =
                                            0.obs;
                                        walletPageController.typeTextCheck =
                                            0.obs;
                                        walletPageController.applyPress =
                                            false.obs;
                                        walletPageController.profitAmt =
                                            0.0.obs;
                                        AppString.contestAmount =
                                            0; //newly added

                                        CashFreeController cashFreeController =
                                            Get.put(CashFreeController());
                                        Get.to(() =>
                                            CashFreeScreen()); //<<<<<<<<<<<<<<<<<<<<<<<<
                                        cashFreeController
                                            .amountCashTextController
                                            .value
                                            .text = item.fromValue;
                                        walletPageController.selectAmount
                                            .value = item.fromValue;
                                        //await cashFreeController.haveCodeApplied(item.fromValue.toString());
                                        walletPageController.applyPress.value =
                                            true;
                                        walletPageController
                                            .buttonApplyText.value = 'Apply';
                                        walletPageController
                                            .boolEnterCode.value = false;
                                        cashFreeController.click_remove_code =
                                            true;
                                        walletPageController.promocode.value =
                                            item.code;
                                        vipBannerClickPromoCode(
                                            context); //new method
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: CachedNetworkImage(
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                  imageUrl: (item.banner),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Stack(
                                        children: [
                                          Image(
                                            height: 40,
                                            width: 40,
                                            //fit: BoxFit.cover,
                                            image: AssetImage(
                                                ImageRes().banner_overlay),
                                          ),
                                          Center(
                                            child:
                                                '${item.total - item.usesCount}'
                                                            .length <
                                                        5
                                                    ? Text(
                                                        '${item.total - item.usesCount} Left',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 11,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        '${item.total - item.usesCount} Left',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 9,
                                                            color:
                                                                Colors.white),
                                                      ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])
                                : GestureDetector(
                                    onTap: () async {},
                                    child: Stack(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Center(
                                            child: CachedNetworkImage(
                                              height: 100,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                              imageUrl: (item.banner),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        child: Stack(
                                          children: [
                                            Image(
                                              height: 40,
                                              width: 40,
                                              //fit: BoxFit.cover,
                                              image: AssetImage(
                                                  ImageRes().banner_overlay),
                                            ),
                                            Center(
                                              child:
                                                  '${item.total - item.usesCount}'
                                                              .length <
                                                          5
                                                      ? Text(
                                                          '${item.total - item.usesCount} Left',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      : Text(
                                                          '${item.total - item.usesCount} Left',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontSize: 9,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ClipRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.0, sigmaY: 2.0),
                                          child: Center(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black12
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                height: 50,
                                                width: 230,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    //"To Unlock next VIP level,\nDeposit ${item.needDepositAmtForNextVipLevel}!",
                                                    "Get ${(userController.instantCashLimitNextLevel.value / 100).toStringAsFixed(0)} in instant cash\nto unlock this offer",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ))
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
                      ),
                    ),
                  ),
                )
              : Container()),*/
          //NEW VIP WORK REJECTED
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 25,
                    child: Container(
                      height: 180,
                      /*     decoration: BoxDecoration(
                        color: AppColor().vip_button,
                        border: Border.all(
                          width: 2,
                          color: AppColor().reward_grey_bg,
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                            blurRadius: 1.0,
                            spreadRadius: .3,
                            color: AppColor().reward_grey_bg,
                            inset: true,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),*/
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 5.0, top: 10),
                            child: Text(
                              "VIP Progress",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.0,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                //
                                walletPageController
                                    .showBottomSheetVipCircularProgress();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: CircularPercentIndicator(
                                  //startAngle: 1,
                                  radius: 50.0,
                                  lineWidth: 15.0,
                                  //animation: true,
                                  percent: walletPageController
                                      .percentageVipProgressCircularBar.value,
                                  center: Text(
                                    userController.profileDataRes.value.stats !=
                                            null
                                        ? "VIP-${userController.profileDataRes.value.level.value}"
                                            "\n${(userController.profileDataRes.value.stats.instantCash.value / 100).toStringAsFixed(0)}"
                                            "/${(userController.instantCashLimitNextLevel.value / 100).toStringAsFixed(0)}"
                                        : '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
                                        fontFamily: "Montserrat",
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  /*header: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: const Text(
                                    "Level Progress",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20.0,
                                        fontFamily: "Montserrat",
                                        color: Colors.white),
                                  ),
                                ),*/
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: AppColor().colorPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 75,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        height: 180,
                        /* decoration: BoxDecoration(
                          color: AppColor().vip_button,
                          border: Border.all(
                            width: 2,
                            color: AppColor().reward_grey_bg,
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(
                                0.0,
                                0.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: AppColor().reward_grey_bg,
                              inset: true,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),*/
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5.0, top: 10),
                              child: Text(
                                "Offers",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.0,
                                    fontFamily: "Montserrat",
                                    color: Colors.white),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Obx(() => walletPageController
                                                .walletModelPromoBanner
                                                .value
                                                .data !=
                                            null &&
                                        walletPageController
                                                .walletModelPromoBanner
                                                .value
                                                .data
                                                .length >
                                            0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, right: 5),
                                        child: Container(
                                          height: 120,
                                          //color: Colors.red,
                                          //margin: EdgeInsets.only(top: 20, left: 20),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CarouselSlider(
                                              items:
                                                  walletPageController
                                                      .walletModelPromoBanner
                                                      .value
                                                      .data
                                                      .map((item) =>
                                                          item.banner != null &&
                                                                  item.banner !=
                                                                      '' &&
                                                                  item.isVIP ==
                                                                      true
                                                              ? Stack(
                                                                  children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          walletPageController
                                                                              .gameListSelectedColor
                                                                              .value = 1000; //initialisation
                                                                          walletPageController
                                                                              .amtAfterPromoApplied
                                                                              .value = 0;
                                                                          //showBottomSheetAddAmount(context);
                                                                          //promocode api call again for refreshing the data
                                                                          index_promo =
                                                                              null;

                                                                          walletPageController
                                                                              .gameAmtSelectedColor
                                                                              .value = 0;
                                                                          walletPageController
                                                                              .selectAmount
                                                                              .value = "0";
                                                                          walletPageController
                                                                              .amountTextController
                                                                              .value
                                                                              .text = "";
                                                                          walletPageController
                                                                              .youWillGet
                                                                              .value = '';
                                                                          walletPageController.click =
                                                                              false;
                                                                          walletPageController
                                                                              .promocode
                                                                              .value = '';
                                                                          walletPageController.walletTypePromocode =
                                                                              '';
                                                                          walletPageController.percentagePromocode =
                                                                              '';
                                                                          walletPageController
                                                                              .boolEnterCode
                                                                              .value = false;
                                                                          walletPageController
                                                                              .havCodeController
                                                                              .value
                                                                              .text = '';
                                                                          walletPageController
                                                                              .buttonApplyText
                                                                              .value = 'Apply';

                                                                          //new promocode work
                                                                          walletPageController.promo_type =
                                                                              "".obs;
                                                                          walletPageController.promo_amt =
                                                                              0.0.obs;
                                                                          walletPageController.promo_minus_amt =
                                                                              0.obs;
                                                                          walletPageController.typeTextCheck =
                                                                              0.obs;
                                                                          walletPageController.applyPress =
                                                                              false.obs;
                                                                          walletPageController.profitAmt =
                                                                              0.0.obs;
                                                                          AppString.contestAmount =
                                                                              0; //newly added

                                                                          CashFreeController
                                                                              cashFreeController =
                                                                              Get.put(CashFreeController());
                                                                          Get.to(() =>
                                                                              CashFreeScreen()); //<<<<<<<<<<<<<<<<<<<<<<<<
                                                                          cashFreeController
                                                                              .amountCashTextController
                                                                              .value
                                                                              .text = item.fromValue;
                                                                          walletPageController
                                                                              .selectAmount
                                                                              .value = item.fromValue;
                                                                          //await cashFreeController.haveCodeApplied(item.fromValue.toString());
                                                                          walletPageController
                                                                              .applyPress
                                                                              .value = true;
                                                                          walletPageController
                                                                              .buttonApplyText
                                                                              .value = 'Apply';
                                                                          walletPageController
                                                                              .boolEnterCode
                                                                              .value = false;
                                                                          cashFreeController.click_remove_code =
                                                                              true;
                                                                          walletPageController
                                                                              .promocode
                                                                              .value = item.code;
                                                                          vipBannerClickPromoCode(
                                                                              context); //new method
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              const EdgeInsets.symmetric(horizontal: 6),
                                                                          child:
                                                                              Center(
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 5.0),
                                                                                  child: CachedNetworkImage(
                                                                                    height: 120,
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    fit: BoxFit.fill,
                                                                                    imageUrl: (item.banner),
                                                                                  ),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Image(
                                                                              height: 40,
                                                                              width: 40,
                                                                              //fit: BoxFit.cover,
                                                                              image: AssetImage(ImageRes().banner_overlay),
                                                                            ),
                                                                            Center(
                                                                              child: '${item.total - item.usesCount}'.length < 5
                                                                                  ? Text(
                                                                                      '${item.total - item.usesCount} Left',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Montserrat", fontSize: 11, color: Colors.white),
                                                                                    )
                                                                                  : Text(
                                                                                      '${item.total - item.usesCount} Left',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Montserrat", fontSize: 9, color: Colors.white),
                                                                                    ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ])
                                                              : GestureDetector(
                                                                  onTap:
                                                                      () async {},
                                                                  child: Stack(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.symmetric(horizontal: 6),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 5.0),
                                                                            child:
                                                                                Center(
                                                                              child: CachedNetworkImage(
                                                                                height: 100,
                                                                                width: MediaQuery.of(context).size.width,
                                                                                fit: BoxFit.cover,
                                                                                imageUrl: (item.banner),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Image(
                                                                                height: 40,
                                                                                width: 40,
                                                                                //fit: BoxFit.cover,
                                                                                image: AssetImage(ImageRes().banner_overlay),
                                                                              ),
                                                                              Center(
                                                                                child: '${item.total - item.usesCount}'.length < 5
                                                                                    ? Text(
                                                                                        '${item.total - item.usesCount} Left',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Montserrat", fontSize: 11, color: Colors.white),
                                                                                      )
                                                                                    : Text(
                                                                                        '${item.total - item.usesCount} Left',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Montserrat", fontSize: 9, color: Colors.white),
                                                                                      ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        ClipRect(
                                                                          child:
                                                                              BackdropFilter(
                                                                            filter:
                                                                                ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                                            child:
                                                                                Center(
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(color: Colors.black12.withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                                                                                  height: 50,
                                                                                  width: 230,
                                                                                  child: Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      "Unlocks at \nNext VIP level",
                                                                                      /*${item.needDepositAmtForNextVipLevel}!*/
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: "Montserrat", color: Colors.white),
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ))
                                                      .toList(),
                                              options: CarouselOptions(
                                                height: 120.0,
                                                autoPlay: true,
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
                                                  // controller.currentIndexSlider.value = index;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                                Obx(
                                  () => walletPageController
                                                  .walletModelPromoBanner
                                                  .value
                                                  .data !=
                                              null &&
                                          walletPageController
                                                  .walletModelPromoBanner
                                                  .value
                                                  .data
                                                  .length >
                                              0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: walletPageController
                                              .walletModelPromoBanner.value.data
                                              .map(
                                            (image) {
                                              int index = walletPageController
                                                  .walletModelPromoBanner
                                                  .value
                                                  .data
                                                  .indexOf(image);
                                              return Container(
                                                width: 8.0,
                                                height: 8.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: walletPageController
                                                                .currentIndexSlider
                                                                .value ==
                                                            index
                                                        ? walletPageController
                                                            .appBtnBgColor.value
                                                        : walletPageController
                                                            .appBtnTxtColor
                                                            .value),
                                              );
                                            },
                                          ).toList(), // this was the part the I had to add
                                        )
                                      : Text(""),
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
            ),
          ),
          //NEW VIP WORK
          /*Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              //color: Colors.blue,
              //height: 200,
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: AppColor().reward_card_bg,
                  border: Border.all(
                    width: 2,
                    color: AppColor().vip_button,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(
                        0.0,
                        0.3,
                      ),
                      blurRadius: 1.0,
                      spreadRadius: .3,
                      color: AppColor().vip_button,
                      inset: true,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0, top: 10),
                    child: Text(
                      "Instant Cash",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                        fontFamily: "Montserrat",
                        color: AppColor().yellow_vip,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      userController.instantCashLimitNextLevel.value == 0
                          ? "${(userController.profileDataRes.value.stats.instantCash.value / 100).toStringAsFixed(0)}"
                              "/Max"
                          : userController.profileDataRes.value.stats != null
                              ? "${(userController.profileDataRes.value.stats.instantCash.value / 100).toStringAsFixed(0)}"
                                  "/${(userController.instantCashLimitNextLevel.value / 100).toStringAsFixed(0)}"
                              : '',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0,
                          fontFamily: "Montserrat",
                          color: AppColor().yellow_vip_button),
                    ),
                  ),
                  */ /*Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    //height: 30,
                    //color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    */ /* */ /*  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(90),
                    ),*/ /* */ /*
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(
                          () => LinearPercentIndicator(
                            //width: 140.0,
                            lineHeight: 20.0,
                            percent: walletPageController
                                .percentageVipProgressCircularBar.value,
                            */ /* */ /*  center: Text(
                              "50.0%",
                              style: new TextStyle(fontSize: 12.0),
                            ),
                            trailing: Icon(Icons.mood),*/ /* */ /*
                            barRadius: Radius.circular(8),
                            backgroundColor: AppColor().whiteColor,
                            progressColor: AppColor().green_color_light,
                            animationDuration: 2000,
                            animation: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "VIP ${userController.profileDataRes.value.level.value}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.0,
                                  fontFamily: "Montserrat",
                                  color: AppColor().blackColor,
                                ),
                              ),
                              Text(
                                "VIP ${userController.profileDataRes.value.level.value + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.0,
                                  fontFamily: "Montserrat",
                                  color: AppColor().blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/ /*
                  Container(
                    //height: 250,
                    //color: Colors.white,
                    width: MediaQuery.of(navigatorKey.currentState.context)
                        .size
                        .width,
                    child: Center(
                      child: Card(
                        elevation: 1,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 12, bottom: 20),
                        color: Colors.transparent,
                        child: Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                */ /* CarouselSlider(
                                items: [
                                  Container(
                                    height: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        color: AppColor().vip_button,
                                        border: Border.all(
                                          width: 2,
                                          color: AppColor().reward_grey_bg,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(
                                              0.0,
                                              0.0,
                                            ),
                                            blurRadius: 1.0,
                                            spreadRadius: .3,
                                            color: AppColor().reward_grey_bg,
                                            inset: true,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 5, top: 0),
                                          child: CircleAvatar(
                                            radius: 20.0,
                                            child: Image.asset(
                                                "assets/images/redeem_lock.png"),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                        Text(
                                          "VIP100",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            fontFamily: "Montserrat",
                                            color: AppColor().yellow_vip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        color: AppColor().vip_button,
                                        border: Border.all(
                                          width: 2,
                                          color: AppColor().reward_grey_bg,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(
                                              0.0,
                                              0.0,
                                            ),
                                            blurRadius: 1.0,
                                            spreadRadius: .3,
                                            color: AppColor().reward_grey_bg,
                                            inset: true,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 5, top: 0),
                                          child: CircleAvatar(
                                            radius: 20.0,
                                            child: Image.asset(
                                                "assets/images/redeem_lock.png"),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                        Text(
                                          "VIP200",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            fontFamily: "Montserrat",
                                            color: AppColor().yellow_vip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        color: AppColor().vip_button,
                                        border: Border.all(
                                          width: 2,
                                          color: AppColor().reward_grey_bg,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(
                                              0.0,
                                              0.0,
                                            ),
                                            blurRadius: 1.0,
                                            spreadRadius: .3,
                                            color: AppColor().reward_grey_bg,
                                            inset: true,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 5, top: 0),
                                          child: CircleAvatar(
                                            radius: 20.0,
                                            child: Image.asset(
                                                "assets/images/redeem_lock.png"),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                        Text(
                                          "VIP300",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            fontFamily: "Montserrat",
                                            color: AppColor().yellow_vip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                options: CarouselOptions(
                                  height: 70,
                                  autoPlay: false,
                                  disableCenter: true,
                                  viewportFraction: .8,
                                  aspectRatio: 3,
                                  enlargeCenterPage: false,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 1000),
                                  onPageChanged: (index, reason) {
                                    walletPageController
                                        .currentIndexSliderVip.value = index;
                                    print(
                                        "call data currentIndexSlider$walletPageController.currentIndexSliderVip");
                                  },
                                ),
                              ),*/ /*
                                Obx(() => walletPageController
                                                .walletModelPromoBanner
                                                .value
                                                .data !=
                                            null &&
                                        walletPageController
                                                .walletModelPromoBanner
                                                .value
                                                .data
                                                .length >
                                            0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, right: 5),
                                        child: Container(
                                          height: 100,
                                          //color: Colors.red,
                                          //margin: EdgeInsets.only(top: 20, left: 20),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CarouselSlider(
                                              items:
                                                  walletPageController
                                                      .walletModelPromoBanner
                                                      .value
                                                      .data
                                                      .map((item) =>
                                                          item.banner != null &&
                                                                  item.banner !=
                                                                      '' &&
                                                                  item.isVIP ==
                                                                      true
                                                              ? Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              20),
                                                                      child:
                                                                          Container(
                                                                        //height: 30,
                                                                        //color: Colors.white,
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10,
                                                                            vertical:
                                                                                3),
                                                                        */ /*  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(90),
                    ),*/ /*
                                                                        child:
                                                                            Stack(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          children: [
                                                                            Obx(
                                                                              () => LinearPercentIndicator(
                                                                                //width: 140.0,
                                                                                lineHeight: 20.0,
                                                                                percent: item.vipLevel == userController.profileDataRes.value.level.value ? walletPageController.percentageVipProgressCircularBar.value : 1,
                                                                                */ /*  center: Text(
                              "50.0%",
                              style: new TextStyle(fontSize: 12.0),
                            ),
                            trailing: Icon(Icons.mood),*/ /*
                                                                                barRadius: Radius.circular(8),
                                                                                backgroundColor: AppColor().whiteColor,
                                                                                progressColor: AppColor().green_color_light,
                                                                                animationDuration: 2000,
                                                                                animation: true,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 15.0, right: 15),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    //"VIP ${userController.profileDataRes.value.level.value}",
                                                                                    "VIP ${item.vipLevel}",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 10.0,
                                                                                      fontFamily: "Montserrat",
                                                                                      color: AppColor().blackColor,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    //"VIP ${userController.profileDataRes.value.level.value + 1}",
                                                                                    "VIP ${item.vipLevel + 1}",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 10.0,
                                                                                      fontFamily: "Montserrat",
                                                                                      color: AppColor().blackColor,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        vipPopUpClick(
                                                                            context,
                                                                            item);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 8.0),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              30,
                                                                          margin:
                                                                              const EdgeInsets.symmetric(horizontal: 30),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow: const [
                                                                              BoxShadow(
                                                                                offset: const Offset(
                                                                                  0.0,
                                                                                  5.0,
                                                                                ),
                                                                                blurRadius: 3.2,
                                                                                spreadRadius: 0.3,
                                                                                color: Color(0xFF02310A),
                                                                                inset: true,
                                                                              ),
                                                                            ],
                                                                            gradient:
                                                                                LinearGradient(
                                                                              begin: Alignment.topRight,
                                                                              end: Alignment.bottomLeft,
                                                                              colors: [
                                                                                AppColor().green_color_light,
                                                                                AppColor().green_color,
                                                                              ],
                                                                            ),
                                                                            border:
                                                                                Border.all(color: AppColor().whiteColor, width: 1),
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                            // color: AppColor().whiteColor
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: 10, right: 0, top: 0),
                                                                                child: CircleAvatar(
                                                                                  radius: 0.0,
                                                                                  child: Icon(
                                                                                    Icons.lock_open,
                                                                                    color: Colors.white,
                                                                                    size: 0.0,
                                                                                  ),
                                                                                  //Image.asset("assets/images/redeem_lock.png"),
                                                                                  backgroundColor: Colors.transparent,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "CODE: ${item.code}".toUpperCase(),
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 10.0,
                                                                                  fontFamily: "Montserrat",
                                                                                  color: AppColor().whiteColor,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              20),
                                                                      child:
                                                                          Container(
                                                                        //height: 30,
                                                                        //color: Colors.white,
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10,
                                                                            vertical:
                                                                                3),
                                                                        */ /*  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(90),
                    ),*/ /*
                                                                        child:
                                                                            Stack(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          children: [
                                                                            Obx(
                                                                              () => LinearPercentIndicator(
                                                                                //width: 140.0,
                                                                                lineHeight: 20.0,
                                                                                percent: item.vipLevel > userController.profileDataRes.value.level.value ? 0 : 1,
                                                                                */ /*  center: Text(
                              "50.0%",
                              style: new TextStyle(fontSize: 12.0),
                            ),
                            trailing: Icon(Icons.mood),*/ /*
                                                                                barRadius: Radius.circular(8),
                                                                                backgroundColor: AppColor().whiteColor,
                                                                                progressColor: AppColor().green_color_light,
                                                                                animationDuration: 2000,
                                                                                animation: true,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 15.0, right: 15),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    //"VIP ${userController.profileDataRes.value.level.value}",
                                                                                    "VIP ${item.vipLevel}",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 10.0,
                                                                                      fontFamily: "Montserrat",
                                                                                      color: AppColor().blackColor,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    //"VIP ${userController.profileDataRes.value.level.value + 1}",
                                                                                    "VIP ${item.vipLevel + 1}",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 10.0,
                                                                                      fontFamily: "Montserrat",
                                                                                      color: AppColor().blackColor,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        vipPopUpClick(
                                                                            context,
                                                                            item);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 8.0),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              30,
                                                                          margin:
                                                                              const EdgeInsets.symmetric(horizontal: 30),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow: const [
                                                                              BoxShadow(
                                                                                offset: const Offset(
                                                                                  0.0,
                                                                                  5.0,
                                                                                ),
                                                                                blurRadius: 3.2,
                                                                                spreadRadius: 0.3,
                                                                                color: Color(0xFFFD5E00),
                                                                                inset: true,
                                                                              ),
                                                                            ],
                                                                            gradient:
                                                                                LinearGradient(
                                                                              begin: Alignment.topRight,
                                                                              end: Alignment.bottomLeft,
                                                                              colors: [
                                                                                AppColor().yellow_vip,
                                                                                AppColor().yellow_vip_button,
                                                                              ],
                                                                            ),
                                                                            border:
                                                                                Border.all(color: AppColor().whiteColor, width: 1),
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                            // color: AppColor().whiteColor
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: 10, right: 5, top: 0),
                                                                                child: CircleAvatar(
                                                                                  radius: 8.0,
                                                                                  child: Image.asset("assets/images/redeem_lock.png"),
                                                                                  backgroundColor: Colors.transparent,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "NEXT VIP CODE",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 10.0,
                                                                                  fontFamily: "Montserrat",
                                                                                  color: AppColor().whiteColor,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ))
                                                      .toList(),
                                              options: CarouselOptions(
                                                enableInfiniteScroll: false,
                                                height: 100.0,
                                                autoPlay: false,
                                                disableCenter: true,
                                                viewportFraction: .8,
                                                aspectRatio: 3,
                                                enlargeCenterPage: false,
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                autoPlayAnimationDuration:
                                                    Duration(
                                                        milliseconds: 1000),
                                                initialPage: userController
                                                            .profileDataRes
                                                            .value
                                                            .level
                                                            .value >
                                                        2
                                                    ? 0
                                                    : userController
                                                        .profileDataRes
                                                        .value
                                                        .level
                                                        .value,
                                                onPageChanged: (index, reason) {
                                                  walletPageController
                                                      .currentIndexSliderVip
                                                      .value = index;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                                */ /* Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(
                                      () => CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 12,
                                        child: Container(
                                          width: 12.0,
                                          height: 12.0,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 2.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: walletPageController
                                                          .currentIndexSliderVip
                                                          .value ==
                                                      0
                                                  ? walletPageController
                                                      .appBtnBgColorVip.value
                                                  : walletPageController
                                                      .appBtnTxtColorVip.value),
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 12,
                                        child: Container(
                                          width: 12.0,
                                          height: 12.0,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 2.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: walletPageController
                                                          .currentIndexSliderVip
                                                          .value ==
                                                      1
                                                  ? walletPageController
                                                      .appBtnBgColorVip.value
                                                  : walletPageController
                                                      .appBtnTxtColorVip.value),
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 12,
                                        child: Container(
                                          width: 12.0,
                                          height: 12.0,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 2.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: walletPageController
                                                          .currentIndexSliderVip
                                                          .value ==
                                                      2
                                                  ? walletPageController
                                                      .appBtnBgColorVip.value
                                                  : walletPageController
                                                      .appBtnTxtColorVip.value),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/ /*
                                //code commented for three dots
                                */ /*Obx(
                                () => walletPageController
                                                .walletModelPromoBanner
                                                .value
                                                .data !=
                                            null &&
                                        walletPageController
                                                .walletModelPromoBanner
                                                .value
                                                .data
                                                .length >
                                            0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: walletPageController
                                            .walletModelPromoBanner.value.data
                                            .map(
                                          (image) {
                                            int index = walletPageController
                                                .walletModelPromoBanner
                                                .value
                                                .data
                                                .indexOf(image);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    walletPageController
                                                                .walletModelPromoBanner
                                                                .value
                                                                .data[index]
                                                                .isVIP ==
                                                            true
                                                        ? AppColor()
                                                            .DartGreenColor
                                                        : AppColor()
                                                            .yellow_vip_button,
                                                radius: 12,
                                                child: Container(
                                                  width: 12.0,
                                                  height: 12.0,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 2.0),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: walletPageController
                                                                  .currentIndexSliderVip
                                                                  .value ==
                                                              index
                                                          ? walletPageController
                                                              .appBtnBgColorVip
                                                              .value
                                                          : null),
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(), // this was the part the I had to add
                                      )
                                    : Text(""),
                              ),*/ /*
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),*/
        ],
      );
    } catch (e) {}
  }

  //not used
  void showKycDialogPennyDropCheckStatus(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                    color: AppColor().reward_card_bg,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("     "),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "UPDATE KYC",
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
                                walletPageController.getProfileData();

                                // walletPageController.getProfileData();

                                /* walletPageController.result.value =
                                    "Slide to complete KYC";*/
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "You are just a step away from the KYC completion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Registered Number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${userController.profileDataRes.value != null ? userController.profileDataRes.value.mobile.getFullNumber() : ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    userController.profileDataRes.value != null &&
                            userController
                                    .profileDataRes.value.withdrawMethod[0] !=
                                null
                        ? Text(
                            "Your KYC name does not match your bank name ${userController.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank != null && userController.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank.isNotEmpty ? "[ ${userController.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank}]" : ""} Please re-upload your kyc.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          )
                        : Text(""),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Please select one of the document for KYC",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        walletPageController.type_kyc_document.value =
                            ApiUrl.DOCUMENT_TYPE_PANCARD;
                        showBottomSheetAddCamera(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: 50, right: 50, bottom: 10, top: 00),
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
                        child: Text("UPLOAD PAN CARD",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void showKycDialog(BuildContext context) {
    //kyc down work
    if (userController.appSettingReponse.value.featuresStatus != null &&
        userController.appSettingReponse.value.featuresStatus.length > 0) {
      for (FeaturesStatus obj
          in userController.appSettingReponse.value.featuresStatus) {
        if (obj.id == 'kycUpdate' && obj.status == 'inactive') {
          //Fluttertoast.showToast(msg: 'INACTIVE');
          Utils().showKycDown(context);
          return;
        }
      }
    }

    //end
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                    color: AppColor().reward_card_bg,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("     "),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "UPDATE KYC".tr,
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
                                walletPageController.getProfileData();
                                /* walletPageController.result.value =
                                    "Slide to complete KYC";*/
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "You are just a step away from the KYC completion".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Registered Number".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${userController.profileDataRes.value != null ? userController.profileDataRes.value.mobile.getFullNumber() : ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Please select one of the document for KYC".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        walletPageController.type_kyc_document.value =
                            ApiUrl.DOCUMENT_TYPE_PANCARD;
                        showBottomSheetAddCamera(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: 50, right: 50, bottom: 0, top: 00),
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
                        child: Text("UPLOAD PAN CARD".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /*  Wrap(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //event calls
                                      Map<String, Object> map =
                                          new Map<String, Object>();
                                      map["USER_NAME"] = userController
                                          .profileDataRes.value.username;
                                      map["USER_ID"] = userController
                                          .profileDataRes.value.id;

                                      cleverTapController.logEventCT(
                                          EventConstant
                                              .EVENT_CLEAVERTAB_KYC_Initiated,
                                          map);
                                      //map["Method"] = walletPageController.type_kyc_document.value;
                                      //aadhar api call
                                      walletPageController
                                              .type_kyc_document.value =
                                          ApiUrl.DOCUMENT_TYPE_AADHAR_CARD;
                                      walletPageController
                                          .checkInvoidAadharcard(context);
                                      // showBottomSheetAddCamera(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          left: 50,
                                          right: 50,
                                          bottom: 10,
                                          top: 10),
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
                                        borderRadius: BorderRadius.circular(30),
                                        // color: AppColor().whiteColor
                                      ),
                                      child: Text("UPLOAD AADHAAR CARD",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Montserrat",
                                          )),
                                    ),
                                  ),

                                  */ /*  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      walletPageController
                                              .type_kyc_document.value =
                                          ApiUrl.DOCUMENT_TYPE_PASSPORT;
                                      showBottomSheetAddCamera(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      margin: EdgeInsets.only(
                                          left: 50,
                                          right: 50,
                                          bottom: 0,
                                          top: 10),
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
                                        borderRadius: BorderRadius.circular(30),
                                        // color: AppColor().whiteColor
                                      ),
                                      child: Text("UPLOAD PASSPORT",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Montserrat",)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      walletPageController.type_kyc_document
                                          .value = ApiUrl.DOCUMENT_TYPE_DL;
                                      showBottomSheetAddCamera(context);
                                      // walletPageController.getFromGallery();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 15,
                                      ),
                                      margin: EdgeInsets.only(
                                          left: 50,
                                          right: 50,
                                          bottom: 10,
                                          top: 10),
                                      width: MediaQuery.of(context).size.width,
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
                                        borderRadius: BorderRadius.circular(30),
                                        // color: AppColor().whiteColor
                                      ),
                                      child: Text(
                                        "UPLOAD  DRIVER'S  LICENSE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Montserrat",),
                                      ),
                                    ),
                                  )*/ /*
                                ],
                              )*/
                  ],
                ),
              ),
            ],
          );
        });
  }

  void showBottomSheetAddCamera(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Map<String, Object> map = new Map<String, Object>();
                          map["USER_NAME"] =
                              userController.profileDataRes.value.username;
                          map["USER_ID"] =
                              userController.profileDataRes.value.id;

                          cleverTapController.logEventCT(
                              EventConstant.EVENT_CLEAVERTAB_KYC_Initiated,
                              map);

                          FirebaseEvent().firebaseEvent(
                              EventConstant.EVENT_CLEAVERTAB_KYC_Initiated_F,
                              map);

                          //map["Method"] = walletPageController.type_kyc_document.value;

                          walletPageController.getFromCamera(context);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              child: Image.asset(ImageRes().ic_camera),
                            ),
                            Text(
                              "Camera".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            )
                          ],
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Map<String, Object> map = new Map<String, Object>();
                          map["USER_NAME"] =
                              userController.profileDataRes.value.username;
                          map["USER_ID"] =
                              userController.profileDataRes.value.id;

                          cleverTapController.logEventCT(
                              EventConstant.EVENT_CLEAVERTAB_KYC_Initiated,
                              map);
                          //map["Method"] =walletPageController.type_kyc_document.value;
                          walletPageController.getFromGallery(context);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              child: Image.asset(ImageRes().ic_camera),
                            ),
                            Text(
                              "Gallery".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget showBottomSheetAddAmount(BuildContext context) {
    userController.wallet_s.value = false;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          //Wrap commented for smaller view
          return Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, top: 0),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("     "),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Add Money".tr,
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
                    Visibility(
                      visible: false,
                      child: GestureDetector(
                        onTap: () async {
                          await walletPageController.getAdvertisersDeals();
                          walletPageController.getUserDeals();
                          AppString.isClickFromHome = false;
                          Get.to(() => OfferWallScreen());
                          //Fluttertoast.showToast(msg: 'Banner clicked!');
                        },
                        child: Container(
                          height: 130,
                          margin: EdgeInsets.only(top: 0, right: 10, left: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image(
                              height: 120,
                              fit: BoxFit.cover,
                              image: /* NetworkImage("url"):*/
                                  AssetImage(
                                      "assets/images/add_money_banner.png" /*ImageRes().store_banner_wallet*/),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent),
                      child: Obx(
                        () => TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                          ],
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          controller:
                              walletPageController.amountTextController.value,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle:
                                  TextStyle(color: AppColor().whiteColor),
                              hintText: "Enter Amount"),
                          onChanged: (text) {
                            if (text.length == 0) {
                              walletPageController.gameAmtSelectedColor.value =
                                  0;
                              walletPageController.amtAfterPromoApplied.value =
                                  0;
                              index_promo = null;
                              walletPageController.gameListSelectedColor.value =
                                  1000;
                              walletPageController.youWillGet.value = '';
                              walletPageController.click = false;
                            }
                            walletPageController.selectAmount.value = text;
                            walletPageController.gameAmtSelectedColor.value =
                                int.parse(text);
                            //walletPageController.amountTextController.value.text = text;

                            //when promo code clicked
                            promo_code(text);
                          },
                          //autofocus: true,
                        ),
                      ),
                    ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(children: [
                                  Text(
                                    //"You'll get: ${walletPageController.amtAfterPromoApplied.value}",
                                    "You'll get: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        //decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    //"You'll get: ${walletPageController.amtAfterPromoApplied.value}",
                                    "${walletPageController.youWillGet.value}",
                                    style: TextStyle(
                                        color: AppColor().colorPrimary,
                                        fontSize: 15,
                                        //decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (click) {
                                    click = false;
                                    walletPageController.boolEnterCode.value =
                                        true;
                                  } else {
                                    click = true;
                                    walletPageController.boolEnterCode.value =
                                        false;
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, bottom: 5, top: 10),
                                  child: Text(
                                    "Apply Code?",
                                    style: TextStyle(
                                      color: AppColor().colorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration
                                          .underline, /*fontWeight: FontWeight.w600*/
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  walletPageController
                                      .amountTextController.value.text = "50";
                                  walletPageController
                                      .gameAmtSelectedColor.value = 50;
                                  //when promo code clicked
                                  promo_code("50");
                                },
                                child: Container(
                                  height: 40,
                                  decoration: walletPageController
                                              .gameAmtSelectedColor.value ==
                                          50
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 1))
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 1)),
                                  child: Center(
                                      child: Text(
                                    "Rs 50",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )),
                                ),
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  walletPageController
                                      .amountTextController.value.text = "100";
                                  walletPageController
                                      .gameAmtSelectedColor.value = 100;
                                  //when promo code clicked
                                  promo_code("100");
                                },
                                child: Container(
                                  height: 40,
                                  decoration: walletPageController
                                              .gameAmtSelectedColor.value ==
                                          100
                                      ? /* BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 2))*/
                                      BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 1))
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 1)),
                                  child: Center(
                                      child: Text(
                                    "Rs 100",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )),
                                ),
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  walletPageController
                                      .amountTextController.value.text = "250";
                                  walletPageController
                                      .gameAmtSelectedColor.value = 250;
                                  //when promo code clicked
                                  promo_code("250");
                                },
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: walletPageController
                                              .gameAmtSelectedColor.value ==
                                          250
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 1))
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 1)),
                                  child: Center(
                                    child: Text("Rs 250",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                ),
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  walletPageController
                                      .amountTextController.value.text = "500";
                                  walletPageController
                                      .gameAmtSelectedColor.value = 500;
                                  //when promo code clicked
                                  promo_code("500");
                                },
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: walletPageController
                                              .gameAmtSelectedColor.value ==
                                          500
                                      ? /*BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 2))*/
                                      BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor().colorPrimary,
                                              width: 1))
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 1)),
                                  child: Center(
                                    child: Text("Rs 500",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                ),
                              )),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    //PROMO CODE WORK STARTED
                    //new code for deposit
                    Obx(
                      () => Visibility(
                        visible: walletPageController.boolEnterCode.value,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent),
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.characters,

                                  //keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.white),
                                  controller: walletPageController
                                      .havCodeController.value,
                                  //controller: walletPageController.amountTextController.value,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      hintStyle: TextStyle(
                                          color: AppColor().whiteColor),
                                      hintText: "Enter Code"),
                                  onChanged: (text) {
                                    walletPageController.promocode.value = text;
                                  },
                                  //autofocus: true,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  //new code

                                  walletPageController
                                      .gameAmtSelectedColor.value = 0;
                                  walletPageController
                                      .amtAfterPromoApplied.value = 0;
                                  index_promo = null;
                                  walletPageController
                                      .gameListSelectedColor.value = 1000;
                                  walletPageController.youWillGet.value = '';
                                  walletPageController.click = false;

                                  if (walletPageController
                                          .buttonApplyText.value ==
                                      'Remove') {
                                    //click = false;
                                    walletPageController
                                        .amtAfterPromoApplied.value = 0;
                                    walletPageController
                                        .gameListSelectedColor.value = 1000;
                                    walletPageController.youWillGet.value = '';
                                    walletPageController.walletTypePromocode =
                                        '';
                                    walletPageController.percentagePromocode =
                                        '';
                                    walletPageController.buttonApplyText.value =
                                        'Apply';
                                    Fluttertoast.showToast(
                                        msg: "Offer Removed!");
                                    walletPageController.promocode.value = '';
                                    walletPageController
                                        .havCodeController.value.text = '';
                                    //setState(() {});
                                    return;
                                  }

                                  if (walletPageController.amountTextController
                                              .value.text ==
                                          "" ||
                                      walletPageController.amountTextController
                                              .value.text ==
                                          "0") {
                                    Fluttertoast.showToast(
                                        msg: "Please enter amount!");
                                    return;
                                  }
                                  if (walletPageController.amountTextController
                                          .value.text.length >
                                      7) {
                                    Fluttertoast.showToast(
                                        msg: "Deposit limit exceeded!");
                                    return;
                                  }

                                  if (walletPageController.promocode.value ==
                                      '') {
                                    Fluttertoast.showToast(
                                        msg: "Please enter code!");
                                  } else {
                                    //code checking for offline codes
                                    bool temp = false;
                                    for (int i = 0;
                                        i <
                                            walletPageController
                                                .walletModelPromoFull
                                                .data
                                                .length;
                                        i++) {
                                      Utils().customPrint(
                                          "PROMOCODE Loop code ${walletPageController.walletModelPromoFull.data[i].code}");

                                      if (walletPageController.promocode.value
                                              .toLowerCase() ==
                                          walletPageController
                                              .walletModelPromoFull.data[i].code
                                              .toLowerCase()) {
                                        //validation
                                        double enterAmtInt = double.parse(
                                            walletPageController
                                                .amountTextController
                                                .value
                                                .text);
                                        double fromValue = double.parse(
                                            walletPageController
                                                .walletModelPromoFull
                                                .data[i]
                                                .fromValue);
                                        double toValue = double.parse(
                                            walletPageController
                                                .walletModelPromoFull
                                                .data[i]
                                                .toValue);
                                        Utils().customPrint(
                                            'Offer Valid F ${fromValue}');
                                        Utils().customPrint(
                                            'Offer Valid T ${toValue}');

                                        if (enterAmtInt < fromValue) {
                                          Fluttertoast.showToast(
                                              textColor: Colors.red,
                                              msg:
                                                  'Offer Valid On Deposit for ${walletPageController.walletModelPromoFull.data[i].fromValue} - ${walletPageController.walletModelPromoFull.data[i].toValue} Rs!');
                                          return;
                                        } else if (enterAmtInt > toValue) {
                                          Fluttertoast.showToast(
                                              textColor: Colors.red,
                                              msg:
                                                  'Offer Valid On Deposit for ${walletPageController.walletModelPromoFull.data[i].fromValue} - ${walletPageController.walletModelPromoFull.data[i].toValue} Rs!');
                                          return;
                                        }

                                        //promo code
                                        promo_code_not_visible(
                                            walletPageController
                                                .amountTextController
                                                .value
                                                .text,
                                            i);
                                        Utils().customPrint(
                                            "PROMOCODE Applied: ${walletPageController.promocode.value}");

                                        temp = true;
                                        break;
                                      } else {
                                        Utils().customPrint(
                                            "PROMOCODE Invalid: ${walletPageController.promocode.value}");
                                        temp = false;
                                      }
                                    }
                                    //check
                                    if (temp == true) {
                                      Fluttertoast.showToast(
                                          msg: "Offer Applied!");
                                      //Navigator.pop(context);
                                    } else if (temp == false) {
                                      Fluttertoast.showToast(
                                          msg: "Offer Invalid!");
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10,
                                        top: 5,
                                        bottom: 5),
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
                                      borderRadius: BorderRadius.circular(10),
                                      // color: AppColor().whiteColor
                                    ),
                                    child: Center(
                                      child: Text(
                                          walletPageController
                                              .buttonApplyText.value
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (click) {
                                click = false;
                                walletPageController.boolEnterCode.value = true;
                              } else {
                                click = true;
                                walletPageController.boolEnterCode.value =
                                    false;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, bottom: 5, top: 10),
                              child: Text(
                                "Have Code?",
                                style: TextStyle(
                                  color: AppColor().colorPrimary,
                                  fontSize: 15,
                                  decoration: TextDecoration
                                      .underline, /*fontWeight: FontWeight.w600*/
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ViewAllPromoCodes());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10.0, bottom: 5),
                              child: Container(
                                child: Text("View All",
                                    style: TextStyle(
                                      color: AppColor().colorPrimary,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      /*fontWeight: FontWeight.w600,*/
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //listview //promocodes
                    Visibility(
                      visible:
                          walletPageController.walletModelPromo.data != null &&
                                  walletPageController
                                          .walletModelPromo.data.length >
                                      0
                              ? true
                              : false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Container(
                          height: 160,
                          child: ListView.builder(
                              itemCount:
                                  walletPageController.walletModelPromo.data !=
                                          null
                                      ? walletPageController
                                          .walletModelPromo.data.length
                                      : 0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, int index) {
                                return Obx(() => promo_code_design_list(index));
                              }),
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          walletPageController.walletModelPromo.data != null &&
                                  walletPageController
                                          .walletModelPromo.data.length >
                                      0
                              ? true
                              : true,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ViewAllPromoCodes());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, bottom: 20, top: 5),
                          child: Text(
                            "View More Offers",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ), //later we'll make dynamic
                    GestureDetector(
                        onTap: () async {
                          if (userController
                                      .appSettingReponse.value.featuresStatus !=
                                  null &&
                              userController.appSettingReponse.value
                                      .featuresStatus.length >
                                  0) {
                            for (FeaturesStatus obj in userController
                                .appSettingReponse.value.featuresStatus) {
                              if (obj.id == 'addMoney' &&
                                  obj.status == 'inactive') {
                                //Fluttertoast.showToast(msg: 'INACTIVE');
                                Utils().showWalletDown(context);
                                return;
                              }
                            }
                          }

                          if (walletPageController
                                      .amountTextController.value.text ==
                                  "" ||
                              walletPageController
                                      .amountTextController.value.text ==
                                  "0") {
                            Fluttertoast.showToast(msg: "Please enter amount!");
                            return;
                          }
                          if (walletPageController
                                  .amountTextController.value.text.length >
                              7) {
                            Fluttertoast.showToast(
                                msg: "Deposit limit exceeded!");
                            return;
                          }
                          //Fluttertoast.showToast(msg: "call values${Utils.stateV.value}");

                          if (ApiUrl().isPlayStore == false) {
                            bool stateR =
                                await Utils().checkResLocation(context);
                            if (stateR) {
                              return;
                            }
                          }
                          Navigator.pop(context);

                          //Events work //cleverTap
                          Map<String, Object> map_clevertap =
                              new Map<String, Object>();
                          Map<String, Object> map_clevertap_f =
                              new Map<String, Object>();
                          if (walletPageController.promocode.value != null &&
                              walletPageController.promocode.value != '') {
                            map_clevertap["Code Name"] =
                                walletPageController.promocode.value;
                            map_clevertap["Code target wallet"] =
                                walletPageController.walletTypePromocode;
                            map_clevertap["Code percentage"] =
                                walletPageController.percentagePromocode;

                            map_clevertap_f["Code_Name"] =
                                walletPageController.promocode.value;
                            map_clevertap_f["Code_target_wallet"] =
                                walletPageController.walletTypePromocode;
                            map_clevertap_f["Code_percentage"] =
                                walletPageController.percentagePromocode;
                          }
                          map_clevertap["Amount"] = walletPageController
                              .amountTextController
                              .value
                              .text; //new event added

                          map_clevertap_f["Amount"] = walletPageController
                              .amountTextController.value.text;

                          cleverTapController.logEventCT(
                              EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                              map_clevertap);
                          FirebaseEvent().firebaseEvent(
                              EventConstant.EVENT_FIREBASE_Deposit_Initiated_f,
                              map_clevertap_f);

                          //appsflyer
                          Map<String, Object> map_appsflyer =
                              new Map<String, Object>();
                          map_appsflyer["USER_NAME"] =
                              userController.profileDataRes.value.username;
                          map_appsflyer["USER_ID"] =
                              userController.profileDataRes.value.id;
                          map_appsflyer["EVENT"] =
                              EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;
                          AppsflyerController appsflyerController =
                              Get.put(AppsflyerController());
                          appsflyerController.logEventAf(
                              EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                              map_appsflyer);

                          //facebook
                          Map<String, Object> map_fb =
                              new Map<String, Object>();
                          map_fb["USER_NAME"] =
                              userController.profileDataRes.value.username;
                          map_fb["USER_ID"] =
                              userController.profileDataRes.value.id;
                          map_fb["EVENT"] =
                              EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;

                          //facebook event work //ravi
                          map_fb["EVENT_PARAM_CURRENCY"] = "INR";
                          map_fb["EVENT_PARAM_CONTENT_TYPE"] = "product";
                          map_fb["EVENT_PARAM_CONTENT"] =
                              "[{\"id\": \"12345\", \"quantity\": 1}]";
                          map_fb["EVENT_NAME_PURCHASE"] = walletPageController
                              .amountTextController
                              .value
                              .text; //<< this line is imp
                          //end

                          FaceBookEventController().logEventFacebook(
                              EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                              map_fb);

                          final params = {
                            "event_name":
                                "${EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM}",
                            "event_time":
                                "${DateTime.now().millisecondsSinceEpoch}",
                            "event_id": "",
                            "action_source": "App",
                            "user_data": {
                              "client_ip_address":
                                  "${userController.profileDataRes.value.username}",
                              "client_user_agent": "",
                              "external_id": [
                                userController.profileDataRes.value.id
                              ],
                            },
                            "custom_data": {}
                          };
                          FacebookEventApi().FacebookEventC(params);

                          //API CALL FOR PAYMENT GATEWAY
                          walletPageController.createOrderRazorepay(
                              context,
                              walletPageController
                                  .amountTextController.value.text);
                          Utils().customPrint(
                              'depositWalletId : ${AppString.depositWalletId}');
                        },
                        /*          onTap: () async {
                          if (walletPageController
                                      .amountTextController.value.text ==
                                  "" ||
                              walletPageController
                                      .amountTextController.value.text ==
                                  "0") {
                            Fluttertoast.showToast(msg: "Please enter amount!");
                            return;
                          }
                          if (walletPageController
                                  .amountTextController.value.text.length >
                              7) {
                            Fluttertoast.showToast(
                                msg: "Deposit limit exceeded!");
                            return;
                          }
                          //Fluttertoast.showToast(msg: "call values${Utils.stateV.value}");

                          if (ApiUrl().isPlayStore == false) {
                            bool stateR =
                                await Utils().checkResLocation(context);
                            if (stateR) {
                              return;
                            }
                          }
                          Navigator.pop(context);

                          //Events work //cleverTap
                          Map<String, Object> map_clevertap =
                              new Map<String, Object>();

                          if (walletPageController.promocode.value != null &&
                              walletPageController.promocode.value != '') {
                            map_clevertap["Code Name"] =
                                walletPageController.promocode.value;
                            map_clevertap["Code target wallet"] =
                                walletPageController.walletTypePromocode;
                            map_clevertap["Code percentage"] =
                                walletPageController.percentagePromocode;
                          }
                          map_clevertap["Amount"] = walletPageController
                              .amountTextController
                              .value
                              .text; //new event added

                          cleverTapController.logEventCT(
                              EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                              map_clevertap);

                          //appsflyer
                          Map<String, Object> map_appsflyer =
                              new Map<String, Object>();
                          map_appsflyer["USER_NAME"] =
                              userController.profileDataRes.value.username;
                          map_appsflyer["USER_ID"] =
                              userController.profileDataRes.value.id;
                          map_appsflyer["EVENT"] =
                              EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;
                          AppsflyerController appsflyerController =
                              Get.put(AppsflyerController());
                          appsflyerController.logEventAf(
                              EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                              map_appsflyer);

                          //facebook
                          Map<String, Object> map_fb =
                              new Map<String, Object>();
                          map_fb["USER_NAME"] =
                              userController.profileDataRes.value.username;
                          map_fb["USER_ID"] =
                              userController.profileDataRes.value.id;
                          map_fb["EVENT"] =
                              EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;

                          //facebook event work //ravi
                          map_fb["EVENT_PARAM_CURRENCY"] = "INR";
                          map_fb["EVENT_PARAM_CONTENT_TYPE"] = "product";
                          map_fb["EVENT_PARAM_CONTENT"] =
                              "[{\"id\": \"12345\", \"quantity\": 1}]";
                          map_fb["EVENT_NAME_PURCHASE"] = walletPageController
                              .amountTextController
                              .value
                              .text; //<< this line is imp
                          //end

                          FaceBookEventController().logEventFacebook(
                              EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                              map_fb);

                          final params = {
                            "event_name":
                                "${EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM}",
                            "event_time":
                                "${DateTime.now().millisecondsSinceEpoch}",
                            "event_id": "",
                            "action_source": "App",
                            "user_data": {
                              "client_ip_address":
                                  "${userController.profileDataRes.value.username}",
                              "client_user_agent": "",
                              "external_id": [
                                userController.profileDataRes.value.id
                              ],
                            },
                            "custom_data": {}
                          };
                          FacebookEventApi().FacebookEventC(params);

                          //API CALL FOR PAYMENT GATEWAY
                          walletPageController.createOrderRazorepay(context);
                          Utils().customPrint(
                              'depositWalletId : ${AppString.depositWalletId}');
                        },*/
                        child: Container(
                          width: MediaQuery.of(context).size.width - 200,
                          height: 45,
                          /*  margin:
                              EdgeInsets.symmetric(horizontal: 85, vertical: 5),
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
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

                            border: Border.all(
                                color: AppColor().whiteColor, width: 2),
                            borderRadius: BorderRadius.circular(30),
                            // color: AppColor().whiteColor
                          ),
                          child: Center(
                            child: Text(
                              "ADD",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  color: AppColor().whiteColor),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showBottomSheetInfo(BuildContext context) {
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
                            "There are 4 type of cash in GMNG".tr,
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
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          child: Image.asset("assets/images/winning_coin.webp"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Winning Cash".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                            Text(
                              "Cash that you won and can withdraw at any time"
                                  .tr,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  fontSize: 10),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      height: .5,
                      color: AppColor().colorGray,
                    ),
                    Row(
                      children: [
                        Container(
                            height: 35,
                            child: Image.asset("assets/images/deposited.webp")),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deposited Cash".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "Cash that you add to your GMNG wallet".tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 10),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      height: .5,
                      color: AppColor().colorGray,
                    ),

                    /* Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      height: .5,
                      color: AppColor().colorGray,
                    ),*/

                    Row(
                      children: [
                        Container(
                          height: 35,
                          child: Image.asset(ImageRes().ic_coin),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bonus Cash".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "Cash that you get from GMNG as a reward to play contests"
                                      .tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 10),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      height: .5,
                      color: AppColor().colorGray,
                    ),
                    //vip
                    Row(
                      children: [
                        Container(
                          height: 35,
                          child: Image.asset("assets/images/instant_coin.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Instant Cash".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "Money that you earn just by playing games"
                                      .tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 10),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        /* walletPageController.openCheckout(
                          userController.profileDataRes.value.username,
                          (userController.profileDataRes.value.email != null &&
                                  userController
                                          .profileDataRes.value.email.address !=
                                      null)
                              ? userController
                                  .profileDataRes.value.email.address
                              : "",
                          userController.profileDataRes.value.mobile.number
                              .toString(),
                        );*/
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
                          "OKAY".tr,
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

  _loadWidget(BuildContext context) async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    showBottomSheetAddAmount(context);
  }

  String getStartTimeHHMMSS(String date_c) {
    return DateFormat("yyyy-MM-dd' 'HH:mm:ss").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date_c, true).toLocal());
  }

  //ListView Promo-codes design
  Widget promo_code_design_list(int index) {
    return GestureDetector(
      onTap: () {
        walletPageController.havCodeController.value.text = '';
        walletPageController.buttonApplyText.value = 'Apply';
        if (walletPageController.amountTextController.value.text == "" ||
            walletPageController.amountTextController.value.text == "0") {
          Fluttertoast.showToast(msg: "Please enter amount!");
          return;
        }
        if (walletPageController.amountTextController.value.text.length > 7) {
          Fluttertoast.showToast(msg: "Deposit limit exceeded!");
          return;
        }
        //validation
        double enterAmtInt =
            double.parse(walletPageController.amountTextController.value.text);
        double fromValue = double.parse(
            walletPageController.walletModelPromo.data[index].fromValue);
        double toValue = double.parse(
            walletPageController.walletModelPromo.data[index].toValue);
        Utils().customPrint('Offer Valid F ${fromValue}');
        Utils().customPrint('Offer Valid T ${toValue}');

        if (enterAmtInt < fromValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${walletPageController.walletModelPromo.data[index].fromValue} - ${walletPageController.walletModelPromo.data[index].toValue} Rs!');

          walletPageController.youWillGet.value =
              '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
          walletPageController.amtAfterPromoApplied.value = 0;
          index_promo = null;
          walletPageController.gameListSelectedColor.value = 1000;
          walletPageController.click = false;
          walletPageController.promocode.value = '';
          walletPageController.walletTypePromocode = '';
          walletPageController.percentagePromocode = '';

          return;
        } else if (enterAmtInt > toValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${walletPageController.walletModelPromo.data[index].fromValue} - ${walletPageController.walletModelPromo.data[index].toValue} Rs!');

          walletPageController.youWillGet.value =
              '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
          walletPageController.amtAfterPromoApplied.value = 0;
          index_promo = null;
          walletPageController.gameListSelectedColor.value = 1000;
          walletPageController.click = false;
          walletPageController.promocode.value = '';
          walletPageController.walletTypePromocode = '';
          walletPageController.percentagePromocode = '';

          return;
        }

        //click again
        if (click_index != index) {
          click_index = index;
          walletPageController.click = false;
          walletPageController.amtAfterPromoApplied.value = 0;
          index_promo = null;
          walletPageController.gameListSelectedColor.value = 1000;
          walletPageController.youWillGet.value = '';
          if (!walletPageController.click) {
            walletPageController.click = true;
            click_index = index;
            walletPageController.promocode.value =
                walletPageController.walletModelPromo.data[index].code;
            walletPageController.gameListSelectedColor.value = index;
            Utils().customPrint(
                "PROMOCODE: ${walletPageController.promocode.value}");
            index_promo = index;
            //when promo code clicked
            promo_code(walletPageController.amountTextController.value.text);
          } else {
            click_index = index;
            walletPageController.click = false;
            walletPageController.amtAfterPromoApplied.value = 0;
            index_promo = null;
            walletPageController.gameListSelectedColor.value = 1000;
            walletPageController.youWillGet.value = '';
            walletPageController.promocode.value = '';
            walletPageController.walletTypePromocode = '';
            walletPageController.percentagePromocode = '';
          }
        } else {
          if (!walletPageController.click) {
            walletPageController.click = true;
            click_index = index;
            walletPageController.promocode.value =
                walletPageController.walletModelPromo.data[index].code;
            walletPageController.gameListSelectedColor.value = index;
            Utils().customPrint(
                "PROMOCODE1: ${walletPageController.promocode.value}");
            index_promo = index;
            //when promo code clicked
            promo_code(walletPageController.amountTextController.value.text);
          } else {
            click_index = index;
            walletPageController.click = false;
            walletPageController.amtAfterPromoApplied.value = 0;
            index_promo = null;
            walletPageController.gameListSelectedColor.value = 1000;
            walletPageController.youWillGet.value = '';
            walletPageController.promocode.value = '';
            walletPageController.walletTypePromocode = '';
            walletPageController.percentagePromocode = '';
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 15, top: 5, left: 0),
        child: Container(
          margin: EdgeInsets.only(right: 15),
          height: 160,
          width: 120,
          decoration: walletPageController.gameListSelectedColor.value == index
              ? BoxDecoration(
                  border:
                      Border.all(color: AppColor().colorPrimary, width: 1.5),
                  // color: AppColor().whiteColor,
                  borderRadius: BorderRadius.circular(10),
                )
              : BoxDecoration(
                  border: Border.all(color: AppColor().whiteColor, width: 1.5),
                  // color: AppColor().whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
          // : BoxDecoration(
          //     border: Border.all(color: AppColor().whiteColor, width: 2),
          //     borderRadius: BorderRadius.circular(10),
          //     color: AppColor().whiteColor),
          child: walletPageController.gameListSelectedColor.value == index
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ViewAllPromoCodes());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Image.asset(
                                  "assets/images/info.webp",
                                  width: 10,
                                  height: 10,
                                  color: Colors.white,
                                ),
                              ),
                              /*Container(
                            padding: EdgeInsets.all(5),
                            child: Image.asset("assets/images/info.webp",
                                width: 15, height: 15),
                          ),*/
                            ],
                          ),
                        ),
                        Container(
                          width: 110,
                          padding: EdgeInsets.all(5),
                          /*decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white, width: .5)) ,*/
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("",
                                  style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(
                                  walletPageController
                                      .walletModelPromo.data[index].code
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(
                              walletPageController
                                  .walletModelPromo.data[index].name.capitalize,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        height: 35,
                        width: 100,
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor().whiteColor, width: 2),
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor().whiteColor),
                        child: Center(
                          child: Text("Remove",
                              style: TextStyle(
                                color: AppColor().colorPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Image.asset(
                                "assets/images/info.webp",
                                width: 10,
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 110,
                          padding: EdgeInsets.all(5),
                          /*decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black, width: .5)),*/
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  walletPageController.walletModelPromo
                                                  .data[index].benefit[0] !=
                                              null &&
                                          walletPageController
                                                  .walletModelPromo
                                                  .data[index]
                                                  .benefit[0]
                                                  .wallet[0] !=
                                              null &&
                                          walletPageController
                                                  .walletModelPromo
                                                  .data[index]
                                                  .benefit[0]
                                                  .wallet[0]
                                                  .percentage !=
                                              null &&
                                          walletPageController
                                                  .walletModelPromo
                                                  .data[index]
                                                  .benefit[0]
                                                  .wallet[0]
                                                  .percentage !=
                                              ''
                                      ? "" //"(%) "
                                      : AppString().txt_currency_symbole,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(
                                  walletPageController
                                      .walletModelPromo.data[index].code
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(
                              walletPageController
                                  .walletModelPromo.data[index].name.capitalize,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        height: 35,
                        width: 100,
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor().whiteColor, width: 1.5),
                          // color: AppColor().whiteColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text("Apply",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void promo_code(var entered_amount) {
    if (index_promo != null) {
      try {
        if (walletPageController.walletModelPromo.data[index_promo].benefit[0]
                    .wallet[0].percentage !=
                '' &&
            walletPageController.walletModelPromo.data[index_promo].benefit[0]
                    .wallet[0].maximumAmount !=
                '') {
          double maxAmtFixed = double.parse(walletPageController
              .walletModelPromo
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .maximumAmount);

          double percentage = double.parse(walletPageController.walletModelPromo
              .data[index_promo].benefit[0].wallet[0].percentage);

          double enterAmtInt = double.parse(entered_amount);
          //validation
          double fromValue = double.parse(walletPageController
              .walletModelPromo.data[index_promo].fromValue);
          double toValue = double.parse(
              walletPageController.walletModelPromo.data[index_promo].toValue);
          Utils().customPrint('Offer Valid F ${fromValue}');
          Utils().customPrint('Offer Valid T ${toValue}');

          if (enterAmtInt < fromValue) {
            Fluttertoast.showToast(
                textColor: Colors.red,
                msg:
                    'Offer Valid On Deposit for ${walletPageController.walletModelPromo.data[index_promo].fromValue} - ${walletPageController.walletModelPromo.data[index_promo].toValue} Rs!');

            walletPageController.youWillGet.value = '$entered_amount Deposit';
            walletPageController.amtAfterPromoApplied.value = 0;
            index_promo = null;
            walletPageController.gameListSelectedColor.value = 1000;
            walletPageController.click = false;
            walletPageController.promocode.value = '';
            walletPageController.promocode.value = '';
            walletPageController.walletTypePromocode = '';
            walletPageController.percentagePromocode = '';

            return;
          } else if (enterAmtInt > toValue) {
            Fluttertoast.showToast(
                textColor: Colors.red,
                msg:
                    'Offer Valid On Deposit for ${walletPageController.walletModelPromo.data[index_promo].fromValue} - ${walletPageController.walletModelPromo.data[index_promo].toValue} Rs!');

            walletPageController.youWillGet.value = '$entered_amount Deposit';
            walletPageController.amtAfterPromoApplied.value = 0;
            index_promo = null;
            walletPageController.gameListSelectedColor.value = 1000;
            walletPageController.click = false;
            walletPageController.promocode.value = '';
            walletPageController.promocode.value = '';
            walletPageController.walletTypePromocode = '';
            walletPageController.percentagePromocode = '';

            return;
          }

          double calcValuePerc = ((percentage / 100) * enterAmtInt);

          //conditions
          if (walletPageController.walletModelPromo.data[index_promo].benefit[0]
                  .wallet[0].type ==
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
          } else if (walletPageController.walletModelPromo.data[index_promo]
                  .benefit[0].wallet[0].type ==
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
          walletPageController.walletTypePromocode = walletPageController
              .walletModelPromo.data[index_promo].benefit[0].wallet[0].type;

          Utils().customPrint(
              'applied promo code: ${walletPageController.amtAfterPromoApplied.value}');

          //popup animation work need to implement here
          // Fluttertoast.showToast(msg: 'Pop-up Launching...');
          showCustomDialog(context);
          //_scaleDialog();
        }
      } catch (e) {
        Utils().customPrint('applied amount: $e');
      }
    } else {
      //for dynamic showing value in 'You'll get' place.
      walletPageController.amtAfterPromoApplied.value =
          double.parse(entered_amount);
      walletPageController.youWillGet.value = '${entered_amount} Deposit';
    }
  }

  void promo_code_not_visible(var entered_amount, int index_promo) {
    if (index_promo != null) {
      try {
        if (walletPageController.walletModelPromoFull.data[index_promo]
                    .benefit[0].wallet[0].percentage !=
                '' &&
            walletPageController.walletModelPromoFull.data[index_promo]
                    .benefit[0].wallet[0].maximumAmount !=
                '') {
          double maxAmtFixed = double.parse(walletPageController
              .walletModelPromoFull
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .maximumAmount);

          double percentage = double.parse(walletPageController
              .walletModelPromoFull
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .percentage);
          Utils().customPrint('Offer enterAmtInt F ');
          Utils().customPrint('Offer calcValuePerc T ');
          double enterAmtInt = double.parse(entered_amount);
          double calcValuePerc = ((percentage / 100) * enterAmtInt);

          //conditions
          if (walletPageController.walletModelPromoFull.data[index_promo]
                  .benefit[0].wallet[0].type ==
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
          } else if (walletPageController.walletModelPromoFull.data[index_promo]
                  .benefit[0].wallet[0].type ==
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
          walletPageController.walletTypePromocode = walletPageController
              .walletModelPromoFull.data[index_promo].benefit[0].wallet[0].type;
          Utils().customPrint(
              'applied promo code: ${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")}');
          walletPageController.buttonApplyText.value = "Remove";
          showCustomDialog(context);
        }
      } catch (e) {
        //print('applied amount: $e');
        Utils().customPrint('Offer calcValuePerc T $e');
      }
    } else {
      //for dynamic showing value in 'You'll get' place.
      walletPageController.amtAfterPromoApplied.value =
          double.parse(entered_amount);
      walletPageController.youWillGet.value =
          '${entered_amount.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
    }
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Container(
          child: Center(
            child: Container(
              height: 200,
              width: 300,
              //color: Colors.white,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.all(5),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("     "),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "",
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
                          child: IconButton(
                              icon: new Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Lottie.asset(
                                'assets/lottie_files/tick.json',
                                repeat: false,
                                height: 100,
                                width: 100,
                              ),
                              Lottie.asset(
                                'assets/lottie_files/bust.json',
                                repeat: false,
                                height: 200,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 70.0),
                            child: Text(
                              "\'${walletPageController.promocode.value.toUpperCase()}\' applied",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: AppColor().reward_grey_bg),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 140.0),
                            child: Text(
                              "Hurray!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().colorPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget listTransaction(BuildContext context, int indexV) {
    return walletPageController.transtsionlist[indexV].status != null
        ? walletPageController.transtsionlist[indexV].status
                    .compareTo("approvalRequired") ==
                0
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  /*walletPageController.withdrawRequestlist[indexV].id*/
                                  'WITHDRAWAL PENDING',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor)),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                  getStartTimeHHMMSS(walletPageController
                                      .transtsionlist[indexV].createdAt),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Montserrat",
                                      color: AppColor().optional_payment)),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "Transaction id :${walletPageController.transtsionlist[indexV].id}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    color: AppColor().wallet_light_grey),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  walletPageController
                                              .transtsionlist[indexV].amount !=
                                          null
                                      ? walletPageController
                                              .transtsionlist[indexV].amount
                                              .isBonuseType()
                                          ? walletPageController
                                              .transtsionlist[indexV]
                                              .amount
                                              .value
                                              .toString()
                                          : (Utils().getDepositeBalnace(
                                              walletPageController
                                                  .transtsionlist[indexV]
                                                  .amount
                                                  .value)

                                          /*walletPageController.transtsionlist[indexV]
                                            .amount.value /
                                        100*/
                                          )
                                      : "",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                      color: AppColor().colorPrimary)),
                              Text('pending',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                      color: AppColor().red)),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (isRedundentClick(DateTime.now())) {
                                    Utils().customPrint(
                                        'ProgressBarClick: showProgress click');
                                    return;
                                  }
                                  Utils().customPrint(
                                      'ProgressBarClick: showProgress run process');

                                  final param = {"status": "cancelled"};
                                  await walletPageController
                                      .cancelWithdrawRequest(
                                          context,
                                          walletPageController
                                              .transtsionlist[indexV]
                                              .operation
                                              .referenceId,
                                          param);
                                  await userController.getWalletAmount();
                                },
                                child: Container(
                                    height: 22,
                                    width: 64,
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
                                          color: AppColor().whiteColor,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(30),

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
                                      // color: AppColor().whiteColor
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Montserrat",
                                            color: Colors.white),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 15),
                    child: DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Colors.white,
                      //  dashGradient: [Colors.red, Colors.blue],
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  /*walletPageController.withdrawRequestlist[indexV].id*/
                                  'WITHDRAWAL',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor)),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                  getStartTimeHHMMSS(walletPageController
                                      .transtsionlist[indexV].date),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Montserrat",
                                      color: AppColor().optional_payment)),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "Transaction id :${walletPageController.transtsionlist[indexV].id}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    color: AppColor().wallet_light_grey),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  walletPageController
                                              .transtsionlist[indexV].amount !=
                                          null
                                      ? walletPageController
                                              .transtsionlist[indexV].amount
                                              .isBonuseType()
                                          ? walletPageController
                                              .transtsionlist[indexV]
                                              .amount
                                              .value
                                              .toString()
                                          : (Utils().getDepositeBalnace(
                                              walletPageController
                                                  .transtsionlist[indexV]
                                                  .amount
                                                  .value)

                                          /*walletPageController.transtsionlist[indexV]
                                            .amount.value /
                                        100*/
                                          )
                                      : "",
                                  // double.parse(walletPageController
                                  //     .transtsionlist[indexV].amount.value).toStringAsFixed(2).toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                      color: AppColor().colorPrimary)),
                              /*   Text('pending',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().red)),*/
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  height: 25,
                                  width: 85,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: walletPageController
                                                      .transtsionlist[indexV]
                                                      .status
                                                      .compareTo("queued") ==
                                                  0 ||
                                              walletPageController
                                                      .transtsionlist[indexV]
                                                      .status
                                                      .compareTo("pending") ==
                                                  0
                                          ? [
                                              AppColor().vip_button,
                                              AppColor().vip_button_light,
                                            ]
                                          : walletPageController
                                                      .transtsionlist[indexV]
                                                      .status
                                                      .compareTo("completed") ==
                                                  0
                                              ? [
                                                  AppColor().green_color,
                                                  AppColor().green_color_light,
                                                ]
                                              : walletPageController
                                                              .transtsionlist[
                                                                  indexV]
                                                              .status
                                                              .compareTo(
                                                                  "Reversed") ==
                                                          0 ||
                                                      walletPageController
                                                              .transtsionlist[
                                                                  indexV]
                                                              .status
                                                              .compareTo(
                                                                  "cancelled") ==
                                                          0
                                                  ? [
                                                      AppColor().red,
                                                      AppColor()
                                                          .button_bg_reddark,
                                                    ]
                                                  : [
                                                      AppColor().red,
                                                      AppColor()
                                                          .button_bg_reddark,
                                                    ],
                                    ),
                                    border: Border.all(
                                        color: AppColor().whiteColor, width: 1),
                                    borderRadius: BorderRadius.circular(30),

                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(
                                          0.0,
                                          5.0,
                                        ),
                                        blurRadius: 1.0,
                                        spreadRadius: .3,
                                        color: walletPageController
                                                        .transtsionlist[indexV]
                                                        .status
                                                        .compareTo("queued") ==
                                                    0 ||
                                                walletPageController
                                                        .transtsionlist[indexV]
                                                        .status
                                                        .compareTo("pending") ==
                                                    0
                                            ? Color(0xFF333232)
                                            : walletPageController
                                                        .transtsionlist[indexV]
                                                        .status
                                                        .compareTo(
                                                            "completed") ==
                                                    0
                                                ? Color(0xFF067906)
                                                : walletPageController
                                                                .transtsionlist[
                                                                    indexV]
                                                                .status
                                                                .compareTo(
                                                                    "Reversed") ==
                                                            0 ||
                                                        walletPageController
                                                                .transtsionlist[indexV]
                                                                .status
                                                                .compareTo("cancelled") ==
                                                            0
                                                    ? Color(0xFF810A0A)
                                                    : Color(0xFF810A0A),
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
                                  child: Center(
                                    child: walletPageController
                                                    .transtsionlist[indexV]
                                                    .status
                                                    .compareTo("queued") ==
                                                0 ||
                                            walletPageController
                                                    .transtsionlist[indexV]
                                                    .status
                                                    .compareTo("pending") ==
                                                0
                                        ? Text(
                                            "Processing".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Montserrat",
                                                color: Colors.white),
                                          )
                                        : walletPageController
                                                    .transtsionlist[indexV]
                                                    .status
                                                    .compareTo("completed") ==
                                                0
                                            ? Text(
                                                "Processed".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              )
                                            : walletPageController
                                                            .transtsionlist[
                                                                indexV]
                                                            .status
                                                            .compareTo(
                                                                "reversed") ==
                                                        0 ||
                                                    walletPageController
                                                            .transtsionlist[
                                                                indexV]
                                                            .status
                                                            .compareTo("cancelled") ==
                                                        0
                                                ? Text(
                                                    "Reversed",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    "Failed",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.white),
                                                  ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 15),
                    child: DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Colors.white,
                      //  dashGradient: [Colors.red, Colors.blue],
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                    ),
                  ),
                ],
              )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              walletPageController
                                  .transtsionlist[indexV].description,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                              getStartTimeHHMMSS(walletPageController
                                  .transtsionlist[indexV].date),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().optional_payment)),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Transaction id".tr +
                                " :${walletPageController.transtsionlist[indexV].id}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: AppColor().wallet_light_grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              walletPageController
                                          .transtsionlist[indexV].amount !=
                                      null
                                  ? walletPageController
                                          .transtsionlist[indexV].amount
                                          .isBonuseType()
                                      ? walletPageController
                                          .transtsionlist[indexV].amount.value
                                          .toString()
                                      : (Utils().getDepositeBalnace(
                                          walletPageController
                                              .transtsionlist[indexV]
                                              .amount
                                              .value)

                                      /*walletPageController.transtsionlist[indexV]
                                            .amount.value /
                                        100*/
                                      )
                                  : "",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().colorPrimary)),
                          Text(walletPageController.transtsionlist[indexV].mode,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().wallet_light_grey)),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              var eventName = "event_track_report";
                              var eventProperties = {
                                "Order Id":
                                    '${walletPageController.transtsionlist[indexV].id}',
                                "type": "Real_money"
                              };
                              Freshchat.trackEvent(eventName,
                                  properties: eventProperties);
                              Freshchat.showConversations(
                                  filteredViewTitle: "Order Queries",
                                  tags: ["Order Queries"]);
                            },
                            child: Container(
                                height: 22,
                                width: 64,
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
                                      color: AppColor().whiteColor, width: 1),
                                  borderRadius: BorderRadius.circular(30),

                                  boxShadow: const [
                                    BoxShadow(
                                      offset: const Offset(
                                        0.0,
                                        5.0,
                                      ),
                                      blurRadius: 2,
                                      spreadRadius: .1,
                                      color: Color(0xFFAF3902),
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
                                child: Center(
                                  child: Text(
                                    "Report".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 10, right: 10, bottom: 15),
                child: DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.white,
                  //  dashGradient: [Colors.red, Colors.blue],
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                ),
              ),
            ],
          );
  }

  //pending withdrawal list
/*  Widget listWithdrawal(BuildContext context, int indexV) {
*/ /*<<<<<<< HEAD
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        */ /**/ /*walletPageController.withdrawRequestlist[indexV].id*/ /**/ /*
                        'WITHDRAWAL PENDING',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            color: AppColor().whiteColor)),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                        getStartTimeHHMMSS(walletPageController
                            .withdrawRequestlist[indexV].createdAt),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            color: AppColor().optional_payment)),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Transaction id :${walletPageController.withdrawRequestlist[indexV].transactionId}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          color: AppColor().wallet_light_grey),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        walletPageController
                                    .withdrawRequestlist[indexV].amount !=
                                null
                            ? walletPageController
                                    .withdrawRequestlist[indexV].amount
                                    .isBonuseType()
                                ? walletPageController
                                    .withdrawRequestlist[indexV].amount.value
                                    .toString()
                                : (Utils().getDepositeBalnace(
                                    walletPageController
                                        .withdrawRequestlist[indexV]
                                        .amount
                                        .value))
                            : "",
                        // double.parse(walletPageController
                        //     .transtsionlist[indexV].amount.value).toStringAsFixed(2).toString(),
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat",
                            color: AppColor().colorPrimary)),
                    Text("pending".tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat",
                            color: AppColor().red)),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isRedundentClick(DateTime.now())) {
                          Utils().customPrint(
                              'ProgressBarClick: showProgress click');
                          return;
                        }
                        Utils().customPrint(
                            'ProgressBarClick: showProgress run process');

                        final param = {"status": "cancelled"};
                        await walletPageController.cancelWithdrawRequest(
                            context,
                            walletPageController.withdrawRequestlist[indexV].id,
                            param);
                        await userController.getWalletAmount();
                      },
                      child: Container(
                          height: 22,
                          width: 64,
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
                                color: AppColor().whiteColor, width: 1),
                            borderRadius: BorderRadius.circular(30),

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
                            // color: AppColor().whiteColor
                          ),
                          child: Center(
                            child: Text(
                              "Cancel".tr,
                              textAlign: TextAlign.center,*/ /*

    return walletPageController.withdrawRequestModelR.value.data[indexV].status
                .compareTo("approvalRequired") ==
            0
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              */ /*walletPageController.withdrawRequestlist[indexV].id*/ /*
                              'WITHDRAWAL PENDING',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                              getStartTimeHHMMSS(walletPageController
                                  .withdrawRequestModelR
                                  .value
                                  .data[indexV]
                                  .createdAt),

                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().optional_payment)),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Transaction id :${walletPageController.withdrawRequestModelR.value.data[indexV].id}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: AppColor().wallet_light_grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              walletPageController.withdrawRequestModelR.value
                                          .data[indexV].amount !=
                                      null
                                  ? walletPageController.withdrawRequestModelR
                                          .value.data[indexV].amount
                                          .isBonuseType()
                                      ? walletPageController
                                          .withdrawRequestModelR
                                          .value
                                          .data[indexV]
                                          .amount
                                          .value
                                          .toString()
                                      : (Utils().getDepositeBalnace(
                                          walletPageController
                                              .withdrawRequestModelR
                                              .value
                                              .data[indexV]
                                              .amount
                                              .value))
                                  : "",
                              // double.parse(walletPageController
                              //     .transtsionlist[indexV].amount.value).toStringAsFixed(2).toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().colorPrimary)),
                          Text('pending',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().red)),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (isRedundentClick(DateTime.now())) {
                                Utils().customPrint(
                                    'ProgressBarClick: showProgress click');
                                return;
                              }
                              Utils().customPrint(
                                  'ProgressBarClick: showProgress run process');

                              final param = {"status": "cancelled"};
                              await walletPageController.cancelWithdrawRequest(
                                  context,
                                  walletPageController.withdrawRequestModelR
                                      .value.data[indexV].id,
                                  param);
                              await userController.getWalletAmount();
                            },
                            child: Container(
                                height: 22,
                                width: 64,
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
                                      color: AppColor().whiteColor, width: 1),
                                  borderRadius: BorderRadius.circular(30),

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
                                  // color: AppColor().whiteColor
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Montserrat",
                                        color: Colors.white),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 10, right: 10, bottom: 15),
                child: DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.white,
                  //  dashGradient: [Colors.red, Colors.blue],
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                ),
              ),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              */ /*walletPageController.withdrawRequestlist[indexV].id*/ /*
                              'WITHDRAWAL',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                              getStartTimeHHMMSS(walletPageController
                                  .withdrawRequestModelR
                                  .value
                                  .data[indexV]
                                  .createdAt),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  color: AppColor().optional_payment)),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Transaction id :${walletPageController.withdrawRequestModelR.value.data[indexV].id}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: AppColor().wallet_light_grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              walletPageController.withdrawRequestModelR.value
                                          .data[indexV].amount !=
                                      null
                                  ? walletPageController.withdrawRequestModelR
                                          .value.data[indexV].amount
                                          .isBonuseType()
                                      ? walletPageController
                                          .withdrawRequestModelR
                                          .value
                                          .data[indexV]
                                          .amount
                                          .value
                                          .toString()
                                      : (Utils().getDepositeBalnace(
                                          walletPageController
                                              .withdrawRequestModelR
                                              .value
                                              .data[indexV]
                                              .amount
                                              .value))
                                  : "",
                              // double.parse(walletPageController
                              //     .transtsionlist[indexV].amount.value).toStringAsFixed(2).toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().colorPrimary)),
                          */ /*   Text('pending',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  color: AppColor().red)),*/ /*
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              height: 25,
                              width: 85,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors:  walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("queued")==0 || walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("pending")==0?[
                                    AppColor().vip_button,
                                    AppColor().vip_button_light,
                                  ]:walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("completed")==0? [AppColor().green_color,
                                  AppColor().green_color_light,
                                  ]:walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("Reversed")==0 || walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("cancelled")==0 ?[AppColor().red,
                                    AppColor().button_bg_reddark,
                                  ]:[ AppColor().red,
                                    AppColor().button_bg_reddark,
                                  ],
                                ),
                                border: Border.all(
                                    color: AppColor().whiteColor, width: 1),
                                borderRadius: BorderRadius.circular(30),

                                boxShadow:  [
                                  BoxShadow(
                                    offset:  Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color:  walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("queued")==0 || walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("pending")==0?Color(
                                        0xFF333232)
                                :walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("completed")==0?  Color(0xFF067906):walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("Reversed")==0 || walletPageController.withdrawRequestModelR.value.data[indexV].status.compareTo("cancelled")==0 ?Color(
                                        0xFF810A0A):Color(0xFF810A0A),
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
                              child: Center(
                                child: walletPageController
                                                .withdrawRequestModelR
                                                .value
                                                .data[indexV]
                                                .status
                                                .compareTo("queued") ==
                                            0 ||
                                        walletPageController
                                                .withdrawRequestModelR
                                                .value
                                                .data[indexV]
                                                .status
                                                .compareTo("pending") ==
                                            0
                                    ? Text(
                                        "Processing",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Montserrat",
                                            color: Colors.white),
                                      )
                                    : walletPageController.withdrawRequestModelR
                                                .value.data[indexV].status
                                                .compareTo("completed") ==
                                            0
                                        ? Text(
                                            "Processed",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Montserrat",
                                                color: Colors.white),
                                          )
                                        : walletPageController
                                                    .withdrawRequestModelR
                                                    .value
                                                    .data[indexV]
                                                    .status
                                                    .compareTo("reversed") ==
                                                0 || walletPageController
                                    .withdrawRequestModelR
                                    .value
                                    .data[indexV]
                                    .status
                                    .compareTo("cancelled") ==
                                    0
                                            ? Text(
                                                "Reversed",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                "Failed",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 10, right: 10, bottom: 15),
                child: DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.white,
                  //  dashGradient: [Colors.red, Colors.blue],
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                ),
              ),
            ],
          );
  }*/

  Future<void> getWhNumber(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    whatsAppNo.value = prefs.getString("whatsappMobile");

    //isPopUp banner
    Utils().getBannerAsPerPageType(
        prefs.getString("token"), AppString().appTypes, 'wallet');
  }

  void _scaleDialog() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      //title: const Text("Hurrey!"),
      //content: const Text("PROMOCODE APPLY SUCCESSFULLY!"),
      actions: <Widget>[
        //Lottie.network('https://assets10.lottiefiles.com/packages/lf20_56Jc5o.json'),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Lottie.asset(
                    'assets/lottie_files/tick.json',
                    repeat: false,
                    height: 100,
                    width: 100,
                  ),
                  Lottie.asset(
                    'assets/lottie_files/bust.json',
                    repeat: false,
                    height: 200,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text(
                  "Promocode Applied!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      color: AppColor().blackColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //ListView Promo-Banner
  Widget promo_code_banner_list(int index) {
    int limitsTotal = walletPageController.walletModelPromo.data[index].total;
    int usesCount = walletPageController.walletModelPromo.data[index].usesCount;
    Utils().customPrint('usesCount limitsTotal: $limitsTotal');
    Utils().customPrint('usesCount : $usesCount');
    Utils().customPrint(
        'usesCount limitsTotal-usesCount: ${limitsTotal - usesCount}');
    return GestureDetector(
      onTap: () {
        //click here
      },
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 15, right: 0),
          child: Image(
            height: 120,
            fit: BoxFit.cover,
            image: /*walletPageController.bannerModelRV.value !=
              null &&
              walletPageController
                  .bannerModelRV.value.data !=
                  null &&
              walletPageController
                  .bannerModelRV.value.data.length >=
                  1
              ? NetworkImage(walletPageController
              .bannerModelRV.value.data[0].image.url)
              : */
                AssetImage(ImageRes().store_banner_wallet),
          ),
        ),
        Container(
          height: 50,
          width: 50,
          child: Stack(
            children: [
              Image(
                height: 50,
                width: 50,
                //fit: BoxFit.cover,
                image: AssetImage(ImageRes().banner_overlay),
              ),
              Center(
                child: Text(
                  '${walletPageController.walletModelPromo.data[index].total - walletPageController.walletModelPromo.data[index].usesCount} Left',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      fontSize: 11,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void alertInstantCashWithdraw(BuildContext context) {
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
                  height: 420,
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().hole_popup_bg)),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(ImageRes().hole_popup_bg))),
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 430,
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
                            "            ",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: 60,
                            child: Image.asset("assets/images/rupee_gmng.png"),
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
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                              onTap: () {
                                // Fluttertoast.showToast(msg: 'Banner Clicked!');
                              },
                              child: Image(
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                image: userController.current_vip_banner !=
                                            null &&
                                        userController
                                                .current_vip_banner.value !=
                                            null
                                    ? NetworkImage(
                                        userController.current_vip_banner.value)
                                    : AssetImage(
                                        "assets/images/vip_banner_level0.png"),
                                fit: BoxFit.fill,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 0, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Deposit Cash Balance'.tr,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            Text(
                              '${AppString().txt_currency_symbole} ${double.parse(userController.getDepositeBalnace())}',
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                  color: AppColor().green_color),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 5, bottom: 0, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Extra Cash Balance'.tr,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: AppColor().colorPrimary_dark),
                            ),
                            Text(
                              '${AppString().txt_currency_symbole}${userController.getInstantCashInt()}',
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 2, bottom: 0, right: 20),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          lineLength: double.infinity,
                          lineThickness: 1.0,
                          dashLength: 4.0,
                          dashColor: Colors.white,
                          //  dashGradient: [Colors.red, Colors.blue],
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        padding: EdgeInsets.only(
                            left: 8, top: 0, bottom: 0, right: 8),
                        decoration: BoxDecoration(
                            color: AppColor().reward_grey_bg,
                            borderRadius: BorderRadius.circular(8)),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Updated Deposit Cash Balance'.tr,
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            Text(
                              '${AppString().txt_currency_symbole} ${(userController.getInstantCashInt() + double.parse(userController.getDepositeBalnace())).toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Map<String, dynamic> parme = {
                            "amount":
                                ((userController.getInstantCashInt()) * 100)
                                    .toStringAsFixed(2), // amount in paisa
                          };
                          walletPageController.claimInstantCash(context, parme);
                          // Get.offAll(() => DashBord(4, ""));
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 43,
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width - 220,
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
                              /*BoxShadow(
                      offset: Offset(00, 00),
                      blurRadius: 00,
                      color: Color(0xFFffffff),
                      inset: true,
                    ),*/
                            ],

                            border: Border.all(
                                color: AppColor().whiteColor, width: 2),
                            borderRadius: BorderRadius.circular(30),
                            // color: AppColor().whiteColor
                          ),
                          child: Text(
                            "REDEEM".tr,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Nunito",
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          "*Note: Amount redeemed will be added to your Deposit Cash*"
                              .tr,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                              color: AppColor().version_bg),
                        ),
                      )
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

  //Vip redeem amount is low
  void showBottomSheetInfoInstant(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: 550,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 30,
                right: 10),
            decoration: BoxDecoration(
                color: AppColor().border_inside,
                border: Border.all(
                  width: 5,
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
                    inset: true,
                  ),
                ],
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
                      padding: const EdgeInsets.only(top: 10, left: 0),
                      child: Text(
                        "How To Unlock Instant Cash ",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
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
                Visibility(
                  visible: userController.profileDataRes.value.level.value == 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () {
                            // Fluttertoast.showToast(msg: 'Banner Clicked!');
                          },
                          child: Image(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            image: userController.current_vip_banner != null &&
                                    userController.current_vip_banner.value !=
                                        null
                                ? NetworkImage(
                                    userController.current_vip_banner.value)
                                : AssetImage(
                                    "assets/images/vip_banner_level0.png"),
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                ),
                /*       Visibility(
                  visible: userController.profileDataRes.value.level.value == 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () {
                            //Fluttertoast.showToast(msg: 'Banner Clicked!');
                          },
                          child: Image(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            //image: AssetImage("assets/images/vip_banner_level0.png"),
                            image: walletPageController.bannerModelRV.value !=
                                        null &&
                                    walletPageController
                                            .bannerModelRV.value.data !=
                                        null &&
                                    walletPageController
                                            .bannerModelRV.value.data.length >=
                                        1
                                ? NetworkImage(walletPageController
                                    .bannerModelRV.value.data[0].image.url)
                                : AssetImage(
                                    "assets/images/vip_banner_level0.png"),
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                ),*/
                Html(
                  shrinkWrap: false,
                  data: userController
                      .appSettingReponse.value.instantCash.featureDescription,
                  /* onLinkTap: (url, _, _
                  _, ___) {
                       Utils().customPrint("Opening $url");
                      makeLaunch(url!);
                    },*/
                  style: {
                    "body": Style(
                      fontSize:
                          FontSize(14 * MediaQuery.of(context).textScaleFactor),
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.left,
                      color: Colors.white,
                    ),
                    'h1': Style(
                      fontSize:
                          FontSize(12 * MediaQuery.of(context).textScaleFactor),
                      color: Colors.white,
                      textAlign: TextAlign.left,
                    ),
                    'p': Style(
                      fontSize:
                          FontSize(13 * MediaQuery.of(context).textScaleFactor),
                      textAlign: TextAlign.left,
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      fontFamily: "Montserrat",
                    ),
                    'ul': Style(
                      fontSize:
                          FontSize(13 * MediaQuery.of(context).textScaleFactor),
                      color: Colors.white,
                      textAlign: TextAlign
                          .center, /*margin:  EdgeInsets.only(left: 10)*/
                    )
                  },
                ),
                SizedBox(
                  height: 10,
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

                      border:
                          Border.all(color: AppColor().whiteColor, width: 2),
                      borderRadius: BorderRadius.circular(30),
                      // color: AppColor().whiteColor
                    ),
                    child: Text(
                      "OKAY",
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
          );
        });
  }

  void vipBannerClickPromoCode(BuildContext context) {
    //code checking for offline codes
    bool temp = false;
    for (int i = 0;
        i < walletPageController.walletModelPromoFull.data.length;
        i++) {
      Utils().customPrint(
          "PROMOCODE Loop code ${walletPageController.walletModelPromoFull.data[i].code}");
      if (walletPageController.promocode.value.toLowerCase() ==
          walletPageController.walletModelPromoFull.data[i].code
              .toLowerCase()) {
        //validation
        double enterAmtInt =
            double.parse(walletPageController.selectAmount.value);
        double fromValue = double.parse(
            walletPageController.walletModelPromoFull.data[i].fromValue);
        double toValue = double.parse(
            walletPageController.walletModelPromoFull.data[i].toValue);
        Utils().customPrint('Offer Valid F ${fromValue}');
        Utils().customPrint('Offer Valid T ${toValue}');

        if (enterAmtInt < fromValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${walletPageController.walletModelPromoFull.data[i].fromValue} - ${walletPageController.walletModelPromoFull.data[i].toValue} Rs!');
          return;
        } else if (enterAmtInt > toValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${walletPageController.walletModelPromoFull.data[i].fromValue} - ${walletPageController.walletModelPromoFull.data[i].toValue} Rs!');
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
            "PROMOCODE Invalid: ${walletPageController.promocode.value}");
        temp = false;
      }
    }
  }

  //banner click method for VIP
  void promo_code_not_visible1(
      var entered_amount, int index_promo, BuildContext context) {
    if (index_promo != null) {
      try {
        if (walletPageController.walletModelPromoFull.data[index_promo]
                    .benefit[0].wallet[0].percentage !=
                '' &&
            walletPageController.walletModelPromoFull.data[index_promo]
                    .benefit[0].wallet[0].maximumAmount !=
                '') {
          double maxAmtFixed = double.parse(walletPageController
              .walletModelPromoFull
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .maximumAmount);

          double percentage = double.parse(walletPageController
              .walletModelPromoFull
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .percentage);
          Utils().customPrint('Offer enterAmtInt F ');
          Utils().customPrint('Offer calcValuePerc T ');
          double enterAmtInt = double.parse(entered_amount);
          double calcValuePerc = ((percentage / 100) * enterAmtInt);

          //conditions
          if (walletPageController.walletModelPromoFull.data[index_promo]
                  .benefit[0].wallet[0].type ==
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
          } else if (walletPageController.walletModelPromoFull.data[index_promo]
                  .benefit[0].wallet[0].type ==
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
          walletPageController.walletTypePromocode = walletPageController
              .walletModelPromoFull.data[index_promo].benefit[0].wallet[0].type;
          Utils().customPrint(
              'applied promo code: ${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")}');
          walletPageController.buttonApplyText.value = "Remove";
          //showCustomDialog(context);

          /////

          //saving values for UI
          //layout hide work & show deposit get UI
          CashFreeController cashFreeController = Get.put(CashFreeController());
          cashFreeController.promocodeValue = int.parse(walletPageController
              .walletModelPromoFull.data[index_promo].fromValue);

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

          walletPageController.promo_type.value = walletPageController
              .walletModelPromoFull.data[index_promo].benefit[0].wallet[0].type;

          walletPageController.promo_minus_amt.value =
              cashFreeController.promocodeValue - int.parse(entered_amount);
          ;
          int max_per = int.parse(walletPageController.walletModelPromoFull
              .data[index_promo].benefit[0].wallet[0].percentage);
          walletPageController.promo_amt.value =
              (enterAmtInt * (max_per / 100));

          walletPageController.typeTextCheck.value = 2; //eqauls
          /*   walletPageController.profitAmt.value =
                                              enteredValue +
                                                  walletPageController
                                                      .promo_amt.value;*/
          cashFreeController.promocodeHelper.value =
              walletPageController.walletModelPromoFull.data[index_promo].code;

          walletPageController.promo_maximumAmt.value = int.parse(
              walletPageController.walletModelPromoFull.data[index_promo]
                  .benefit[0].wallet[0].maximumAmount);
          if (walletPageController.promo_amt.value >
              walletPageController.promo_maximumAmt.value) {
            walletPageController.profitAmt.value = int.parse(entered_amount) +
                double.parse(
                    walletPageController.promo_maximumAmt.value.toString());
          } else {
            walletPageController.profitAmt.value = int.parse(entered_amount) +
                walletPageController.promo_amt.value;
          }

          Utils().customPrint('PROMOCODES 1 View All *******************  '
              'CODE: ${walletPageController.walletModelPromoFull.data[index_promo].code} |'
              'TYPE: ${walletPageController.walletModelPromoFull.data[index_promo].benefit[0].wallet[0].type} |'
              '%: ${walletPageController.walletModelPromoFull.data[index_promo].benefit[0].wallet[0].percentage}% |'
              ' calc%: ${walletPageController.promo_amt.value} |'
              'FROM: ${walletPageController.walletModelPromoFull.data[index_promo].fromValue}|'
              'TO: ${walletPageController.walletModelPromoFull.data[index_promo].toValue}|'
              'GET AMT: ${walletPageController.profitAmt.value}|'
              'MAX: ${walletPageController.promo_maximumAmt.value}');
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

  //Vip redeem amount is low
  void vipPopUpClick(BuildContext context, var item) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: 250,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 10,
                right: 10),
            decoration: BoxDecoration(
                color: AppColor().border_inside,
                border: Border.all(
                  width: 5,
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
                    inset: true,
                  ),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 0),
                      child: Text(
                        "VIP CODE",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          // Fluttertoast.showToast(msg: 'Banner Clicked!');
                        },
                        child: Image(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          image: item.banner != null && item.banner != ''
                              ? NetworkImage(item.banner)
                              : Container(),
                          fit: BoxFit.fill,
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    /*print(
                        'Length of vipLevelIds ${item.code} ${item.vipLevelIds.length}');
                    return;*/
                    if (item.isVIP == true) {
                      walletPageController.gameListSelectedColor.value =
                          1000; //initialisation
                      walletPageController.amtAfterPromoApplied.value = 0;
                      //showBottomSheetAddAmount(context);
                      //promocode api call again for refreshing the data
                      index_promo = null;

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
                      walletPageController.promo_type = "".obs;
                      walletPageController.promo_amt = 0.0.obs;
                      walletPageController.promo_minus_amt = 0.obs;
                      walletPageController.typeTextCheck = 0.obs;
                      walletPageController.applyPress = false.obs;
                      walletPageController.profitAmt = 0.0.obs;
                      AppString.contestAmount = 0; //newly added

                      CashFreeController cashFreeController =
                          Get.put(CashFreeController());
                      Get.to(() => CashFreeScreen()); //<<<<<<<<<<<<<<<<<<<<<<<<
                      cashFreeController.amountCashTextController.value.text =
                          item.fromValue;
                      walletPageController.selectAmount.value = item.fromValue;
                      //await cashFreeController.haveCodeApplied(item.fromValue.toString());
                      walletPageController.applyPress.value = true;
                      walletPageController.buttonApplyText.value = 'Apply';
                      walletPageController.boolEnterCode.value = false;
                      cashFreeController.click_remove_code = true;
                      walletPageController.promocode.value = item.code;
                      vipBannerClickPromoCode(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                    width: MediaQuery.of(context).size.width - 200,
                    decoration: item.isVIP == true
                        ? BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                offset: const Offset(
                                  0.0,
                                  5.0,
                                ),
                                blurRadius: 3.2,
                                spreadRadius: 0.3,
                                color: Color(0xFF02310A),
                                inset: true,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                AppColor().green_color_light,
                                AppColor().green_color,
                              ],
                            ),
                            border: Border.all(
                                color: AppColor().whiteColor, width: 2),
                            borderRadius: BorderRadius.circular(30),
                            // color: AppColor().whiteColor
                          )
                        : BoxDecoration(
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
                        item.isVIP == true
                            ? Container()
                            : Container(
                                height: 17,
                                width: 17,
                                child: SvgPicture.asset(
                                  "assets/images/padlock.svg",
                                  color: AppColor().whiteColor,
                                ),
                              ),
                        item.isVIP == true
                            ? Container()
                            : SizedBox(
                                width: 10,
                              ),
                        Text(
                          item.isVIP == true ? "USE" : "LOCKED",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Montserrat",
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        });
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
}
