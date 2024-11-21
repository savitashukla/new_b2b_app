import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/main/wallet/ViewAllPromoCodes.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';
import 'package:gmng/utills/event_tracker/FaceBookEventController.dart';
import 'package:gmng/utills/event_tracker/FacebookEventApi.dart';
import 'package:lottie/lottie.dart';

import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import '../../../utills/Utils.dart';
import '../../../utills/event_tracker/CleverTapController.dart';
import '../../../webservices/ApiUrl.dart';
import '../../controller/WalletPageController.dart';
import '../../controller/user_controller.dart';
import '../dashbord/DashBord.dart';
import 'CashFreeController.dart';

class CashFreeScreen extends StatelessWidget {
  CashFreeScreen({Key key}) : super(key: key);
  UserController _userController = Get.put(UserController());
  CashFreeController cashFreeController = Get.put(CashFreeController());
  WalletPageController walletPageController = Get.put(WalletPageController());
  CleverTapController cleverTapController = Get.put(CleverTapController());
  String buttonApplyText = 'Apply';

  var click_upi = false.obs;
  var click_wallet = false.obs;
  var click_netbanking = false.obs;
  var selectedBank = '';
  var selectedWallet = '';
  List<Widget> widgetlist = [];

  Future<bool> _onWillPop() async {
    AppString.contestAmount = 0;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //list of widget
    widgetlist = [
      /*UPI*/
      Obx(() => Visibility(
            visible: cashFreeController.selectedApp != null &&
                    cashFreeController.selectedApp.value.length >= 0
                ? true
                : false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "UPI".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: FontSizeC().front_regular16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: AppColor().colorPrimary_dark),
                      ),
                      /*GestureDetector(
                                onTap: () async {
                                  // showProgressDismissible(context);
                                  //Fluttertoast.showToast(msg: 'Add UPI!');
                                  if (walletPageController.selectAmount.value ==
                                          "" ||
                                      walletPageController.selectAmount.value ==
                                          "0") {
                                    Fluttertoast.showToast(
                                        msg: "Please enter amount!");
                                    return;
                                  }
                                  if (walletPageController
                                          .selectAmount.value.length >
                                      7) {
                                    Fluttertoast.showToast(
                                        msg: "Deposit limit exceeded!");
                                    return;
                                  }

                                  //POP UP
                                  showBottomSheetAddAmount(context);
                                },
                                child: Text(
                                  " ADD UPI  ",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: FontSizeC().front_regular16,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: AppColor().colorPrimary_dark),
                                ),
                              ),*/
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    //height: 75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor().grey_other, width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cashFreeController.selectedApp.value.length > 0
                            ? Container(
                                height: 75,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: cashFreeController
                                              .selectedApp.value.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return UPIList(context, index);
                                          }),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (walletPageController
                                                          .selectAmount.value ==
                                                      "" ||
                                                  walletPageController
                                                          .selectAmount.value ==
                                                      "0") {
                                                Fluttertoast.showToast(
                                                    msg: "Please enter amount!"
                                                        .tr);
                                                return;
                                              }
                                              int amountInt = int.parse(
                                                  walletPageController
                                                      .selectAmount.value);
                                              if (amountInt < 10) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Minimum Deposit Amount Must be 10₹!"
                                                            .tr);
                                                return;
                                              }
                                              if (walletPageController
                                                      .selectAmount
                                                      .value
                                                      .length >
                                                  7) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Deposit limit exceeded!"
                                                            .tr);
                                                return;
                                              }

                                              //POP UP
                                              showBottomSheetAddUPI(context);
                                            },
                                            child: Container(
                                              width: 50,
                                              margin: EdgeInsets.only(
                                                  right: 10, left: 5),
                                              height: 50,
                                              alignment: Alignment.bottomCenter,
                                              child: Image.asset(
                                                  "assets/images/add_upi.png"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                height: 70,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text("App Not Found".tr,
                                            style: TextStyle(
                                                fontSize:
                                                    FontSizeC().front_regular16,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w500,
                                                color: AppColor().whiteColor)),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (walletPageController
                                                          .selectAmount.value ==
                                                      "" ||
                                                  walletPageController
                                                          .selectAmount.value ==
                                                      "0") {
                                                Fluttertoast.showToast(
                                                    msg: "Please enter amount!"
                                                        .tr);
                                                return;
                                              }
                                              int amountInt = int.parse(
                                                  walletPageController
                                                      .selectAmount.value);
                                              if (amountInt < 10) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Minimum Deposit Amount Must be 10₹!"
                                                            .tr);
                                                return;
                                              }
                                              if (walletPageController
                                                      .selectAmount
                                                      .value
                                                      .length >
                                                  7) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Deposit limit exceeded!");
                                                return;
                                              }

                                              //POP UP
                                              showBottomSheetAddUPI(context);
                                            },
                                            child: Container(
                                              width: 50,
                                              margin: EdgeInsets.only(
                                                  right: 10, left: 5),
                                              height: 50,
                                              alignment: Alignment.bottomCenter,
                                              child: Image.asset(
                                                  "assets/images/add_upi.png"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                        click_upi == true
                            ? GestureDetector(
                                onTap: () async {
                                  //Fluttertoast.showToast(msg: 'click payment btn! ${walletPageController.profileDataRes.value.email.address}');
                                  try {
                                    if (walletPageController
                                                .selectAmount.value ==
                                            "" ||
                                        walletPageController
                                                .selectAmount.value ==
                                            "0") {
                                      Fluttertoast.showToast(
                                          msg: "Please enter amount!".tr);
                                      return;
                                    }
                                    int amountInt = int.parse(
                                        walletPageController
                                            .selectAmount.value);
                                    if (amountInt < 10) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Minimum Deposit Amount Must be 10₹!"
                                                  .tr);
                                      return;
                                    }
                                    if (walletPageController
                                            .selectAmount.value.length >
                                        7) {
                                      Fluttertoast.showToast(
                                          msg: "Deposit limit exceeded!".tr);
                                      return;
                                    }
                                    if (isRedundentClick(DateTime.now())) {
                                      Utils().customPrint(
                                          'ProgressBarClick: showProgress click');
                                      return;
                                    }
                                    Utils().customPrint(
                                        'ProgressBarClick: showProgress run process');
                                    //event calling..................
                                    Map<String, Object> map_clevertap =
                                        new Map<String, Object>();

                                    Map<String, Object> map_clevertap_f =
                                        new Map<String, Object>();

                                    if (walletPageController.promocode.value !=
                                            null &&
                                        walletPageController.promocode.value !=
                                            '') {
                                      map_clevertap["USER_ID"] =
                                          walletPageController.user_id;
                                      map_clevertap["Code Name"] =
                                          walletPageController.promocode.value;
                                      map_clevertap["Code target wallet"] =
                                          walletPageController
                                              .walletTypePromocode;
                                      map_clevertap["Code percentage"] =
                                          walletPageController
                                              .percentagePromocode;

                                      map_clevertap_f["USER_ID"] =
                                          walletPageController.user_id;
                                      map_clevertap_f["Code_Name"] =
                                          walletPageController.promocode.value;
                                      map_clevertap_f["Code_target_wallet"] =
                                          walletPageController
                                              .walletTypePromocode;
                                      map_clevertap_f["Code_percentage"] =
                                          walletPageController
                                              .percentagePromocode;
                                    }
                                    map_clevertap["Amount"] =
                                        walletPageController.selectAmount
                                            .value; //new event added

                                    map_clevertap_f["Amount"] =
                                        walletPageController.selectAmount.value;

                                    cleverTapController.logEventCT(
                                        EventConstant
                                            .EVENT_CLEAVERTAB_Deposit_Initiated,
                                        map_clevertap);

                                    FirebaseEvent().firebaseEvent(
                                        EventConstant
                                            .EVENT_FIREBASE_Deposit_Initiated_f,
                                        map_clevertap_f);

                                    //appsflyer
                                    Map<String, Object> map_appsflyer =
                                        new Map<String, Object>();
                                    map_appsflyer["USER_NAME"] = _userController
                                        .profileDataRes.value.username;
                                    map_appsflyer["USER_ID"] =
                                        _userController.profileDataRes.value.id;
                                    map_appsflyer["EVENT"] = EventConstant
                                        .EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;
                                    AppsflyerController appsflyerController =
                                        Get.put(AppsflyerController());
                                    appsflyerController.logEventAf(
                                        EventConstant
                                            .EVENT_CLEAVERTAB_Deposit_Initiated,
                                        map_appsflyer);

                                    //facebook
                                    Map<String, Object> map_fb =
                                        new Map<String, Object>();
                                    map_fb["USER_NAME"] = _userController
                                        .profileDataRes.value.username;
                                    map_fb["USER_ID"] =
                                        _userController.profileDataRes.value.id;
                                    map_fb["EVENT"] = EventConstant
                                        .EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;

                                    //facebook event work //ravi
                                    map_fb["EVENT_PARAM_CURRENCY"] = "INR";
                                    map_fb["EVENT_PARAM_CONTENT_TYPE"] =
                                        "product";
                                    map_fb["EVENT_PARAM_CONTENT"] =
                                        "[{\"id\": \"12345\", \"quantity\": 1}]";
                                    map_fb["EVENT_NAME_PURCHASE"] =
                                        walletPageController.selectAmount
                                            .value; //<< this line is imp
                                    //end

                                    FaceBookEventController().logEventFacebook(
                                        EventConstant
                                            .EVENT_CLEAVERTAB_Deposit_Initiated,
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
                                            "${_userController.profileDataRes.value.username}",
                                        "client_user_agent": "",
                                        "external_id": [
                                          _userController
                                              .profileDataRes.value.id
                                        ],
                                      },
                                      "custom_data": {}
                                    };
                                    FacebookEventApi().FacebookEventC(params);

                                    //end event calling..............

                                    //API call
                                    final param = {
                                      "amount": walletPageController
                                              .selectAmount.value
                                              .toString() +
                                          "00",
                                      "currency": "INR",
                                      'email': walletPageController.profileDataRes
                                                      .value.email !=
                                                  null &&
                                              walletPageController
                                                      .profileDataRes
                                                      .value
                                                      .email
                                                      .address !=
                                                  null &&
                                              walletPageController
                                                      .profileDataRes
                                                      .value
                                                      .email
                                                      .address !=
                                                  ''
                                          ? walletPageController.profileDataRes
                                              .value.email.address
                                          : 'support@gmng.pro',
                                      "contact": walletPageController
                                          .profileDataRes.value.mobile.number
                                          .toString(),
                                      "method": "upi",
                                      "vpa": {"intent": true},
                                      "description": "UPI Deposit",
                                      "promoCode": walletPageController
                                                  .promocode.value !=
                                              ""
                                          ? walletPageController.promocode.value
                                          : "",
                                      "notes": {
                                        "userId": cashFreeController.user_id
                                      }
                                    };
                                    await cashFreeController.paymentGatewayNew(
                                        context,
                                        param,
                                        cashFreeController.upiSource);
                                    //status API call after few minutes
                                    Future.delayed(const Duration(seconds: 30),
                                        () {
                                      //Fluttertoast.showToast(msg: 'UPI Intent after 15 sec...');
                                      Utils().customPrint(
                                          'UPI Intent after 30 sec...');
                                      if (cashFreeController.upiSource ==
                                          'razorpay') {
                                        try {
                                          final param = {
                                            "paymentId": cashFreeController
                                                .razorpayResponseModel
                                                .data
                                                .checkPayment
                                                .paymentId,
                                            "orderId": cashFreeController
                                                .razorpayResponseModel
                                                .data
                                                .checkPayment
                                                .orderId,
                                            "userId": cashFreeController
                                                .razorpayResponseModel
                                                .data
                                                .checkPayment
                                                .userId,
                                            "gateway": cashFreeController
                                                .razorpayResponseModel
                                                .data
                                                .checkPayment
                                                .gateway
                                          };
                                          cashFreeController
                                              .paymentGatewayStatusNew(
                                                  context,
                                                  param,
                                                  cashFreeController.upiSource);
                                          //second timer
                                          /*Future.delayed(const Duration(seconds: 20), () {
                                          Utils().customPrint(
                                              'UPI Intent after 15 sec...');
                                          cashFreeController.paymentGatewayStatusNew(context, param, cashFreeController.upiSource);
                                        });*/
                                        } catch (e) {
                                          //Utils().customPrint('UPI Intent after 15 sec...ERROR');
                                          Fluttertoast.showToast(
                                              msg:
                                                  'UPI Intent after 15 sec... ${e.toString()}');
                                        }
                                      } else {
                                        try {
                                          final param = {
                                            "paymentId": cashFreeController
                                                .cashFreeResponseModel
                                                .data
                                                .checkPayment
                                                .paymentId,
                                            "orderId": cashFreeController
                                                .cashFreeResponseModel
                                                .data
                                                .checkPayment
                                                .orderId,
                                            "userId": cashFreeController
                                                .cashFreeResponseModel
                                                .data
                                                .checkPayment
                                                .userId,
                                            "gateway": cashFreeController
                                                .cashFreeResponseModel
                                                .data
                                                .checkPayment
                                                .gateway
                                          };
                                          cashFreeController
                                              .paymentGatewayStatusNew(
                                                  context,
                                                  param,
                                                  cashFreeController.upiSource);
                                          //second timer
                                          /*Future.delayed(const Duration(seconds: 20), () {
                                          Utils().customPrint(
                                              'UPI Intent after 15 sec...');
                                          cashFreeController.paymentGatewayStatusNew(context, param, cashFreeController.upiSource);
                                        });*/
                                        } catch (e) {
                                          Utils().customPrint(
                                              'UPI Intent after 30 sec...ERROR');
                                          Fluttertoast.showToast(
                                              msg:
                                                  'UPI Intent after 30 sec... ${e.toString()}');
                                        }
                                      }
                                    });
                                  } catch (e) {
                                    Fluttertoast.showToast(msg: e.toString());
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 110,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          boxShadow: [
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
                                              color: AppColor().whiteColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          // color: AppColor().whiteColor
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              ImageRes().triangle_rupees,
                                              height: 12,
                                              width: 20,
                                              fit: BoxFit.fill,
                                            ),
                                            Text(
                                              "${walletPageController.selectAmount.value}",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_very_small15,
                                                  color: AppColor().whiteColor,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
      /*WALLET*/
      Obx(() => Visibility(
            visible: cashFreeController.walletList != null &&
                    cashFreeController.walletList.value.length > 0
                ? true
                : false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Wallets".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: FontSizeC().front_regular16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: AppColor().colorPrimary_dark),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    //height: 75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor().grey_other, width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cashFreeController.walletList.value.length > 0
                            ? Container(
                                height: 75,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cashFreeController
                                        .walletList.value.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return walletCardView(context, index);
                                    }),
                              )
                            : Container(
                                height: 70,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("App Not Found".tr,
                                      style: TextStyle(
                                          fontSize: FontSizeC().front_regular16,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          color: AppColor().whiteColor)),
                                ),
                              ),
                        click_wallet == true
                            ? GestureDetector(
                                onTap: () {
                                  //Fluttertoast.showToast(msg: 'click payment btn!');
                                  if (walletPageController.selectAmount.value ==
                                          "" ||
                                      walletPageController.selectAmount.value ==
                                          "0") {
                                    Fluttertoast.showToast(
                                        msg: "Please enter amount!".tr);
                                    return;
                                  }
                                  int amountInt = int.parse(
                                      walletPageController.selectAmount.value);
                                  if (amountInt < 10) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Minimum Deposit Amount Must be 10₹!"
                                                .tr);
                                    return;
                                  }
                                  if (walletPageController
                                          .selectAmount.value.length >
                                      7) {
                                    Fluttertoast.showToast(
                                        msg: "Deposit limit exceeded!".tr);
                                    return;
                                  }
                                  if (isRedundentClick(DateTime.now())) {
                                    Utils().customPrint(
                                        'ProgressBarClick: showProgress click');
                                    return;
                                  }
                                  Utils().customPrint(
                                      'ProgressBarClick: showProgress run process');
                                  //event calling..................
                                  Map<String, Object> map_clevertap =
                                      new Map<String, Object>();
                                  Map<String, Object> map_clevertap_f =
                                      new Map<String, Object>();

                                  if (walletPageController.promocode.value !=
                                          null &&
                                      walletPageController.promocode.value !=
                                          '') {
                                    map_clevertap["USER_ID"] =
                                        _userController.profileDataRes.value.id;
                                    map_clevertap["Code Name"] =
                                        walletPageController.promocode.value;
                                    map_clevertap["Code target wallet"] =
                                        walletPageController
                                            .walletTypePromocode;
                                    map_clevertap["Code percentage"] =
                                        walletPageController
                                            .percentagePromocode;

                                    // firebase

                                    map_clevertap_f["USER_ID"] =
                                        _userController.profileDataRes.value.id;
                                    map_clevertap_f["Code_Name"] =
                                        walletPageController.promocode.value;
                                    map_clevertap_f["Code_target_wallet"] =
                                        walletPageController
                                            .walletTypePromocode;
                                    map_clevertap_f["Code_percentage"] =
                                        walletPageController
                                            .percentagePromocode;
                                  }
                                  map_clevertap["Amount"] = walletPageController
                                      .selectAmount.value; //new event added

                                  cleverTapController.logEventCT(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Deposit_Initiated,
                                      map_clevertap);

                                  map_clevertap_f["Amount"] =
                                      walletPageController.selectAmount.value;

                                  FirebaseEvent().firebaseEvent(
                                      EventConstant
                                          .EVENT_FIREBASE_Deposit_Initiated_f,
                                      map_clevertap_f);

                                  //appsflyer
                                  Map<String, Object> map_appsflyer =
                                      new Map<String, Object>();
                                  map_appsflyer["USER_NAME"] = _userController
                                      .profileDataRes.value.username;
                                  map_appsflyer["USER_ID"] =
                                      _userController.profileDataRes.value.id;
                                  map_appsflyer["EVENT"] = EventConstant
                                      .EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;
                                  AppsflyerController appsflyerController =
                                      Get.put(AppsflyerController());
                                  appsflyerController.logEventAf(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Deposit_Initiated,
                                      map_appsflyer);

                                  //facebook
                                  Map<String, Object> map_fb =
                                      new Map<String, Object>();
                                  map_fb["USER_NAME"] = _userController
                                      .profileDataRes.value.username;
                                  map_fb["USER_ID"] =
                                      _userController.profileDataRes.value.id;
                                  map_fb["EVENT"] = EventConstant
                                      .EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;

                                  //facebook event work //ravi
                                  map_fb["EVENT_PARAM_CURRENCY"] = "INR";
                                  map_fb["EVENT_PARAM_CONTENT_TYPE"] =
                                      "product";
                                  map_fb["EVENT_PARAM_CONTENT"] =
                                      "[{\"id\": \"12345\", \"quantity\": 1}]";
                                  map_fb["EVENT_NAME_PURCHASE"] =
                                      walletPageController.selectAmount
                                          .value; //<< this line is imp
                                  //end

                                  FaceBookEventController().logEventFacebook(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Deposit_Initiated,
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
                                          "${_userController.profileDataRes.value.username}",
                                      "client_user_agent": "",
                                      "external_id": [
                                        _userController.profileDataRes.value.id
                                      ],
                                    },
                                    "custom_data": {}
                                  };
                                  FacebookEventApi().FacebookEventC(params);
                                  //API call
                                  final param = {
                                    "amount": walletPageController
                                            .selectAmount.value
                                            .toString() +
                                        "00",
                                    "currency": "INR",
                                    'email': walletPageController.profileDataRes
                                                    .value.email !=
                                                null &&
                                            walletPageController.profileDataRes
                                                    .value.email.address !=
                                                null &&
                                            walletPageController.profileDataRes
                                                    .value.email.address !=
                                                ''
                                        ? walletPageController
                                            .profileDataRes.value.email.address
                                        : 'support@gmng.pro',
                                    "contact": walletPageController
                                        .profileDataRes.value.mobile.number
                                        .toString(),
                                    "method": "wallet",
                                    "wallet": selectedWallet,
                                    //need to be dynamic
                                    "description": "Wallet Deposit",
                                    "promoCode": walletPageController
                                                .promocode.value !=
                                            ""
                                        ? walletPageController.promocode.value
                                        : "",
                                    "notes": {
                                      "userId": cashFreeController.user_id
                                    }
                                  };
                                  cashFreeController.paymentGatewayNew(context,
                                      param, cashFreeController.walletSource);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 110,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          boxShadow: [
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
                                              color: AppColor().whiteColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          // color: AppColor().whiteColor
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              ImageRes().triangle_rupees,
                                              height: 12,
                                              width: 20,
                                              fit: BoxFit.fill,
                                            ),
                                            Text(
                                              "${walletPageController.selectAmount.value}",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_very_small15,
                                                  color: AppColor().whiteColor,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
      /*NETBANKING*/
      Obx(() => Visibility(
            visible: cashFreeController.razorPayOrcashFreeBankList != null &&
                    cashFreeController.razorPayOrcashFreeBankList.length > 0
                ? true
                : false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Netbanking".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: FontSizeC().front_regular16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: AppColor().colorPrimary_dark),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    //height: 75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor().grey_other, width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cashFreeController.razorPayOrcashFreeBankList.length > 0
                            ? Container(
                                height: 75,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cashFreeController
                                        .razorPayOrcashFreeBankList.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return netBankingCardView(context, index);
                                    }),
                              )
                            : Container(
                                height: 70,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("App Not Found",
                                      style: TextStyle(
                                          fontSize: FontSizeC().front_regular16,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          color: AppColor().whiteColor)),
                                ),
                              ),
                        click_netbanking == true
                            ? GestureDetector(
                                onTap: () {
                                  //Fluttertoast.showToast(msg: 'click payment btn!');

                                  if (walletPageController.selectAmount.value ==
                                          "" ||
                                      walletPageController.selectAmount.value ==
                                          "0") {
                                    Fluttertoast.showToast(
                                        msg: "Please enter amount!".tr);
                                    return;
                                  }
                                  int amountInt = int.parse(
                                      walletPageController.selectAmount.value);
                                  if (amountInt < 10) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Minimum Deposit Amount Must be 10₹!"
                                                .tr);
                                    return;
                                  }
                                  if (walletPageController
                                          .selectAmount.value.length >
                                      7) {
                                    Fluttertoast.showToast(
                                        msg: "Deposit limit exceeded!".tr);
                                    return;
                                  }
                                  if (isRedundentClick(DateTime.now())) {
                                    Utils().customPrint(
                                        'ProgressBarClick: showProgress click');
                                    return;
                                  }
                                  Utils().customPrint(
                                      'ProgressBarClick: showProgress run process');

                                  //event calling..................
                                  Map<String, Object> map_clevertap =
                                      new Map<String, Object>();
                                  Map<String, Object> map_clevertap_f =
                                      new Map<String, Object>();

                                  if (walletPageController.promocode.value !=
                                          null &&
                                      walletPageController.promocode.value !=
                                          '') {
                                    map_clevertap["USER_ID"] =
                                        walletPageController.user_id;
                                    map_clevertap["Code Name"] =
                                        walletPageController.promocode.value;
                                    map_clevertap["Code target wallet"] =
                                        walletPageController
                                            .walletTypePromocode;
                                    map_clevertap["Code percentage"] =
                                        walletPageController
                                            .percentagePromocode;

                                    map_clevertap_f["USER_ID"] =
                                        walletPageController.user_id;
                                    map_clevertap_f["Code_Name"] =
                                        walletPageController.promocode.value;
                                    map_clevertap_f["Code_target_wallet"] =
                                        walletPageController
                                            .walletTypePromocode;
                                    map_clevertap_f["Code_percentage"] =
                                        walletPageController
                                            .percentagePromocode;
                                  }
                                  map_clevertap["Amount"] = walletPageController
                                      .selectAmount.value; //new event added

                                  map_clevertap_f["Amount"] =
                                      walletPageController.selectAmount.value;
                                  cleverTapController.logEventCT(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Deposit_Initiated,
                                      map_clevertap);
                                  FirebaseEvent().firebaseEvent(
                                      EventConstant
                                          .EVENT_FIREBASE_Deposit_Initiated_f,
                                      map_clevertap_f);

                                  //appsflyer
                                  Map<String, Object> map_appsflyer =
                                      new Map<String, Object>();
                                  map_appsflyer["USER_NAME"] = _userController
                                      .profileDataRes.value.username;
                                  map_appsflyer["USER_ID"] =
                                      _userController.profileDataRes.value.id;
                                  map_appsflyer["EVENT"] = EventConstant
                                      .EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;
                                  AppsflyerController appsflyerController =
                                      Get.put(AppsflyerController());
                                  appsflyerController.logEventAf(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Deposit_Initiated,
                                      map_appsflyer);

                                  //facebook
                                  Map<String, Object> map_fb =
                                      new Map<String, Object>();
                                  map_fb["USER_NAME"] = _userController
                                      .profileDataRes.value.username;
                                  map_fb["USER_ID"] =
                                      _userController.profileDataRes.value.id;
                                  map_fb["EVENT"] = EventConstant
                                      .EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;

                                  //facebook event work //ravi
                                  map_fb["EVENT_PARAM_CURRENCY"] = "INR";
                                  map_fb["EVENT_PARAM_CONTENT_TYPE"] =
                                      "product";
                                  map_fb["EVENT_PARAM_CONTENT"] =
                                      "[{\"id\": \"12345\", \"quantity\": 1}]";
                                  map_fb["EVENT_NAME_PURCHASE"] =
                                      walletPageController.selectAmount
                                          .value; //<< this line is imp
                                  //end

                                  FaceBookEventController().logEventFacebook(
                                      EventConstant
                                          .EVENT_CLEAVERTAB_Deposit_Initiated,
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
                                          "${_userController.profileDataRes.value.username}",
                                      "client_user_agent": "",
                                      "external_id": [
                                        _userController.profileDataRes.value.id
                                      ],
                                    },
                                    "custom_data": {}
                                  };
                                  FacebookEventApi().FacebookEventC(params);

                                  //API call
                                  final param = {
                                    "amount": walletPageController
                                            .selectAmount.value
                                            .toString() +
                                        "00",
                                    "currency": "INR",
                                    'email': walletPageController.profileDataRes
                                                    .value.email !=
                                                null &&
                                            walletPageController.profileDataRes
                                                    .value.email.address !=
                                                null &&
                                            walletPageController.profileDataRes
                                                    .value.email.address !=
                                                ''
                                        ? walletPageController
                                            .profileDataRes.value.email.address
                                        : 'support@gmng.pro',
                                    "contact": walletPageController
                                        .profileDataRes.value.mobile.number
                                        .toString(),
                                    "method": "netbanking",
                                    "bank": selectedBank, //need to be dynamic
                                    "description": "Netbanking Deposit",
                                    "promoCode": walletPageController
                                                .promocode.value !=
                                            ""
                                        ? walletPageController.promocode.value
                                        : "",
                                    "notes": {
                                      "userId": cashFreeController.user_id
                                    }
                                  };
                                  cashFreeController.paymentGatewayNew(
                                      context,
                                      param,
                                      cashFreeController.netbankingSource);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 110,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          boxShadow: [
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
                                              color: AppColor().whiteColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          // color: AppColor().whiteColor
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              ImageRes().triangle_rupees,
                                              height: 12,
                                              width: 20,
                                              fit: BoxFit.fill,
                                            ),
                                            Text(
                                              "${walletPageController.selectAmount.value}",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_very_small15,
                                                  color: AppColor().whiteColor,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
      /*CARD*/
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Cards".tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: FontSizeC().front_regular16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: AppColor().colorPrimary_dark),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              if (walletPageController.selectAmount.value == "" ||
                  walletPageController.selectAmount.value == "0") {
                Fluttertoast.showToast(msg: "Please enter amount!".tr);
                return;
              }
              int amountInt =
                  int.parse(walletPageController.selectAmount.value);
              if (amountInt < 10) {
                Fluttertoast.showToast(
                    msg: "Minimum Deposit Amount Must be 10₹!".tr);
                return;
              }
              if (walletPageController.selectAmount.value.length > 7) {
                Fluttertoast.showToast(msg: "Deposit limit exceeded!".tr);
                return;
              }

              //event calling..................
              Map<String, Object> map_clevertap = new Map<String, Object>();

              if (walletPageController.promocode.value != null &&
                  walletPageController.promocode.value != '') {
                map_clevertap["Code Name"] =
                    walletPageController.promocode.value;
                map_clevertap["Code target wallet"] =
                    walletPageController.walletTypePromocode;
                map_clevertap["Code percentage"] =
                    walletPageController.percentagePromocode;
                map_clevertap["USER_ID"] = walletPageController.user_id;
              }
              map_clevertap["Amount"] =
                  walletPageController.selectAmount.value; //new event added

              cleverTapController.logEventCT(
                  EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                  map_clevertap);

              //appsflyer
              Map<String, Object> map_appsflyer = new Map<String, Object>();
              map_appsflyer["USER_NAME"] =
                  _userController.profileDataRes.value.username;
              map_appsflyer["USER_ID"] =
                  _userController.profileDataRes.value.id;
              map_appsflyer["EVENT"] =
                  EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;
              AppsflyerController appsflyerController =
                  Get.put(AppsflyerController());
              appsflyerController.logEventAf(
                  EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                  map_appsflyer);

              //facebook
              Map<String, Object> map_fb = new Map<String, Object>();
              map_fb["USER_NAME"] =
                  _userController.profileDataRes.value.username;
              map_fb["USER_ID"] = _userController.profileDataRes.value.id;
              map_fb["EVENT"] =
                  EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;

              //facebook event work //ravi
              map_fb["EVENT_PARAM_CURRENCY"] = "INR";
              map_fb["EVENT_PARAM_CONTENT_TYPE"] = "product";
              map_fb["EVENT_PARAM_CONTENT"] =
                  "[{\"id\": \"12345\", \"quantity\": 1}]";
              map_fb["EVENT_NAME_PURCHASE"] =
                  walletPageController.selectAmount.value; //<< this line is imp
              //end

              FaceBookEventController().logEventFacebook(
                  EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated, map_fb);

              final params = {
                "event_name":
                    "${EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM}",
                "event_time": "${DateTime.now().millisecondsSinceEpoch}",
                "event_id": "",
                "action_source": "App",
                "user_data": {
                  "client_ip_address":
                      "${_userController.profileDataRes.value.username}",
                  "client_user_agent": "",
                  "external_id": [_userController.profileDataRes.value.id],
                },
                "custom_data": {}
              };
              FacebookEventApi().FacebookEventC(params);

              //end event calling..............
              walletPageController.payment_method = 'Card';
              if (cashFreeController.cardSource.value == "cashfree") {
                cashFreeController.createOrderRazorepay(
                    context,
                    walletPageController.promocode.value,
                    walletPageController.selectAmount.value,
                    walletPageController.profileDataRes.value.username,
                    (walletPageController.profileDataRes.value.email != null &&
                            walletPageController
                                    .profileDataRes.value.email.address !=
                                null)
                        ? walletPageController
                            .profileDataRes.value.email.address
                        : "",
                    walletPageController.profileDataRes.value.mobile.number
                        .toString());
              } else {
                walletPageController.createOrderRazorepay(
                    context, walletPageController.selectAmount.value);
              }

              /* Fluttertoast.showToast(
                      msg: 'Need to integrate both RazorPay & Cashfree SDK!');*/
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              height: 75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor().grey_other, width: 1.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 8),
                    child: Text(
                      "Add Debit / Credit Card".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: FontSizeC().front_very_small14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          color: AppColor().reward_grey_bg),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Image(
                        height: 20,
                        width: 200,
                        image: AssetImage('assets/images/card_multiple.png'),
                        //fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ];
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Image(
          height: 80,
          image: AssetImage('assets/images/offerwall_header.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Container(
            height: 80,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Add Money".tr,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                    ),
                  ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {
                        if (walletPageController.selectAmount.value == "" ||
                            walletPageController.selectAmount.value == "0") {
                          Fluttertoast.showToast(
                              msg: "Please enter amount!".tr);
                          Utils().alertOldWallet(context);
                          return;
                        }
                        int amountInt =
                            int.parse(walletPageController.selectAmount.value);
                        if (amountInt < 10) {
                          Fluttertoast.showToast(
                              msg: "Minimum Deposit Amount Must be 10₹!".tr);
                          return;
                        }
                        if (walletPageController.selectAmount.value.length >
                            7) {
                          Fluttertoast.showToast(
                              msg: "Deposit limit exceeded!".tr);
                          return;
                        }
                        if (isRedundentClick(DateTime.now())) {
                          Utils().customPrint(
                              'ProgressBarClick: showProgress click');
                          return;
                        }
                        Utils().customPrint(
                            'ProgressBarClick: showProgress run process');
                        walletPageController.payment_method =
                            'Old-Payment-Method';
                        walletPageController.createOrderRazorepayOld(
                            context, walletPageController.selectAmount.value);
                      },
                      child: Image(
                        height: 130,
                        width: MediaQuery.of(context).size.width,
                        image:
                            AssetImage("assets/images/old_method_banner.png"),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Visibility(
                  visible: !walletPageController.applyPress.value,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 30),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: AppColor().whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                ),
                                controller: cashFreeController
                                    .amountCashTextController.value,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: AppColor().reward_grey_bg),
                                    ),
                                    //[focusedBorder], displayed when [TextField, InputDecorator.isFocused] is true
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: AppColor().colorPrimary),
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    hintStyle: TextStyle(
                                      color: AppColor().whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                    ),
                                    hintText: "Enter Amount".tr),
                                onChanged: (text) {
                                  Utils().customPrint("TEST-PROMO  ${text}");
                                  walletPageController.typeTextCheck.value = 0;
                                  if (text.length == 0) {
                                    AppString.contestAmount = 0;
                                    walletPageController.typeTextCheck.value =
                                        0;
                                    walletPageController.profitAmt.value = 0;
                                    walletPageController.selectAmount.value =
                                        "0";
                                    walletPageController
                                        .amountTextController.value.text = "";
                                    /* cashFreeController.amountCashTextController
                                        .value.text = "";*/
                                  } else if (text.length > 0) {
                                    promocodeAutoFilled(text);
                                  }
                                }
                                //autofocus: true,
                                ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                //Fluttertoast.showToast(msg: 'click!');
                                if (cashFreeController.click_remove_code) {
                                  cashFreeController.click_remove_code = false;
                                  walletPageController.boolEnterCode.value =
                                      false;
                                } else {
                                  cashFreeController.click_remove_code = true;
                                  walletPageController.boolEnterCode.value =
                                      true;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10, top: 5, bottom: 5),
                                  child: Center(
                                    child: Text(
                                        walletPageController.applyPress.value ==
                                                false
                                            ? "Have Code?".tr
                                            : "Remove Code".tr,
                                        style: TextStyle(
                                          color: AppColor().colorPrimary,
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
                ),
              ),
              /*enter code*/
              Obx(
                () => Visibility(
                  visible: walletPageController.applyPress.value,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              if (cashFreeController.click_remove_code) {
                                cashFreeController.click_remove_code = false;
                                walletPageController.boolEnterCode.value =
                                    false;
                                walletPageController.applyPress.value = false;
                                walletPageController.promocode.value = "";

                                cashFreeController
                                        .amountCashTextController.value.text =
                                    walletPageController.selectAmount.value;
                              } else {
                                cashFreeController.click_remove_code = true;
                                walletPageController.boolEnterCode.value = true;
                                walletPageController.applyPress.value = true;
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10.0, top: 20),
                              child: Container(
                                height: 55,
                                width: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      AppColor().clan_header_dark,
                                      AppColor().clan_header_dark,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  // color: AppColor().whiteColor
                                ),
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 0, bottom: 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("DEPOSIT".tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                            color: AppColor().grey_li,
                                            fontSize: 12,
                                          )),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          "${walletPageController.selectAmount.value}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                            color: AppColor().whiteColor,
                                            fontSize: 19,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0.0, top: 20),
                            child: Container(
                              height: 55,
                              width: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().clan_header_dark,
                                    AppColor().clan_header_dark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                // color: AppColor().whiteColor
                              ),
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 0, bottom: 0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("GET".tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                          color: AppColor().grey_li,
                                          fontSize: 12,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  walletPageController.promo_type.value ==
                                          'bonus'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                  "${walletPageController.selectAmount.value}D+",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Montserrat",
                                                    color: AppColor()
                                                        .green_color_light,
                                                    fontSize: 20,
                                                  )),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                  "${walletPageController.promo_amt.value.toStringAsFixed(0)}B",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Montserrat",
                                                    color:
                                                        AppColor().yellow_color,
                                                    fontSize: 20,
                                                  )),
                                            ),
                                          ],
                                        )
                                      : Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                              "${walletPageController.profitAmt.value.toStringAsFixed(0)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat",
                                                color: AppColor()
                                                    .green_color_light,
                                                fontSize: 20,
                                              )),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              //Fluttertoast.showToast(msg: 'click!');
                              if (cashFreeController.click_remove_code) {
                                cashFreeController.click_remove_code = false;
                                walletPageController.boolEnterCode.value =
                                    false;
                                walletPageController.applyPress.value = false;
                                walletPageController.typeTextCheck.value = 0;
                                walletPageController.applyPress.value = false;
                                click_upi = false.obs;
                                click_wallet = false.obs;
                                click_netbanking = false.obs;
                                walletPageController.selectAmount.value = "0";
                                walletPageController.promocode.value = "";
                                cashFreeController
                                    .amountCashTextController.value.text = "";
                                walletPageController.buttonApplyText.value =
                                    'Apply'.tr;
                                Fluttertoast.showToast(
                                    msg: 'Promocode removed!'.tr);
                                walletPageController
                                    .gameListSelectedColor.value = 10000;
                              } else {
                                cashFreeController.click_remove_code = true;
                                walletPageController.boolEnterCode.value = true;
                                walletPageController.applyPress.value = true;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 20),
                              child: Container(
                                height: 80,
                                width: 100,
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 5, top: 5, bottom: 5),
                                child: Center(
                                  child: Text(
                                      walletPageController.applyPress.value ==
                                              false
                                          ? "Have Code?".tr
                                          : "Remove Code".tr,
                                      style: TextStyle(
                                        color: AppColor().red,
                                        fontSize: 14,
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
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => Visibility(
                  visible: walletPageController.boolEnterCode.value,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor().grey_other, width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              textCapitalization: TextCapitalization.characters,
                              textAlign: TextAlign.center,
                              //keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                              ),
                              //controller: walletPageController.havCodeController.value,
                              //controller: walletPageController.amountTextController.value,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                  ),
                                  hintText: "Enter Code".tr),
                              onChanged: (text) {
                                walletPageController.promocode.value = text;
                              },
                              //autofocus: true,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //here we are using some extra variables but they are of no use, we will figure it out later!
                            walletPageController.gameAmtSelectedColor.value = 0;
                            walletPageController.amtAfterPromoApplied.value = 0;
                            walletPageController.gameListSelectedColor.value =
                                1000;
                            walletPageController.youWillGet.value = '';
                            //walletPageController.click = false;

                            if (walletPageController.buttonApplyText.value ==
                                'Remove') {
                              //click = false;
                              walletPageController.amtAfterPromoApplied.value =
                                  0;
                              walletPageController.gameListSelectedColor.value =
                                  1000;
                              walletPageController.youWillGet.value = '';
                              walletPageController.walletTypePromocode = '';
                              walletPageController.percentagePromocode = '';
                              walletPageController.buttonApplyText.value =
                                  'Apply'.tr;
                              Fluttertoast.showToast(msg: "Offer Removed!".tr);
                              walletPageController.promocode.value = '';
                              walletPageController
                                  .havCodeController.value.text = '';
                              //setState(() {});
                              return;
                            }

                            if (walletPageController.selectAmount.value == "" ||
                                walletPageController.selectAmount.value ==
                                    "0") {
                              Fluttertoast.showToast(
                                  msg: "Please enter amount!".tr);
                              return;
                            }
                            int amountInt = int.parse(
                                walletPageController.selectAmount.value);
                            if (amountInt < 10) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Minimum Deposit Amount Must be 10₹!".tr);
                              return;
                            }
                            if (walletPageController.selectAmount.value.length >
                                7) {
                              Fluttertoast.showToast(
                                  msg: "Deposit limit exceeded!".tr);
                              return;
                            }
                            print(
                                'TEST PROMO: ${walletPageController.promocode.value}');
                            if (walletPageController.promocode.value == '') {
                              Fluttertoast.showToast(
                                  msg: "Please enter code!".tr);
                            } else {
                              //code checking for offline codes
                              bool temp = false;
                              for (int i = 0;
                                  i <
                                      walletPageController
                                          .walletModelPromoFull.data.length;
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
                                      walletPageController.selectAmount.value);
                                  double fromValue = double.parse(
                                      walletPageController.walletModelPromoFull
                                          .data[i].fromValue);
                                  double toValue = double.parse(
                                      walletPageController.walletModelPromoFull
                                          .data[i].toValue);
                                  Utils().customPrint(
                                      'Offer Valid F ${fromValue}');
                                  Utils()
                                      .customPrint('Offer Valid T ${toValue}');

                                  if (enterAmtInt < fromValue) {
                                    Fluttertoast.showToast(
                                        textColor: Colors.red,
                                        msg: 'Offer Valid On Deposit for'.tr +
                                            ' ${walletPageController.walletModelPromoFull.data[i].fromValue} - ${walletPageController.walletModelPromoFull.data[i].toValue} Rs!');
                                    return;
                                  } else if (enterAmtInt > toValue) {
                                    Fluttertoast.showToast(
                                        textColor: Colors.red,
                                        msg: 'Offer Valid On Deposit for'.tr +
                                            ' ${walletPageController.walletModelPromoFull.data[i].fromValue} - ${walletPageController.walletModelPromoFull.data[i].toValue} Rs!');
                                    return;
                                  }

                                  //promo code
                                  promo_code_not_visible(
                                      walletPageController.selectAmount.value,
                                      i,
                                      context);
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
                                    msg: "Offer Applied!".tr);
                                //Navigator.pop(context);
                              } else if (temp == false) {
                                Fluttertoast.showToast(
                                    msg: "Offer Invalid!".tr);
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().clan_header_dark,
                                    AppColor().clan_header_dark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                // color: AppColor().whiteColor
                              ),
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 5, bottom: 5),
                              child: Center(
                                child: Text(
                                    walletPageController.buttonApplyText.value
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: AppColor().colorPrimary,
                                      fontSize: 14,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColor().grey_other, width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Obx(
                            () => Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: walletPageController.applyPress.value ==
                                        false
                                    ? Container(child: Obx(() {
                                        if (walletPageController
                                                .typeTextCheck ==
                                            1) {
                                          return Wrap(
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text("Get ".tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 12,
                                                    )),
                                                Text(
                                                    "${walletPageController.promo_amt.value.toStringAsFixed(0) /*walletPageController.profitAmt.toStringAsFixed(0)*/} ${walletPageController.promo_type} ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color: AppColor()
                                                          .green_color_light,
                                                      fontSize: 13,
                                                    )),
                                                Text("Cashback".tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 12,
                                                    )),
                                                Text(" By Depositing ".tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 12,
                                                    )),
                                                Text(
                                                    "${walletPageController.promo_minus_amt.value} ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color: AppColor()
                                                          .colorPrimary,
                                                      fontSize: 12,
                                                    )),
                                                Text("More Rupees".tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 12,
                                                    ))
                                              ]);
                                        } else if (walletPageController
                                                .typeTextCheck ==
                                            2) {
                                          return Wrap(
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text("Get ".tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 12,
                                                    )),
                                                Text(
                                                    walletPageController
                                                                .promo_type
                                                                .value ==
                                                            'bonus'
                                                        ? "${walletPageController.promo_amt.value.toStringAsFixed(0)} ${walletPageController.promo_type} "
                                                        : "${walletPageController.profitAmt.toStringAsFixed(0)} ${walletPageController.promo_type} ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color: AppColor()
                                                          .green_color_light,
                                                      fontSize: 13,
                                                    )),
                                                Text("Cashback".tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 12,
                                                    ))
                                              ]);
                                        } else {
                                          return Wrap(
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(
                                                    "Deposit Now And Play Your Favorite Games"
                                                        .tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 12,
                                                    )),
                                              ]);
                                        }
                                      }))
                                    : Container(child: Obx(() {
                                        return Wrap(
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text("Code ".tr,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Montserrat",
                                                    color:
                                                        AppColor().whiteColor,
                                                    fontSize: 12,
                                                  )),
                                              Text(
                                                  "${walletPageController.promocode.value} ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Montserrat",
                                                    color:
                                                        AppColor().colorPrimary,
                                                    fontSize: 12,
                                                  ))
                                            ]);
                                      }))),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: walletPageController.typeTextCheck == 0
                                ? false
                                : true,
                            child: GestureDetector(
                              onTap: () {
                                //Fluttertoast.showToast(msg: 'click applied');
                                walletPageController.applyPress.value = true;
                                walletPageController.buttonApplyText.value =
                                    'Apply';
                                walletPageController.boolEnterCode.value =
                                    false;
                                cashFreeController.click_remove_code = true;
                                if (cashFreeController.promocodeValue >
                                    int.parse(walletPageController
                                        .selectAmount.value)) {
                                  walletPageController.selectAmount.value =
                                      cashFreeController.promocodeValue
                                          .toString();
                                }

                                walletPageController.promocode.value =
                                    cashFreeController.promocodeHelper.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Container(
                                  height: 30,
                                  width: 95,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        AppColor().clan_header_dark,
                                        AppColor().clan_header_dark,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    // color: AppColor().whiteColor
                                  ),
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10, top: 5, bottom: 5),
                                  child: Center(
                                    child: Text(
                                        walletPageController.applyPress.value ==
                                                false
                                            ? "APPLY".tr
                                            : "APPLIED".tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                          color: AppColor().colorPrimary,
                                          fontSize: 14,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, left: 10, right: 10, bottom: 5),
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
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SvgPicture.asset(
                            ImageRes().view_all_coupon,
                            height: 15,
                            //color: AppColor().whiteColor,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: () {
                              /* if (walletPageController.selectAmount.value ==
                                      "" ||
                                  walletPageController.selectAmount.value ==
                                      "0") {
                                Fluttertoast.showToast(
                                    msg: "Please enter amount!");
                                return;
                              }*/
                              /*  int amountInt = int.parse(
                                  walletPageController.selectAmount.value);
                              if (amountInt < 10) {
                                Fluttertoast.showToast(
                                    msg: "Minimum Deposit Amount Must be 10₹!");
                                return;
                              }*/
                              /* if (walletPageController
                                      .selectAmount.value.length >
                                  7) {
                                Fluttertoast.showToast(
                                    msg: "Deposit limit exceeded!");
                                return;
                              }*/
                              if (walletPageController.walletModelPromo.data !=
                                  null) {
                                Get.to(() => ViewAllPromoCodes());
                              } else {
                                Fluttertoast.showToast(
                                  msg:
                                      "Coupons not found! Please try again!".tr,
                                );
                              }
                            },
                            child: Text("View more coupons > ".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: AppColor().optional_payment,
                                  fontSize: 12,
                                )),
                          ),
                        ),
                        Expanded(flex: 1, child: Text('')),
                      ],
                    )
                  ],
                ),
              ),
              //end promo codes
              //payment code
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Select Payment Options".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: FontSizeC().front_very_small15,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          color: AppColor().whiteColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              /*TEST*/
              Obx(() => cashFreeController.cashFreeModel != null &&
                      cashFreeController.cashFreeModel.value.data != null &&
                      cashFreeController
                              .cashFreeModel.value.data.paymentMethods !=
                          null &&
                      cashFreeController
                              .cashFreeModel.value.data.paymentMethods.length >
                          0
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widgetlist.length,
                      itemBuilder: (BuildContext context, index) {
                        return paymentOrderWidget(
                            context,
                            cashFreeController.cashFreeModel.value.data
                                .paymentMethods[index].order,
                            cashFreeController.cashFreeModel.value.data
                                .paymentMethods[index].method);
                      })
                  : Container())
            ],
          ),
        ),
      ),
    ));
  }

  UPIList(BuildContext context, int index) {
    Uint8List _imageBytesDecoded;
    _imageBytesDecoded = Base64Codec()
        .decode(cashFreeController.selectedApp.value[index]["icon"]);
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: GestureDetector(
        onTap: () async {
          //var url = 'upi://pay?pa=9598848185@upi&pn=GMNGEntertainmentPrivateLimited&tr=kovhl0Ap2a839bv&tn=razorpay&am=15&cu=INR&mc=5411';
          //print('testing:: ${url.replaceRange(0, 9, 'amazonToAlipay://pay')}');
          //print('testing:: ${url.replaceRange(0, 3, 'bhim')}');
          //Utils.launchURLApp(url.replaceRange(0, 9, 'amazontoalipay://pay'));
          //Utils.launchURLApp(url.replaceRange(0, 3, 'bhim'));
          //return;

          if (walletPageController.selectAmount.value == "" ||
              walletPageController.selectAmount.value == "0") {
            Fluttertoast.showToast(msg: "Please enter amount!".tr);
            return;
          }
          int amountInt = int.parse(walletPageController.selectAmount.value);
          if (amountInt < 10) {
            Fluttertoast.showToast(
                msg: "Minimum Deposit Amount Must be 10₹!".tr);
            return;
          }
          if (walletPageController.selectAmount.value.length > 7) {
            Fluttertoast.showToast(msg: "Deposit limit exceeded!".tr);
            return;
          }

          //payment_method
          walletPageController.payment_method = 'UPI';
          click_upi.value = true;
          click_wallet.value = false;
          click_netbanking.value = false;
          cashFreeController.upiListSelectedColor.value = index;
          cashFreeController.netBankingListSelectedColor.value = 1000;
          cashFreeController.walletListSelectedColor.value = 1000;
          cashFreeController.selectedUPIApp.value =
              cashFreeController.selectedApp.value[index]['displayName'];
          //Fluttertoast.showToast(msg: 'click upi! ${index} : ${cashFreeController.selectedApp.value[index]['displayName']}');
        },
        child: Container(
          height: 50,
          width: 50,
          child: Center(
            child: Obx(
              () => Container(
                padding: EdgeInsets.all(3),
                decoration:
                    cashFreeController.upiListSelectedColor.value == index
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                width: 2, color: AppColor().colorPrimaryDark))
                        : BoxDecoration(),
                child: _imageBytesDecoded != null
                    ? Image.memory(
                        _imageBytesDecoded,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image),
              ),
            ),
          ),
        ),
      ),
    );
  }

  netBankingCardView(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: GestureDetector(
        onTap: () {
          if (walletPageController.selectAmount.value == "" ||
              walletPageController.selectAmount.value == "0") {
            Fluttertoast.showToast(msg: "Please enter amount!".tr);
            return;
          }
          int amountInt = int.parse(walletPageController.selectAmount.value);
          if (amountInt < 10) {
            Fluttertoast.showToast(
                msg: "Minimum Deposit Amount Must be 10₹!".tr);
            return;
          }
          if (walletPageController.selectAmount.value.length > 7) {
            Fluttertoast.showToast(msg: "Deposit limit exceeded!".tr);
            return;
          }
          walletPageController.payment_method = 'Netbanking';
          click_upi.value = false;
          click_wallet.value = false;
          click_netbanking.value = true;
          cashFreeController.netBankingListSelectedColor.value = index;
          cashFreeController.upiListSelectedColor.value = 1000;
          cashFreeController.walletListSelectedColor.value = 1000;
          selectedBank =
              cashFreeController.razorPayOrcashFreeBankList[index].name;
          //Fluttertoast.showToast(msg: 'Bank: $selectedBank');
        },
        child: Container(
          height: 50,
          width: 50,
          child: Center(
            child: Obx(() => Container(
                  child:
                      cashFreeController.razorPayOrcashFreeBankList.length > 0
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: MediaQuery.of(context).size.height / 15.5,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: cashFreeController
                                            .netBankingListSelectedColor
                                            .value ==
                                        index
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            width: 3,
                                            color: AppColor().colorPrimaryDark))
                                    : BoxDecoration(),
                                child: Image(
                                    height: 35,
                                    width: 35,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(cashFreeController
                                        .razorPayOrcashFreeBankList[index].icon)

                                    // AssetImage('assets/images/images.png'),
                                    ),
                              ),
                            )
                          : Image(
                              image: AssetImage('assets/images/sbi_logo.png'),
                              //fit: BoxFit.cover,
                            ),
                  //Icon(Icons.image),
                )),
          ),
        ),
      ),
    );
  }

  walletCardView(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: GestureDetector(
        onTap: () {
          if (walletPageController.selectAmount.value == "" ||
              walletPageController.selectAmount.value == "0") {
            Fluttertoast.showToast(msg: "Please enter amount!".tr);
            return;
          }
          int amountInt = int.parse(walletPageController.selectAmount.value);
          if (amountInt < 10) {
            Fluttertoast.showToast(
                msg: "Minimum Deposit Amount Must be 10₹!".tr);
            return;
          }
          if (walletPageController.selectAmount.value.length > 7) {
            Fluttertoast.showToast(msg: "Deposit limit exceeded!".tr);
            return;
          }

          walletPageController.payment_method = 'Wallet';
          click_upi.value = false;
          click_wallet.value = true;
          click_netbanking.value = false;

          cashFreeController.walletListSelectedColor.value = index;
          cashFreeController.upiListSelectedColor.value = 1000;
          cashFreeController.netBankingListSelectedColor.value = 1000;
          selectedWallet = cashFreeController.walletList[index].name;
        },
        child: Container(
          height: 50,
          width: 50,
          child: Center(
            child: Obx(() => CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: MediaQuery.of(context).size.height / 15.5,
                  child: Container(
                    decoration:
                        cashFreeController.walletListSelectedColor.value ==
                                index
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    width: 3,
                                    color: AppColor().colorPrimaryDark))
                            : BoxDecoration(),
                    padding: EdgeInsets.all(5),
                    child: Image(
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            cashFreeController.walletList[index].icon)

                        // AssetImage('assets/images/images.png'),
                        ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void promo_code_not_visible(
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
          showCustomDialog(context);

          /////

          //saving values for UI
          //layout hide work & show deposit get UI
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
          try {
            //for cleverTap use
            double percentage = double.parse(walletPageController
                .walletModelPromoFull
                .data[index_promo]
                .benefit[0]
                .wallet[0]
                .percentage);
            walletPageController.percentagePromocode = percentage.toString();
            walletPageController.walletTypePromocode = walletPageController
                .walletModelPromoFull
                .data[index_promo]
                .benefit[0]
                .wallet[0]
                .type;
          } catch (e) {}

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

          Utils().customPrint('PROMOCODES View All *******************  '
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

  //Add UPI bottomsheet
  var upiEnteredController = TextEditingController(text: "").obs;
  Widget showBottomSheetAddUPI(BuildContext context) {
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
                            "Add UPI Address",
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
                    /*  Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Entered UPI ID:',
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),*/
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent),
                      child: TextField(
                        //keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        controller: upiEnteredController.value,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: AppColor().whiteColor),
                            hintText: "Enter UPI ID"),
                        onChanged: (text) async {
                          if (text.length == 0) {
                            cashFreeController.enteredUPIid.value = '';
                            upiEnteredController.value.text = '';
                          } else {
                            cashFreeController.enteredUPIid.value = text;
                          }
                        },
                        //autofocus: true,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _userController.profileDataRes.value.depositMethods !=
                                null &&
                            _userController.profileDataRes.value.depositMethods
                                    .length >
                                0
                        ? Visibility(
                            visible: true,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Saved',
                                        style: TextStyle(
                                          color: AppColor().clan_header_dark,
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _userController.profileDataRes
                                        .value.depositMethods.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return upiListingWidget(context, index);
                                    }),
                              ],
                            ),
                          )
                        : Container(),
                    GestureDetector(
                        onTap: () async {
                          if (cashFreeController.enteredUPIid.value == "" ||
                              cashFreeController.enteredUPIid.value == "0") {
                            Fluttertoast.showToast(
                                msg: "Please enter UPI Address!".tr);
                            return;
                          }
                          final bool enteredUPIValid =
                              RegExp(r"^[\w.-]+@[\w.-]+$").hasMatch(
                                  cashFreeController.enteredUPIid.value);
                          if (enteredUPIValid == false) {
                            Fluttertoast.showToast(
                                msg: 'Please enter valid UPI ID'.tr);
                            return;
                          }
                          if (isRedundentClick(DateTime.now())) {
                            Utils().customPrint(
                                'ProgressBarClick: showProgress click');
                            return;
                          }
                          Utils().customPrint(
                              'ProgressBarClick: showProgress run process');
                          //event calling..................
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
                            map_clevertap["USER_ID"] =
                                walletPageController.user_id;
                          }
                          map_clevertap["Amount"] = walletPageController
                              .selectAmount.value; //new event added

                          cleverTapController.logEventCT(
                              EventConstant.EVENT_CLEAVERTAB_Deposit_Initiated,
                              map_clevertap);

                          //appsflyer
                          Map<String, Object> map_appsflyer =
                              new Map<String, Object>();
                          map_appsflyer["USER_NAME"] =
                              _userController.profileDataRes.value.username;
                          map_appsflyer["USER_ID"] =
                              _userController.profileDataRes.value.id;
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
                              _userController.profileDataRes.value.username;
                          map_fb["USER_ID"] =
                              _userController.profileDataRes.value.id;
                          map_fb["EVENT"] =
                              EventConstant.EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM;

                          //facebook event work //ravi
                          map_fb["EVENT_PARAM_CURRENCY"] = "INR";
                          map_fb["EVENT_PARAM_CONTENT_TYPE"] = "product";
                          map_fb["EVENT_PARAM_CONTENT"] =
                              "[{\"id\": \"12345\", \"quantity\": 1}]";
                          map_fb["EVENT_NAME_PURCHASE"] = walletPageController
                              .selectAmount.value; //<< this line is imp
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
                                  "${_userController.profileDataRes.value.username}",
                              "client_user_agent": "",
                              "external_id": [
                                _userController.profileDataRes.value.id
                              ],
                            },
                            "custom_data": {}
                          };
                          FacebookEventApi().FacebookEventC(params);

                          //end event calling..............

                          //API call
                          final param = {
                            "amount": walletPageController.selectAmount.value
                                    .toString() +
                                "00",
                            "currency": "INR",
                            'email': walletPageController
                                            .profileDataRes.value.email !=
                                        null &&
                                    walletPageController.profileDataRes.value
                                            .email.address !=
                                        null &&
                                    walletPageController.profileDataRes.value
                                            .email.address !=
                                        ''
                                ? walletPageController
                                    .profileDataRes.value.email.address
                                : 'support@gmng.pro',
                            "contact": walletPageController
                                .profileDataRes.value.mobile.number
                                .toString(),
                            "method": "upi",
                            "vpa": {
                              "address": cashFreeController.enteredUPIid.value
                            },
                            //"vpa": {"intent": true}, need
                            "description": "UPI Deposit",
                            "promoCode":
                                walletPageController.promocode.value != ""
                                    ? walletPageController.promocode.value
                                    : "",
                            "notes": {"userId": cashFreeController.user_id}
                          };
                          await cashFreeController.paymentGatewayNew(
                              context, param, cashFreeController.upiSource);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 200,
                            height: 45,
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
                                "Proceed",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    color: AppColor().whiteColor),
                              ),
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

  void promocodeAutoFilled(String text) {
    walletPageController.selectAmount.value = text;
    walletPageController.amountTextController.value.text = text;
    var ftdCheck = false.obs;

    if (walletPageController.walletModelPromo.data != null) {
      //FTD STARTS
      for (int i = 0;
          i < walletPageController.walletModelPromo.data.length;
          i++) {
        print(
            'response promo code ftd ${walletPageController.walletModelPromo.data[i].ftd}');
        print('ftdCheck.value 1 ${ftdCheck.value}');
        if (walletPageController.walletModelPromo.data[i].ftd == true) {
          ftdCheck.value = true;
          print('ftdCheck.value 2 ${ftdCheck.value}');
          Utils().customPrint("TEST-PROMO true");

          int enteredValue = int.parse(text);
          cashFreeController.promocodeValue = int.parse(
              walletPageController.walletModelPromo.data[i].fromValue);
          Utils().customPrint(
              "PROMOCODE CODEx ftd ${walletPageController.walletModelPromo.data[i].code}");
          Utils().customPrint("PROMOCODE ENTER VALUE ftd ${enteredValue}");
          Utils().customPrint(
              "PROMOCODE FRM GREATER AMT ftd ${walletPageController.walletModelPromo.data[i].fromValue}");

          if (cashFreeController.promocodeValue > enteredValue) {
            Utils().customPrint("TEST-PROMO enterValue is low");
            //saving values
            walletPageController.promo_type.value = walletPageController
                .walletModelPromo.data[i].benefit[0].wallet[0].type;

            walletPageController.promo_minus_amt.value =
                cashFreeController.promocodeValue - enteredValue;
            int max_per = int.parse(walletPageController
                .walletModelPromo.data[i].benefit[0].wallet[0].percentage);
            walletPageController.promo_amt.value =
                (cashFreeController.promocodeValue * (max_per / 100));

            walletPageController.typeTextCheck.value = 1; //greater

            walletPageController.promo_maximumAmt.value = int.parse(
                walletPageController.walletModelPromo.data[i].benefit[0]
                    .wallet[0].maximumAmount);
            if (walletPageController.promo_amt.value >
                walletPageController.promo_maximumAmt.value) {
              walletPageController.profitAmt.value = cashFreeController
                      .promocodeValue +
                  double.parse(
                      walletPageController.promo_maximumAmt.value.toString());
            } else {
              walletPageController.profitAmt.value =
                  cashFreeController.promocodeValue +
                      walletPageController.promo_amt.value;
            }

            cashFreeController.promocodeHelper.value =
                walletPageController.walletModelPromo.data[i].code;
            try {
              //for cleverTap use
              double percentage = double.parse(walletPageController
                  .walletModelPromoFull
                  .data[i]
                  .benefit[0]
                  .wallet[0]
                  .percentage);
              walletPageController.percentagePromocode = percentage.toString();
              walletPageController.walletTypePromocode = walletPageController
                  .walletModelPromoFull.data[i].benefit[0].wallet[0].type;
            } catch (e) {}

            Utils().customPrint('PROMOCODES GREATER ftd *******************  '
                'CODE: ${walletPageController.walletModelPromo.data[i].code} |'
                'TYPE: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].type} |'
                '%: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].percentage}% |'
                ' calc%: ${walletPageController.promo_amt.value} |'
                'FROM: ${walletPageController.walletModelPromo.data[i].fromValue}|'
                'TO: ${walletPageController.walletModelPromo.data[i].toValue}|'
                'GET AMT: ${walletPageController.profitAmt.value}|'
                'MAX: ${walletPageController.promo_maximumAmt.value}');

            break;
          }

          //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          Utils().customPrint(
              "TEST-PROMO enterValue is High ftd ${walletPageController.typeTextCheck.value}");
          if (walletPageController.typeTextCheck.value == 0 ||
              walletPageController.typeTextCheck.value == 2) {
            Utils().customPrint("TEST-PROMO enterValue is High ftd ");
            //EQUAL TO CONDITION
            int enteredValue = int.parse(text);

            cashFreeController.promocodeValue = int.parse(
                walletPageController.walletModelPromo.data[i].fromValue);
            int promocodeToValue = int.parse(
                walletPageController.walletModelPromo.data[i].toValue);
            Utils().customPrint("--------");
            Utils().customPrint(
                "PROMOCODE FRM EQUAL AMT ftd ${walletPageController.walletModelPromo.data[i].fromValue}");
            Utils().customPrint(
                "PROMOCODE TO EQUAL AMT ftd ${walletPageController.walletModelPromo.data[i].toValue}");
            if (enteredValue >= cashFreeController.promocodeValue &&
                enteredValue <= promocodeToValue) {
              Utils().customPrint(
                  'PROMOCODES EQUALS/BWT ftd *******************  '
                  '${walletPageController.walletModelPromo.data[i].code} |'
                  '${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].type} |'
                  '${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].percentage}% |'
                  '${walletPageController.walletModelPromo.data[i].fromValue}|'
                  'MAX: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].maximumAmount}');
              //saving values
              walletPageController.promo_type.value = walletPageController
                  .walletModelPromo.data[i].benefit[0].wallet[0].type;

              walletPageController.promo_minus_amt.value =
                  cashFreeController.promocodeValue - enteredValue;
              int max_per = int.parse(walletPageController
                  .walletModelPromo.data[i].benefit[0].wallet[0].percentage);
              walletPageController.promo_amt.value =
                  (enteredValue * (max_per / 100));

              walletPageController.typeTextCheck.value = 2; //eqauls
              cashFreeController.promocodeHelper.value =
                  walletPageController.walletModelPromo.data[i].code;
              //new change for FTD code by default apply
              walletPageController.promocode.value =
                  walletPageController.walletModelPromo.data[i].code;

              try {
                //for cleverTap use
                double percentage = double.parse(walletPageController
                    .walletModelPromoFull
                    .data[i]
                    .benefit[0]
                    .wallet[0]
                    .percentage);
                walletPageController.percentagePromocode =
                    percentage.toString();
                walletPageController.walletTypePromocode = walletPageController
                    .walletModelPromoFull.data[i].benefit[0].wallet[0].type;
              } catch (e) {}

              walletPageController.promo_maximumAmt.value = int.parse(
                  walletPageController.walletModelPromo.data[i].benefit[0]
                      .wallet[0].maximumAmount);
              if (walletPageController.promo_amt.value >
                  walletPageController.promo_maximumAmt.value) {
                walletPageController.profitAmt.value = enteredValue +
                    double.parse(
                        walletPageController.promo_maximumAmt.value.toString());
              } else {
                walletPageController.profitAmt.value =
                    enteredValue + walletPageController.promo_amt.value;
              }
              Utils().customPrint('PROMOCODES EQUAL ftd *******************  '
                  'CODE: ${walletPageController.walletModelPromo.data[i].code} |'
                  'TYPE: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].type} |'
                  '%: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].percentage}% |'
                  ' calc%: ${walletPageController.promo_amt.value} |'
                  'FROM: ${walletPageController.walletModelPromo.data[i].fromValue}|'
                  'TO: ${walletPageController.walletModelPromo.data[i].toValue}|'
                  'GET AMT: ${walletPageController.profitAmt.value}|'
                  'MAX: ${walletPageController.promo_maximumAmt.value}');
            }
          }
          break;
        }
      }
      //FTD ENDS ----------------------------------------------------------------
      print('ftdCheck.value 3 ${ftdCheck.value}');

      print('ftdCheck.value 4 ${ftdCheck.value}');
      if (ftdCheck.value == false) {
        Utils().customPrint("TEST-PROMO false");
        for (int i = 0;
            i < walletPageController.walletModelPromo.data.length;
            i++) {
          int enteredValue = int.parse(text);
          cashFreeController.promocodeValue = int.parse(
              walletPageController.walletModelPromo.data[i].fromValue);
          //Utils().customPrint("PROMOCODE CODEx ${walletPageController.walletModelPromo.data[i].code}");
          //Utils().customPrint("PROMOCODE ENTER VALUE ${enteredValue}");
          //Utils().customPrint("PROMOCODE FRM GREATER AMT ${walletPageController.walletModelPromo.data[i].fromValue}");

          if (cashFreeController.promocodeValue > enteredValue) {
            Utils().customPrint("TEST-PROMO enterValue is low");
            //saving values
            walletPageController.promo_type.value = walletPageController
                .walletModelPromo.data[i].benefit[0].wallet[0].type;

            walletPageController.promo_minus_amt.value =
                cashFreeController.promocodeValue - enteredValue;
            int max_per = int.parse(walletPageController
                .walletModelPromo.data[i].benefit[0].wallet[0].percentage);
            walletPageController.promo_amt.value =
                (cashFreeController.promocodeValue * (max_per / 100));

            walletPageController.typeTextCheck.value = 1; //greater

            walletPageController.promo_maximumAmt.value = int.parse(
                walletPageController.walletModelPromo.data[i].benefit[0]
                    .wallet[0].maximumAmount);
            if (walletPageController.promo_amt.value >
                walletPageController.promo_maximumAmt.value) {
              walletPageController.profitAmt.value = cashFreeController
                      .promocodeValue +
                  double.parse(
                      walletPageController.promo_maximumAmt.value.toString());
            } else {
              walletPageController.profitAmt.value =
                  cashFreeController.promocodeValue +
                      walletPageController.promo_amt.value;
            }

            cashFreeController.promocodeHelper.value =
                walletPageController.walletModelPromo.data[i].code;
            try {
              //for cleverTap use
              double percentage = double.parse(walletPageController
                  .walletModelPromoFull
                  .data[i]
                  .benefit[0]
                  .wallet[0]
                  .percentage);
              walletPageController.percentagePromocode = percentage.toString();
              walletPageController.walletTypePromocode = walletPageController
                  .walletModelPromoFull.data[i].benefit[0].wallet[0].type;
            } catch (e) {}

            Utils().customPrint('PROMOCODES GREATER *******************  '
                'CODE: ${walletPageController.walletModelPromo.data[i].code} |'
                'TYPE: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].type} |'
                '%: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].percentage}% |'
                ' calc%: ${walletPageController.promo_amt.value} |'
                'FROM: ${walletPageController.walletModelPromo.data[i].fromValue}|'
                'TO: ${walletPageController.walletModelPromo.data[i].toValue}|'
                'GET AMT: ${walletPageController.profitAmt.value}|'
                'MAX: ${walletPageController.promo_maximumAmt.value}');

            break;
          }

          //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          Utils().customPrint(
              "TEST-PROMO enterValue is High ${walletPageController.typeTextCheck.value}");
          if (walletPageController.typeTextCheck.value == 0 ||
              walletPageController.typeTextCheck.value == 2) {
            Utils().customPrint("TEST-PROMO enterValue is High");
            //EQUAL TO CONDITION
            int enteredValue = int.parse(text);

            cashFreeController.promocodeValue = int.parse(walletPageController
                .walletModelPromo
                .data[walletPageController.walletModelPromo.data.length - 1]
                .fromValue);
            int promocodeToValue = int.parse(walletPageController
                .walletModelPromo
                .data[walletPageController.walletModelPromo.data.length - 1]
                .toValue);
            Utils().customPrint("--------");
            Utils().customPrint(
                "PROMOCODE FRM EQUAL AMT ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].fromValue}");
            Utils().customPrint(
                "PROMOCODE TO EQUAL AMT ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].toValue}");
            if (enteredValue >= cashFreeController.promocodeValue &&
                enteredValue <= promocodeToValue) {
              Utils().customPrint('PROMOCODES EQUALS/BWT *******************  '
                  '${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].code} |'
                  '${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].benefit[0].wallet[0].type} |'
                  '${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].benefit[0].wallet[0].percentage}% |'
                  '${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].fromValue}|'
                  'MAX: ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].benefit[0].wallet[0].maximumAmount}');
              //saving values
              walletPageController.promo_type.value = walletPageController
                  .walletModelPromo
                  .data[walletPageController.walletModelPromo.data.length - 1]
                  .benefit[0]
                  .wallet[0]
                  .type;

              walletPageController.promo_minus_amt.value =
                  cashFreeController.promocodeValue - enteredValue;
              int max_per = int.parse(walletPageController
                  .walletModelPromo
                  .data[walletPageController.walletModelPromo.data.length - 1]
                  .benefit[0]
                  .wallet[0]
                  .percentage);
              walletPageController.promo_amt.value =
                  (enteredValue * (max_per / 100));

              walletPageController.typeTextCheck.value = 2; //eqauls
              cashFreeController.promocodeHelper.value = walletPageController
                  .walletModelPromo
                  .data[walletPageController.walletModelPromo.data.length - 1]
                  .code;

              try {
                //for cleverTap use
                double percentage = double.parse(walletPageController
                    .walletModelPromoFull
                    .data[walletPageController.walletModelPromo.data.length - 1]
                    .benefit[0]
                    .wallet[0]
                    .percentage);
                walletPageController.percentagePromocode =
                    percentage.toString();
                walletPageController.walletTypePromocode = walletPageController
                    .walletModelPromoFull
                    .data[walletPageController.walletModelPromo.data.length - 1]
                    .benefit[0]
                    .wallet[0]
                    .type;
              } catch (e) {}

              walletPageController.promo_maximumAmt.value = int.parse(
                  walletPageController
                      .walletModelPromo
                      .data[
                          walletPageController.walletModelPromo.data.length - 1]
                      .benefit[0]
                      .wallet[0]
                      .maximumAmount);
              if (walletPageController.promo_amt.value >
                  walletPageController.promo_maximumAmt.value) {
                walletPageController.profitAmt.value = enteredValue +
                    double.parse(
                        walletPageController.promo_maximumAmt.value.toString());
              } else {
                walletPageController.profitAmt.value =
                    enteredValue + walletPageController.promo_amt.value;
              }
              Utils().customPrint('PROMOCODES EQUAL *******************  '
                  'CODE: ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].code} |'
                  'TYPE: ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].benefit[0].wallet[0].type} |'
                  '%: ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].benefit[0].wallet[0].percentage}% |'
                  ' calc%: ${walletPageController.promo_amt.value} |'
                  'FROM: ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].fromValue}|'
                  'TO: ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].toValue}|'
                  'GET AMT: ${walletPageController.profitAmt.value}|'
                  'MAX: ${walletPageController.promo_maximumAmt.value}');
            }
          }
        }
      }
    }
  }

  paymentOrderWidget(BuildContext context, int order, String methodName) {
    print("order call values $order  call $methodName");
    return Container(
      child: methodName == "upi"
          ? widgetlist[0]
          : methodName == "wallet"
              ? widgetlist[1]
              : methodName == "netbanking"
                  ? widgetlist[2]
                  : methodName == "card"
                      ? widgetlist[3]
                      : SizedBox(height: 0),
      //Icon(Icons.image),
    );
  }

  var checkbox_bool = true.obs;
  upiListingWidget(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        cashFreeController.enteredUPIid.value = _userController
            .profileDataRes.value.depositMethods[index].data.upi.link;
        upiEnteredController.value.text = _userController
            .profileDataRes.value.depositMethods[index].data.upi.link;
        //_userController.profileDataRes.value.depositMethods[index].isSelected = true;
      },
      child: Container(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10.0, top: 5, right: 10, bottom: 5),
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColor().reward_card_bg,
                /* border: Border.all(
                  width: 0,
                  color: AppColor().reward_grey_bg,
                ),*/
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                  activeColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(width: 2.0, color: Colors.white),
                  ),
                  onChanged: (value) {
                    //print(value);
                    /*checkbox_bool.value = value;
                        Utils().customPrint(
                            'checkbox_bool 1 ${checkbox_bool.value}');*/
                  },
                  value: true,
                ),
                Text(
                  '${_userController.profileDataRes.value.depositMethods[index].data.upi.link}',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 18.0,
                      fontStyle: FontStyle.normal),
                ),
              ],
            ),
          ),
        ),
        //Icon(Icons.image),
      ),
    );
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
    if (currentTime.difference(loginClickTime).inSeconds < 5) {
      // set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
  }
}
