import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/HomePageController.dart';
import 'package:gmng/ui/controller/ProfileController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/profile/EditProfile.dart';
import 'package:gmng/ui/main/team_management/TeamManagementNew.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/ESportsEventList.dart';
import '../../../preferences/UserPreferences.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppString.dart';
import '../../../webservices/ApiUrl.dart';
import '../../login/Login.dart';
import '../esports/JoinedBattlesDetails.dart';

Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class Profile extends StatelessWidget {
  var userPreferences;
  String gameid;
  Profile(this.gameid, {Key key}) : super(key: key);

  ProfileController controller = Get.put(ProfileController());
  HomePageController home_Controller = Get.put(HomePageController());
  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    userPreferences = new UserPreferences(context);

    controller.getJoinedContestList(gameid);
    //  userController.callAllProfileData();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/store_back.png"))),
      /*  decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/profile_bottom_new.webp"))),*/
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                showLogoutDailogBox1(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                height: 22,
                width: 22,
                child: Image(
                  color: Colors.white,
                  image: AssetImage(ImageRes().ic_logout),
                ),
              ),
            )
          ],
          elevation: 0.0,
          centerTitle: true,
          flexibleSpace: Image(
            image: AssetImage('assets/images/store_top.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          title: Text(
            'profile'.tr,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 15),
                        padding: EdgeInsets.all(5),
                        width: double.infinity,
                        //  height: 250,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    ImageRes().leader_board_rank_back)),
                            borderRadius: BorderRadius.circular(15)),

                        height: 225,

                        /* margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 10,
                            top: 5),*/ // width: double.infinity,
                        /*   decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image:AssetImage(
                                   ImageRes().leader_board_rank_back)
                             */ /* AssetImage(
                                    "assets/images/profile_top.webp")*/ /*)),*/
                      ),
                      /* Container(
                        //constraints: BoxConstraints.expand(), //
                        height: MediaQuery.of(context).size.height - 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    "assets/images/profile_bottom_new.webp"))),
                      ),*/
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(10, 257, 10, 0),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 2, sigmaX: 5),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                                colors: [Colors.white30, Colors.white30]),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 0,
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "GAMES PLAYED".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Inter",
                                        color: AppColor().whiteColor),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Text(
                                    "${userController.getUserSemmaryV != null ? userController.getUserSemmaryV["join"] : '0'}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Inter",
                                        color: AppColor().whiteColor),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                ],
                              )),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.only(
                                    top: 3, left: 10, right: 10, bottom: 8),
                                color: AppColor().reward_card_bg,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Text(
                                        "GAMES WON".tr,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Inter",
                                            color: AppColor().whiteColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "${userController.getUserSemmaryV != null ? userController.getUserSemmaryV["win"] : '0'}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Inter",
                                          color: AppColor().whiteColor),
                                    )
                                  ],
                                ),
                              )),
                              Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    "CASH WON".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Inter",
                                        color: AppColor().whiteColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${userController.getUserSemmaryV != null ? userController.getUserSemmaryV["cashWon"]['value'] ~/ 100 : '0'}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Inter",
                                        color: AppColor().whiteColor),
                                  )
                                ],
                              )),
                              SizedBox(
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    children: [
                      Container(
                        height: 70,
                      ),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColor().colorPrimary,
                              radius: MediaQuery.of(context).size.height / 15,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius:
                                    MediaQuery.of(context).size.height / 15.5,
                                child: Obx(
                                  () => userController.profileDataRes.value !=
                                              null &&
                                          userController
                                                  .profileDataRes.value.photo !=
                                              null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(52),
                                          ),
                                          child: CachedNetworkImage(
                                            height: 107,
                                            width: 107,
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                ("${userController.profileDataRes.value.photo.url}"),
                                            /*height: 20,
                                            width: 20*/
                                          ),
                                        )
                                      : Center(
                                          child: Image(
                                          height: 30,
                                          image:
                                              AssetImage(ImageRes().team_group),
                                        )),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12.5,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  //                     EditProfileController().getProfileData();
                                  Get.to(() => EditProfile());
                                },
                                child: CircleAvatar(
                                  backgroundColor: AppColor().colorPrimary,
                                  radius: 12.5,
                                  child: Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 2,
                      ),
                      Obx(() => Container(
                          margin: EdgeInsets.fromLTRB(0, 158, 0, 0),
                          child: (controller.esportJoinedList != null &&
                                  controller.esportJoinedList.value != null &&
                                  controller.esportJoinedList.value.data !=
                                      null)
                              ? controller.esportJoinedList.value.data.length >
                                      0
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: ListView.builder(
                                          itemCount: controller.esportJoinedList
                                              .value.data.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return joinedListView(
                                                context, index);
                                          }),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .61,
                                      child: Center(
                                        child: Text(
                                          "No items are available Please Come back later"
                                              .tr,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                              : Container(
                                  child: Center(
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
                                    ),
                                  ),
                                ))),

                      /*team management code comment */
                      /* Center(
                        child: Wrap(
                          children: [
                            Obx(
                              () => userController.profileDataRes.value != null
                                  ? Column(
                                      children: [
                                        Text(
                                          "${userController.profileDataRes.value.username != null ? userController.profileDataRes.value.username : ""}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: "Inter",
                                              color: AppColor().whiteColor),
                                        ),
                                        Text(
                                          "${userController.profileDataRes.value.mobile.getFullNumber()}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Inter",
                                              color: AppColor().colorGray),
                                        )
                                      ],
                                    )
                                  : Text(""),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 135, 0, 0),
                      ),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15,left: 20,),
                            child: Text(
                              "Team \nManagement",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Inter",
                                  color: AppColor().whiteColor),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                        child: Text(
                                          "Create",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Roboto",
                                              color: AppColor().whiteColor),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Text(
                                          "Team",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Roboto",
                                              color: AppColor().whiteColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showCustomDialog(context);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: AppColor().whiteColor,
                                    radius: 25,
                                    child: CircleAvatar(
                                      backgroundColor: AppColor().reward_card_bg,
                                      radius: 24,
                                      child: Center(
                                          child: Image.asset(
                                            "assets/images/ic_create_tem_upload.webp",
                                            color: Colors.white,
                                            height: 20,
                                          )),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ),
                          */ /*SizedBox(
                            width: 10,
                          ),*/ /*

                        ],
                      ),
                      Container(height: 25,),
                      Obx(
                        () => Container(
                          child: controller.teamGetModel.value != null
                              ? Obx(
                                  () =>controller.teamGetModel.value.data!=null? GridView.count(
                                      crossAxisCount: 3,
                                      shrinkWrap: true,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 8.0,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: List.generate(
                                          controller.teamGetModel.value.data
                                              .length, (index) {
                                        return Obx(
                                            () => listGameName(context, index));
                                      })):Container(
                                    height: 0,
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.topCenter,
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                        ),
                      ),*/
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
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
            height: 450,
            child: Card(
              color: AppColor().wallet_dark_grey,
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
                  CircleAvatar(
                    backgroundColor: AppColor().whiteColor,
                    radius: 40,
                    child: CircleAvatar(
                      backgroundColor: AppColor().colorGray,
                      radius: 39,
                      child: Center(
                          child: Image.asset(
                        "assets/images/ic_create_tem_upload.webp",
                        color: Colors.white,
                        height: 30,
                      )),
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
                  spinnerShowSec(),
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
                  spinnerShow(),
                  SizedBox(
                    height: 15,
                  ),
                  _Button(context),
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
      /* transitionBuilder: (_, anim, __, child) {
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
      },*/
    );
  }

  Widget _Button(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*     Navigator.pop(context);
        showProgress(context, "", true);
        var mapD = controller.getTeamCreate(
            controller.teamTypeId.value, controller.gameId.value);
        hideProgress(context);
        if (mapD != null) {
          //  Fluttertoast.showToast(msg: mapD.toString());

        } else {
          Fluttertoast.showToast(msg: "some error");
        }*/
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
              "Create",
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

  spinnerShow() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 1),
      child: Obx(
        () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor().whiteColor, width: 1),
            ),
            child: controller.teamTypeModelR.value.data.length > 1
                ? DropdownButton<String>(
                    isExpanded: true,
                    icon: Container(
                      margin: EdgeInsets.only(right: 5),
                      width: 13,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/arrow_down.png",
                        color: Colors.white,
                      ),
                    ),
                    dropdownColor: AppColor().colorGray,
                    onChanged: (String value) {
                      controller.selectedValue.value = value;
                      for (var i in controller.teamTypeModelR.value.data) {
                        if (i.name == value) {
                          controller.teamTypeId.value = i.id;
                        }
                      }
                    },
                    underline: const SizedBox(),
                    hint: Text(
                      "Select Game",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    value: controller.selectedValue.value == ""
                        ? null
                        : controller.selectedValue.value,
                    items: controller.teamTypeModelR.value.data.map((value) {
                      return DropdownMenuItem(
                        value: value.name,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : DropdownButton(
                    underline: const SizedBox(),
                    isExpanded: true,
                    value: controller.selectedValue2.value,
                    dropdownColor: AppColor().colorPrimary,
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Select Game",
                          style: TextStyle(color: Colors.white),
                        ),
                        value: "0",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Single",
                          style: TextStyle(color: Colors.white),
                        ),
                        value: "1",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Duo",
                          style: TextStyle(color: Colors.white),
                        ),
                        value: "2",
                      ),
                    ],
                    onChanged: (value11) {
                      controller.selectedValue2.value = value11;
                    })),
      ),
    );
  }

  spinnerShowSec() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 1),
      child: Obx(
        () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor().whiteColor, width: 1),
            ),
            child: home_Controller.esports_model_v.value.data.length > 1
                ? DropdownButton<String>(
                    isExpanded: true,
                    icon: Container(
                      margin: EdgeInsets.only(right: 5),
                      width: 13,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/arrow_down.png",
                        color: Colors.white,
                      ),
                    ),
                    dropdownColor: AppColor().colorGray,
                    onChanged: (String value) {
                      controller.selectedValueGame.value = value;
                      for (var i
                          in home_Controller.esports_model_v.value.data) {
                        if (i.name == value) {
                          controller.gameId.value = i.id;

                          // Fluttertoast.showToast(msg: controller.gameId.value);
                        }
                      }
                    },
                    underline: const SizedBox(),
                    hint: Text(
                      "Select Game",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: controller.selectedValueGame.value == ""
                        ? null
                        : controller.selectedValueGame.value,
                    items:
                        home_Controller.esports_model_v.value.data.map((value) {
                      return DropdownMenuItem(
                        value: value.name,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Roboto",
                                color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : DropdownButton(
                    underline: const SizedBox(),
                    isExpanded: true,
                    value: controller.selectedValue2.value,
                    dropdownColor: AppColor().colorPrimary,
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Select Game",
                          style: TextStyle(color: Colors.white),
                        ),
                        value: "0",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Single",
                          style: TextStyle(color: Colors.white),
                        ),
                        value: "1",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "duo",
                          style: TextStyle(color: Colors.white),
                        ),
                        value: "2",
                      ),
                    ],
                    onChanged: (value11) {
                      controller.selectedValue2.value = value11;
                    })),
      ),
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
              "${controller.esportJoinedList.value.data[index].name}",
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
                              controller.esportJoinedList.value.data[index]
                                  .eventDate.start,
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
                    '${controller.esportJoinedList.value.data[index].eventDate.getStartTimeHHMMSS()}',
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
                    controller.esportJoinedList.value.data[index].gameMapId !=
                                null &&
                            controller.esportJoinedList.value.data[index]
                                    .gameMapId.name !=
                                null
                        ? controller
                            .esportJoinedList.value.data[index].gameMapId.name
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
                    controller.esportJoinedList.value.data[index]
                                    .gamePerspectiveId !=
                                null &&
                            controller.esportJoinedList.value.data[index]
                                    .gamePerspectiveId.name !=
                                null
                        ? controller.esportJoinedList.value.data[index]
                            .gamePerspectiveId.name
                        : "",
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
                      controller.esportJoinedList.value.data[index].winner
                                      .customPrize !=
                                  null &&
                              controller.esportJoinedList.value.data[index]
                                  .winner.customPrize.isNotEmpty
                          ? Text(
                              "${controller.esportJoinedList.value.data[index].winner.customPrize}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            )
                          : controller.esportJoinedList.value.data[index].winner
                                          .prizeAmount !=
                                      null &&
                                  controller.esportJoinedList.value.data[index]
                                          .winner.prizeAmount.type
                                          .compareTo("bonus") ==
                                      0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Container(
                                        height: 20,
                                        child: Image.asset(ImageRes().ic_coin),
                                      ),
                                      Text(
                                        "${controller.esportJoinedList.value.data[index].winner.prizeAmount != null ? controller.esportJoinedList.value.data[index].winner.prizeAmount.value : "-"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: AppColor().colorPrimary),
                                      )
                                    ])
                              : Text(
                                  "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportJoinedList.value.data[index].winner.prizeAmount != null ? controller.esportJoinedList.value.data[index].winner.prizeAmount.value ~/ 100 : "-"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: AppColor().colorPrimary),
                                ),

                      /*      Text(
                        "${ApiUrl().isPlayStore?"":'\u{20B9}'} ${controller.esportJoinedList.value.data[index].winner.prizeAmount!=null?controller.esportJoinedList.value.data[index].winner.prizeAmount.value~/ 100:"--"}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),*/
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
                    controller.esportJoinedList.value.data[index].gameModeId !=
                                null &&
                            controller.esportJoinedList.value.data[index]
                                    .gameModeId.name !=
                                null
                        ? controller
                            .esportJoinedList.value.data[index].gameModeId.name
                        : "",
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
                    "${controller.esportJoinedList.value.data[index].winner.isKillType() ? "Per Kill" : "Winners"}",
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
                        "${!controller.esportJoinedList.value.data[index].winner.isKillType() ? controller.esportJoinedList.value.data[index].getTotalWinner() : controller.esportJoinedList.value.data[index].winner.perKillAmount.value ~/ 100}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller.esportJoinedList.value.data[index]
                                  .getTotalWinner() !=
                              null) {
                            showWinningBreakupDialog(context,
                                controller.esportJoinedList.value.data[index]);
                          }
                        },
                        child: Container(
                          width: 13,
                          alignment: Alignment.topCenter,
                          child: !controller
                                  .esportJoinedList.value.data[index].winner
                                  .isKillType()
                              ? Image.asset("assets/images/arrow_down.png")
                              : Container(),
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
                    child: controller.esportJoinedList.value.data[index].entry
                                .fee.value >
                            0
                        ? Text(
                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${controller.esportJoinedList.value.data[index].entry.fee.value ~/ 100}",
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
                value: controller.esportJoinedList.value.data[index]
                    .getProgresBar(),
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
                  controller.esportJoinedList.value.data[index]
                      .getRemaningPlayer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: AppColor().wallet_medium_grey),
                ),
                Text(
                  controller.esportJoinedList.value.data[index]
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
            height: 2,
            color: AppColor().colorPrimary,
            width: MediaQuery.of(context).size.width,
          ),
          GestureDetector(
            onTap: () async {
              Get.to(() => JoinedBattlesDetails(
                  controller.esportJoinedList.value.data[index].gameId.id,
                  "",
                  controller.esportJoinedList.value.data[index].id));
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
                "${(controller.esportJoinedList != null && controller.esportJoinedList.value.data != null && controller.esportJoinedList.value.userRegistrations != null) ? "YOU WON ${ApiUrl().isPlayStore ? "" : '\u{20B9}'}" + controller.esportJoinedList.value.data[index].getUserWinningAmount(controller.esportJoinedList.value.userRegistrations, controller.esportJoinedList.value.data[index].id) : "YOU WON -${ApiUrl().isPlayStore ? "" : '\u{20B9}'} 0.00"}",
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
                    model.winner.customPrize != null &&
                            model.winner.customPrize.isNotEmpty
                        ? Text(
                            "${model.winner.customPrize}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          )
                        : model.winner.prizeAmount != null &&
                                model.winner.prizeAmount.type
                                        .compareTo("bonus") ==
                                    0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Container(
                                      height: 20,
                                      child: Image.asset(ImageRes().ic_coin),
                                    ),
                                    Text(
                                      "${model.winner.prizeAmount != null ? model.winner.prizeAmount.value : "-"}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          color: AppColor().colorPrimary),
                                    )
                                  ])
                            : Text(
                                "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${model.winner.prizeAmount != null ? model.winner.prizeAmount.value ~/ 100 : "-"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: AppColor().colorPrimary),
                              ),

                    /*  Text(
                      "${ApiUrl().isPlayStore?"":'\u{20B9}'} ${(model.winner.prizeAmount!=null?model.winner.prizeAmount.value~/ 100:"--")}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        color: AppColor().colorPrimary,
                      ),
                    ),*/
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
                list[index].custom != null && list[index].custom.isNotEmpty
                    ? Text(
                        "${list[index].custom}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      )
                    : list[index].amount != null &&
                            list[index].amount.type.compareTo("bonus") == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Container(
                                  height: 20,
                                  child: Image.asset(ImageRes().ic_coin),
                                ),
                                Text(
                                  "${list[index].amount != null ? list[index].amount.value : "-"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: AppColor().colorPrimary),
                                )
                              ])
                        : Text(
                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${list[index].amount.value ~/ 100}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),

                /* Text(
                  "${ApiUrl().isPlayStore?"":'\u{20B9}'} ${list[index].amount!=null?list[index].amount.value~/ 100:"--"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),*/
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

  Widget listGameName(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => TeamManagementNew());
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: AppColor().colorPrimary,
              radius: 40,
              child: CircleAvatar(
                backgroundColor: AppColor().whiteColor,
                radius: 39,
                child: Image(
                    image: AssetImage('assets/images/circle_game.png'),
                    height: 40,
                    width: 40),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                controller.teamGetModel.value.data[index].name,
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
                controller.teamGetModel.value.data[index].gameId.name,
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
                controller.teamGetModel.value.data[index].teamTypeId.name,
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

  //old logout pop-up
  showLogoutDailogBox(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "No".tr,
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes".tr),
      onPressed: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        userPreferences.removeValues();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Login(),
          ),
          (route) => false,
        );
        //  Get.off(() => Login());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "txt_logout".tr,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
      ),
      content: Text("txt_are_you_sure_logout".tr),
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

  //new logout pop-up
  void showLogoutDailogBox1(BuildContext context) {
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
            height: 200,
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
                          "txt_logout".tr.toUpperCase(),
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "txt_are_you_sure_logout".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            color: AppColor().colorPrimary),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(ImageRes().button_bg)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("No".tr,
                                  style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    fontFamily: "Montserrat",
                                  )),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            //Navigator.of(context).pop();
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.remove('token');
                            await preferences.remove('user_id');
                            await preferences.clear();
                            userPreferences.removeValues();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Login(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(ImageRes().button_bg)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Yes".tr,
                                  style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    fontFamily: "Montserrat",
                                  )),
                            ),
                          ),
                        ),
                      ],
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
