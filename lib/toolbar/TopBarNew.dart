import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../res/AppColor.dart';
import '../res/AppString.dart';
import '../res/ImageRes.dart';
import '../ui/controller/user_controller.dart';
import '../ui/main/dashbord/DashBord.dart';
import '../utills/event_tracker/CleverTapController.dart';
import '../webservices/ApiUrl.dart';

class topBarSec extends StatefulWidget {
  @override
  State<topBarSec> createState() => _topBarSecState();
}

class _topBarSecState extends State<topBarSec> {
  UserController userController = Get.put(UserController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  //AnimationController _controller;
  //Tween<double> _tween = Tween(begin: .85, end: 1.1);
  bool isAnimationActive = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            if (!await InternetConnectionChecker().hasConnection) {
              Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
              return null;
            }
            print("call here data values");
            scaffoldKey.currentState.openDrawer();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 0),
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  height: 51,
                  width: 51,
                  child: Obx(
                    () => userController.profileDataRes.value != null &&
                            userController.profileDataRes.value.photo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(51),
                            ),
                            child: CachedNetworkImage(
                              height: 50,
                              width: 50,
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
                            image: AssetImage(ImageRes().team_group),
                          )),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => userController.profileDataRes.value != null
                        ? Text(
                            "${userController.profileDataRes.value.username != null ? userController.profileDataRes.value.username : ""}"
                                .capitalize,
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.none,
                                height: 0,
                                fontWeight: FontWeight.w900,
                                fontFamily: "Montserrat",
                                color: AppColor().whiteColor),
                          )
                        : Text(
                            "Name".tr,
                            style: TextStyle(
                                fontSize: 15,
                                height: 0,
                                fontWeight: FontWeight.w900,
                                fontFamily: "Montserrat",
                                decoration: TextDecoration.none,
                                color: AppColor().whiteColor),
                          ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 1, right: 8, bottom: 2, top: 2),
                    child: Row(
                      children: [
                        Obx(
                          () => userController.profileDataRes.value != null &&
                                  userController.profileDataRes.value.level !=
                                      null
                              ? Row(
                                  children: [
                                    Text(
                                      "VIP Level".tr +
                                          "  ${userController.profileDataRes.value.level.value}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Montserrat",
                                          color: AppColor().whiteColor),
                                    ),

                                    /*  SmoothStarRating(
                                    rating: userController
                                        .profileDataRes
                                        .value
                                        .level
                                        .value
                                        .toDouble(),
                                    size: 16.5,
                                    isReadOnly: true,
                                    filledIconData:
                                    Icons.star,
                                    halfFilledIconData:
                                    Icons.star_half,
                                    defaultIconData:
                                    Icons.star_border,
                                    starCount: userController
                                        .profileDataRes
                                        .value
                                        .level
                                        .value,
                                    allowHalfRating: false,
                                    onRated: (v) async {
                                      //      rating = v;
                                      print(
                                          "get rested values $v ");
                                    },
                                    spacing: 1.5,
                                  )*/
                                  ],
                                )
                              : Text(
                                  "VIP Level".tr + " 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                ),
                        ),
                      ],
                    ),
                    /*   decoration: BoxDecoration(
                      color: AppColor().colorAccentDark,
                      borderRadius: BorderRadius.circular(5),
                      // color: AppColor().whiteColor
                    ),*/
                  ),
                ],
              )
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            if (!await InternetConnectionChecker().hasConnection) {
              Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
              return null;
            }
            userController.currentIndex.value = 4;
            Get.offAll(() => DashBord(4, ""));
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 4, top: 4),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    "${AppString().txt_currency_symbole} ${(userController.winning_bal / 100 + userController.deposit_bal / 100).toPrecision(2).toString()}", //${userController.getTotalBalnace()} ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.none,
                        fontFamily: "Inter",
                        height: 0,
                        fontWeight: FontWeight.w700,
                        color: AppColor().whiteColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    " +",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w800,
                        height: 0,
                        fontFamily: "Montserrat",
                        color: AppColor().whiteColor),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: AppColor().greenDark,
              borderRadius: BorderRadius.circular(7),
              // color: AppColor().whiteColor
            ),
          ),
        ),
      ],
    );
  }
}
