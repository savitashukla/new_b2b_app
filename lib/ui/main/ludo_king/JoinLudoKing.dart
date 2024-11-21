import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/ESportsEventList.dart';
import 'package:gmng/model/UserLobboyModel.dart';
import 'package:gmng/model/responsemodel/PreJoinResponseModel.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/ESportsController.dart';
import 'package:gmng/ui/dialog/helperProgressBar.dart';
import 'package:gmng/ui/main/ludo_king/Ludo_King_Screen.dart';
import 'package:gmng/ui/main/ludo_king/how_to_play_esport.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../res/AppColor.dart';
import '../../../res/FontSizeC.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/user_controller.dart';
import '../dashbord/DashBord.dart';
import 'LudoKingController.dart';

class JoinLudoKingScreen extends StatelessWidget {
  ContestModel data;
  String gameid;
  String howtoPlay;
  PreJoinResponseModel preJoinResponseModel;
  List<UserRegistrations> userRegistrations;
  LudoKingController ludo_king_controller = Get.find();

  bool click_pay = true;

  JoinLudoKingScreen(this.gameid, this.data, this.preJoinResponseModel,
      this.userRegistrations, this.howtoPlay,
      {Key key})
      : super(key: key);

  UserController _userController = Get.find();
  ESportsController esports = Get.find();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    esports.getESportsEventList("");
    esports.getJoinedContestList("");
    if (esports.selected_contest.value.rounds != null &&
            esports.selected_contest.value.rounds.length > 0 &&
            esports.selected_userRegistrations.value != null &&
            esports.selected_userRegistrations.value.length <= 0 ||
        !esports.selected_contest.value.isCompletedJoined(
            esports.selected_contest.value.id,
            esports.selected_userRegistrations.value) ||
        esports.selected_contest.value
            .getUserRoundRoomId(esports.selected_userRegistrations.value)
            .isEmpty) {
      // ludo_king_controller.Confirm_test.value = "REGISTERED";
    } else {
      ludo_king_controller.Confirm_test.value = "GO TO GAME";
    }

    print(data);
    return Container(
      color: AppColor().blackColor_DARK,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () async {
            esports.getESportsEventList("");
            esports.getJoinedContestList("");
          });
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Image(
              image: AssetImage('assets/images/offerwall_header.png'),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            title: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: GestureDetector(
                      onTap: () {
                        esports.getESportsEventList("");
                        esports.getJoinedContestList("");

                        ludo_king_controller.checkEventHis.value = false;
                        ludo_king_controller.colorPrimary.value =
                            Color(0xFFffffff);
                        ludo_king_controller.colorwhite.value =
                            Color(0xFFe55f19);

                        Get.to(() => LudoKingScreen(gameid, "", ""));
                      },
                      child: Container(
                          //    margin: EdgeInsets.only(top: 40, left: 10),
                          // alignment: Alignment.topLeft,
                          child: Image.asset("assets/images/right_arrow.png")),
                    ),
                  ),
                  Text(
                    data.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: FontSizeC().front_larger18,
                        color: AppColor().colorPrimary_dark,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),
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
                        Get.offAll(() => DashBord(4, ""));
                        //  Wallet().showBottomSheetAddAmount(context);
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
                                          fontFamily: "Inter",
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
                                          fontFamily: "Inter",
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
          body: WillPopScope(
            onWillPop: onWillPop,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => how_to_play_esport(howtoPlay));
                      //Get.to(()=>PokerHowToPlayWebviewState(howtoPlay));
                      /*   if (click_pay) {
                        click_pay = false;
                        showCustomDialogHowToPlay(context);
                      }
*/
                    },
                    child: Container(
                      height: 180,
                      child: Image.asset(ImageRes().wallet_banner),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image(
                            height: 38,
                            width: 38,
                            image: AssetImage(ImageRes().lens)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Room Details",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: FontSizeC().front_larger18,
                              color: AppColor().colorPrimary_dark,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColor().scratch_card,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => esports.selected_contest.value != null &&
                                        esports.selected_contest.value.rounds !=
                                            null &&
                                        esports.selected_contest.value.rounds
                                                .length >
                                            0 &&
                                        esports.selected_userRegistrations
                                                .value !=
                                            null &&
                                        esports.selected_userRegistrations.value
                                                .length <=
                                            0 ||
                                    !esports.selected_contest.value
                                        .isCompletedJoined(
                                            esports.selected_contest.value.id,
                                            esports.selected_userRegistrations
                                                .value) ||
                                    esports.selected_contest.value
                                        .getUserRoundRoomId(esports
                                            .selected_userRegistrations.value)
                                        .isEmpty
                                ? Text(
                                    "Creating Room",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: FontSizeC().front_larger18,
                                        color: AppColor().optional_payment,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600),
                                  )
                                : Text(
                                    "Room has been created",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: FontSizeC().front_larger18,
                                        color: AppColor().optional_payment,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600),
                                  ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => esports.selected_contest.value != null &&
                                        esports.selected_contest.value.rounds !=
                                            null &&
                                        esports.selected_contest.value.rounds
                                                .length >
                                            0 &&
                                        esports.selected_userRegistrations
                                                .value !=
                                            null &&
                                        esports.selected_userRegistrations.value
                                                .length <=
                                            0 ||
                                    !esports.selected_contest.value
                                        .isCompletedJoined(
                                            esports.selected_contest.value.id,
                                            esports.selected_userRegistrations
                                                .value) ||
                                    esports.selected_contest.value
                                        .getUserRoundRoomId(esports
                                            .selected_userRegistrations.value)
                                        .isEmpty
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor().scratch_card,
                                    ),
                                    child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                          ImageRes().scratch_card,
                                        )),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor().scratch_card,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${esports.selected_contest.value.rounds != null && esports.selected_contest.value.rounds.length > 0 && esports.selected_userRegistrations.value != null && esports.selected_userRegistrations.value.length > 0 ? !esports.selected_contest.value.isCompletedJoined(esports.selected_contest.value.id, esports.selected_userRegistrations.value) ? "--" : esports.selected_contest.value.getUserRoundRoomId(esports.selected_userRegistrations.value) : "--"}"
                                                  .toUpperCase(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_largest24,
                                                  color: AppColor().whiteColor,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                    text:
                                                        "${esports.selected_contest.value.rounds != null && esports.selected_contest.value.rounds.length > 0 && esports.selected_userRegistrations.value != null && esports.selected_userRegistrations.value.length > 0 ? esports.selected_contest.value.getUserRoundRoomId(esports.selected_userRegistrations.value) : "--"}"));

                                                Fluttertoast.showToast(
                                                    msg: "Copied Succesfully");
                                              },
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  "assets/images/ic_copy.webp",
                                                  color: AppColor()
                                                      .colorPrimary_dark,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        /*  Text(
                                          "${data.rounds != null && data.rounds.length > 0 && userRegistrations != null && userRegistrations.length > 0 ? !data.isCompletedJoined(data.id, userRegistrations) ? "" : data.getUserRoundRoomId(userRegistrations) : "--"}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: FontSizeC().front_larger18,
                                              color: AppColor().colorPrimary_dark,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600),
                                        )*/
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 8),
                            child: Lottie.asset(
                              'assets/lottie_files/truphy.json',
                              repeat: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              "Prizepool",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: FontSizeC().front_larger18,
                                  color: AppColor().colorPrimary,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      )),
                      /* preJoinResponseModel != null
                          ?*/
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 13, bottom: 0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              height: 33,
                              width: 33,
                              child: Image.asset(ImageRes().rupee_gmng),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Charges",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: FontSizeC().front_larger18,
                                  color: AppColor().colorPrimary,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ))
                      /* : Container(
                              width: 0,
                            )*/
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: AppColor().scratch_card,
                            /* image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  ImageRes().scratch_card,
                                )),*/

                            borderRadius: BorderRadius.circular(5)),
                        height: 150,
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        margin: EdgeInsets.only(left: 5, right: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            data.winner.customPrize != null &&
                                    data.winner.customPrize.isNotEmpty
                                ? Text(
                                    "${data.winner.customPrize}",
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: FontSizeC().front_largest50,
                                        color: AppColor().yellow_color,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600),
                                  )
                                : data.winner.prizeAmount != null &&
                                        data.winner.prizeAmount.type
                                                .compareTo("bonus") ==
                                            0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            Container(
                                              height: 20,
                                              child: Image.asset(
                                                  ImageRes().ic_coin),
                                            ),
                                            Text(
                                              "${data.winner.prizeAmount != null ? data.winner.prizeAmount.value : "-"}",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_largest50,
                                                  color:
                                                      AppColor().yellow_color,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ])
                                    : Text(
                                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${data.winner.prizeAmount != null ? data.winner.prizeAmount.value ~/ 100 : "-"}",
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                FontSizeC().front_largest50,
                                            color: AppColor().yellow_color,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600),
                                      ),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: Image(
                                    height: 77,
                                    width: 77,
                                    image: AssetImage(
                                        "assets/images/rupees_coin.gif"))
                                /* Lottie.asset(
                                'assets/lottie_files/rupees_coin.json',
                                repeat: true,
                                height: 77,
                                width: 77,
                              ),*/

                                /*Lottie.asset(
                                'assets/lottie_files/rupee_coin.json',
                                repeat: true,
                                height:50,
                               // width: 50,
                                //fit: BoxFit.fill,
                              ),*/
                                ),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(left: 0, right: 5),
                        padding: EdgeInsets.only(top: 10, left: 7, right: 7),
                        decoration: BoxDecoration(
                            color: AppColor().scratch_card,
                            borderRadius: BorderRadius.circular(5)),
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            preJoinResponseModel != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 135,
                                        child: Text(
                                          "Entry Fee",
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: FontSizeC()
                                                  .front_very_small14,
                                              color: AppColor().reward_grey_bg,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Image(
                                              height: 15,
                                              width: 15,
                                              image: AssetImage(
                                                  ImageRes().rupee_gmng)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              //"${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${'0'}",
                                              data.entry.fee.type == "bonus"
                                                  ? data.entry.fee.value
                                                      .toString()
                                                  : "${data.entry.fee.value > 0 ? data.entry.fee.value ~/ 100 : "Free"}",
                                              style: TextStyle(
                                                  color: AppColor().whiteColor))
                                          /*   Text(
                                      "${AppString().txt_currency_symbole} 75",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: FontSizeC().front_very_small14,
                                          color: AppColor().version_bg,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600),
                                    ),*/
                                        ],
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 135,
                                        child: Text(
                                          "Entry Fee",
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize:
                                                  FontSizeC().front_larger20,
                                              color: AppColor().reward_grey_bg,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image(
                                              height: 15,
                                              width: 15,
                                              image: AssetImage(
                                                  ImageRes().rupee_gmng)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              //"${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${'0'}",
                                              data.entry.fee.type == "bonus"
                                                  ? data.entry.fee.value
                                                      .toString()
                                                  : "${data.entry.fee.value > 0 ? (data.entry.fee.value / 100).toString().replaceAll(ludo_king_controller.regex, '') : "Free"}",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: FontSizeC()
                                                      .front_very_small14,
                                                  color: AppColor().whiteColor))
                                          /*   Text(
                                      "${AppString().txt_currency_symbole} 75",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: FontSizeC().front_very_small14,
                                          color: AppColor().version_bg,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600),
                                    ),*/
                                        ],
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            preJoinResponseModel != null
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 135,
                                            child: Text(
                                              "You are paying",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_very_small10,
                                                  color: AppColor()
                                                      .colorPrimary_dark,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                  height: 15,
                                                  width: 15,
                                                  image: AssetImage(
                                                      ImageRes().rupee_gmng)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${(((preJoinResponseModel.deposit.value + preJoinResponseModel.winning.value) / 100) + preJoinResponseModel.bonus.value).toString().replaceAll(ludo_king_controller.regex, '')}",
                                                textScaleFactor: 1.0,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: FontSizeC()
                                                        .front_very_small12,
                                                    color:
                                                        AppColor().version_bg,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 2,
                                        color: AppColor().reward_grey_bg,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 135,
                                            child: Text(
                                              "From Bonus Cash",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_very_small10,
                                                  color:
                                                      AppColor().reward_grey_bg,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                  height: 15,
                                                  width: 15,
                                                  image: AssetImage(
                                                      ImageRes().rupee_gmng)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${preJoinResponseModel.bonus.value.toString().replaceAll(ludo_king_controller.regex, '')}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: FontSizeC()
                                                        .front_very_small12,
                                                    color:
                                                        AppColor().version_bg,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 135,
                                            child: Text(
                                              "From Deposited Cash",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_very_small10,
                                                  color:
                                                      AppColor().reward_grey_bg,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                  height: 15,
                                                  width: 15,
                                                  image: AssetImage(
                                                      ImageRes().rupee_gmng)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${(preJoinResponseModel.deposit.value / 100).toString().replaceAll(ludo_king_controller.regex, '')}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: FontSizeC()
                                                        .front_very_small12,
                                                    color:
                                                        AppColor().version_bg,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 135,
                                            child: Text(
                                              "From Winning Cash",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: FontSizeC()
                                                      .front_very_small10,
                                                  color:
                                                      AppColor().reward_grey_bg,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Image(
                                                  height: 15,
                                                  width: 15,
                                                  image: AssetImage(
                                                      ImageRes().rupee_gmng)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${(preJoinResponseModel.winning.value / 100).toString().replaceAll(ludo_king_controller.regex, '')}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: FontSizeC()
                                                        .front_very_small12,
                                                    color:
                                                        AppColor().version_bg,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: 0,
                                  )
                          ],
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  data.joinSummary.users != null && data.joinSummary.users > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 190,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        AppColor().colorPrimary),
                                    backgroundColor: AppColor().colorGray,
                                    value: data.getProgresBar(),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 0),
                                  child: data.joinSummary.users ==
                                              data.maxPlayers ||
                                          (data.maxPlayers -
                                                      data.joinSummary.users) -
                                                  1 <=
                                              0
                                      ? Text(
                                          "SLOTS ${data.maxPlayers - 1}/${data.maxPlayers - 1}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: FontSizeC()
                                                  .front_very_small14,
                                              color: AppColor().whiteColor,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600))
                                      : Text(
                                          "SLOTS ${data.joinSummary.users}/${data.maxPlayers - 1}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: FontSizeC()
                                                  .front_very_small14,
                                              color: AppColor().whiteColor,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (ludo_king_controller.Confirm_test.value
                              .compareTo("GO TO GAME") ==
                          0) {
                        Utils().customPrint('open ludo...');
                        //NativeBridge().OpenLudoKing();
                        try {
                          ///checks if the app is installed on your mobile device
                          bool isInstalled =
                              await DeviceApps.isAppInstalled('com.ludo.king');
                          if (isInstalled) {
                            Utils().customPrint('open ludo...IF');
                            DeviceApps.openApp("com.ludo.king");
                          } else {
                            Utils().customPrint('open ludo...ELSE');

                            ///if the app is not installed it lunches google play store so you can install it from there
                            Utils.launchURLApp(
                                "market://details?id=" + "com.ludo.king");
                          }
                        } catch (e) {
                          Utils().customPrint(e);
                          Utils().customPrint('open ludo...E');
                        }
                      } else if (ludo_king_controller.Confirm_test.value
                              .compareTo("REGISTERED") ==
                          0) {
                        ludo_king_controller.Confirm_test.value = "REGISTERED";
                        ESportsController esports = Get.find();
                        esports.getESportsEventList("");
                        esports.getJoinedContestList("");
                        Fluttertoast.showToast(
                            msg: "Event REGISTERED Succesfully");

                        //Get.to(() => LudoKingScreen(gameid, "", ""));
                      } else {
                        getJoinEvent(data.id, context);
                      }

                      /*    Utils().customPrint('open ludo...');
                      //NativeBridge().OpenLudoKing();
                      try {
                        ///checks if the app is installed on your mobile device
                        bool isInstalled =
                            await DeviceApps.isAppInstalled(
                            'com.ludo.king');
                        if (isInstalled) {
                          Utils().customPrint('open ludo...IF');
                          DeviceApps.openApp("com.ludo.king");
                        } else {
                          Utils().customPrint('open ludo...ELSE');

                          ///if the app is not installed it lunches google play store so you can install it from there
                          Utils.launchURLApp(
                              "market://details?id=" +
                                  "com.ludo.king");
                        }
                      } catch (e) {
                        Utils().customPrint(e);
                        Utils().customPrint('open ludo...E');
                      }*/
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Container(
                            width: 200,
                            height: 45,
                            decoration: ludo_king_controller.Confirm_test.value
                                        .compareTo("REGISTERED") ==
                                    0
                                ? BoxDecoration(
                                    border: Border.all(
                                        color: AppColor().whiteColor, width: 2),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(
                                          0.0,
                                          5.0,
                                        ),
                                        blurRadius: 3.2,
                                        spreadRadius: 0.3,
                                        color: Color(0xFF573838),
                                        inset: true,
                                      ),
                                    ],

                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        AppColor().special_bg_c,
                                        AppColor().special_bg_c2,
                                      ],
                                    ),

                                    // color: AppColor().whiteColor
                                  )
                                : ludo_king_controller.Confirm_test.value
                                            .compareTo("GO TO GAME") ==
                                        0
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
                                            color: AppColor().whiteColor,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                        // color: AppColor().whiteColor
                                      )
                                    : BoxDecoration(
                                        border: Border.all(
                                            color: AppColor().whiteColor,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 3.2,
                                            spreadRadius: 0.3,
                                            color: Color(0xFFA73804),
                                            inset: true,
                                          ),
                                        ],

                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            AppColor().button_bg_light,
                                            AppColor().button_bg_dark,
                                          ],
                                        ),

                                        // color: AppColor().whiteColor
                                      ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 10, bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Text(
                                        ludo_king_controller.Confirm_test.value,
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                FontSizeC().front_very_small14,
                                            color: AppColor().whiteColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Container(
                                    width: 5,
                                  ),
                                  Obx(
                                    () => ludo_king_controller
                                                .Confirm_test.value
                                                .compareTo("CONFIRM") ==
                                            0
                                        ? data.entry.fee.value > 0
                                            ? Text(
                                                "${AppString().txt_currency_symbole}${data.entry.fee.type == "bonus" ? "${data.entry.fee.value}" : "${data.entry.fee.value ~/ 100}"}",
                                                textAlign: TextAlign.center,
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontSize: FontSizeC()
                                                        .front_very_small14,
                                                    color:
                                                        AppColor().whiteColor,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            : Text(
                                                "Free",
                                                textScaleFactor: 1.0,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: FontSizeC()
                                                        .front_very_small14,
                                                    color:
                                                        AppColor().whiteColor,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                        : Text(""),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => ((DateTime.parse("${data.eventDate.start}").toUtc())
                              .difference(esports.getCurrentdate())
                              .inSeconds) >
                          0
                      ? TweenAnimationBuilder<Duration>(
                          duration: Duration(
                              seconds: esports.subtractDate(
                                  DateTime.parse("${data.eventDate.start}"))),
                          tween: Tween(
                              begin: Duration(
                                  seconds: esports.subtractDate(DateTime.parse(
                                      "${data.eventDate.start}"))),
                              end: Duration.zero),
                          onEnd: () {
                            Utils().customPrint('Timer ended');
                          },
                          builder: (BuildContext context, Duration value,
                              Widget child) {
                            String seconds = (value.inSeconds % 60)
                                .toInt()
                                .toString()
                                .padLeft(2, '0');
                            String minutes = ((value.inSeconds / 60) % 60)
                                .toInt()
                                .toString()
                                .padLeft(2, '0');
                            String hours = (value.inSeconds ~/ 3600)
                                .toString()
                                .padLeft(2, '0');

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                    height: 25,
                                    width: 25,
                                    image: AssetImage(ImageRes().timer)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    "Starts in  ${"$hours\:$minutes\:$seconds"}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            FontSizeC().front_very_small15,
                                        color: AppColor().whiteColor,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600))
                              ],
                            );
                            /* Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 5),
                                child: Text("$hours\:$minutes\:$seconds",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                        FontSizeC().front_very_small15,
                                        color: AppColor().colorAccent,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500)))*/
                            ;
                          })
                      : Text(
                          '',
                          style: TextStyle(
                              fontSize: FontSizeC().front_very_small15,
                              color: AppColor().colorAccent,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500),
                        )),

/*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          height: 25,
                          width: 25,
                          image: AssetImage(ImageRes().timer)),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Start in ${data.eventDate.getStartTimeHHMMSS()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: FontSizeC().front_very_small15,
                              color: AppColor().whiteColor,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600))

                    ],
                  ),*/
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Map> getJoinEvent(String event_id, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String user_id = prefs.getString("user_id");
    // Map<String, dynamic> response;
    if (data != null) {
      showProgress(context, "", false);
      var param = {};

      if (data.isSoloContest()) {
        param = {"userId": user_id, "teamId": "", "memberIds": []};

        final response_final =
            await WebServicesHelper().getEventJoin(param, token, event_id);

        if (response_final != null && response_final.statusCode == 200) {
          /*  ESportsController     controller = Get.put(ESportsController(gameid, event_id));
          controller.getJoinedContestList(gameid);
          controller.getESportsEventList(gameid);*/

          Fluttertoast.showToast(msg: "Event joined Succesfully");
          Navigator.pop(context);
          ludo_king_controller.Confirm_test.value = "REGISTERED";

          esports.getJoinedContestList("");
          // esports.getESportsEventList("");

          /* if (ludo_king_controller.Confirm_test.value.compareTo("REGISTERED") ==
              0) {
            ludo_king_controller.Confirm_test.value = "GO TO GAME";
            ludo_king_controller.checkEventHis.value = false;

            Get.to(LudoKingScreen(gameid, ""));
          } else {
            ludo_king_controller.Confirm_test.value = "REGISTERED";
           // Navigator.pop(context);
          }*/

          /*controller.getJoinedContestList(gameid);
          .getESportsEventList(gameid);*/
        } else {
          Map<String, dynamic> response =
              json.decode(response_final.body.toString());
          AppBaseResponseModel appBaseErrorModel =
              AppBaseResponseModel.fromMap(response);
          Utils().showErrorMessage("", appBaseErrorModel.error);
        }
      }
    }
  }

  Future<bool> onWillPop() async {
    esports.getESportsEventList("");
    esports.getJoinedContestList("");
    ludo_king_controller.checkEventHis.value = false;
    ludo_king_controller.colorPrimary.value = Color(0xFFffffff);
    ludo_king_controller.colorwhite.value = Color(0xFFe55f19);
    return true;
  }

  void showCustomDialogHowToPlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile_bg.webp"),
                fit: BoxFit.cover,
              ),
            ),
            child: Card(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: _onWillPop,
                child: Wrap(
                  children: [
                    Container(
                      color: AppColor().reward_card_bg,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "How to Play".tr,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Inter",
                                  color: Colors.white),
                            ),
                          ),
                          new IconButton(
                              icon: new Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                click_pay = true;
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .89,
                      child: WebView(
                          initialUrl: howtoPlay ?? "",
                          javascriptMode: JavascriptMode.unrestricted),
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    click_pay = true;
    //SystemNavigator.pop();
    return true;
  }
}
