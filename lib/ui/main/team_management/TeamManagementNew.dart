import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/*
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
*/
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/ProfileModel/TeamGetModelR.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/ProfileController.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/ui/main/team_management/TeamManagementDetails.dart';
import 'package:gmng/utills/Utils.dart';

import '../../../utills/Platfrom.dart';
import '../../controller/HomePageController.dart';
import '../../controller/TeamManagementController.dart';
import '../../controller/TeamManagementDetailsController.dart';
import '../../dialog/helperProgressBar.dart';

class TeamManagementNew extends StatelessWidget {
  double width;

  var captain_name_invite;
  String mobile = "";

 // PhoneContact _contact;
  String captain_photo_invite;

  TeamManagementNew({Key key}) : super(key: key);
  ProfileController controller = Get.put(ProfileController());
  HomePageController home_Controller = Get.put(HomePageController());
  TeamManagementController teamManagementController =
      Get.put(TeamManagementController());

  Future<bool> _onWillPop() async {
    Get.offAll(() => DashBord(2, ""));
    //SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    width = Platfrom().isWeb()
        ? MediaQuery.of(context).size.width * FontSizeC().screen_percentage_web
        : MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
       //   padding: EdgeInsets.only(top: AppString.appBarHeight.value-5),
          width: width,
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/store_back.png")))),
              Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(80.0),
                  child: AppBar(
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: true,
                      flexibleSpace: Image(
                        image: AssetImage('assets/images/store_top.png'),
                        fit: BoxFit.cover,
                      ),
                      title: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          "Team Management".tr,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      centerTitle: true,
                      bottom: TabBar(
                        labelColor: AppColor().reward_card_bg,
                        unselectedLabelColor: Colors.white,
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                width: 2.0, color: AppColor().colorPrimary),
                            insets: EdgeInsets.symmetric(horizontal: 16.0)),
                        tabs: [
                          Tab(
                            child: Text(
                              "My Team".tr,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Tab(
                              child: Text(
                            "Invites".tr,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400),
                          )),
                          Tab(
                              child: Text(
                            "Pending".tr,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400),
                          )),
                        ],
                      )),
                ),
                body: TabBarView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage("assets/images/store_back.png"))),
                      child: firstTabCall(context),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage("assets/images/store_back.png"))),
                      child: secondTabCall(context),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage("assets/images/store_back.png"))),
                      child: thirdTabCall(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listGameName(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: GestureDetector(
        onTap: () {
          TeamManagementDetailsController tDe =
              Get.put(TeamManagementDetailsController());
          tDe.getTeamDetails(controller.teamGetModel.value.data[index].id);
          tDe.teamMemberListId.value =
              controller.teamGetModel.value.data[index].id;
          Get.to(() => TeamManagementDetails());
        },
        child: Wrap(
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: AppColor().colorPrimary,
                radius: 40,
                child: CircleAvatar(
                  backgroundColor: AppColor().whiteColor,
                  radius: 39,
                  child: controller.teamGetModel.value != null &&
                          controller.teamGetModel.value.data[index].banner !=
                              null &&
                          controller.teamGetModel.value.data[index].banner.url
                              .isNotEmpty
                      ? CircleAvatar(
                          radius: 39,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            controller
                                .teamGetModel.value.data[index].banner.url,
                          ),
                        )
                      : Image(
                          image: AssetImage('assets/images/circle_game.png'),
                          height: 40,
                          width: 40),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                controller.teamGetModel.value.data[index].name ?? "-",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    color: AppColor().whiteColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                controller.teamGetModel.value.data[index].gameId != null
                    ? controller.teamGetModel.value.data[index].gameId.name
                    : "-",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontFamily: "Inter",
                    color: AppColor().whiteColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                controller.teamGetModel.value.data[index].teamTypeId != null
                    ? controller.teamGetModel.value.data[index].teamTypeId.name
                    : "-",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 9,
                    fontFamily: "Inter",
                    color: AppColor().whiteColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget firstTabCall(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (AppString.createTeam.value == 'inactive') {
                    Fluttertoast.showToast(msg: 'Create team disable!');
                    return;
                  }
                  showCustomDialog(context);
                },
                child: CircleAvatar(
                  backgroundColor: AppColor().whiteColor,
                  radius: 40,
                  child: CircleAvatar(
                    backgroundImage:
                        //AssetImage(ImageRes().rectangle_orange_gradient_box),
                        AppString.createTeam.value == 'inactive'
                            ? AssetImage(
                                'assets/images/profile_bottom_new.webp')
                            : AssetImage(
                                ImageRes().rectangle_orange_gradient_box),
                    radius: 39,
                    child: Center(
                        child: Image.asset(
                      "assets/images/ic_create_tem_upload.webp",
                      color: Colors.white,
                      height: 30,
                    )),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Create".tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Roboto",
                      color: AppColor().whiteColor),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Team".tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Roboto",
                      color: AppColor().whiteColor),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: spinnerGameType()),
              Expanded(child: spinnerTeamType()),
              Expanded(
                  child: Container(
                height: 45,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor().whiteColor, width: 1),
                ),
                child: Obx(
                  () => DropdownButton(
                      icon: Container(
                        margin: EdgeInsets.only(right: 5),
                        width: 13,
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/arrow_down.png",
                          color: Colors.white,
                        ),
                      ),
                      underline: const SizedBox(),
                      isExpanded: true,
                      hint: Text(
                        "Member Type",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      value: controller.selectedMemberType.value == ""
                          ? null
                          : controller.selectedMemberType.value,
                      dropdownColor: AppColor().reward_card_bg,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            "All",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400),
                          ),
                          value: "0",
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "Captain",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400),
                          ),
                          value: "1",
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "Member",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400),
                          ),
                          value: "2",
                        ),
                      ],
                      onChanged: (value11) {
                        controller.selectedMemberType.value = value11 ?? "";
                        if (value11 == "1") {
                          controller.isCaptain.value = "isCaptain=true";
                          controller.getTeamS(
                              "",
                              controller.game_id_teams.value,
                              controller.team_id_teams.value,
                              controller.isCaptain.value,
                              "");
                        } else if (value11 == "2") {
                          controller.isCaptain.value = "isCaptain=false";
                          controller.getTeamS(
                              "",
                              controller.game_id_teams.value,
                              controller.team_id_teams.value,
                              controller.isCaptain.value,
                              "");
                        } else {
                          controller.isCaptain.value = "";
                          controller.getTeamS(
                              "",
                              controller.game_id_teams.value,
                              controller.team_id_teams.value,
                              "",
                              "");
                        }
                      }),
                ),
              ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => Container(
              height: MediaQuery.of(context).size.height,
              child: controller.teamGetModel.value != null
                  ? Obx(
                      () => controller.teamGetModel.value.data != null
                          ? GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 15.0,
                              children: List.generate(
                                  controller.teamGetModel.value.data.length,
                                  (index) {
                                return Obx(() => listGameName(context, index));
                              }))
                          : Center(
                              child: Container(
                                child: Text("No Team Found",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                    )
                  : Container(
                      alignment: Alignment.topCenter,
                      height: 100,
                      width: 100,
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
                      )),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondTabCall(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          Obx(
            () => Container(
              height: MediaQuery.of(context).size.height * .85,
              child: controller.teamGetModelInvites.value != null
                  ? controller.teamGetModelInvites.value.data.length >= 1
                      ? ListView.builder(
                          itemCount: controller
                                      .teamGetModelInvites.value.data.length >
                                  0
                              ? controller.teamGetModelInvites.value.data.length
                              : 0,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, indexIn) {
                            return inviteListDynamic(context, indexIn);
                          })
                      : Container(
                          child: Center(
                            child: Text(
                              "No pending requests",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13),
                            ),
                          ),
                        )
                  : Center(
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
                    )),
            ),
          ),
        ],
      ),
    );
  }

  Widget spinnerTeamType() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor().whiteColor, width: 1),
      ),
      child: Obx(
        () => controller.teamTypeList != null &&
                controller.teamTypeList.length > 0
            ? Obx(
                () => DropdownButton<String>(
                  icon: Container(
                    margin: EdgeInsets.only(right: 5),
                    width: 13,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/arrow_down.png",
                      color: Colors.white,
                    ),
                  ),
                  isExpanded: true,
                  dropdownColor: AppColor().reward_card_bg,
                  onChanged: (String value) {
                    //   Fluttertoast.showToast(msg: value);
                    controller.selectedValue.value = value;
                    for (var i in controller.teamTypeModelR.value.data) {
                      if (i.name == value) {
                        controller.teamTypeId.value = i.id;
                        controller.team_id_teams.value =
                            "teamTypeId=${controller.teamTypeId.value}";
                        if (controller.teamTypeId.value.compareTo("0") == 0) {
                          controller.team_id_teams.value = "";
                        }

                        controller.getTeamS(
                            "",
                            controller.game_id_teams.value,
                            controller.team_id_teams.value,
                            controller.isCaptain.value,
                            "");
                        /*  controller.getTeamS(
                            "", "", controller.team_id_teams.value, "", "");*/
                      }
                    }
                  },
                  underline: const SizedBox(),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Team Type",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                  value: controller.selectedValue.value == ""
                      ? null
                      : controller.selectedValue.value,
                  items: controller.teamTypeList.map((value) {
                    return DropdownMenuItem(
                      value: value.name,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          value.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  "Team Type",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 13),
                ),
              ),
      ),
    );
  }

  Widget spinnerGameType() {
    return Obx(
      () => Container(
          height: 45,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor().whiteColor, width: 1),
          ),
          child: home_Controller.only_esport_game_e.value.data != null
              ? Obx(
                  () => DropdownButton(
                    icon: Container(
                      margin: EdgeInsets.only(right: 5),
                      width: 13,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/arrow_down.png",
                        color: Colors.white,
                      ),
                    ),
                    isExpanded: true,
                    dropdownColor: AppColor().reward_card_bg,
                    onChanged: (String value) {
                      controller.selectedValueGame.value = value;
                      for (var i
                          in home_Controller.only_esport_game_e.value.data) {
                        if (i.name == value) {
                          controller.gameId.value = i.id;

                          controller.game_id_teams.value =
                              "gameId=${controller.gameId.value}";

                          if (controller.gameId.value.compareTo("0") == 0) {
                            controller.game_id_teams.value = "";
                          }
                          controller.getTeamS(
                              "",
                              controller.game_id_teams.value,
                              controller.team_id_teams.value,
                              controller.isCaptain.value,
                              "");
                          /*   controller.getTeamS(
                              "", controller.game_id_teams.value, "", "", "");*/
                        }
                      }
                    },
                    underline: const SizedBox(),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "Game Type",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    value: controller.selectedValueGame.value == ""
                        ? null
                        : controller.selectedValueGame.value,
                    items: home_Controller.only_esport_game_e.value.data
                        .map((value) {
                      return DropdownMenuItem(
                        value: value.name,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: .0),
                  child: Center(
                    child: Text(
                      "Select Game",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
    );
  }

  Widget spinnerTeamTypeCreate() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor().whiteColor, width: 1),
      ),
      child: Obx(
        () => controller.teamTypeList != null &&
                controller.teamTypeList.length > 0
            ? Obx(
                () => DropdownButton<String>(
                  icon: Container(
                    margin: EdgeInsets.only(right: 5),
                    width: 13,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/arrow_down.png",
                      color: Colors.white,
                    ),
                  ),
                  isExpanded: true,
                  dropdownColor: AppColor().reward_card_bg,
                  onChanged: (String value) {
                    //   Fluttertoast.showToast(msg: value);
                    controller.selectedValueTeamCreate.value = value;
                    for (var i in controller.teamTypeModelR.value.data) {
                      if (i.name == value) {
                        controller.teamTypeId.value = i.id;
                        controller.team_id_teams.value =
                            "teamTypeId=${controller.teamTypeId.value}";
                        if (controller.teamTypeId.value.compareTo("0") == 0) {
                          controller.team_id_teams.value = "";
                        }

                        controller.getTeamS(
                            "",
                            controller.game_id_teams.value,
                            controller.team_id_teams.value,
                            controller.isCaptain.value,
                            "");
                        /*  controller.getTeamS(
                            "", "", controller.team_id_teams.value, "", "");*/
                      }
                    }
                  },
                  underline: const SizedBox(),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Team Type",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                  value: controller.selectedValueTeamCreate.value == ""
                      ? null
                      : controller.selectedValueTeamCreate.value,
                  items: controller.teamTypeList.map((value) {
                    return DropdownMenuItem(
                      value: value.name,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          value.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  "Team Type",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 13),
                ),
              ),
      ),
    );
  }

  Widget spinnerGameTypeCreate() {
    return Obx(
      () => Container(
          height: 45,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor().whiteColor, width: 1),
          ),
          child: home_Controller.only_esport_game_e.value.data != null
              ? Obx(
                  () => DropdownButton(
                    icon: Container(
                      margin: EdgeInsets.only(right: 5),
                      width: 13,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/arrow_down.png",
                        color: Colors.white,
                      ),
                    ),
                    isExpanded: true,
                    dropdownColor: AppColor().reward_card_bg,
                    onChanged: (String value) {
                      controller.selectedValueGameCreate.value = value;
                      for (var i
                          in home_Controller.only_esport_game_e.value.data) {
                        if (i.name == value) {
                          controller.gameId.value = i.id;

                          controller.game_id_teams.value =
                              "gameId=${controller.gameId.value}";

                          if (controller.gameId.value.compareTo("0") == 0) {
                            controller.game_id_teams.value = "";
                          }
                          controller.getTeamS(
                              "",
                              controller.game_id_teams.value,
                              controller.team_id_teams.value,
                              controller.isCaptain.value,
                              "");
                          /*   controller.getTeamS(
                              "", controller.game_id_teams.value, "", "", "");*/
                        }
                      }
                    },
                    underline: const SizedBox(),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "Game Type",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    value: controller.selectedValueGameCreate.value == ""
                        ? null
                        : controller.selectedValueGameCreate.value,
                    items: home_Controller.only_esport_game_e.value.data
                        .map((value) {
                      return DropdownMenuItem(
                        value: value.name,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: .0),
                  child: Center(
                    child: Text(
                      "Select Game",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
    );
  }

  void AddMember(BuildContext context, String team_id) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().new_rectangle_box_blank)),
            ),
            height: 220,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "   ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "Add Member",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "Enter Team Member Mobile No",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _editTitleTextFieldMember(
                              teamManagementController.teamMemberNumber,
                              "Enter your Member Mobile No"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Expanded(
                              flex: 1,
                              child: InkWell(
                                  onTap: () async {
                                /*    final PhoneContact contact =
                                        await FlutterContactPicker
                                            .pickPhoneContact();*/
                                   // _contact = contact;
                                    //  _name = _contact.fullName;
                                    mobile =
                                        "";
                                     //   _contact.phoneNumber.number.toString();
                                    teamManagementController.teamMemberNumber
                                        .text = mobile.removeAllWhitespace;
                                    teamManagementController
                                            .teamMemberNumber.text =
                                        teamManagementController
                                            .teamMemberNumber.text
                                            .replaceAll(RegExp('[^0-9]'), '');

                                    if (teamManagementController
                                            .teamMemberNumber.text.length >
                                        10) {
                                      teamManagementController
                                              .teamMemberNumber.text =
                                          teamManagementController
                                              .teamMemberNumber.text
                                              .substring(2);
                                    }
                                    //Fluttertoast.showToast(msg: "${teamManagementController.teamMemberNumber.text}");
                                    /* teamManagementController.teamMemberNumber.text=mobile;*/
                                  },
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/user_wallet.webp'),
                                      height: 30,
                                      width: 30)

                                  /*Text("Cont",style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColor().colorPrimary),),*/
                                  )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _Button(context, "SUBMIT", team_id),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().new_rectangle_box_blank)),
            ),
            height: 450,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Create Team".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
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
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.getFromGallery();
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColor().whiteColor,
                      radius: 40,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                            ImageRes().rectangle_orange_gradient_box),
                        radius: 39,
                        child: Obx(
                          () => controller.iamges1.value != null &&
                                  controller.pickedFile != null
                              ? CircleAvatar(
                                  radius: MediaQuery.of(context).size.height,
                                  backgroundImage:
                                      FileImage(controller.iamges1.value),
                                )
                              : Center(
                                  child: Image.asset(
                                  "assets/images/ic_create_tem_upload.webp",
                                  color: Colors.white,
                                  height: 30,
                                )),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "Team Name",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  _editTitleTextField(controller.teamName, "Team Name"),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "Game",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: spinnerGameTypeCreate()),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "No. of Player",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 30, right: 20),
                      child: spinnerTeamTypeCreate()),
                  //spinnerShow(),
                  SizedBox(
                    height: 15,
                  ),
                  _ButtonCreate(context, "Create", ""),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  Widget editTitleTextFieldInGame(
      TextEditingController controllerV, String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      margin: EdgeInsets.symmetric(horizontal: 35),
      height: 50,
      child: TextField(
        style: TextStyle(color: AppColor().whiteColor),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColor().whiteColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            hintText: "${text}"),
        onChanged: (textv) {
          controllerV.text = textv;
          Utils().customPrint("First text field: $textv");
          controllerV.selection = TextSelection.fromPosition(
              TextPosition(offset: controllerV.text.length));
        },
        autofocus: false,
        controller: controllerV,
      ),
    );
  }

  Widget buttonSubmit(BuildContext context, String game_id, String team_id,
      List<Members> memberV) {
    return GestureDetector(
      onTap: () {
        teamManagementController.getINGamePost(game_id, team_id, memberV);
        Navigator.pop(context);
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 34),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor().colorPrimary,
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              "Submit",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
            ),
          )),
    );
  }

  Widget _Button(BuildContext context, String showText, String team_id) {
    return GestureDetector(
      onTap: () {
        teamManagementController.getAddTeamMember(team_id);
        Navigator.pop(context);
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 34),
          width: 180,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(ImageRes().submit_bg)),
            // color: AppColor().colorPrimary,
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              showText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
            ),
          )),
    );
  }

  Widget _ButtonCreate(BuildContext context, String showText, String team_id) {
    return GestureDetector(
      onTap: () {
        showProgress(context, "", true);
        var mapD = controller.getTeamCreate(
            controller.teamTypeId.value, controller.gameId.value, context);

        if (mapD == true) {
          Navigator.pop(context);
          hideProgress(context);
          //  Fluttertoast.showToast(msg: mapD.toString());
        } else {
          hideProgress(context);
          //  Fluttertoast.showToast(msg: "some error");
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 34),
          width: 180,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(ImageRes().submit_bg)),
            // color: AppColor().colorPrimary,
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              showText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
            ),
          )),
    );
  }

  Widget _editTitleTextField(TextEditingController controllerV, String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      margin: EdgeInsets.symmetric(horizontal: 35),
      height: 50,
      child: TextField(
        style: TextStyle(color: AppColor().whiteColor),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColor().whiteColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            hintText: "${text}"),
        onChanged: (textv) {
          controller.mapKey[text] = textv;
          Utils().customPrint("First text field: $textv");
        },
        autofocus: false,
        controller: controllerV,
      ),
    );
  }

  Widget _editTitleTextFieldMember(
      TextEditingController controllerV, String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      //margin: EdgeInsets.only(left: 25),
      height: 50,
      child: TextField(
        style: TextStyle(color: AppColor().whiteColor),
        inputFormatters: [
          new LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColor().whiteColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            hintText: "${text}"),
        onChanged: (textv) {
          // controllerV.text = textv;
        },
        autofocus: false,
        controller: controllerV,
      ),
    );
  }

  Widget inviteListDynamic(BuildContext context, int indexP) {
    // Utils().customPrint("data members ${controller.teamGetModelInvites.value.data[indexP].members[0].userId.username ?? ""}");
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 40, 10, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 10),
                            child: Obx(
                              () => Text(
                                controller.teamGetModelInvites.value
                                            .data[indexP].gameId !=
                                        null
                                    ? controller.teamGetModelInvites.value
                                        .data[indexP].gameId.name
                                    : "",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().whiteColor),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Obx(
                              () => Text(
                                controller.teamGetModelInvites.value
                                            .data[indexP].teamTypeId !=
                                        null
                                    ? controller.teamGetModelInvites.value
                                        .data[indexP].teamTypeId.name
                                    : "-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Inter",
                                    color: AppColor().whiteColor),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          //  height: 60,
                          width: 3,
                          // color: Colors.white,
                        ),
                        Container(
                          // height: 60,
                          width: 1,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (AppString.acceptTeamInvitation.value ==
                                  'inactive') {
                                Fluttertoast.showToast(
                                    msg: 'Accept team disable!');
                                return;
                              }
                              var mapData = await teamManagementController
                                  .getINGameCheck(controller.teamGetModelInvites
                                      .value.data[indexP].gameId.id);
                              if (mapData != null) {
                                if (teamManagementController
                                        .inGameCheckModel.value !=
                                    null) {
                                  if (!teamManagementController.inGameCheckModel
                                      .value.inGameName.isEmpty) {
                                    teamManagementController
                                        .getAcceptTeamMember(
                                            controller.teamGetModelInvites.value
                                                .data[indexP].id,
                                            controller.teamGetModelInvites.value
                                                .data[indexP].members);
                                  } else {
                                    showInGameDialog(
                                        context,
                                        controller.teamGetModelInvites.value
                                            .data[indexP].gameId.id,
                                        controller.teamGetModelInvites.value
                                            .data[indexP].id,
                                        controller.teamGetModelInvites.value
                                            .data[indexP].members);
                                  }
                                }
                              } else {
                                showInGameDialog(
                                    context,
                                    controller.teamGetModelInvites.value
                                        .data[indexP].gameId.id,
                                    controller.teamGetModelInvites.value
                                        .data[indexP].id,
                                    controller.teamGetModelInvites.value
                                        .data[indexP].members);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                "Accept",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                    fontFamily: "Inter",
                                    color: Colors.greenAccent),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          // color: Colors.white,
                          height: 0,
                        ),
                      ),
                      Container(
                        //color: Colors.white,
                        width: .0,

                        //height: 60,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          //color: Colors.white,
                          height: 0,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  captain_photo_invite != null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 17.5,
                                          // height: 15,
                                          backgroundImage: NetworkImage(
                                              captain_photo_invite))
                                      : CircleAvatar(
                                          radius: 17.5,
                                          backgroundColor: Colors.white,
                                          child: Image(
                                            height: 14,
                                            image: AssetImage(
                                                ImageRes().team_group),
                                          ),
                                        ),
                                  Obx(
                                    () => Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "${controller.teamGetModelInvites.value.data[indexP] != null && controller.teamGetModelInvites.value.data[indexP].members != null ? getMemberData(controller.teamGetModelInvites.value.data[indexP].members) : ""}"
                                                .capitalize,
                                            // " Captain\n ${controller.teamGetModelInvites.value.data[indexP].members[0].name}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Inter",
                                                color: AppColor().whiteColor),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 6, top: 3),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                AppColor().colorPrimary,
                                            radius: 9,
                                            child: Text(
                                              "C",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColor().whiteColor,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                        Expanded(
                          child: Obx(
                            () => Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: controller.teamGetModelInvites.value
                                              .data[indexP].teamTypeId !=
                                          null &&
                                      controller.teamGetModelInvites.value
                                              .data[indexP].teamTypeId.name ==
                                          "duo"
                                  ? Container(
                                      height: 20,
                                      child: Image.asset(ImageRes().team_duo),
                                    )
                                  : Container(
                                      height: 20,
                                      child: Image.asset(ImageRes().team_group),
                                    ),
                            ),
                          ),
                        ),
                        Container(
                          //height: 60,
                          width: 3,
                          // color: Colors.white,
                        ),
                        Container(
                          color: Colors.white,
                          width: 1,
                          // height: 60,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              teamManagementController.getRejectedTeamMember(
                                  controller.teamGetModelInvites.value
                                      .data[indexP].id,
                                  controller.teamGetModelInvites.value
                                      .data[indexP].members);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Reject",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontFamily: "Inter",
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, top: 20),
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      "assets/images/rectangle_orange_gradient_box.png"),
                ),
              ),
              child: Center(
                child: Obx(
                  () => Text(
                    controller
                        .teamGetModelInvites.value.data[indexP].name.capitalize,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Inter",
                        color: AppColor().whiteColor),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  memberListInvited(BuildContext context, int indexbASE, int index) {
    return controller
            .teamGetModelInvites.value.data[indexbASE].members[index].isCaptain
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20.5,
                  // height: 15,
                  backgroundImage: NetworkImage(controller.teamGetModelNewTeam
                      .value.data[indexbASE].members[index].userId.photo.url))
              /*CircleAvatar(
          backgroundColor: AppColor().whiteColor,
          radius: 20,
          child: Center(
              child: Icon(
                Icons.supervised_user_circle_outlined,
                color: Colors.black,
                //size: 50,
              )),
        )*/
              ,
              Obx(
                () => Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "${controller.teamGetModelInvites.value.data[indexbASE].members[index].userId.username}",
                        // " Captain\n ${controller.teamGetModelInvites.value.data[indexP].members[0].name}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inter",
                            color: AppColor().whiteColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : Container(height: 0);
  }

  thirdTabCall(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            height: MediaQuery.of(context).size.height * .84,
            // height: MediaQuery.of(context).size.height,

            child: Obx(
              () => controller.teamGetModelNewTeam.value != null
                  ? ListView.builder(
                      itemCount:
                          controller.teamGetModelNewTeam.value.data.length,
                      shrinkWrap: true,

                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, indexThird) {
                        return newTeamList(context, indexThird);
                      })
                  : Center(
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
                    )),
            ),
          ),
        ],
      ),
    );
  }

  newTeamList(BuildContext context, int indexThi) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(
                  10), /*color: AppColor().reward_grey_bg*/
            ),
            child: Container(
              margin: EdgeInsets.only(top: 0, bottom: 5, left: 10, right: 10),
              child: Column(
                children: [
                  /*   GestureDetector(
                    onTap: () {
                      AddMember(
                          context,
                          controller
                              .teamGetModelNewTeam.value.data[indexThi].id);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 0),
                      alignment: Alignment.center,
                      child: controller.teamGetModelNewTeam.value.data[indexThi]
                                  .teamTypeId.size >
                              controller.teamGetModelNewTeam.value
                                  .data[indexThi].members.length
                          ? controller.teamGetModelNewTeam.value.data[indexThi]
                                      .createdBy
                                      .compareTo(controller.user_id) ==
                                  0
                              ? Container(
                                  width: 60,
                                  margin: EdgeInsets.only(left: 30, bottom: 0),
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 7, bottom: 7),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Add",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        //decoration: TextDecoration.underline,
                                        fontSize: 15,
                                        fontFamily: "Inter",
                                        color: Colors.blue),
                                  ),
                                )
                              : Container(
                                  height: 20,
                                )
                          : Container(
                              height: 20,
                            ),
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.teamGetModelNewTeam.value.data[indexThi]
                                      .gameId !=
                                  null
                              ? controller.teamGetModelNewTeam.value
                                  .data[indexThi].gameId.name.capitalize
                              : "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Inter",
                              color: AppColor().whiteColor),
                        ),
                        Text(
                          controller.teamGetModelNewTeam.value.data[indexThi]
                                      .teamTypeId !=
                                  null
                              ? controller.teamGetModelNewTeam.value
                                  .data[indexThi].teamTypeId.name
                              : "-",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Inter",
                              color: AppColor().whiteColor),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.teamGetModelNewTeam.value
                                  .data[indexThi].members !=
                              null
                          ? controller.teamGetModelNewTeam.value.data[indexThi]
                              .members.length
                          : 0,
                      itemBuilder: (context, indexM) {
                        return MemberList(context, indexThi, indexM);
                      }),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 40, top: 0),
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                    "assets/images/rectangle_orange_gradient_box.png"),
              ),
            ),
            child: Center(
              child: Text(
                controller
                    .teamGetModelNewTeam.value.data[indexThi].name.capitalize,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Inter",
                    color: AppColor().whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  MemberList(BuildContext context, int indexThi, int indexM) {
    /*  Utils().customPrint("team ma photo =>${controller.teamGetModelNewTeam.value.data[indexThi]
        .members[indexM].userId.photo.url}");*/
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(() => controller.teamGetModelNewTeam.value.data[indexThi]
                              .members[indexM].isCaptain ==
                          true
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20.5,
                          child: Center(
                              child: controller
                                              .teamGetModelNewTeam
                                              .value
                                              .data[indexThi]
                                              .members[indexM]
                                              .userId !=
                                          null &&
                                      controller
                                              .teamGetModelNewTeam
                                              .value
                                              .data[indexThi]
                                              .members[indexM]
                                              .userId
                                              .photo !=
                                          null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20.5,
                                      // height: 15,
                                      backgroundImage: NetworkImage(controller
                                          .teamGetModelNewTeam
                                          .value
                                          .data[indexThi]
                                          .members[indexM]
                                          .userId
                                          .photo
                                          .url))
                                  : Image(
                                      height: 15,
                                      image: AssetImage(ImageRes().team_group),
                                    )),
                        )
                      : CircleAvatar(
                          backgroundColor: AppColor().whiteColor,
                          radius: 20,
                          child: Center(
                              child: controller
                                              .teamGetModelNewTeam
                                              .value
                                              .data[indexThi]
                                              .members[indexM]
                                              .userId !=
                                          null &&
                                      controller
                                              .teamGetModelNewTeam
                                              .value
                                              .data[indexThi]
                                              .members[indexM]
                                              .userId
                                              .photo !=
                                          null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20.5,
                                      // fit: BoxFit.fill,
                                      //height: 15,
                                      backgroundImage: NetworkImage(controller
                                          .teamGetModelNewTeam
                                          .value
                                          .data[indexThi]
                                          .members[indexM]
                                          .userId
                                          .photo
                                          .url))
                                  : Image(
                                      height: 15,
                                      image: AssetImage(ImageRes().team_group),
                                    )),
                        )),
                  SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 90,
                        child: Text(
                          controller.teamGetModelNewTeam.value.data[indexThi]
                                      .members[indexM].userId !=
                                  null
                              ? controller
                                          .teamGetModelNewTeam
                                          .value
                                          .data[indexThi]
                                          .members[indexM]
                                          .userId
                                          .username
                                          .length >
                                      15
                                  ? controller
                                      .teamGetModelNewTeam
                                      .value
                                      .data[indexThi]
                                      .members[indexM]
                                      .userId
                                      .username
                                      .substring(0, 15)
                                      .capitalize
                                  : controller
                                      .teamGetModelNewTeam
                                      .value
                                      .data[indexThi]
                                      .members[indexM]
                                      .userId
                                      .username
                                      .capitalize
                              : "user name".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Inter",
                              color: AppColor().whiteColor),
                        ),
                      ),
                      controller.teamGetModelNewTeam.value.data[indexThi]
                                  .members[indexM].isCaptain ==
                              true
                          ? Container(
                              margin: EdgeInsets.only(left: 6, top: 3),
                              child: CircleAvatar(
                                backgroundColor: AppColor().colorPrimary,
                                radius: 9,
                                child: Text(
                                  "C",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColor().whiteColor,
                                      fontSize: 10),
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 20,
                            )
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              controller.teamGetModelNewTeam.value.data[indexThi]
                          .members[indexM].isCaptain ==
                      true
                  ? GestureDetector(
                      onTap: () {
                        AddMember(
                            context,
                            controller
                                .teamGetModelNewTeam.value.data[indexThi].id);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0),
                        alignment: Alignment.center,
                        child: controller.teamGetModelNewTeam.value
                                        .data[indexThi].teamTypeId !=
                                    null &&
                                controller.teamGetModelNewTeam.value
                                        .data[indexThi].teamTypeId.size >
                                    controller.teamGetModelNewTeam.value
                                        .data[indexThi].members.length
                            ? controller.teamGetModelNewTeam.value
                                        .data[indexThi].createdBy
                                        .compareTo(controller.user_id) ==
                                    0
                                ? Container(
                                    width: 60,
                                    margin: EdgeInsets.only(left: 0, bottom: 0),
                                    padding: EdgeInsets.only(
                                        left: 0, right: 0, top: 7, bottom: 7),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      "Add",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          //decoration: TextDecoration.underline,
                                          fontSize: 15,
                                          fontFamily: "Inter",
                                          color: AppColor().colorPrimary),
                                    ),
                                  )
                                : Container(
                                    height: 20,
                                  )
                            : Container(
                                height: 20,
                              ),
                      ),
                    )
                  : Center(
                      child: Text(
                        controller.teamGetModelNewTeam.value.data[indexThi]
                                    .members[indexM].userId !=
                                null
                            ? controller
                                .teamGetModelNewTeam
                                .value
                                .data[indexThi]
                                .members[indexM]
                                .status
                                .capitalize
                            : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inter",
                            color: AppColor().whiteColor),
                      ),
                    ),
              Obx(
                () => controller.teamGetModelNewTeam.value.data[indexThi]
                            .members[indexM].isCaptain ==
                        true
                    ? Text(
                        "                    ",
                        textAlign: TextAlign.center,
                      )
                    : controller.teamGetModelNewTeam.value.data[indexThi]
                                .createdBy
                                .compareTo(controller.user_id) ==
                            0
                        ? GestureDetector(
                            onTap: () {
                              showAlertDialog(context, indexThi, indexM);
                            },
                            child: Text(
                              " Remove",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  fontFamily: "Inter",
                                  color: Colors.red),
                            ),
                          )
                        : Text(
                            "                   ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                fontFamily: "Inter",
                                color: Colors.red),
                          ),
              )
            ],
          ),
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context, int indexThi, int indexM) {
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        /*   Fluttertoast.showToast(
            msg:
                "team_id ${controller.teamGetModelNewTeam.value.data[indexThi].id} member id ${controller.teamGetModelNewTeam.value.data[indexThi].members[indexM].id}");*/
        teamManagementController.getDeleteTeamMember(
            controller.teamGetModelNewTeam.value.data[indexThi].id,
            controller
                .teamGetModelNewTeam.value.data[indexThi].members[indexM].id);

        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Do you want to delete Member?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showInGameDialog(BuildContext context, String game_id, String team_id1,
      List<Members> memberV) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().new_rectangle_box_blank)),
            ),
            height: 300,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "   ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "Game Name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "InGameName",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  editTitleTextFieldInGame(
                    teamManagementController.inGameName,
                    "Enter your InGameName",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "InGameID",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  editTitleTextFieldInGame(
                      teamManagementController.iNGameId, "Enter your InGameID"),
                  SizedBox(
                    height: 15,
                  ),
                  buttonSubmit(context, game_id, team_id1, memberV),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  getMemberData(List<Members> members) {
    for (int a = 0; members.length > a; a++) {
      if (members[a].isCaptain) {
        captain_name_invite = members[a].userId.username;
        if (members[a].userId.username.length > 8) {
          captain_name_invite = members[a].userId.username.substring(0, 7);
        } else {
          captain_name_invite = members[a].userId.username;
        }

        if (members[a].userId.photo != null) {
          captain_photo_invite = members[a].userId.photo.url;
        }
        /* else{
              captain_photo_invite
            }*/

      }
    }

    return captain_name_invite;
  }
}
