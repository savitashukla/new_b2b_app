import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gmng/model/AppSettingResponse.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/ui/controller/BaseController.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/cash_free/CashFreeController.dart';
import 'package:gmng/ui/main/cash_free/CashFreeScreen.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class VipProgramScreen extends StatefulWidget {
  //const VipProgramScreen({Key key}) : super(key: key);
  VipProgramScreen();

  @override
  State<VipProgramScreen> createState() => _VipProgramScreenState();
}

class _VipProgramScreenState extends State<VipProgramScreen> {
  WalletPageController walletPageController = Get.put(WalletPageController());
  UserController userController = Get.put(UserController());
  CleverTapController cleverTapController = Get.put(CleverTapController());
  var vip_benefits_text = "".obs;
  var vip_description_text = "".obs;
  var vip_border_click_helper = 0.obs;
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  @override
  void initState() {
    try {
      walletPageController.selectAmount.value = "";
      walletPageController.promocode.value = "";
      Utils().customPrint(
          'PROFILE LEVEL ${userController.profileDataRes.value.level.value}');

      //dynamic work
      vip_benefits_text.value = "LEVEL".tr +
          " ${userController.profileDataRes.value.level.value} " +
          "Benefits".tr;
      vip_description_text.value =
          userController.descriptionAccordingVIPLevel.value;
      vip_border_click_helper.value =
          userController.profileDataRes.value.level.value;

      for (int i = 0;
          i < walletPageController.walletModelPromoBanner.value.data.length;
          i++) {
        if (walletPageController
                .walletModelPromoBanner.value.data[i].vipLevel ==
            userController.profileDataRes.value.level.value) {
          print(
              'userVipLevel MATCH obj new ${userController.profileDataRes.value.level.id}');
          walletPageController.selectAmount.value = walletPageController
              .walletModelPromoBanner.value.data[i].fromValue;
          walletPageController.promocode.value =
              walletPageController.walletModelPromoBanner.value.data[i].code;
          vipBannerClickPromoCode();
          break;
        }
      }

      //end

      //static work
      /*if (userController.profileDataRes.value.level.value == 0) {
        vip_benefits_text.value = "LEVEL 0 Benefits"; //-done
        vip_description_text.value =
            userController.descriptionAccordingZeroVIPLevel.value;
        vip_border_click_helper.value = 0; //-done

        for (int i = 0;
            i < walletPageController.walletModelPromoBanner.value.data.length;
            i++) {
          if (walletPageController
                  .walletModelPromoBanner.value.data[i].vipLevel ==
              0) {
            Utils().customPrint(
                'initStateinitState: Level ${walletPageController.walletModelPromoBanner.value.data[i].vipLevel}');

            //setting up values
            walletPageController.selectAmount.value = walletPageController
                .walletModelPromoBanner.value.data[i].fromValue;
            walletPageController.promocode.value =
                walletPageController.walletModelPromoBanner.value.data[i].code;
            vipBannerClickPromoCode();
            break;
          }
        }
      } else if (userController.profileDataRes.value.level.value == 1) {
        vip_benefits_text.value = "LEVEL 1 Benefits";
        vip_description_text.value =
            userController.descriptionAccordingOneVIPLevel.value;
        vip_border_click_helper.value = 1;

        for (int i = 0;
            i < walletPageController.walletModelPromoBanner.value.data.length;
            i++) {
          if (walletPageController
                  .walletModelPromoBanner.value.data[i].vipLevel ==
              1) {
            Utils().customPrint(
                'initStateinitState: Level ${walletPageController.walletModelPromoBanner.value.data[i].vipLevel}');

            //setting up values
            walletPageController.selectAmount.value = walletPageController
                .walletModelPromoBanner.value.data[i].fromValue;
            walletPageController.promocode.value =
                walletPageController.walletModelPromoBanner.value.data[i].code;
            vipBannerClickPromoCode();
            break;
          }
        }
      } else if (userController.profileDataRes.value.level.value == 2) {
        vip_benefits_text.value = "LEVEL 2 Benefits";
        vip_description_text.value =
            userController.descriptionAccordingTwoVIPLevel.value;
        vip_border_click_helper.value = 2;

        for (int i = 0;
            i < walletPageController.walletModelPromoBanner.value.data.length;
            i++) {
          if (walletPageController
                  .walletModelPromoBanner.value.data[i].vipLevel ==
              2) {
            Utils().customPrint(
                'initStateinitState: Level ${walletPageController.walletModelPromoBanner.value.data[i].vipLevel}');

            //setting up values
            walletPageController.selectAmount.value = walletPageController
                .walletModelPromoBanner.value.data[i].fromValue;
            walletPageController.promocode.value =
                walletPageController.walletModelPromoBanner.value.data[i].code;
            vipBannerClickPromoCode();
            break;
          }
        }
      } else {
        vip_benefits_text.value = "LEVEL 3 Benefits";
        vip_description_text.value = "N/A";
        vip_border_click_helper.value = 3;
        walletPageController.selectAmount.value = "0";
        walletPageController.promocode.value = "";
      }*/
    } catch (e) {
      Utils().customPrint("Error @initState: ${e.toString()}");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.black,
            /*flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),*/
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    BaseController base_controller = Get.put(BaseController());
                    base_controller.openwhatsappOTPV();
                  },
                  child: Image(
                      height: 30,
                      width: 30,
                      image: AssetImage("assets/images/vip_whatsapp.png")),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    BaseController base_controller = Get.put(BaseController());
                    base_controller.dialNumber();
                  },
                  child: Image(
                      height: 30,
                      width: 30,
                      image: AssetImage("assets/images/vip_call.png")),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    //BaseController base_controller = Get.put(BaseController());
                    //base_controller.msgNumber();
                    //opening freshchat
                    userController.SetFreshchatUser();
                    Freshchat.showFAQ();
                  },
                  child: Image(
                      height: 30,
                      width: 30,
                      image: AssetImage("assets/images/vip_message.png")),
                ),
              ],
            )),
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Center(
                    child: Image(
                        height: 100,
                        //width: 30,
                        image:
                            AssetImage("assets/images/vip_program_text.png")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    margin:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                    padding:
                        EdgeInsets.only(top: 20, bottom: 0, left: 0, right: 0),
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
                      border:
                          Border.all(color: AppColor().border_inside, width: 1),
                      borderRadius: BorderRadius.circular(20),
                      // color: AppColor().whiteColor
                    ),
                    child: Column(
                      children: [
                        Padding(
                          key: walletPageController.keyButton3,
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0, bottom: 0, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, bottom: 2),
                                            child: Text(
                                              "LEVEL".tr +
                                                  " ${userController.profileDataRes.value.level.value}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: "Montserrat",
                                                  color: AppColor()
                                                      .vip_light_gray),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0, bottom: 2),
                                            child: Text(
                                              "LEVEL".tr +
                                                  " ${userController.profileDataRes.value.level.value + 1}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: "Montserrat",
                                                  color: AppColor()
                                                      .vip_light_gray),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: LinearPercentIndicator(
                                        //width: 140.0,
                                        lineHeight: 10.0,
                                        percent: walletPageController
                                            .percentageVipProgressCircularBar
                                            .value,
                                        padding: EdgeInsets.all(0),
                                        //center: Text("50.0%", style: new TextStyle(fontSize: 12.0),),
                                        /* trailing: Align(
                                      alignment: Alignment.topLeft,
                                      child: Image(
                                          height: 20,
                                          width: 20,
                                          image: AssetImage("assets/images/vip_flag.png")),
                                    ),*/
                                        barRadius: Radius.circular(8),
                                        backgroundColor:
                                            AppColor().gray_vip_button,
                                        progressColor:
                                            AppColor().yellow_vip_button,
                                        animationDuration: 2000,
                                        animation: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image(
                                  height: 30,
                                  width: 30,
                                  image:
                                      AssetImage("assets/images/vip_flag.png")),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            // margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                            padding: EdgeInsets.only(
                                top: 15, bottom: 5, left: 0, right: 0),
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
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15))
                                // color: AppColor().whiteColor
                                ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      userController.profileDataRes.value !=
                                                  null &&
                                              userController.profileDataRes
                                                      .value.stats !=
                                                  null &&
                                              userController
                                                      .profileDataRes
                                                      .value
                                                      .stats
                                                      .instantCash !=
                                                  null
                                          ? Text(
                                              "\u{20B9}${(userController.profileDataRes.value.stats.instantCash.value / 100).toStringAsFixed(2).replaceAll(regex, '')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: "Inter",
                                                  color: AppColor()
                                                      .yellow_vip_button),
                                            )
                                          : Text(""),
                                      Text(
                                        userController.instantCashLimitNextLevel
                                                    .value ==
                                                0
                                            ? "Max"
                                            : "\u{20B9}${(userController.instantCashLimitNextLevel.value / 100).toStringAsFixed(0)}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: "Inter",
                                            color: AppColor().vip_green),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Current".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Montserrat",
                                            color: AppColor().gray_vip_text),
                                      ),
                                      Text(
                                        "Goal".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Montserrat",
                                            color: AppColor().gray_vip_text),
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 30),
                    child: Text(
                      "Journey".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Montserrat",
                          color: AppColor().yellow_vip_button),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    margin:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                    padding:
                        EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
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
                      border:
                          Border.all(color: AppColor().border_inside, width: 1),
                      borderRadius: BorderRadius.circular(20),
                      // color: AppColor().whiteColor
                    ),
                    child: Column(
                      children: [
                        Column(
                          key: walletPageController.keyButton4,
                          children: [
                            Text(
                              "Instant Cashback".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: AppColor().gray_vip_text),
                            ),
                            Stack(children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 40, right: 40),
                                child: LinearPercentIndicator(
                                  //width: 140.0,
                                  lineHeight: 3.0,
                                  percent: userController.profileDataRes.value
                                              .level.value ==
                                          0
                                      ? 0
                                      : userController.profileDataRes.value
                                                  .level.value ==
                                              1
                                          ? 0.5
                                          : userController.profileDataRes.value
                                                      .level.value ==
                                                  2
                                              ? 1
                                              : 1, //walletPageController.percentageVipProgressCircularBar.value,
                                  padding: EdgeInsets.all(0),
                                  barRadius: Radius.circular(8),
                                  backgroundColor: Color(0x4d4e554e),
                                  progressColor: Color(0x80f19812),
                                  animationDuration: 2000,
                                  animation: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (userController
                                                  .descriptionAccordingZeroVIPLevel !=
                                              null) {
                                            vip_benefits_text.value =
                                                "LEVEL".tr +
                                                    " 0 " +
                                                    "Benefits".tr;
                                            vip_description_text.value =
                                                userController
                                                    .descriptionAccordingZeroVIPLevel
                                                    .value;
                                            vip_border_click_helper.value = 0;
                                            walletPageController
                                                .selectAmount.value = "";
                                            walletPageController
                                                .promocode.value = "";
                                            updateAmountWidget(0);
                                          }
                                        },
                                        child: Image(
                                            height: 25,
                                            width: 25,
                                            image: userController.profileDataRes
                                                        .value.level.value ==
                                                    0
                                                ? AssetImage(
                                                    "assets/images/vip_green_dot.png")
                                                : AssetImage(
                                                    "assets/images/vip_yellow_dot.png")),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 10,
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (userController
                                                  .descriptionAccordingOneVIPLevel !=
                                              null) {
                                            vip_benefits_text.value =
                                                "LEVEL".tr +
                                                    " 1 " +
                                                    "Benefits".tr;
                                            vip_description_text.value =
                                                userController
                                                    .descriptionAccordingOneVIPLevel
                                                    .value;
                                            vip_border_click_helper.value = 1;
                                            walletPageController
                                                .selectAmount.value = "";
                                            walletPageController
                                                .promocode.value = "";

                                            updateAmountWidget(1);
                                          }
                                        },
                                        child: Image(
                                            height: 25,
                                            width: 25,
                                            image: userController.profileDataRes
                                                        .value.level.value ==
                                                    1
                                                ? AssetImage(
                                                    "assets/images/vip_green_dot.png")
                                                : userController.profileDataRes
                                                            .value.level.value >
                                                        1
                                                    ? AssetImage(
                                                        "assets/images/vip_yellow_dot.png")
                                                    : AssetImage(
                                                        "assets/images/vip_gray_dot.png")),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 10,
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (userController
                                                  .descriptionAccordingTwoVIPLevel !=
                                              null) {
                                            vip_benefits_text.value =
                                                "LEVEL".tr +
                                                    " 2 " +
                                                    "Benefits".tr;
                                            vip_description_text.value =
                                                userController
                                                    .descriptionAccordingTwoVIPLevel
                                                    .value;
                                            vip_border_click_helper.value = 2;
                                            walletPageController
                                                .selectAmount.value = "";
                                            walletPageController
                                                .promocode.value = "";
                                            updateAmountWidget(2);
                                          }
                                        },
                                        child: Image(
                                            height: 25,
                                            width: 25,
                                            image: userController.profileDataRes
                                                        .value.level.value ==
                                                    2
                                                ? AssetImage(
                                                    "assets/images/vip_green_dot.png")
                                                : userController.profileDataRes
                                                            .value.level.value >
                                                        2
                                                    ? AssetImage(
                                                        "assets/images/vip_yellow_dot.png")
                                                    : AssetImage(
                                                        "assets/images/vip_gray_dot.png")),
                                      ),
                                    ),
                                    Visibility(
                                      visible: userController
                                                  .vipmodulesAllL.value.data !=
                                              null &&
                                          userController.vipmodulesAllL.value
                                                  .data.length >
                                              3,
                                      child: Expanded(
                                        child: SizedBox(
                                          width: 10,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: userController.vipmodulesAllL
                                              .value.data.length >
                                          3,
                                      child: Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (userController
                                                    .descriptionAccordingTwoVIPLevel !=
                                                null) {
                                              vip_benefits_text.value =
                                                  "LEVEL".tr +
                                                      " 3 " +
                                                      "Benefits".tr;
                                              vip_description_text.value =
                                                  userController
                                                      .descriptionAccordingTwoVIPLevel
                                                      .value;
                                              vip_border_click_helper.value = 3;
                                              walletPageController
                                                  .selectAmount.value = "";
                                              walletPageController
                                                  .promocode.value = "";
                                              updateAmountWidget(3);
                                            }
                                          },
                                          child: Image(
                                              height: 25,
                                              width: 25,
                                              image: userController
                                                          .profileDataRes
                                                          .value
                                                          .level
                                                          .value ==
                                                      3
                                                  ? AssetImage(
                                                      "assets/images/vip_green_dot.png")
                                                  : userController
                                                              .profileDataRes
                                                              .value
                                                              .level
                                                              .value >
                                                          3
                                                      ? AssetImage(
                                                          "assets/images/vip_yellow_dot.png")
                                                      : AssetImage(
                                                          "assets/images/vip_gray_dot.png")),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: userController.vipmodulesAllL
                                              .value.data.length >
                                          4,
                                      child: Expanded(
                                        child: SizedBox(
                                          width: 10,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: userController.vipmodulesAllL
                                              .value.data.length >
                                          4,
                                      child: Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (userController
                                                    .descriptionAccordingTwoVIPLevel !=
                                                null) {
                                              vip_benefits_text.value =
                                                  "LEVEL".tr +
                                                      " 4 " +
                                                      "Benefits".tr;
                                              vip_description_text.value =
                                                  userController
                                                      .descriptionAccordingTwoVIPLevel
                                                      .value;
                                              vip_border_click_helper.value = 4;
                                              walletPageController
                                                  .selectAmount.value = "";
                                              walletPageController
                                                  .promocode.value = "";
                                              updateAmountWidget(4);
                                            }
                                          },
                                          child: Image(
                                              height: 25,
                                              width: 25,
                                              image: userController
                                                          .profileDataRes
                                                          .value
                                                          .level
                                                          .value ==
                                                      3
                                                  ? AssetImage(
                                                      "assets/images/vip_green_dot.png")
                                                  : userController
                                                              .profileDataRes
                                                              .value
                                                              .level
                                                              .value >
                                                          3
                                                      ? AssetImage(
                                                          "assets/images/vip_yellow_dot.png")
                                                      : AssetImage(
                                                          "assets/images/vip_gray_dot.png")),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: InkWell(
                                      onTap: () {
                                        if (userController
                                                .descriptionAccordingZeroVIPLevel !=
                                            null) {
                                          vip_benefits_text.value = "LEVEL".tr +
                                              " 0 " +
                                              "Benefits".tr;
                                          vip_description_text.value =
                                              userController
                                                  .descriptionAccordingZeroVIPLevel
                                                  .value;
                                          vip_border_click_helper.value = 0;
                                          walletPageController
                                              .selectAmount.value = "";
                                          walletPageController.promocode.value =
                                              "";
                                          updateAmountWidget(0);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 20,
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5),
                                          decoration: BoxDecoration(
                                            gradient: vip_border_click_helper
                                                        .value ==
                                                    0
                                                ? null
                                                : LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      AppColor().scratch_card,
                                                      AppColor().border_outside,
                                                      AppColor().border_outside,
                                                      AppColor().scratch_card,
                                                    ],
                                                  ),
                                            border: vip_border_click_helper
                                                        .value ==
                                                    0
                                                ? Border.all(
                                                    color: AppColor()
                                                        .yellow_vip_button,
                                                    width: 1)
                                                : Border.all(
                                                    color: AppColor()
                                                        .vip_button_light,
                                                    width: 0),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // color: AppColor().whiteColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "LEVEL".tr + " 0",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: userController
                                                              .profileDataRes
                                                              .value
                                                              .level
                                                              .value >
                                                          3
                                                      ? 10
                                                      : 12,
                                                  fontWeight:
                                                      vip_border_click_helper
                                                                  .value ==
                                                              0
                                                          ? FontWeight.w600
                                                          : FontWeight.w400,
                                                  fontFamily: "Montserrat",
                                                  color: AppColor().whiteColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      width: 10,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: InkWell(
                                      onTap: () {
                                        if (userController
                                                .descriptionAccordingOneVIPLevel !=
                                            null) {
                                          vip_benefits_text.value = "LEVEL".tr +
                                              " 1 " +
                                              "Benefits".tr;
                                          vip_description_text.value =
                                              userController
                                                  .descriptionAccordingOneVIPLevel
                                                  .value;
                                          vip_border_click_helper.value = 1;
                                          walletPageController
                                              .selectAmount.value = "";
                                          walletPageController.promocode.value =
                                              "";
                                          updateAmountWidget(1);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: Container(
                                          height: 20,
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5),
                                          decoration: BoxDecoration(
                                            gradient: vip_border_click_helper
                                                        .value ==
                                                    1
                                                ? null
                                                : LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      AppColor().scratch_card,
                                                      AppColor().border_outside,
                                                      AppColor().border_outside,
                                                      AppColor().scratch_card,
                                                    ],
                                                  ),
                                            border: vip_border_click_helper
                                                        .value ==
                                                    1
                                                ? Border.all(
                                                    color: AppColor()
                                                        .yellow_vip_button,
                                                    width: 1)
                                                : Border.all(
                                                    color: AppColor()
                                                        .vip_button_light,
                                                    width: 0),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // color: AppColor().whiteColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "LEVEL".tr + " 1",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: userController
                                                              .profileDataRes
                                                              .value
                                                              .level
                                                              .value >
                                                          3
                                                      ? 10
                                                      : 12,
                                                  fontWeight:
                                                      vip_border_click_helper
                                                                  .value ==
                                                              1
                                                          ? FontWeight.w600
                                                          : FontWeight.w400,
                                                  fontFamily: "Montserrat",
                                                  color: userController
                                                              .profileDataRes
                                                              .value
                                                              .level
                                                              .value ==
                                                          1
                                                      ? AppColor().whiteColor
                                                      : userController
                                                                  .profileDataRes
                                                                  .value
                                                                  .level
                                                                  .value >
                                                              1
                                                          ? AppColor()
                                                              .whiteColor
                                                          : vip_border_click_helper
                                                                      .value ==
                                                                  1
                                                              ? AppColor()
                                                                  .whiteColor
                                                              : AppColor()
                                                                  .gray_vip_button),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      width: 10,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: InkWell(
                                      onTap: () {
                                        if (userController
                                                .descriptionAccordingTwoVIPLevel !=
                                            null) {
                                          vip_benefits_text.value = "LEVEL".tr +
                                              " 2 " +
                                              "Benefits".tr;
                                          vip_description_text.value =
                                              userController
                                                  .descriptionAccordingTwoVIPLevel
                                                  .value;
                                          vip_border_click_helper.value = 2;
                                          walletPageController
                                              .selectAmount.value = "";
                                          walletPageController.promocode.value =
                                              "";
                                          updateAmountWidget(2);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.0),
                                        child: Container(
                                          height: 20,
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5),
                                          decoration: BoxDecoration(
                                            gradient: vip_border_click_helper
                                                        .value ==
                                                    2
                                                ? null
                                                : LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      AppColor().scratch_card,
                                                      AppColor().border_outside,
                                                      AppColor().border_outside,
                                                      AppColor().scratch_card,
                                                    ],
                                                  ),
                                            border: vip_border_click_helper
                                                        .value ==
                                                    2
                                                ? Border.all(
                                                    color: AppColor()
                                                        .yellow_vip_button,
                                                    width: 1)
                                                : Border.all(
                                                    color: AppColor()
                                                        .vip_button_light,
                                                    width: 0),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // color: AppColor().whiteColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "LEVEL".tr + " 2",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: userController
                                                              .profileDataRes
                                                              .value
                                                              .level
                                                              .value >
                                                          3
                                                      ? 10
                                                      : 12,
                                                  fontWeight:
                                                      vip_border_click_helper
                                                                  .value ==
                                                              2
                                                          ? FontWeight.w600
                                                          : FontWeight.w400,
                                                  fontFamily: "Montserrat",
                                                  color: vip_border_click_helper
                                                              .value ==
                                                          2
                                                      ? AppColor().whiteColor
                                                      : AppColor()
                                                          .gray_vip_button),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userController
                                            .vipmodulesAllL.value.data.length >
                                        3,
                                    child: Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 10,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userController
                                            .vipmodulesAllL.value.data.length >
                                        3,
                                    child: Expanded(
                                      flex: 3,
                                      child: InkWell(
                                        onTap: () {
                                          if (userController
                                                  .descriptionAccordingThreeVIPLevel !=
                                              null) {
                                            vip_benefits_text.value =
                                                "LEVEL".tr +
                                                    " 3 " +
                                                    "Benefits".tr;
                                            vip_description_text.value =
                                                userController
                                                    .descriptionAccordingThreeVIPLevel
                                                    .value;
                                            vip_border_click_helper.value = 3;
                                            walletPageController
                                                .selectAmount.value = "";
                                            walletPageController
                                                .promocode.value = "";
                                            updateAmountWidget(3);
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3.0),
                                          child: Container(
                                            height: 20,
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 5),
                                            decoration: BoxDecoration(
                                              gradient: vip_border_click_helper
                                                          .value ==
                                                      3
                                                  ? null
                                                  : LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        AppColor().scratch_card,
                                                        AppColor()
                                                            .border_outside,
                                                        AppColor()
                                                            .border_outside,
                                                        AppColor().scratch_card,
                                                      ],
                                                    ),
                                              border: vip_border_click_helper
                                                          .value ==
                                                      3
                                                  ? Border.all(
                                                      color: AppColor()
                                                          .yellow_vip_button,
                                                      width: 1)
                                                  : Border
                                                      .all(
                                                          color: AppColor()
                                                              .vip_button_light,
                                                          width: 0),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              // color: AppColor().whiteColor
                                            ),
                                            child: Center(
                                              child: Text(
                                                "LEVEL".tr + " 3",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: userController
                                                                .profileDataRes
                                                                .value
                                                                .level
                                                                .value >
                                                            3
                                                        ? 10
                                                        : 12,
                                                    fontWeight:
                                                        vip_border_click_helper
                                                                    .value ==
                                                                3
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                    fontFamily: "Montserrat",
                                                    color: vip_border_click_helper
                                                                .value ==
                                                            3
                                                        ? AppColor().whiteColor
                                                        : AppColor()
                                                            .gray_vip_button),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userController
                                            .vipmodulesAllL.value.data.length >
                                        4,
                                    child: Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userController
                                            .vipmodulesAllL.value.data.length >
                                        4,
                                    child: Expanded(
                                      flex: 3,
                                      child: InkWell(
                                        onTap: () {
                                          if (userController
                                                  .descriptionAccordingFourVIPLevel !=
                                              null) {
                                            vip_benefits_text.value =
                                                "LEVEL".tr +
                                                    " 4 " +
                                                    "Benefits".tr;
                                            vip_description_text.value =
                                                userController
                                                    .descriptionAccordingFourVIPLevel
                                                    .value;
                                            vip_border_click_helper.value = 4;
                                            walletPageController
                                                .selectAmount.value = "";
                                            walletPageController
                                                .promocode.value = "";
                                            updateAmountWidget(4);
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3.0),
                                          child: Container(
                                            height: 20,
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 5),
                                            decoration: BoxDecoration(
                                              gradient: vip_border_click_helper
                                                          .value ==
                                                      4
                                                  ? null
                                                  : LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        AppColor().scratch_card,
                                                        AppColor()
                                                            .border_outside,
                                                        AppColor()
                                                            .border_outside,
                                                        AppColor().scratch_card,
                                                      ],
                                                    ),
                                              border: vip_border_click_helper
                                                          .value ==
                                                      4
                                                  ? Border.all(
                                                      color: AppColor()
                                                          .yellow_vip_button,
                                                      width: 1)
                                                  : Border
                                                      .all(
                                                          color: AppColor()
                                                              .vip_button_light,
                                                          width: 0),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              // color: AppColor().whiteColor
                                            ),
                                            child: Center(
                                              child: Text(
                                                "LEVEL".tr + " 4",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: userController
                                                                .profileDataRes
                                                                .value
                                                                .level
                                                                .value >
                                                            3
                                                        ? 10
                                                        : 12,
                                                    fontWeight:
                                                        vip_border_click_helper
                                                                    .value ==
                                                                4
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                    fontFamily: "Montserrat",
                                                    color: vip_border_click_helper
                                                                .value ==
                                                            4
                                                        ? AppColor().whiteColor
                                                        : AppColor()
                                                            .gray_vip_button),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, left: 10, right: 10, bottom: 15),
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
                          ],
                        ),

                        //....
                        Column(
                          key: walletPageController.keyButton5,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 0),
                                child: Text(
                                  vip_benefits_text.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Montserrat",
                                      fontStyle: FontStyle.italic,
                                      color: AppColor().yellow_vip_button),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                // margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 0, right: 0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColor().scratch_card,
                                      AppColor().border_outside,
                                      AppColor().border_outside,
                                      AppColor().border_outside,
                                    ],
                                  ),
                                  border: Border.all(
                                      color: AppColor().border_inside,
                                      width: 1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  // color: AppColor().whiteColor
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Html(
                                    shrinkWrap: false,
                                    data: vip_description_text.value,
                                    /* onLinkTap: (url, _, _
                    _, ___) {
                         Utils().customPrint("Opening $url");
                        makeLaunch(url!);
                      },*/
                                    style: {
                                      "body": Style(
                                        fontSize: FontSize(14 *
                                            MediaQuery.of(context)
                                                .textScaleFactor),
                                        fontWeight: FontWeight.normal,
                                        textAlign: TextAlign.left,
                                        color: Colors.white,
                                      ),
                                      'h1': Style(
                                        fontSize: FontSize(12 *
                                            MediaQuery.of(context)
                                                .textScaleFactor),
                                        color: Colors.white,
                                        textAlign: TextAlign.left,
                                      ),
                                      'p': Style(
                                        fontSize: FontSize(16 *
                                            MediaQuery.of(context)
                                                .textScaleFactor),
                                        textAlign: TextAlign.left,
                                        color: Colors.white,
                                        alignment: Alignment.centerLeft,
                                        fontFamily: "Montserrat",
                                      ),
                                      'ul': Style(
                                        fontSize: FontSize(13 *
                                            MediaQuery.of(context)
                                                .textScaleFactor),
                                        color: Colors.white,
                                        textAlign: TextAlign
                                            .center, /*margin:  EdgeInsets.only(left: 10)*/
                                      )
                                    },
                                  ),
                                ),
                              ),
                            ),
                            walletPageController.selectAmount.value != ""
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Container(
                                      height: 55,
                                      // margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                                      padding: EdgeInsets.only(
                                          top: 5, bottom: 0, left: 0, right: 0),
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
                                              color: AppColor().border_inside,
                                              width: 1),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 10),
                                                  child: CircleAvatar(
                                                    radius: 9.0,
                                                    child: Image.asset(
                                                        "assets/images/vip_star.png"),
                                                    // child: Image.asset("assets/images/bonuscoin.webp"),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${AppString().txt_currency_symbole} ${walletPageController.selectAmount.value}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height: 10,
                                                            width: 10,
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/images/plus_sv.svg",
                                                              color: AppColor()
                                                                  .vip_green,
                                                            )),
                                                        Text(
                                                          " ${walletPageController.youWillGet.value}",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color: AppColor()
                                                                  .GreenColor),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                if (userController
                                                            .appSettingReponse
                                                            .value
                                                            .featuresStatus !=
                                                        null &&
                                                    userController
                                                            .appSettingReponse
                                                            .value
                                                            .featuresStatus
                                                            .length >
                                                        0) {
                                                  for (FeaturesStatus obj
                                                      in userController
                                                          .appSettingReponse
                                                          .value
                                                          .featuresStatus) {
                                                    if (obj.id == 'addMoney' &&
                                                        obj.status ==
                                                            'inactive') {
                                                      Utils().showWalletDown(
                                                          context);
                                                      return;
                                                    }
                                                  }
                                                }
                                                //check for VIP Levels if more that self then disable
                                                if (vip_border_click_helper
                                                        .value >
                                                    userController
                                                        .profileDataRes
                                                        .value
                                                        .level
                                                        .value) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Unlock At Next Level!');
                                                  return;
                                                }

                                                walletPageController
                                                        .gameListSelectedColor
                                                        .value =
                                                    1000; //initialisation
                                                walletPageController
                                                    .amtAfterPromoApplied
                                                    .value = 0;

                                                walletPageController
                                                    .gameAmtSelectedColor
                                                    .value = 0;
                                                //walletPageController.selectAmount.value = "0";
                                                walletPageController
                                                    .amountTextController
                                                    .value
                                                    .text = "";
                                                walletPageController
                                                    .youWillGet.value = '';
                                                walletPageController.click =
                                                    false;
                                                //walletPageController.promocode.value = '';
                                                walletPageController
                                                    .walletTypePromocode = '';
                                                walletPageController
                                                    .percentagePromocode = '';
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
                                                walletPageController
                                                    .promo_type = "".obs;
                                                walletPageController.promo_amt =
                                                    0.0.obs;
                                                walletPageController
                                                    .promo_minus_amt = 0.obs;
                                                walletPageController
                                                    .typeTextCheck = 0.obs;
                                                walletPageController
                                                    .applyPress = false.obs;
                                                walletPageController.profitAmt =
                                                    0.0.obs;
                                                AppString.contestAmount =
                                                    0; //newly added

                                                CashFreeController
                                                    cashFreeController =
                                                    Get.put(
                                                        CashFreeController());
                                                Get.to(() =>
                                                    CashFreeScreen()); //<<<<<<<<<<<<<<<<<<<<<<<<
                                                cashFreeController
                                                        .amountCashTextController
                                                        .value
                                                        .text =
                                                    walletPageController
                                                        .selectAmount.value;
                                                //walletPageController.selectAmount.value = item.fromValue;
                                                //await cashFreeController.haveCodeApplied(item.fromValue.toString());
                                                walletPageController
                                                    .applyPress.value = true;
                                                walletPageController
                                                    .buttonApplyText
                                                    .value = 'Apply';
                                                walletPageController
                                                    .boolEnterCode
                                                    .value = false;
                                                cashFreeController
                                                    .click_remove_code = true;
                                                //walletPageController.promocode.value = item.code;
                                                vipBannerClickPromoCode(); //new method
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 7.0),
                                                child: Container(
                                                    width: 125,
                                                    height: 50,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Image(
                                                        height: 40,
                                                        //width: 30,
                                                        image: vip_border_click_helper
                                                                    .value >
                                                                userController
                                                                    .profileDataRes
                                                                    .value
                                                                    .level
                                                                    .value
                                                            ? AssetImage(
                                                                "assets/images/vip_add_cash_gray.png")
                                                            : AssetImage(
                                                                "assets/images/vip_add_cash.png"))),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  //banner click method for VIP
  void promo_code_not_visible1(var entered_amount, int index_promo) {
    if (index_promo != null) {
      try {
        Utils().customPrint(
            'RRR:${walletPageController.walletModelPromoBanner.value.data[index_promo].benefit[0].wallet[0].type}');

        if (walletPageController.walletModelPromoBanner.value.data[index_promo]
                    .benefit[0].wallet[0].percentage !=
                '' &&
            walletPageController.walletModelPromoBanner.value.data[index_promo]
                    .benefit[0].wallet[0].maximumAmount !=
                '') {
          double maxAmtFixed = double.parse(walletPageController
              .walletModelPromoBanner
              .value
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .maximumAmount);

          double percentage = double.parse(walletPageController
              .walletModelPromoBanner
              .value
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .percentage);
          Utils().customPrint('Offer enterAmtInt F ');
          Utils().customPrint('Offer calcValuePerc T ');
          double enterAmtInt = double.parse(entered_amount);
          double calcValuePerc = ((percentage / 100) * enterAmtInt);

          //conditions instantCash
          if (walletPageController.walletModelPromoBanner.value
                  .data[index_promo].benefit[0].wallet[0].type ==
              'instantCash') {
            //bonus
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  /* enterAmtInt + */ maxAmtFixed;
              walletPageController.youWillGet.value =
                  /*${enterAmtInt} Cashback &*/ '${maxAmtFixed} Instant Cash';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  /* enterAmtInt +*/ calcValuePerc;
              walletPageController.youWillGet.value =
                  /*${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback &*/ '${calcValuePerc.ceil()} Instant Cash';
            }
          } else if (walletPageController.walletModelPromoBanner.value
                  .data[index_promo].benefit[0].wallet[0].type ==
              'bonus') {
            //bonus
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  /* enterAmtInt + */ maxAmtFixed;
              walletPageController.youWillGet.value =
                  /*${enterAmtInt} Cashback &*/ '${maxAmtFixed} Bonus';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  /* enterAmtInt +*/ calcValuePerc;
              walletPageController.youWillGet.value =
                  /*${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback &*/ '${calcValuePerc.ceil()} Bonus';
            }
          } else if (walletPageController.walletModelPromoBanner.value
                  .data[index_promo].benefit[0].wallet[0].type ==
              'coin') {
            //coin
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  /* enterAmtInt +*/ maxAmtFixed;
              walletPageController.youWillGet.value =
                  /*${enterAmtInt} Cashback &*/ '${maxAmtFixed} Coin';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  /* enterAmtInt + */ calcValuePerc;
              walletPageController.youWillGet.value =
                  /*${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback &*/ '${calcValuePerc.ceil()} Coin';
            }
          } else {
            //deposit
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  /*enterAmtInt +*/ maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  /*enterAmtInt +*/ calcValuePerc;
              walletPageController.youWillGet.value =
                  '${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback';
            }
          }

          //for cleverTap use
          walletPageController.percentagePromocode = percentage.toString();
          walletPageController.walletTypePromocode = walletPageController
              .walletModelPromoBanner
              .value
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .type;
          Utils().customPrint(
              'applied promo code: ${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")}');
          walletPageController.buttonApplyText.value = "Remove";
          //showCustomDialog(context);

          /////

          //saving values for UI
          //layout hide work & show deposit get UI
          CashFreeController cashFreeController = Get.put(CashFreeController());
          cashFreeController.promocodeValue = int.parse(walletPageController
              .walletModelPromoBanner.value.data[index_promo].fromValue);

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
              .walletModelPromoBanner
              .value
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .type;

          walletPageController.promo_minus_amt.value =
              cashFreeController.promocodeValue - int.parse(entered_amount);
          ;
          int max_per = int.parse(walletPageController.walletModelPromoBanner
              .value.data[index_promo].benefit[0].wallet[0].percentage);
          walletPageController.promo_amt.value =
              (enterAmtInt * (max_per / 100));

          walletPageController.typeTextCheck.value = 2; //eqauls
          /*   walletPageController.profitAmt.value =
                                              enteredValue +
                                                  walletPageController
                                                      .promo_amt.value;*/
          cashFreeController.promocodeHelper.value = walletPageController
              .walletModelPromoBanner.value.data[index_promo].code;

          walletPageController.promo_maximumAmt.value = int.parse(
              walletPageController.walletModelPromoBanner.value
                  .data[index_promo].benefit[0].wallet[0].maximumAmount);
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
              'CODE: ${walletPageController.walletModelPromoBanner.value.data[index_promo].code} |'
              'TYPE: ${walletPageController.walletModelPromoBanner.value.data[index_promo].benefit[0].wallet[0].type} |'
              '%: ${walletPageController.walletModelPromoBanner.value.data[index_promo].benefit[0].wallet[0].percentage}% |'
              ' calc%: ${walletPageController.promo_amt.value} |'
              'FROM: ${walletPageController.walletModelPromoBanner.value.data[index_promo].fromValue}|'
              'TO: ${walletPageController.walletModelPromoBanner.value.data[index_promo].toValue}|'
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
          '${entered_amount.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback';
    }
  }

  void updateAmountWidget(int vipLevel) {
    if (walletPageController.walletModelPromoBanner.value.data != null) {
      for (int i = 0;
          i < walletPageController.walletModelPromoBanner.value.data.length;
          i++) {
        if (walletPageController
                .walletModelPromoBanner.value.data[i].vipLevel ==
            vipLevel) {
          Utils().customPrint(
              'initStateinitState: Level ${walletPageController.walletModelPromoBanner.value.data[i].vipLevel}');
          Utils().customPrint(
              'initStateinitState: VALUE ${walletPageController.walletModelPromoBanner.value.data[i].fromValue}');
          Utils().customPrint(
              'initStateinitState: PROMOCODE ${walletPageController.walletModelPromoBanner.value.data[i].code}');

          //setting up values
          walletPageController.selectAmount.value = walletPageController
              .walletModelPromoBanner.value.data[i].fromValue;
          walletPageController.promocode.value =
              walletPageController.walletModelPromoBanner.value.data[i].code;
          vipBannerClickPromoCode();
          break;
        }
      }
    }
  }

  void vipBannerClickPromoCode() {
    //code checking for offline codes
    bool temp = false;
    for (int i = 0;
        i < walletPageController.walletModelPromoBanner.value.data.length;
        i++) {
      Utils().customPrint(
          "PROMOCODE Loop code ${walletPageController.walletModelPromoBanner.value.data[i].code}");
      if (walletPageController.promocode.value.toLowerCase() ==
          walletPageController.walletModelPromoBanner.value.data[i].code
              .toLowerCase()) {
        //validation
        double enterAmtInt =
            double.parse(walletPageController.selectAmount.value);
        double fromValue = double.parse(walletPageController
            .walletModelPromoBanner.value.data[i].fromValue);
        double toValue = double.parse(
            walletPageController.walletModelPromoBanner.value.data[i].toValue);
        Utils().customPrint('Offer Valid F ${fromValue}');
        Utils().customPrint('Offer Valid T ${toValue}');

        if (enterAmtInt < fromValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${walletPageController.walletModelPromoBanner.value.data[i].fromValue} - ${walletPageController.walletModelPromoBanner.value.data[i].toValue} Rs!');
          return;
        } else if (enterAmtInt > toValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${walletPageController.walletModelPromoBanner.value.data[i].fromValue} - ${walletPageController.walletModelPromoBanner.value.data[i].toValue} Rs!');
          return;
        }

        //promo code
        promo_code_not_visible1(walletPageController.selectAmount.value, i);
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

  //new but not used
  void updateAmountWidget1(var vipID) {
    Utils().customPrint('initStateinitState: Level ${vipID}');
    for (int i = 0;
        i < walletPageController.walletModelPromoBanner.value.data.length;
        i++) {
      if (walletPageController.walletModelPromoBanner.value.data[i].vipLevelIds
          .contains(vipID)) {
        Utils().customPrint(
            'initStateinitState: VALUE ${walletPageController.walletModelPromoBanner.value.data[i].fromValue}');
        Utils().customPrint(
            'initStateinitState: PROMOCODE ${walletPageController.walletModelPromoBanner.value.data[i].code}');

        //setting up values
        walletPageController.selectAmount.value =
            walletPageController.walletModelPromoBanner.value.data[i].fromValue;
        walletPageController.promocode.value =
            walletPageController.walletModelPromoBanner.value.data[i].code;
        vipBannerClickPromoCode();
        break;
      } else {
        Utils().customPrint('initStateinitState: Level Not matched ${vipID}');
      }
    }
  }
}
