import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/*
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
*/
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/ProfileController.dart';
import 'package:gmng/ui/main/team_management/TeamManagementNew.dart';
import 'package:intl/intl.dart';

import '../../../model/ESportsEventList.dart';
import '../../../res/FontSizeC.dart';
import '../../../utills/Platfrom.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/ApiUrl.dart';
import '../../controller/HomePageController.dart';
import '../../controller/TeamManagementController.dart';
import '../../controller/TeamManagementDetailsController.dart';
import '../../dialog/helperProgressBar.dart';
import '../esports/JoinedBattlesDetails.dart';

class TeamManagementDetails extends StatelessWidget {
  double width;

  String _name = "";
  String mobile = "";

/*
  PhoneContact _contact;
*/

  ProfileController controller = Get.put(ProfileController());
  HomePageController home_Controller = Get.put(HomePageController());
  TeamManagementController teamManagementController =
      Get.put(TeamManagementController());
  TeamManagementDetailsController tDe =
      Get.put(TeamManagementDetailsController());

  @override
  Widget build(BuildContext context) {
    width = Platfrom().isWeb()
        ? MediaQuery.of(context).size.width * FontSizeC().screen_percentage_web
        : MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          flexibleSpace: Image(
            image: AssetImage('assets/images/store_top.png'),
            fit: BoxFit.cover,
          ),
          title: Container(
            margin: EdgeInsets.only(right: 60),
            child: Center(
              child: Text(
                "Team Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/store_back.png"))),
        child: thirdTabCall(context),
      ),
    );
  }

  void AddMemberDetailsTeam(BuildContext context, String team_id) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 220,
            child: Card(
              color: AppColor().wallet_dark_grey,
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
                        "Enter Your Friends Number",
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
                    margin: const EdgeInsets.only(left: 28, right: 25),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: _editTitleTextFieldMember(
                              teamManagementController.teamMemberNumber,
                              "Enter Your Friends Number"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 14,
                              child: InkWell(
                                  onTap: () async {
                                   /* final PhoneContact contact =
                                        await FlutterContactPicker
                                            .pickPhoneContact();*/
                                  //  _contact = contact;
                                 //   _name = _contact.fullName;
                                    mobile =
                                       "";
                                       // _contact.phoneNumber.number.toString();
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

  Widget _Button(BuildContext context, String showText, String team_id) {
    return GestureDetector(
      onTap: () {
        if (teamManagementController.teamMemberNumber.text != null) {
          if (team_id == "") {
            //  Navigator.pop(context);
            showProgress(context, "", true);
            var mapD = controller.getTeamCreate(
                controller.teamTypeId.value, controller.gameId.value,context);

            if (mapD != null) {
              Get.to(() => TeamManagementNew());
              /*  Route route = MaterialPageRoute(
                  builder: (context) => TeamManagementNew());
              Navigator.pushReplacement(context, route);*/

              // tDe.getTeamDetails(team_id);
              // Fluttertoast.showToast(msg: mapD.toString());

            } else {
              Fluttertoast.showToast(msg: "some error");
            }
          } else {
            if (teamManagementController.teamMemberNumber.text.length > 9) {
              teamManagementController.getAddTeamMember(team_id);
              Get.to(() => TeamManagementNew());
            } else {
              Fluttertoast.showToast(msg: "Please Enter Valid Friends Number");
            }

            /*    Route route = MaterialPageRoute(
                builder: (context) => TeamManagementNew());
            Navigator.pushReplacement(context, route);*/
            // Navigator.pop(context);
          }
        } else {
          Fluttertoast.showToast(msg: "Please Enter Friends Number");
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor().colorPrimary,
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

  Widget _editTitleTextFieldMember(
      TextEditingController controllerV, String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      margin: EdgeInsets.only(left: 0),
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
          controllerV.selection = TextSelection.fromPosition(
              TextPosition(offset: controllerV.text.length));
          // controllerV.text = textv;
        },
        autofocus: false,
        controller: controllerV,
      ),
    );
  }

  Widget inviteListDynamic(BuildContext context, int indexP) {
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
                                    .data[indexP].gameId.name,
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
                                    .data[indexP].teamTypeId.name,
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
                            padding: const EdgeInsets.only(bottom: 15, top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColor().whiteColor,
                                  radius: 20,
                                  child: Center(
                                      child: Icon(
                                    Icons.supervised_user_circle_outlined,
                                    color: Colors.black,
                                    //size: 50,
                                  )),
                                ),
                                Obx(
                                  () => Text(
                                    " Captain\n ${controller.teamGetModelInvites.value.data[indexP].members[0].name}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Inter",
                                        color: AppColor().whiteColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: controller.teamGetModelInvites.value
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
                  border:
                      Border.all(width: 1, color: AppColor().reward_card_bg)),
              child: Center(
                child: Obx(
                  () => Text(
                    controller.teamGetModelInvites.value.data[indexP].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Inter",
                        color: AppColor().reward_card_bg),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget inviteList(BuildContext context, int indexP) {
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
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Pocket 52",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Duo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 3,
                        // color: Colors.white,
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Text(
                          "Accept",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                              fontFamily: "Inter",
                              color: Colors.greenAccent),
                        ),
                      )
                    ],
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 15, top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColor().whiteColor,
                                radius: 20,
                                child: Center(
                                    child: Icon(
                                  Icons.supervised_user_circle_outlined,
                                  color: Colors.black,
                                  //size: 50,
                                )),
                              ),
                              Text(
                                " Captain\n shukla",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Inter",
                                    color: AppColor().whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            height: 20,
                            child: Image.asset(ImageRes().team_duo),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 3,
                        // color: Colors.white,
                      ),
                      Container(
                        color: Colors.white,
                        width: 1,
                        height: 60,
                      ),
                      Expanded(
                        child: Text(
                          "Reject",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              fontFamily: "Inter",
                              color: Colors.red),
                        ),
                      )
                    ],
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
                  border:
                      Border.all(width: 1, color: AppColor().reward_card_bg)),
              child: Center(
                child: Text(
                  "Team Name",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Inter",
                      color: AppColor().reward_card_bg),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  thirdTabCall(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => Container(
                child: tDe.teamDetailsModelR.value != null
                    ? DetailsTeamList(context)
                    : Center(child: CircularProgressIndicator())),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent),
            height: 45,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    tDe.team_upcoming.value = true;
                  },
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(5)),
                          image: tDe.team_upcoming.value == true
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      "assets/images/rectangle_orange_gradient_box.png"),
                                )
                              : null),
                      child: Center(
                          child: Text("History".tr,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Inter",
                                  color: AppColor().whiteColor))),
                    ),
                  ),
                )),
                Container(
                  width: 1,
                  color: Colors.white,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    tDe.team_upcoming.value = false;
                  },
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              bottomLeft: Radius.circular(0)),
                          image: tDe.team_upcoming.value == false
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      "assets/images/rectangle_orange_gradient_box.png"),
                                )
                              : null),
                      child: Center(
                          child: Text("Upcoming",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Inter",
                                  color: AppColor().whiteColor))),
                    ),
                  ),
                )),
                Container(
                  height: 2,
                ),
              ],
            ),
          ),
          Obx(() => Visibility(
                visible: tDe.team_upcoming.value,
                child: Container(
                    // height: 200,
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: (tDe.esportJoinedList != null &&
                            tDe.esportJoinedList.value != null &&
                            tDe.esportJoinedList.value.data != null &&
                            tDe.esportJoinedList.value.data.length > 0)
                        ? tDe.esportJoinedList.value.data.length > 0
                            ? ListView.builder(
                                padding: EdgeInsets.only(top: 0),
                                itemCount:
                                    tDe.esportJoinedList.value.data.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return joinedListView(context, index);
                                })
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * .61,
                                child: Center(
                                  child: Text(
                                    "No items are available Please Come back later",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                        : Container(
                            height: 0,
                          )),
              )),
          Obx(() => Offstage(
                offstage: tDe.team_upcoming.value,
                child: Container(
                    // height: 200,
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: (tDe.esportJoinedListUp != null &&
                            tDe.esportJoinedListUp.value != null &&
                            tDe.esportJoinedListUp.value.data != null &&
                            tDe.esportJoinedListUp.value.data.length > 0)
                        ? tDe.esportJoinedListUp.value.data.length > 0
                            ? ListView.builder(
                                padding: EdgeInsets.only(top: 0),
                                itemCount:
                                    tDe.esportJoinedListUp.value.data.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return joinedListViewUC(context, index);
                                })
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * .61,
                                child: Center(
                                  child: Text(
                                    "No items are available Please Come back later",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                        : Container(
                            height: 0,
                          )),
              ))
        ],
      ),
    );
  }

  DetailsTeamList(BuildContext context) {
  Utils().customPrint("");
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius:
                  BorderRadius.circular(5), /*color: AppColor().reward_grey_bg*/
            ),
            child: Container(
              margin: EdgeInsets.only(top: 0, bottom: 5, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 220,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                tDe.teamDetailsModelR.value.gameId != null
                                    ? tDe.teamDetailsModelR.value.gameId.name
                                    : "-" ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Inter",
                                    color: AppColor().whiteColor),
                              ),
                            ),
                            Center(
                              child: Obx(
                                () => Text(
                                  tDe.teamDetailsModelR.value.teamTypeId != null
                                      ? tDe.teamDetailsModelR.value.teamTypeId
                                          .name
                                      : "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: AppColor().whiteColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              AddMemberDetailsTeam(
                                  context, tDe.teamDetailsModelR.value.id);
                            },
                            child: Obx(
                              () => Container(
                                margin: EdgeInsets.only(bottom: 0),
                                alignment: Alignment.center,
                                child: tDe.teamDetailsModelR.value.createdBy
                                            .compareTo(tDe.user_id) ==
                                        0
                                    ? tDe.teamDetailsModelR.value.teamTypeId !=
                                                null &&
                                            tDe.teamDetailsModelR.value
                                                    .teamTypeId.size >
                                                tDe.teamDetailsModelR.value
                                                    .members.length
                                        ? Container(
                                            width: 60,
                                            margin: EdgeInsets.only(
                                                left: 30, bottom: 0),
                                            padding: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 7,
                                                bottom: 7),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              "Add",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  //decoration: TextDecoration.underline,
                                                  fontSize: 13,
                                                  fontFamily: "Inter",
                                                  color: Colors.red),
                                            ),
                                          )
                                        : Container(
                                            height: 20,
                                          )
                                    : Container(
                                        height: 20,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Obx(
                            () => tDe.teamDetailsModelR.value.createdBy
                                        .compareTo(tDe.user_id) ==
                                    0
                                ? GestureDetector(
                                    onTap: () {
                                      showAlertDialogDeleteTeam(context);
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 60,
                                          margin: EdgeInsets.only(
                                              left: 30, bottom: 0, top: 0),
                                          padding: EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 7,
                                              bottom: 7),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            "Delete",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                //decoration: TextDecoration.underline,
                                                fontSize: 12,
                                                fontFamily: "Inter",
                                                color: Colors.red),
                                          ),
                                        )),
                                  )
                                : Text(""),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Obx(
                    () => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tDe.teamDetailsModelR.value.members.length,
                        itemBuilder: (context, indexM) {
                          return MemberList(context, indexM);
                        }),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 40, top: 0),
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      "assets/images/rectangle_orange_gradient_box.png"),
                ),
                //color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: AppColor().reward_card_bg)),
            child: Center(
              child: Obx(
                () => Text(
                  tDe.teamDetailsModelR.value.name.capitalize,
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
      ),
    );
  }

  MemberList(BuildContext context, int indexM) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(
                    () => tDe.teamDetailsModelR.value.members[indexM]
                                .isCaptain ==
                            true
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.5,
                            child: Center(
                                child: tDe.teamDetailsModelR.value
                                                .members[indexM].userId !=
                                            null &&
                                        tDe.teamDetailsModelR.value
                                                .members[indexM].userId.photo !=
                                            null
                                    ? CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 20.5,
                                        // height: 15,
                                        backgroundImage: NetworkImage(tDe
                                            .teamDetailsModelR
                                            .value
                                            .members[indexM]
                                            .userId
                                            .photo
                                            .url))
                                    : Image(
                                        height: 15,
                                        image:
                                            AssetImage(ImageRes().team_group),
                                      )),
                          )
                        : CircleAvatar(
                            backgroundColor: AppColor().whiteColor,
                            radius: 20,
                            child: Center(
                                child: tDe.teamDetailsModelR.value
                                                .members[indexM].userId !=
                                            null &&
                                        tDe.teamDetailsModelR.value
                                                .members[indexM].userId.photo !=
                                            null
                                    ? CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 20.5,
                                        // fit: BoxFit.fill,
                                        //height: 15,
                                        backgroundImage: NetworkImage(tDe
                                            .teamDetailsModelR
                                            .value
                                            .members[indexM]
                                            .userId
                                            .photo
                                            .url))
                                    : Image(
                                        height: 15,
                                        image:
                                            AssetImage(ImageRes().team_group),
                                      )),
                          ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          tDe.teamDetailsModelR.value.members[indexM].userId !=
                                  null
                              ? tDe.teamDetailsModelR.value.members[indexM]
                                          .userId.username.length >
                                      15
                                  ? tDe.teamDetailsModelR.value.members[indexM]
                                      .userId.username
                                      .substring(0, 15)
                                      .capitalize
                                  : tDe.teamDetailsModelR.value.members[indexM]
                                      .userId.username.capitalize
                              : "Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Inter",
                              color: AppColor().whiteColor),
                        ),
                        tDe.teamDetailsModelR.value.members[indexM].isCaptain ==
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
                  )
                ],
              ),
              Obx(
                () => tDe.teamDetailsModelR.value.members[indexM].isCaptain ==
                        true
                    ? Text("  ")
                    : Text(
                        tDe.teamDetailsModelR.value.members[indexM].status
                                .capitalize ??
                            "status",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inter",
                            color: AppColor().whiteColor),
                      ),
              ),
              Obx(
                () => tDe.teamDetailsModelR.value.members[indexM].isCaptain ==
                        true
                    ? Text(
                        "                   ",
                        textAlign: TextAlign.center,
                      )
                    : tDe.teamDetailsModelR.value.createdBy
                                .compareTo(tDe.user_id) ==
                            0
                        ? GestureDetector(
                            onTap: () {
                              showAlertDialog(context, indexM);
                            },
                            child: Text(
                              "Remove",
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
                          ),
              )
            ],
          ),
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context, int indexM) {
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
        teamManagementController.getDeleteTeamMember(
            tDe.teamDetailsModelR.value.id,
            tDe.teamDetailsModelR.value.members[indexM].id);
        Get.to(() => TeamManagementNew());
        /*    Route route = MaterialPageRoute(
            builder: (context) => TeamManagementNew());
        Navigator.pushReplacement(context, route);*/
        //   tDe.getTeamDetails(team_id);
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogDeleteTeam(BuildContext context) {
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
        tDe.getDeleteTeam(tDe.teamDetailsModelR.value.id);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Do you want to delete Team?"),
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

  /*joined contest list*/
  Widget joinedListView(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AppColor().whiteColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 12, bottom: 12),
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            width: double.infinity,
            child: Text(
              "${tDe.esportJoinedList.value.data[index].name}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontSize: 14),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(
                          DateFormat("yyyy-MM-dd").parse(
                              tDe.esportJoinedList.value.data[index].eventDate
                                  .start,
                              true),
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    '${tDe.esportJoinedList.value.data[index].eventDate.getStartTimeHHMMSS()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Map",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    tDe.esportJoinedList.value.data[index].gameMapId.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Perspective",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    tDe.esportJoinedList.value.data[index].gamePerspectiveId
                        .name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prizepool",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      Text(
                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${tDe.esportJoinedList.value.data[index].winner.prizeAmount!=null?tDe.esportJoinedList.value.data[index].winner.prizeAmount.value ~/ 100:"--"}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Type",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    tDe.esportJoinedList.value.data[index].gameModeId.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  if (tDe.esportJoinedList.value.data[index].getTotalWinner() !=
                      null) {
                    showWinningBreakupDialog(
                        context, tDe.esportJoinedList.value.data[index]);
                  }
                },
                child: Column(
                  children: [
                    Text(
                      "Winners",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().wallet_medium_grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          tDe.esportJoinedList.value.data[index]
                              .getTotalWinner(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Inter",
                              color: AppColor().colorPrimary),
                        ),
                        GestureDetector(
                          onTap: () {
                            /* if (tDe.esportJoinedList.value.data[index]
                                    .getTotalWinner() !=
                                null) {
                              showWinningBreakupDialog(context,
                                  tDe.esportJoinedList.value.data[index]);
                            }*/
                          },
                          child: Container(
                            width: 13,
                            alignment: Alignment.topCenter,
                            child: Image.asset("assets/images/arrow_down.png"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Entry Fee",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Container(
                    child:
                        tDe.esportJoinedList.value.data[index].entry.fee.value >
                                0
                            ? Text(
                                "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${tDe.esportJoinedList.value.data[index].entry.fee.value ~/ 100}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimary),
                              )
                            : Text(
                                "Free",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimary),
                              ),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 7,
          ),

          //LinearProgressIndicator

          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor().colorPrimary),
                backgroundColor: AppColor().colorGray,
                value: tDe.esportJoinedList.value.data[index].getProgresBar(),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tDe.esportJoinedList.value.data[index].getRemaningPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
                Text(
                  tDe.esportJoinedList.value.data[index].getEventJoinedPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          /*  Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor().colorPrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Room ID",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${controller.esportJoinedList.value.data[index].rounds != null && controller.esportJoinedList.value.data[index].rounds.length > 0 && controller.esportJoinedList.value.userRegistrations != null && controller.esportJoinedList.value.userRegistrations.length > 0 ? controller.esportJoinedList.value.data[index].getUserRoundRoomId(controller.esportJoinedList.value.userRegistrations) : "--"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().whiteColor),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    "assets/images/ic_copy.webp",
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: 1,
                      height: 30,
                      color: Colors.white,
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().whiteColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${controller.esportJoinedList.value.data[index].rounds != null && controller.esportJoinedList.value.data[index].rounds.length > 0 && controller.esportJoinedList.value.userRegistrations != null && controller.esportJoinedList.value.userRegistrations.length > 0 ? controller.esportJoinedList.value.data[index].getRoomName(controller.esportJoinedList.value.userRegistrations) : "--"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().whiteColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: "tyu"));
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    "assets/images/ic_copy.webp",
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Details will be shared 15 mins before the game starts",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().whiteColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),*/
          Container(
            height: 1,
            color: AppColor().colorPrimary,
            width: MediaQuery.of(context).size.width,
          ),
          GestureDetector(
            onTap: () async {
              Get.to(() => JoinedBattlesDetails(
                  tDe.esportJoinedList.value.data[index].gameId.id,
                  "",
                  tDe.esportJoinedList.value.data[index].id));
            },
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 12, top: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor().whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Text(
                "${(tDe.esportJoinedList != null && tDe.esportJoinedList.value.data != null && tDe.esportJoinedList.value.userRegistrations != null) ? "YOU WON ${ApiUrl().isPlayStore ? "" : '\u{20B9}'}" + tDe.esportJoinedList.value.data[index].getUserWinningAmount(tDe.esportJoinedList.value.userRegistrations, tDe.esportJoinedList.value.data[index].id) : "YOU WON -${ApiUrl().isPlayStore ? "" : '\u{20B9}'} 0.00"}",
                style: TextStyle(
                    color: AppColor().colorPrimary,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget joinedListViewUC(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AppColor().whiteColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 12, bottom: 12),
            decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            width: double.infinity,
            child: Text(
              "${tDe.esportJoinedListUp.value.data[index].name}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontSize: 14),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(
                          DateFormat("yyyy-MM-dd").parse(
                              tDe.esportJoinedListUp.value.data[index].eventDate
                                  .start,
                              true),
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    '${tDe.esportJoinedListUp.value.data[index].eventDate.getStartTimeHHMMSS()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Map",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    tDe.esportJoinedListUp.value.data[index].gameMapId != null
                        ? tDe
                            .esportJoinedListUp.value.data[index].gameMapId.name
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              Container(
                height: 25,
                width: 1,
                color: AppColor().colorGray,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Perspective",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    tDe.esportJoinedListUp.value.data[index].gamePerspectiveId
                        .name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            height: 1,
            color: AppColor().colorGray,
            width: double.infinity,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prizepool",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().wallet_medium_grey),
                      ),
                      Text(
                        "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${tDe.esportJoinedListUp.value.data[index].winner.prizeAmount!=null?tDe.esportJoinedListUp.value.data[index].winner.prizeAmount.value ~/ 100:"--"}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Type",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Text(
                    tDe.esportJoinedListUp.value.data[index].gameModeId.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().colorPrimary),
                  ),
                ],
              )),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Winners",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        tDe.esportJoinedListUp.value.data[index]
                            .getTotalWinner(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (tDe.esportJoinedListUp.value.data[index]
                                  .getTotalWinner() !=
                              null) {
                            showWinningBreakupDialog(context,
                                tDe.esportJoinedListUp.value.data[index]);
                          }
                        },
                        child: Container(
                          width: 13,
                          alignment: Alignment.topCenter,
                          child: Image.asset("assets/images/arrow_down.png"),
                        ),
                      )
                    ],
                  ),
                ],
              )),
              SizedBox(
                width: 1,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Entry Fee",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        color: AppColor().wallet_medium_grey),
                  ),
                  Container(
                    child: tDe.esportJoinedListUp.value.data[index].entry.fee
                                .value >
                            0
                        ? Text(
                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${tDe.esportJoinedListUp.value.data[index].entry.fee.value ~/ 100}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        : Text(
                            "Free",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          ),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 7,
          ),

          //LinearProgressIndicator

          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor().colorPrimary),
                backgroundColor: AppColor().colorGray,
                value: tDe.esportJoinedListUp.value.data[index].getProgresBar(),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tDe.esportJoinedListUp.value.data[index].getRemaningPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
                Text(
                  tDe.esportJoinedListUp.value.data[index]
                      .getEventJoinedPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),

          Container(
            height: 1,
            color: AppColor().colorPrimary,
            width: MediaQuery.of(context).size.width,
          ),
          GestureDetector(
            onTap: () async {
              Get.to(() => JoinedBattlesDetails(
                  tDe.esportJoinedListUp.value.data[index].gameId.id,
                  "",
                  tDe.esportJoinedListUp.value.data[index].id));
            },
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 12, top: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor().whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Text(
                "View Details",
                style: TextStyle(
                    color: AppColor().colorPrimary,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showWinningBreakupDialog(BuildContext context, ContestModel model) {
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "WINNING BREAKUP",
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Total Amount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${(model.winner.prizeAmount.value ~/ 100)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        color: AppColor().colorPrimary,
                      ),
                    ),
                    model.rankAmount != null && model.rankAmount.length > 0
                        ? ListView.builder(
                            itemCount: model.rankAmount.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              return winnerList(
                                  context, index, model.rankAmount);
                            })
                        : Container(
                            height: 0,
                          )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget winnerList(BuildContext context, int index, List<RankAmount> list) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${list[index].getRank()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),
                Text(
                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${list[index].amount.value ~/ 100}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            )
          ],
        ));
  }
}
