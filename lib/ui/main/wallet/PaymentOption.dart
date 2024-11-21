import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/WithdrawalController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/wallet/BankTransfer.dart';
import 'package:gmng/ui/main/wallet/LinkUPIAddress.dart';
import 'package:gmng/ui/main/wallet/WithdrawProcessingScreen.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../res/AppColor.dart';
import '../../controller/WalletPageController.dart';

class PaymentOption extends StatelessWidget {
  String walletId;

  PaymentOption(this.walletId);

  WithdrawalController controller = Get.put(WithdrawalController());
  UserController userController = Get.put(UserController());
  WalletPageController walletPageController = Get.put(WalletPageController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<ShakeConstant> shakeList = [ShakeHorizontalConstant1()];

  var minimunAmount = false.obs;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () async {
          await walletPageController.getWithdrawRequest();
        });
      },
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              flexibleSpace: Image(
                image: AssetImage('assets/images/store_top.png'),
                fit: BoxFit.cover,
              ),
              title: Container(
                  margin: EdgeInsets.only(right: 50),
                  child: Center(child: Text("Payment Option"))),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/store_back.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColor().colorPrimary,
                            radius: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 29,
                              child: Center(
                                  child: Image(
                                height: 30,
                                image: AssetImage(ImageRes().team_group),
                              )

                                  /*Icon(
                                  Icons.supervised_user_circle_outlined,
                                  // color: Colors.transparent,
                                  size: 30,
                                )*/
                                  ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Winning Cash",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              Obx(
                                () => Text(
                                  " \u{20B9} ${userController.winning_bal.value != null ? userController.winning_bal.value ~/ 100 : "0"}",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: AppColor().colorPrimary_dark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => minimunAmount.value == false
                            ? Column(
                                children: [
                                  Container(
                                      height: 50,
                                      padding: EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColor().whiteColor),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(13),
                                        ],
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: AppColor()
                                                    .optional_payment),
                                            hintText: "Enter Amount"),
                                        onChanged: (text) {
                                          controller.enter_Amount.value =
                                              int.parse(text);
                                          Utils().customPrint(
                                              "First text field: $text");
                                        },
                                        autofocus: false,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Obx(() =>
                                          userController
                                                          .profileDataRes.value !=
                                                      null &&
                                                  userController.profileDataRes
                                                          .value.settings !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest
                                                          .minAmount !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest
                                                          .minAmount >
                                                      0
                                              ? Text(
                                                  " Min  \u{20B9} ${userController.profileDataRes.value.settings.withdrawRequest.minAmount ~/ 100}",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: AppColor()
                                                          .colorPrimary,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              : Text(
                                                  " Min  \u{20B9} ${userController.appSettingReponse != null && userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null ? userController.appSettingReponse.value.withdrawRequest.minAmount ~/ 100 : '0'}",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showInfoDialog(context);
                                        },
                                        child: Image(
                                            height: 15,
                                            image: AssetImage(
                                                "assets/images/ic_leader.png")),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: shakeList.map((shakeConstant) {
                                  return Obx(
                                    () => ShakeWidget(
                                      duration: Duration(seconds: 2),
                                      shakeConstant: shakeConstant,
                                      autoPlay:
                                          minimunAmount.value ? true : false,
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              minimunAmount.value = false;
                                            },
                                            child: Container(
                                              height: 50,
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColor()
                                                          .colorPrimary,
                                                      width: 3),
                                                  color: AppColor().whiteColor),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      13),
                                                ],
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                        color: AppColor()
                                                            .optional_payment),
                                                    hintText: "Enter Amount"),
                                                onChanged: (text) {
                                                  minimunAmount.value = false;
                                                  controller.enter_Amount
                                                      .value = int.parse(text);
                                                  Utils().customPrint(
                                                      "First text field: $text");
                                                },
                                                onTap: (){
                                                  minimunAmount.value = false;
                                                },
                                                autofocus: false,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Obx(() => userController
                                                              .profileDataRes
                                                              .value !=
                                                          null &&
                                                      userController.profileDataRes
                                                              .value.settings !=
                                                          null &&
                                                      userController
                                                              .profileDataRes
                                                              .value
                                                              .settings
                                                              .withdrawRequest !=
                                                          null &&
                                                      userController
                                                              .profileDataRes
                                                              .value
                                                              .settings
                                                              .withdrawRequest
                                                              .minAmount !=
                                                          null &&
                                                      userController
                                                              .profileDataRes
                                                              .value
                                                              .settings
                                                              .withdrawRequest
                                                              .minAmount >
                                                          0
                                                  ? Text(
                                                      " Min  \u{20B9} ${userController.profileDataRes.value.settings.withdrawRequest.minAmount ~/ 100}",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: AppColor()
                                                              .colorPrimary,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  : Text(
                                                      " Min  \u{20B9} ${userController.appSettingReponse != null && userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null ? userController.appSettingReponse.value.withdrawRequest.minAmount ~/ 100 : '0'}",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: AppColor()
                                                              .whiteColor,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showInfoDialog(context);
                                                },
                                                child: Image(
                                                    height: 15,
                                                    image: AssetImage(
                                                        "assets/images/ic_leader.png")),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      /* Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: shakeList.map((shakeConstant) {
                          return Obx(
                            () => ShakeWidget(
                              duration: Duration(seconds: 7),
                              shakeConstant: shakeConstant,
                              autoPlay: minimunAmount.value ? true : false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(
                                      () =>
                                          userController
                                                          .profileDataRes.value !=
                                                      null &&
                                                  userController.profileDataRes
                                                          .value.settings !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest
                                                          .minAmount !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest
                                                          .minAmount >
                                                      0
                                              ? Text(
                                                  " Min  \u{20B9} ${userController.profileDataRes.value.settings.withdrawRequest.minAmount ~/ 100}",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: AppColor()
                                                          .colorPrimary,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              : Text(
                                                  " Min  \u{20B9} ${userController.appSettingReponse != null && userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null ? userController.appSettingReponse.value.withdrawRequest.minAmount ~/ 100 : '0'}",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color:
                                                          AppColor().whiteColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showInfoDialog(context);
                                    },
                                    child: Image(
                                        height: 15,
                                        image: AssetImage(
                                            "assets/images/ic_leader.png")),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),*/
                      SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => controller.withdrawalModelR.value != null
                            ? controller.withdrawalModelR.value.data != null
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: AppColor().colorPrimary,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(13),
                                                  topRight:
                                                      Radius.circular(13))),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 42,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Wrap(
                                                  children: [
                                                    Text(
                                                      "Withdraw Methods",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                /* Container(
                                                  child: Image.asset(
                                                    "assets/images/info.webp",
                                                    color: Colors.white,
                                                  ),
                                                )*/
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Obx(
                                          () => controller.withdrawalModelR.value != null &&
                                                  controller
                                                          .withdrawalModelR
                                                          .value
                                                          .upi_array
                                                          .length >=
                                                      1
                                              ? controller
                                                              .withdrawalModelR
                                                              .value
                                                              .upi_array[0]
                                                              .pennyDropCheckStatus !=
                                                          null &&
                                                      controller
                                                          .withdrawalModelR
                                                          .value
                                                          .upi_array[0]
                                                          .pennyDropCheckStatus
                                                          .sttusCheck
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(children: [
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                "assets/images/iv_upi.webp"),
                                                            height: 30,
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(("UPI")),
                                                              Text(
                                                                controller
                                                                    .withdrawalModelR
                                                                    .value
                                                                    .upi_array[
                                                                        0]
                                                                    .data
                                                                    .upi
                                                                    .link,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Roboto"),
                                                              )
                                                            ],
                                                          ),
                                                        ]),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 15),
                                                          child: Radio(
                                                              hoverColor: AppColor()
                                                                  .colorPrimary,
                                                              value: "UPI",
                                                              groupValue:
                                                                  controller
                                                                      .withdrawType
                                                                      .value,
                                                              onChanged:
                                                                  (value) {
                                                                controller
                                                                        .withdrawType
                                                                        .value =
                                                                    value
                                                                        .toString();
                                                              }),
                                                        ),
                                                      ],
                                                    )
                                                  : walletPageController.profileDataRes.value != null &&
                                                          walletPageController
                                                                  .profileDataRes
                                                                  .value
                                                                  .settings !=
                                                              null &&
                                                          walletPageController
                                                                  .profileDataRes
                                                                  .value
                                                                  .settings
                                                                  .withdrawRequest !=
                                                              null &&
                                                          walletPageController
                                                                  .profileDataRes
                                                                  .value
                                                                  .settings
                                                                  .withdrawRequest
                                                                  .maxLimit !=
                                                              null &&
                                                          ((walletPageController
                                                                          .profileDataRes
                                                                          .value
                                                                          .settings
                                                                          .withdrawRequest
                                                                          .maxLimit ~/
                                                                      100) -
                                                                  (walletPageController.pennyDropSummaryAmount.value ~/ 100)) >
                                                              0
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(children: [
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Image(
                                                                image: AssetImage(
                                                                    "assets/images/iv_upi.webp"),
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(("UPI")),
                                                                  Text(
                                                                    controller
                                                                        .withdrawalModelR
                                                                        .value
                                                                        .upi_array[
                                                                            0]
                                                                        .data
                                                                        .upi
                                                                        .link,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontFamily:
                                                                            "Roboto"),
                                                                  )
                                                                ],
                                                              ),
                                                            ]),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          15),
                                                              child: Radio(
                                                                  hoverColor:
                                                                      AppColor()
                                                                          .colorPrimary,
                                                                  value: "UPI",
                                                                  groupValue:
                                                                      controller
                                                                          .withdrawType
                                                                          .value,
                                                                  onChanged:
                                                                      (value) {
                                                                    controller
                                                                            .withdrawType
                                                                            .value =
                                                                        value
                                                                            .toString();
                                                                  }),
                                                            ),
                                                          ],
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            if (AppString
                                                                    .linkAccount
                                                                    .value ==
                                                                'inactive') {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Link account disable!');
                                                              return;
                                                            }
                                                            Get.to(() =>
                                                                LinkUPIAddress(
                                                                    true,
                                                                    controller
                                                                        .withdrawalModelR
                                                                        .value
                                                                        .upi_array[
                                                                            0]
                                                                        .sId));
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(children: [
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Image(
                                                                  image: AssetImage(
                                                                      "assets/images/iv_upi.webp"),
                                                                  height: 30,
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Text(("UPI")),
                                                              ]),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            15),
                                                                child: Text(
                                                                  "Link Account",
                                                                  style: TextStyle(
                                                                      color: AppString.linkAccount.value ==
                                                                              "inactive"
                                                                          ? AppColor()
                                                                              .reward_grey_bg
                                                                          : AppColor()
                                                                              .colorPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Roboto"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                              : GestureDetector(
                                                  onTap: () {
                                                    if (AppString.linkAccount
                                                            .value ==
                                                        'inactive') {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Link account disable!');
                                                      return;
                                                    }
                                                    Get.to(() => LinkUPIAddress(
                                                        false, ""));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(children: [
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Image(
                                                          image: AssetImage(
                                                              "assets/images/iv_upi.webp"),
                                                          height: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(("UPI")),
                                                      ]),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 15),
                                                        child: Text(
                                                          "Link Account",
                                                          style: TextStyle(
                                                              color: AppString
                                                                          .linkAccount
                                                                          .value ==
                                                                      "inactive"
                                                                  ? AppColor()
                                                                      .reward_grey_bg
                                                                  : AppColor()
                                                                      .colorPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "Roboto"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        SizedBox(
                                          height: 13,
                                        ),
                                        Container(
                                          color: AppColor().colorGray,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 2,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Obx(
                                          () => controller
                                                          .withdrawalModelR.value !=
                                                      null &&
                                                  controller
                                                          .withdrawalModelR.value.bank_array.length >=
                                                      1
                                              ? controller
                                                              .withdrawalModelR
                                                              .value
                                                              .bank_array[0]
                                                              .pennyDropCheckStatus !=
                                                          null &&
                                                      controller
                                                          .withdrawalModelR
                                                          .value
                                                          .bank_array[0]
                                                          .pennyDropCheckStatus
                                                          .sttusCheck
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Image(
                                                              image: AssetImage(
                                                                  "assets/images/iv_bank.webp"),
                                                              height: 30,
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    ("Bank Account")),
                                                                Text(
                                                                  controller
                                                                      .withdrawalModelR
                                                                      .value
                                                                      .bank_array[
                                                                          0]
                                                                      .data
                                                                      .bank
                                                                      .accountNo,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          "Roboto"),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 15),
                                                          child: Radio(
                                                              hoverColor: AppColor()
                                                                  .colorPrimary,
                                                              value: "Bank",
                                                              groupValue:
                                                                  controller
                                                                      .withdrawType
                                                                      .value,
                                                              onChanged:
                                                                  (value) {
                                                                controller
                                                                        .withdrawType
                                                                        .value =
                                                                    value
                                                                        .toString();
                                                              }),
                                                        ),
                                                      ],
                                                    )
                                                  : walletPageController.profileDataRes
                                                                  .value !=
                                                              null &&
                                                          walletPageController
                                                                  .profileDataRes
                                                                  .value
                                                                  .settings !=
                                                              null &&
                                                          walletPageController
                                                                  .profileDataRes
                                                                  .value
                                                                  .settings
                                                                  .withdrawRequest !=
                                                              null &&
                                                          walletPageController
                                                                  .profileDataRes
                                                                  .value
                                                                  .settings
                                                                  .withdrawRequest
                                                                  .maxLimit !=
                                                              null &&
                                                          ((walletPageController
                                                                          .profileDataRes
                                                                          .value
                                                                          .settings
                                                                          .withdrawRequest
                                                                          .maxLimit ~/
                                                                      100) -
                                                                  (walletPageController
                                                                          .pennyDropSummaryAmount
                                                                          .value ~/
                                                                      100)) >
                                                              0
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Image(
                                                                  image: AssetImage(
                                                                      "assets/images/iv_bank.webp"),
                                                                  height: 30,
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                        ("Bank Account")),
                                                                    Text(
                                                                      controller
                                                                          .withdrawalModelR
                                                                          .value
                                                                          .bank_array[
                                                                              0]
                                                                          .data
                                                                          .bank
                                                                          .accountNo,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          15),
                                                              child: Radio(
                                                                  hoverColor:
                                                                      AppColor()
                                                                          .colorPrimary,
                                                                  value: "Bank",
                                                                  groupValue:
                                                                      controller
                                                                          .withdrawType
                                                                          .value,
                                                                  onChanged:
                                                                      (value) {
                                                                    controller
                                                                            .withdrawType
                                                                            .value =
                                                                        value
                                                                            .toString();
                                                                  }),
                                                            ),
                                                          ],
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            if (AppString
                                                                    .linkAccount
                                                                    .value ==
                                                                'inactive') {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Link account disable!');
                                                              return;
                                                            }
                                                            Get.to(() => BankTransfer(
                                                                true,
                                                                controller
                                                                    .withdrawalModelR
                                                                    .value
                                                                    .bank_array[
                                                                        0]
                                                                    .sId));
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        "assets/images/iv_bank.webp"),
                                                                    height: 30,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                      ("Bank Account")),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            15),
                                                                child: Text(
                                                                  "Link Account",
                                                                  style: TextStyle(
                                                                      color: AppString.linkAccount.value ==
                                                                              "inactive"
                                                                          ? AppColor()
                                                                              .reward_grey_bg
                                                                          : AppColor()
                                                                              .colorPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Montserrat"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                              : GestureDetector(
                                                  onTap: () {
                                                    if (AppString.linkAccount
                                                            .value ==
                                                        'inactive') {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Link account disable!');
                                                      return;
                                                    }
                                                    Get.to(() => BankTransfer(
                                                        false, ""));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                "assets/images/iv_bank.webp"),
                                                            height: 30,
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Text(
                                                              ("Bank Account")),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 15),
                                                        child: Text(
                                                          "Link Account",
                                                          style: TextStyle(
                                                              color: AppString
                                                                          .linkAccount
                                                                          .value ==
                                                                      "inactive"
                                                                  ? AppColor()
                                                                      .reward_grey_bg
                                                                  : AppColor()
                                                                      .colorPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "Montserrat"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 1,
                                          color: AppColor().colorPrimary,
                                        ),
                                        GestureDetector(
                                          onTap: () => {
                                            if (controller.withdrawType !=
                                                    null &&
                                                controller.withdrawType.value !=
                                                    null &&
                                                controller.enter_Amount.value >
                                                    0)
                                              {
                                                print("on Tap call here"),
                                                if (userController
                                                            .profileDataRes
                                                            .value !=
                                                        null &&
                                                    userController
                                                            .profileDataRes
                                                            .value
                                                            .settings !=
                                                        null &&
                                                    userController
                                                            .profileDataRes
                                                            .value
                                                            .settings
                                                            .withdrawRequest !=
                                                        null &&
                                                    userController
                                                            .profileDataRes
                                                            .value
                                                            .settings
                                                            .withdrawRequest
                                                            .minAmount !=
                                                        null &&
                                                    userController
                                                            .profileDataRes
                                                            .value
                                                            .settings
                                                            .withdrawRequest
                                                            .minAmount >
                                                        0)
                                                  {
                                                    if (userController
                                                                .profileDataRes
                                                                .value
                                                                .settings
                                                                .withdrawRequest
                                                                .minAmount ~/
                                                            100 <=
                                                        controller
                                                            .enter_Amount.value)
                                                      {
                                                        withdrawTDS(context),
                                                      }
                                                    else
                                                      {
                                                        minimunAmount.value =
                                                            true,
                                                        Future.delayed(const Duration(seconds: 2), () async {

                                                          minimunAmount.value = false;

                                                        }),
                                                      }
                                                  }
                                                else
                                                  {
                                                    if (userController.appSettingReponse != null &&
                                                        userController
                                                                .appSettingReponse
                                                                .value !=
                                                            null &&
                                                        userController
                                                                .appSettingReponse
                                                                .value
                                                                .withdrawRequest !=
                                                            null)
                                                      {
                                                        if (userController
                                                                    .appSettingReponse
                                                                    .value
                                                                    .withdrawRequest
                                                                    .minAmount ~/
                                                                100 <=
                                                            controller
                                                                .enter_Amount
                                                                .value)
                                                          {
                                                            withdrawTDS(
                                                                context),
                                                          }
                                                        else
                                                          {


                                                            minimunAmount
                                                                .value = true,

                                                             Future.delayed(const Duration(seconds: 2), () async {

                                                               minimunAmount.value = false;

                                                             }),

                                                          /*Fluttertoast.showToast(
                                                      msg:
                                                      "Plase Withdraw Min Amount"),*/
                                                          }
                                                      }
                                                  }
                                              }
                                            else if (controller
                                                    .enter_Amount.value ==
                                                0)
                                              {
                                                Fluttertoast.showToast(
                                                    msg: "Please Enter Amount")
                                              }
                                            else
                                              {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please select withdrawn method")
                                              }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(13),
                                                  bottomLeft:
                                                      Radius.circular(13)),
                                              color: AppColor().whiteColor,
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.center,
                                            height: 42,
                                            child: InkWell(
                                              onTap: () => {
                                                if (controller.withdrawType !=
                                                        null &&
                                                    controller.withdrawType
                                                            .value !=
                                                        null &&
                                                    controller.enter_Amount
                                                            .value >
                                                        0)
                                                  {
                                                    print("on Tap call here"),
                                                    if (userController
                                                                .profileDataRes
                                                                .value !=
                                                            null &&
                                                        userController
                                                                .profileDataRes
                                                                .value
                                                                .settings !=
                                                            null &&
                                                        userController
                                                                .profileDataRes
                                                                .value
                                                                .settings
                                                                .withdrawRequest !=
                                                            null &&
                                                        userController
                                                                .profileDataRes
                                                                .value
                                                                .settings
                                                                .withdrawRequest
                                                                .minAmount !=
                                                            null &&
                                                        userController
                                                                .profileDataRes
                                                                .value
                                                                .settings
                                                                .withdrawRequest
                                                                .minAmount >
                                                            0)
                                                      {
                                                        if (userController
                                                                    .profileDataRes
                                                                    .value
                                                                    .settings
                                                                    .withdrawRequest
                                                                    .minAmount ~/
                                                                100 <=
                                                            controller
                                                                .enter_Amount
                                                                .value)
                                                          {
                                                            withdrawTDS(
                                                                context),
                                                          }
                                                        else
                                                          {
                                                            minimunAmount
                                                                .value = true,

                                                            Future.delayed(const Duration(seconds: 2), () async {

                                                              minimunAmount.value = false;

                                                            }),

                                                          }
                                                      }
                                                    else
                                                      {
                                                        if (userController.appSettingReponse != null &&
                                                            userController
                                                                    .appSettingReponse
                                                                    .value !=
                                                                null &&
                                                            userController
                                                                    .appSettingReponse
                                                                    .value
                                                                    .withdrawRequest !=
                                                                null)
                                                          {
                                                            if (userController
                                                                        .appSettingReponse
                                                                        .value
                                                                        .withdrawRequest
                                                                        .minAmount ~/
                                                                    100 <=
                                                                controller
                                                                    .enter_Amount
                                                                    .value)
                                                              {
                                                                withdrawTDS(
                                                                    context),
                                                              }
                                                            else
                                                              {
                                                                minimunAmount
                                                                        .value =
                                                                    true,


                                                                  Future.delayed(const Duration(seconds: 2), () async {

                                                                  minimunAmount.value = false;

                                                                }),
                                                                /*Fluttertoast
                                                          .showToast(
                                                          msg:
                                                          "Plase Withdraw Min Amount"),*/
                                                              }
                                                          }
                                                      }
                                                  }
                                                else if (controller
                                                        .enter_Amount.value ==
                                                    0)
                                                  {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please Enter Amount")
                                                  }
                                                else
                                                  {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please select withdrawn method")
                                                  }
                                              },
                                              child: Text(
                                                "WITHDRAW",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Montserrat",
                                                    color: AppColor()
                                                        .colorPrimary),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: AppColor().reward_card_bg,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(13),
                                                topRight: Radius.circular(13))),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 42,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Wrap(
                                                children: [
                                                  Text(
                                                    "Withdraw Methods",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (AppString.linkAccount.value ==
                                              'inactive') {
                                            Fluttertoast.showToast(
                                                msg: 'Link account disable!');
                                            return;
                                          }
                                          Get.to(
                                              () => LinkUPIAddress(false, ""));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Image(
                                                image: AssetImage(
                                                    "assets/images/iv_upi.webp"),
                                                height: 30,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(("UPI")),
                                            ]),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Link Account",
                                                style: TextStyle(
                                                    color: AppString.linkAccount
                                                                .value ==
                                                            "inactive"
                                                        ? AppColor()
                                                            .reward_grey_bg
                                                        : AppColor()
                                                            .colorPrimary,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Montserrat"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        color: AppColor().colorGray,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 2,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (AppString.linkAccount.value ==
                                              'inactive') {
                                            Fluttertoast.showToast(
                                                msg: 'Link account disable!');
                                            return;
                                          }
                                          Get.to(() => BankTransfer(false, ""));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Image(
                                                  image: AssetImage(
                                                      "assets/images/iv_bank.webp"),
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(("Bank Account")),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Link Account",
                                                style: TextStyle(
                                                    color: AppString.linkAccount
                                                                .value ==
                                                            "inactive"
                                                        ? AppColor()
                                                            .reward_grey_bg
                                                        : AppColor()
                                                            .colorPrimary,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Montserrat"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () => {
                                          if (controller.withdrawType != null &&
                                              controller.withdrawType.value !=
                                                  null &&
                                              controller.enter_Amount.value > 0)
                                            {
                                              print("on Tap call here"),
                                              if (userController.profileDataRes.value != null &&
                                                  userController.profileDataRes
                                                          .value.settings !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest
                                                          .minAmount !=
                                                      null &&
                                                  userController
                                                          .profileDataRes
                                                          .value
                                                          .settings
                                                          .withdrawRequest
                                                          .minAmount >
                                                      0)
                                                {
                                                  if (userController
                                                              .profileDataRes
                                                              .value
                                                              .settings
                                                              .withdrawRequest
                                                              .minAmount ~/
                                                          100 <=
                                                      controller
                                                          .enter_Amount.value)
                                                    {
                                                      withdrawTDS(context),
                                                    }
                                                  else
                                                    {
                                                      minimunAmount.value =
                                                          true,

                                                      Future.delayed(const Duration(seconds: 2), () async {

                                                        minimunAmount.value = false;

                                                      }),

                                                      /* Fluttertoast.showToast(
                                                msg:
                                                "Plase Withdraw Min Amount"),*/
                                                    }
                                                }
                                              else
                                                {
                                                  if (userController.appSettingReponse != null &&
                                                      userController
                                                              .appSettingReponse
                                                              .value !=
                                                          null &&
                                                      userController
                                                              .appSettingReponse
                                                              .value
                                                              .withdrawRequest !=
                                                          null)
                                                    {
                                                      if (userController
                                                                  .appSettingReponse
                                                                  .value
                                                                  .withdrawRequest
                                                                  .minAmount ~/
                                                              100 <=
                                                          controller
                                                              .enter_Amount
                                                              .value)
                                                        {
                                                          withdrawTDS(context),
                                                        }
                                                      else
                                                        {
                                                          minimunAmount.value =
                                                              true,

                                                          Future.delayed(const Duration(seconds: 2), () async {

                                                            minimunAmount.value = false;

                                                          }),

                                                          /*Fluttertoast.showToast(
                                                    msg:
                                                    "Plase Withdraw Min Amount"),*/
                                                        }
                                                    }
                                                }
                                            }
                                          else if (controller
                                                  .enter_Amount.value ==
                                              0)
                                            {
                                              Fluttertoast.showToast(
                                                  msg: "Please Enter Amount")
                                            }
                                          else
                                            {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please select withdrawn method")
                                            }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(13),
                                                bottomLeft:
                                                    Radius.circular(13)),
                                            color: AppColor().colorPrimary,
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          height: 42,
                                          child: Text(
                                            "WITHDRAW",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 200,
                                width: MediaQuery.of(context).size.width * .9,
                                child: Shimmer.fromColors(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.width * 0.3,
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                  ),
                                  baseColor: Colors.grey.withOpacity(0.2),
                                  highlightColor: Colors.grey.withOpacity(0.4),
                                  enabled: true,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: ApiUrl().isbb
                              ? Text(
                                  "Notes : Make sure that you have entered correct details for  Bank Account. We are unable to cross-verify the details.Your money will be transferred to the added  Bank Account if the bank accepts. You can't change the details once you have entered them.\n \n You can view and report your transactions history in the transactions tab in the Wallet Menu. In case of any errors, we will refund your money back into your GMNG account within 7 working days. \n \n Please contact our support in case of any issues. We will help in resolving your concerns.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: FontSizeC().front_small,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                      color: Colors.white),
                                )
                              : Text(
                                  "Notes : Make sure that you have entered correct details for  UPI /Bank Account. We are unable to cross-verify the details.Your money will be transferred to the added UPI ID / Bank Account if the bank accepts. You can't change the details once you have entered them.\n \n You can view and report your transactions history in the transactions tab in the Wallet Menu. In case of any errors, we will refund your money back into your GMNG account within 7 working days. \n \n Please contact our support in case of any issues. We will help in resolving your concerns.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: FontSizeC().front_small,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                      color: Colors.white),
                                )),

                      /*  Text(
                          AppString().text_payment_option,
                          style: TextStyle(
                              fontSize: FontSizeC().front_small,
                              color: AppColor().whiteColor,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Montserrat"),
                        ),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showWithdraw(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg))),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 330,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        Text(
                          "Withdraw Amount",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Montserrat",
                              color: Colors.white),
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
                        /* new IconButton(
                            icon: new Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })*/
                      ],
                    ),
                    Text(
                      "${AppString().txt_currency_symbole} ${controller.enter_Amount.value} ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Montserrat",
                          color: AppColor().colorPrimary),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Withdrawal Amount",
                            style: TextStyle(
                                color: AppColor().whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: "Montserrat")),
                        Text(
                            "${AppString().txt_currency_symbole} ${controller.enter_Amount.value}",
                            style: TextStyle(
                                color: AppColor().whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: "Montserrat")),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Withdrawal fee",
                            style: TextStyle(
                                color: AppColor().whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: "Montserrat")),
                        Obx(
                            () => /*userController.profileDataRes.value != null &&
                                  userController.profileDataRes.value.settings !=
                                      null &&
                                  userController.profileDataRes.value.settings
                                          .withdrawRequest !=
                                      null &&
                                  userController.profileDataRes.value.settings
                                          .withdrawRequest.transactionFee !=
                                      null &&
                                  getWitdrawnFreeLocal() != null
                              ?*/
                                Text(
                                    "${AppString().txt_currency_symbole} " +
                                        "${(controller.withdrawalModelTDS.value.data.withdrawalFee.value / 100).toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: AppColor().whiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        fontFamily: "Montserrat"))
                            /*: Text("${AppString().txt_currency_symbole} " + getWitdrawnFree().toString(),
                                  style: TextStyle(
                                      color: AppColor().whiteColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      fontFamily: "Montserrat")),*/
                            ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TDS Amount",
                            style: TextStyle(
                                color: AppColor().whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: "Montserrat")),
                        Obx(() => controller.withdrawalModelTDS.value.data
                                        .tdsInfo !=
                                    null &&
                                controller.withdrawalModelTDS.value.data.tdsInfo
                                        .tds.value !=
                                    null
                            ? Text(
                                "${AppString().txt_currency_symbole} " +
                                    "${(controller.withdrawalModelTDS.value.data.tdsInfo.tds.value / 100).toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: "Montserrat"))
                            : Text("${AppString().txt_currency_symbole} " + "0",
                                style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: "Montserrat"))),
                      ],
                    ), //TDS
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("You Get",
                            style: TextStyle(
                                color: AppColor().whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: "Montserrat")),
                        controller.withdrawalModelTDS.value.data
                                    .payoutAfterCharges.valueP !=
                                null
                            ? Text(
                                "${AppString().txt_currency_symbole} " +
                                    "${(controller.withdrawalModelTDS.value.data.payoutAfterCharges.valueP / 100).toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: "Montserrat"))
                            : Text("0",
                                style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: "Montserrat")),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => userController.profileDataRes.value!=null && userController.profileDataRes.value.level != null &&
                                  userController.profileDataRes.value.level.value >
                                      0 &&
                                  userController.transactionFee.value != null
                              ? Text("${userController.transactionFee.value} % fee is charged on all withdraw",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppColor().whiteColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      fontFamily: "Roboto"))
                              : userController.profileDataRes.value != null &&
                                      userController.profileDataRes.value.settings !=
                                          null &&
                                      userController.profileDataRes.value.settings.withdrawRequest !=
                                          null &&
                                      userController.profileDataRes.value.settings.withdrawRequest.transactionFee !=
                                          null &&
                                      userController
                                              .profileDataRes
                                              .value
                                              .settings
                                              .withdrawRequest
                                              .transactionFee
                                              .getTransacionFee() !=
                                          null
                                  ? Text("${userController.profileDataRes.value.settings.withdrawRequest.transactionFee.getTransacionFee() + " fee is charged on all withdraw"}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: AppColor().whiteColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                          fontFamily: "Montserrat"))
                                  : Text("${userController.appSettingReponse != null && userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null && userController.appSettingReponse.value.withdrawRequest.transactionFee != null ? userController.appSettingReponse.value.withdrawRequest.transactionFee.getTransacionFee() + " fee is charged on all withdraw" : ""}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: AppColor().whiteColor, fontWeight: FontWeight.w400, fontSize: 10, fontFamily: "Montserrat")),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (isRedundentClick(DateTime.now())) {
                          Utils().customPrint(
                              'ProgressBarClick: showProgress click');
                          return;
                        }
                        Utils().customPrint(
                            'ProgressBarClick: showProgress run process');
                        Navigator.of(context).pop();
                        //Navigator.of(context).pop();

                        if (controller.withdrawType.value.compareTo("Bank") ==
                            0) {
                          //  controller.alertForPendingWithdrawal(context);
                          controller.getWithdrawalClick(
                              "BANK",
                              context,
                              controller
                                  .withdrawalModelR.value.bank_array[0].sId,
                              walletId,
                              userController.winning_bal.value,
                              userController.maxAmountWithdraw,
                              userController.maxAmountUserLavWithdraw,
                              userController.minAmountUserLavWithdraw,
                              userController.noOfTransactionsPerDayWithdraw);


                          Get.to(()=>WithdrawProcessingScreen());
                        } else if (controller.withdrawType.value
                                .compareTo("UPI") ==
                            0) {
                          controller.getWithdrawalClick(
                              "UPI",
                              context,
                              controller
                                  .withdrawalModelR.value.upi_array[0].sId,
                              walletId,
                              userController.winning_bal.value,
                              userController.maxAmountWithdraw,
                              userController.maxAmountUserLavWithdraw,
                              userController.minAmountUserLavWithdraw,
                              userController.noOfTransactionsPerDayWithdraw);

                          Get.to(()=>WithdrawProcessingScreen());
                        } else {
                          Fluttertoast.showToast(
                              msg: "Need to select withdraw methods");
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 235,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().button_bg)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("OKAY",
                              style: TextStyle(
                                  color: AppColor().whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  fontFamily: "Montserrat")),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  void showInfoDialog(BuildContext context) {
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("    "),
                          Center(
                            child: Text(
                              "Withdrawals Limits",
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
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Min. withdrawal amount",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                //  fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                          Obx(
                            () => userController.profileDataRes.value != null &&
                                    userController
                                            .profileDataRes.value.settings !=
                                        null &&
                                    userController.profileDataRes.value.settings
                                            .withdrawRequest !=
                                        null &&
                                    userController.profileDataRes.value.settings
                                            .withdrawRequest.minAmount !=
                                        null &&
                                    userController.profileDataRes.value.settings
                                            .withdrawRequest.minAmount >
                                        0
                                ? Text(
                                    "\u{20B9} ${userController.profileDataRes.value.settings.withdrawRequest.minAmount ~/ 100}",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                : Text(
                                    "\u{20B9} ${userController.appSettingReponse != null && userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null ? userController.appSettingReponse.value.withdrawRequest.minAmount ~/ 100 : '0'}",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: .5,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Withdrawals per day ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                          Obx(
                            () => userController.profileDataRes.value != null &&
                                    userController
                                            .profileDataRes.value.settings !=
                                        null &&
                                    userController.profileDataRes.value.settings
                                            .withdrawRequest !=
                                        null &&
                                    userController
                                            .profileDataRes
                                            .value
                                            .settings
                                            .withdrawRequest
                                            .noOfTransactionsPerDay !=
                                        null &&
                                    userController
                                            .profileDataRes
                                            .value
                                            .settings
                                            .withdrawRequest
                                            .noOfTransactionsPerDay >
                                        0
                                ? Text(
                                    "${userController.profileDataRes.value.settings.withdrawRequest.noOfTransactionsPerDay}",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                : Text(
                                    "${userController.appSettingReponse != null && userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null ? userController.appSettingReponse.value.withdrawRequest.noOfTransactionsPerDay : '0'}",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                          )

                          /* Text(
                            " ${userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null ? userController.appSettingReponse.value.withdrawRequest.noOfTransactionsPerDay : '0'}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),*/
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: .5,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Withdrawal Commission",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                          Obx(
                            () => userController.profileDataRes.value.level !=
                                        null &&
                                    userController
                                            .profileDataRes.value.level.value >
                                        0 &&
                                    userController.transactionFee.value != null
                                ? Text(
                                    "${userController.transactionFee.value}",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: AppColor().whiteColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                : userController
                                                .profileDataRes.value !=
                                            null &&
                                        userController
                                                .profileDataRes.value.settings !=
                                            null &&
                                        userController.profileDataRes.value.settings
                                                .withdrawRequest !=
                                            null &&
                                        userController
                                                .profileDataRes
                                                .value
                                                .settings
                                                .withdrawRequest
                                                .transactionFee !=
                                            null &&
                                        userController
                                            .profileDataRes
                                            .value
                                            .settings
                                            .withdrawRequest
                                            .transactionFee
                                            .getTransacionFee()
                                            .isNotEmpty
                                    ? Text(
                                        "${userController.profileDataRes.value.settings.withdrawRequest.transactionFee.getTransacionFee()}",
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            color: AppColor().whiteColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      )
                                    : Text(
                                        "${userController.appSettingReponse != null && userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null ? userController.appSettingReponse.value.withdrawRequest.transactionFee.getTransacionFee() : '0'}",
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            color: AppColor().whiteColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                          )
                          /*    Text(
                            "${userController.appSettingReponse.value != null && userController.appSettingReponse.value.withdrawRequest != null && userController.appSettingReponse.value.withdrawRequest.transactionFee != null ? userController.appSettingReponse.value.withdrawRequest.transactionFee.getTransacionFee() : "0%"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),*/
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: .5,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor().colorPrimary,
                        ),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        height: 42,
                        child: InkWell(
                          onTap: () => {Navigator.pop(context)},
                          child: Text(
                            "OKAY",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  num getValuePercnet() {
    int percentage = 0;
    String type = "percent";
    num value = 0;
    if (userController.appSettingReponse != null &&
        userController.appSettingReponse.value != null &&
        userController.appSettingReponse.value.withdrawRequest != null &&
        userController.appSettingReponse.value.withdrawRequest.transactionFee !=
            null) {
      percentage = userController
          .appSettingReponse.value.withdrawRequest.transactionFee.value;
      type = userController
          .appSettingReponse.value.withdrawRequest.transactionFee.type;
    }
    if (type == "percent") {
      value = controller.enter_Amount.value -
          ((controller.enter_Amount.value * percentage) / 100);
    } else {
      value = controller.enter_Amount.value - percentage;
    }
    return value;
  }

  num getWitdrawnFree() {
    int percentage = 0;
    String type = "percent";
    num value = 0;
    if (userController.appSettingReponse != null &&
        userController.appSettingReponse.value != null &&
        userController.appSettingReponse.value.withdrawRequest != null &&
        userController.appSettingReponse.value.withdrawRequest.transactionFee !=
            null) {
      percentage = userController
          .appSettingReponse.value.withdrawRequest.transactionFee.value;
      type = userController
          .appSettingReponse.value.withdrawRequest.transactionFee.type;
    }
    if (type == "percent") {
      value = ((controller.enter_Amount.value * percentage) / 100);
    } else {
      value = percentage;
    }
    return value;
  }

  num getValuePercnetLocal() {
    int percentage = 0;
    String type = "percent";
    num value = 0;
    if (userController.profileDataRes != null &&
        userController.profileDataRes.value != null &&
        userController.profileDataRes.value.settings != null &&
        userController.profileDataRes.value.settings.withdrawRequest != null &&
        userController
                .profileDataRes.value.settings.withdrawRequest.transactionFee !=
            null) {
      percentage = userController
          .profileDataRes.value.settings.withdrawRequest.transactionFee.value;
      type = userController
          .profileDataRes.value.settings.withdrawRequest.transactionFee.type;
    }
    if (type == "percent") {
      value = controller.enter_Amount.value -
          ((controller.enter_Amount.value * percentage) / 100);
    } else {
      value = controller.enter_Amount.value - percentage;
    }
    return value;
  }

  num getWitdrawnFreeLocal() {
    int percentage = 0;
    String type = "percent";
    num value = 0;
    if (userController.profileDataRes != null &&
        userController.profileDataRes.value != null &&
        userController.profileDataRes.value.settings != null &&
        userController.profileDataRes.value.settings.withdrawRequest != null &&
        userController
                .profileDataRes.value.settings.withdrawRequest.transactionFee !=
            null) {
      percentage = userController
          .profileDataRes.value.settings.withdrawRequest.transactionFee.value;
      type = userController
          .profileDataRes.value.settings.withdrawRequest.transactionFee.type;
    }
    if (type == "percent") {
      value = ((controller.enter_Amount.value * percentage) / 100);
    } else {
      value = percentage;
    }
    return value;
  }

  num getValuePercnetVIP() {
    num value = 0;
    if (userController.profileDataRes.value.level != null &&
        userController.profileDataRes.value.level.value > 0 &&
        userController.transactionFee.value != null) {
      value = controller.enter_Amount.value -
          ((controller.enter_Amount.value *
                  userController.transactionFee.value) /
              100);
    }
    return value;
  }

  num getWitdrawnFreeVIP() {
    num value = 0;

    if (userController.profileDataRes.value.level != null &&
        userController.profileDataRes.value.level.value > 0 &&
        userController.transactionFee.value != null) {
      value = ((controller.enter_Amount.value *
              userController.transactionFee.value) /
          100);
    }

    return value;
  }

  withdrawTDS(BuildContext context) async {
    if (controller.withdrawType.value.compareTo("Bank") == 0) {
      var map = {
        "walletId": walletId,
        "withdrawMethodId": controller.withdrawalModelR.value.bank_array[0].sId,
        "amount": {"value": (controller.enter_Amount.value * 100)}
      };
      await controller.getWithdrawalTDS(context, map);
      showWithdraw(context);
    } else if (controller.withdrawType.value.compareTo("UPI") == 0) {
      var map = {
        "walletId": walletId,
        "withdrawMethodId": controller.withdrawalModelR.value.upi_array[0].sId,
        "amount": {"value": (controller.enter_Amount.value * 100)}
      };
      await controller.getWithdrawalTDS(context, map);
      showWithdraw(context);
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
    if (currentTime.difference(loginClickTime).inSeconds < 3) {
      // set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
  }
}
