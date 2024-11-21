import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../utills/event_tracker/CleverTapController.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool menuicon;
  final bool iconnotifiction;
  final bool is_supporticon;
  final bool is_whatsappicon;
  final bool menuback;
  final bool is_wallaticon;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  //const TopBar({Key key}) : super(key: key);
  TopBar(
      {@required this.title,
      @required this.menuicon,
      @required this.menuback,
      this.iconnotifiction,
      this.is_wallaticon,
      this.is_supporticon,
      this.is_whatsappicon,
      this.child,
      this.onPressed,
      this.onTitleTapped})
      : preferredSize = Size.fromHeight(60.0);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with TickerProviderStateMixin {
  UserController userController = Get.put(UserController());
  CleverTapController cleverTapController = Get.put(CleverTapController());

  AnimationController _controller;
  Tween<double> _tween = Tween(begin: .85, end: 1.1);
  bool isAnimationActive = false;

  //bool isNormalWidget=false;

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    //_controller.repeat(reverse: false);

    //coin animation work
    /*if (AppString.isUserFTR.value == true && AppString.helperCountAnimation == 0) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        isAnimationActive = true;
        _controller.forward();
        setState(() {});
        AppString.helperCountAnimation++;
      });
    }*/

    /*Future.delayed(const Duration(milliseconds: 5500), () {
      isAnimationActive = false;
      setState(() {});
    });*/

    //_controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: 60,
            child: Container(
              padding: EdgeInsets.all(5),
              //color:AppColor().colorPrimary,
              //color: Colors.red,
              // color: AppColor().colorPrimary,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Image.asset(
                          ImageRes().drawer_icon,
                          height: 35,
                          width: 30,
                          color: AppColor().whiteColor,
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            if (!await InternetConnectionChecker()
                                .hasConnection) {
                              Fluttertoast.showToast(
                                  msg: 'INTERNET CONNECTIVITY LOST');
                              return null;
                            }
                            userController.getWalletAmount();
                            !ApiUrl().isPlayStore
                                ? userController.wallet_s.value = true
                                : userController.wallet_s.value = false;
                            //Wallet().showBottomSheetAddAmount(context);
                            if (userController.checkWallet_class_call.value) {
                              if (userController.currentIndex.value == 4) {
                                //if (!ApiUrl().isPlayStore)
                                //Wallet().showBottomSheetAddAmount(context);
                              } else {
                                userController.currentIndex.value = 4;
                              }
                            } else {
                              userController.currentIndex.value = 4;
                            }
                          },
                          child: AppString.isUserFTR == true
                              ? Row(
                                  children: [
                                    ScaleTransition(
                                      scale: _tween.animate(
                                        CurvedAnimation(
                                            parent: _controller,
                                            curve: Curves.elasticOut),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2,
                                            right: 0,
                                            left: 5,
                                            bottom: 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                                    ' ${userController.getTotalBalnace()}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColor()
                                                            .whiteColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image(
                                                    width: 13,
                                                    height: 13,
                                                    image: AssetImage(
                                                        "assets/images/bonus_coin.png")),
                                                Obx(
                                                  () => Text(
                                                    ' ${userController.getBonuseCashBalance()}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColor()
                                                            .whiteColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5),
                                      child: !ApiUrl().isPlayStore
                                          ? Image(
                                              height: 28,
                                              width: 28,
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/images/plus_new_icon.png"))
                                          : Container(),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    ScaleTransition(
                                      scale: _tween.animate(
                                        CurvedAnimation(
                                            parent: _controller,
                                            curve: Curves.elasticOut),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2,
                                            right: 0,
                                            left: 5,
                                            bottom: 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image(
                                                    width: 16,
                                                    height: 16,
                                                    image: ApiUrl().isPlayStore
                                                        ? AssetImage(
                                                            "assets/images/deposited.webp")
                                                        : AssetImage(
                                                            "assets/images/rupee_icon.png")),
                                                Obx(
                                                  () => Text(
                                                    ' ${userController.getTotalBalnace()}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColor()
                                                            .whiteColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image(
                                                    width: 16,
                                                    height: 16,
                                                    image: AssetImage(
                                                        "assets/images/bonus_coin.png")),
                                                Obx(
                                                  () => Text(
                                                    ' ${userController.getBonuseCashBalance()}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColor()
                                                            .whiteColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 1.5, right: 5),
                                      child: !ApiUrl().isPlayStore
                                          ? Image(
                                              height: 28,
                                              width: 28,
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/images/plus_new_icon.png"))
                                          : Container(),
                                    ),
                                  ],
                                )),
                    ],
                  ),
                  Center(
                    child: Container(
                        padding: EdgeInsets.only(left: 0, top: 10, right: 0),
                        alignment: Alignment.center,
                        child: Image.asset(
                            "assets/images/gmng_logo1.png" /*"assets/images/gmng_logo.png"*/,
                            fit: BoxFit.cover,
                            height: 120,
                            width: 220)),
                  ),
                ],
              ),
            )));
  }
}
