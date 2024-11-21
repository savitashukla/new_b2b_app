import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';

import '../../../model/ESportsEventList.dart';
import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/AffiliatedController.dart';
import '../../controller/BaseController.dart';
import '../../controller/TeamManagementDetailsController.dart';
import '../../controller/user_controller.dart';

class Affiliated extends StatelessWidget with WidgetsBindingObserver {
  //const Affiliated({Key key}) : super(key: key);
  ContestModel contestModel;
  var isSolo;
  var is_joinedContext;
  var team_id;

  Affiliated(
      this.contestModel, this.isSolo, this.team_id, this.is_joinedContext);

  BaseController base_controller = Get.put(BaseController());

  TeamManagementDetailsController tDe =
      Get.put(TeamManagementDetailsController());
  AffiliatedController affiliatedController = Get.put(AffiliatedController());
  UserController userController = Get.put(UserController());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
  Utils().customPrint(
        "didChangeAppLifecycleState ===================================================");

    if (state == AppLifecycleState.resumed) {
    Utils().customPrint(
          "didChangeAppLifecycleState ===================================================");

      AffiliatedController affiliatedController =
          Get.put(AffiliatedController());
      UserController userController = Get.put(UserController());

      userController.callAllProfileData();
      if (is_joinedContext) {
        if (contestModel.isSoloContest()) {
          affiliatedController.getRegistrationMemberList(contestModel.id);
        } else {
          affiliatedController
              .getRegistrationMemberListTeamType(contestModel.id);
        }
      } else {}
    }
  }

  Future<bool> _onWillPop() async {
    Get.offAll(() => DashBord(2, ""));

    /*   AffiliatedController affiliatedController =
    Get.put(AffiliatedController());
    UserController userController = Get.put(UserController());

    userController.callAllProfileData();
    if (is_joinedContext) {
      if (contestModel.isSoloContest()) {
        affiliatedController.getRegistrationMemberList(contestModel.id);
      } else {
        affiliatedController
            .getRegistrationMemberListTeamType(contestModel.id);
      }
    } else {

    }
  Utils().customPrint(
        "_onWillPop ===================================================");*/

    return true;
  }

  @override
  Widget build(BuildContext context) {
    userController.callAllProfileData();
    if (is_joinedContext) {
      if (contestModel.isSoloContest()) {
        affiliatedController.getRegistrationMemberList(contestModel.id);
      } else {
        affiliatedController.getRegistrationMemberListTeamType(contestModel.id);
      }
    } else {}

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/images/store_top.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: AppColor().reward_card_bg,
          title: Text("GMNG Special Tournament"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/store_back.png"))),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Download Sponsor App to join the tournament",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200,
                    child: contestModel.affiliate != null
                        ? Image(
                            fit: BoxFit.fill,
                            image:
                                NetworkImage(contestModel.affiliate.banner.url))
                        : Image.asset("assets/images/gmngcoin.webp"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (is_joinedContext) {
                        Utils().customPrint('url==> ${contestModel.affiliate.url}');
                        String url = contestModel.affiliate.url;
                        if (url.contains("{clickid}")) {
                          url = url.replaceAll(
                              "{clickid}", Utils().genrateRendomNumber());
                        }
                        if (url.contains("{userid}")) {
                          url = url.replaceAll("{userid}",
                              userController.profileDataRes.value.id);
                        }
                        if (url.contains("{username}")) {
                          url = url.replaceAll("{username}",
                              userController.profileDataRes.value.username);
                        }
                        Utils().customPrint('url==> ${url}');

                        base_controller.launchURLApp(url);
                      } else {
                        getJoinEvent(contestModel);
                      }
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor().GreenColor),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("DOWNLOAD  TO JOIN ",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 18,
                              child: Image.asset(
                                ImageRes().iv_download_new,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("STEPS TO REGISTER  FOR THR TOURNAMENT".toUpperCase(),
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: FontSizeC().front_regularX,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: 5,
                  ),
                  Html(
                    data: contestModel.affiliate.rules.capitalize ??
                        "Click on Download to start the registration"
                            .capitalize,
                    style: {
                      "body": Style(
                          fontSize: FontSize(14.0),
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    },
                  ),
                  /*  Text(
                      contestModel.affiliate.rules ??
                          "Click on Download to start the registration",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: AppDimens().front_small,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),*/
                  SizedBox(
                    height: 30,
                  ),
                  Visibility(
                      visible: is_joinedContext,
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor().dark_blue),
                            child: Center(
                              child: Text("Team",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Container(
                            height: 20,
                          ),
                          Obx(
                            () => affiliatedController
                                        .registrationMemberListModel.value !=
                                    null
                                ? Obx(
                                    () => affiliatedController
                                                .registrationMemberListModel
                                                .value !=
                                            null
                                        ? Container(
                                            child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(bottom: 10),
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 10,
                                                top: 5),
                                            decoration: BoxDecoration(
                                                color: AppColor().dark_blue,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text("1",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            fontSize: 12,
                                                            color: AppColor()
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                        height: 30,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Image.asset(
                                                          ImageRes()
                                                              .userProfileImage,
                                                          color: Colors.white,
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            affiliatedController
                                                                        .registrationMemberListModel
                                                                        .value !=
                                                                    null
                                                                ? affiliatedController
                                                                        .registrationMemberListModel
                                                                        .value
                                                                        .userId
                                                                        .username ??
                                                                    "Name"
                                                                : "Name",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontSize: 12,
                                                                color: AppColor()
                                                                    .colorPrimary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        Text(
                                                            affiliatedController
                                                                        .registrationMemberListModel
                                                                        .value
                                                                        .teamId !=
                                                                    null
                                                                ? affiliatedController
                                                                        .registrationMemberListModel
                                                                        .value
                                                                        .teamId ??
                                                                    "Team"
                                                                : "Team",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                  alignment: Alignment.center,
                                                  child: affiliatedController
                                                              .registrationMemberListModel
                                                              .value
                                                              .status
                                                              .compareTo(
                                                                  "initial") ==
                                                          0
                                                      ? Text("Pending",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))
                                                      : Text(
                                                          affiliatedController
                                                                      .registrationMemberListModel
                                                                      .value
                                                                      .status !=
                                                                  null
                                                              ? "Completed"
                                                              : "",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontSize: 12,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w400)),
                                                  /* child: affiliatedController
                                                                .registrationMemberListModel
                                                                .value
                                                                .users[0]
                                                                .status
                                                                .compareTo(
                                                                    "initial") ==
                                                            0
                                                        ? Text(
                                                            affiliatedController
                                                                .registrationMemberListModel
                                                                .value
                                                                .users[0]
                                                                .status,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontSize: 12,
                                                                color:
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400))
                                                        : Container(
                                                            height: 20,
                                                            width: 20,
                                                            child: Image.asset(
                                                                ImageRes()
                                                                    .isCapitan))*/
                                                )
                                              ],
                                            ),
                                          ))
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
                                          ),
                                  )
                                : affiliatedController
                                                .registrationMemberListTeamType
                                                .value !=
                                            null &&
                                        affiliatedController
                                                .registrationMemberListTeamType
                                                .value
                                                .teams !=
                                            null
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: affiliatedController
                                            .registrationMemberListTeamType
                                            .value
                                            .teams[0]
                                            .members
                                            .length,
                                        itemBuilder: (context, index) {
                                          return listShowTeam(context, index);
                                        })
                                    : Text(
                                        "No Member are available Please Come back later"),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (is_joinedContext) {
                        showCustomDialogHowToPlay(context);
                      } else {
                        getJoinEvent(contestModel);
                      }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor().colorPrimary, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor().whiteColor),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Join",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 15,
                                    color: AppColor().colorPrimary,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 15,
                              width: 15,
                              child: Image.asset(
                                "assets/images/password_2.png",
                                color: AppColor().whiteColor,
                              ),
                            )
                          ],
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
    );
  }

  Widget listShowTeam(BuildContext context, int index) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
      decoration: BoxDecoration(
          color: AppColor().dark_blue, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 4,
              ),
              Text("${index + 1}",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 12,
                      color: AppColor().whiteColor,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                width: 10,
              ),
              Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Image.asset(
                    ImageRes().userProfileImage,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      affiliatedController.registrationMemberListTeamType.value
                          .teams[0].teamId.name,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: AppColor().colorPrimary,
                          fontWeight: FontWeight.w400)),
                  Text("Team",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w400))
                ],
              ),
            ],
          ),
          Container(
              height: 20,
              alignment: Alignment.center,
              child: affiliatedController.registrationMemberListTeamType.value
                          .teams[0].members[index].eventRegistration.status
                          .compareTo("initial") ==
                      0
                  ? Text("Pending",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w400))
                  : Text(
                      affiliatedController
                                  .registrationMemberListTeamType
                                  .value
                                  .teams[0]
                                  .members[index]
                                  .eventRegistration
                                  .status !=
                              null
                          ? "Completed"
                          : "",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w400))
              /*: Container(
                      height: 20,
                      width: 20,
                      child: Image.asset(ImageRes().isCapitan))*/
              )
        ],
      ),
    );
  }

  Future<Map> getJoinEvent(ContestModel contestModel) async {
    if (contestModel != null) {
      var param = {};
      if (contestModel.isSoloContest()) {
        param = {
          "userId": affiliatedController.user_id,
          "teamId": "",
          "memberIds": []
        };

        try {
          final response_final = await WebServicesHelper()
              .getEventJoin(param, affiliatedController.token, contestModel.id);

          if (response_final != null && response_final.statusCode == 200) {
            Utils().customPrint('url==> ${contestModel.affiliate.url}');
            String url = contestModel.affiliate.url;
            if (url.contains("{clickid}")) {
              url = url.replaceAll("{clickid}", Utils().genrateRendomNumber());
            }
            if (url.contains("{userid}")) {
              url = url.replaceAll(
                  "{userid}", userController.profileDataRes.value.id);
            }
            if (url.contains("{username}")) {
              url = url.replaceAll(
                  "{username}", userController.profileDataRes.value.username);
            }
            Utils().customPrint('url==> ${url}');
            is_joinedContext = true;
            base_controller.launchURLApp(url);
            // Fluttertoast.showToast(msg: "Event joined Succesfully");
          } else {
            Map<String, dynamic> response =
                json.decode(response_final.body.toString());
            AppBaseResponseModel appBaseErrorModel =
                AppBaseResponseModel.fromMap(response);
            Utils().showErrorMessage("", appBaseErrorModel.error);
          }
        } catch (e) {
          var response = await WebServicesHelper()
              .getEventJoin(param, affiliatedController.token, contestModel.id);
          Utils().customPrint('url==> ${contestModel.affiliate.url}');
          String url = contestModel.affiliate.url;
          if (url.contains("{clickid}")) {
            url = url.replaceAll("{clickid}", Utils().genrateRendomNumber());
          }
          if (url.contains("{userid}")) {
            url = url.replaceAll(
                "{userid}", userController.profileDataRes.value.id);
          }
          if (url.contains("{username}")) {
            url = url.replaceAll(
                "{username}", userController.profileDataRes.value.username);
          }
          Utils().customPrint('url==> ${url}');

          base_controller.launchURLApp(url);
          // Fluttertoast.showToast(msg: "Event joined Succesfully");
        }
      } else {
        param = {"userId": "", "teamId": team_id, "memberIds": []};

        try {
          final response_final = await WebServicesHelper()
              .getEventJoin(param, affiliatedController.token, contestModel.id);

          if (response_final != null && response_final.statusCode == 200) {
            // Fluttertoast.showToast(msg: "Event joined Succesfully");
          } else {
            Map<String, dynamic> response =
                json.decode(response_final.body.toString());
            AppBaseResponseModel appBaseErrorModel =
                AppBaseResponseModel.fromMap(response);
            Utils().showErrorMessage("", appBaseErrorModel.error);
          }
        } catch (e) {
          var response = await WebServicesHelper()
              .getEventJoin(param, affiliatedController.token, contestModel.id);
          String url = contestModel.affiliate.url;
          if (url.contains("{clickid}")) {
            url = url.replaceAll("{clickid}", Utils().genrateRendomNumber());
          }
          if (url.contains("{userid}")) {
            url = url.replaceAll(
                "{userid}", userController.profileDataRes.value.id);
          }
          if (url.contains("{username}")) {
            url = url.replaceAll(
                "{username}", userController.profileDataRes.value.username);
          }
          Utils().customPrint('url==> ${url}');

          base_controller.launchURLApp(url);
          // Fluttertoast.showToast(msg: "Event joined Succesfully");
        }
      }
    }
  }

  void showCustomDialogHowToPlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 200,
            child: Card(
              color: AppColor().wallet_dark_grey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "If You Have Downloaded the App, Your status will be updated in 24 hours ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizeC().front_regular,
                        fontFamily: "Roboto",
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Container(
                      height: 35,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor().colorPrimary),
                        child: Center(
                          child: Text(
                            "OKAY",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: FontSizeC().front_medium,
                              fontFamily: "Roboto",
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
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
}
