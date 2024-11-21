import 'package:device_apps/device_apps.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';

import '../../../res/AppString.dart';

class OfferWallDetail extends StatefulWidget {
  var lootBoxId;

  OfferWallDetail({this.lootBoxId});

  @override
  State<OfferWallDetail> createState() =>
      _OfferWallDetailState(lootBoxId: lootBoxId);
}

class _OfferWallDetailState extends State<OfferWallDetail>
    with WidgetsBindingObserver {
  WalletPageController walletPageController = Get.put(WalletPageController());
  UserController _userController = Get.put(UserController());
  var lootBoxId;

  //var checkbox_bool = true.obs;
  //var checkbox_bool2 = false.obs;

  _OfferWallDetailState({this.lootBoxId});

  @override
  Future<void> initState() {
    Utils().customPrint('distinctList1 above ${lootBoxId}');

    for (int i = 0;
        i < walletPageController.offerWallList.value.data.length;
        i++) {
      if (lootBoxId == walletPageController.offerWallList.value.data[i].id) {
        //Utils().customPrint('distinctList1 0 ${walletPageController.offerWallList.value.data[i].name}');
        walletPageController.selectedList =
            walletPageController.offerWallList.value.data[i];
        //Utils().customPrint('distinctList1 1 ${walletPageController.selectedList.name}');
        break;
      }
    }

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.black,
        title: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 60),
          child: Text(
              "${walletPageController.selectedList.name}"), //and Promotions
        )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        //color: AppColor().reward_card_bg,
                        border: Border.all(
                          width: 1,
                          color: AppColor().whiteColor,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: walletPageController.selectedList.logoUrl !=
                                  null &&
                              walletPageController.selectedList.logoUrl != ''
                          ? Image(
                              //color: AppColor().whiteColor,
                              width: 80,
                              height: 80,
                              //fit: BoxFit.cover,
                              image: NetworkImage(
                                  walletPageController.selectedList.logoUrl))
                          : Image(
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/netflix.png'),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 0),
                        child: Text(
                          "${walletPageController.selectedList.name}",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: AppColor().whiteColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 5),
                        child: Text(
                          '${walletPageController.selectedList.description}',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                height: 70,
                width: 120,
                decoration: BoxDecoration(
                    color: AppColor().reward_card_bg,
                    border: Border.all(
                      width: 1,
                      color: AppColor().reward_grey_bg,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Earnings",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          color: AppColor().whiteColor),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5, left: 5),
                              child: Image.asset(
                                "assets/images/bonus_coin.png",
                                width: 20,
                                height: 20,
                                //color: Colors.blue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 5),
                              child: Text(
                                " \u{20B9}${(walletPageController.selectedList.userEarning.value / 100).toStringAsFixed(0)}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w600,
                                    color: AppColor().whiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
            child: Container(
              //height: 70,
              //width: 120,
              decoration: BoxDecoration(
                  color: AppColor().reward_card_bg,
                  border: Border.all(
                    width: 1,
                    color: AppColor().reward_grey_bg,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Steps",
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                              color: AppColor().whiteColor),
                        ),
                        Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                width: 1,
                                color: AppColor().whiteColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 5, bottom: 5),
                                  child: Image.asset(
                                    "assets/images/bonus_coin.png",
                                    width: 20,
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, top: 5, bottom: 5),
                                  child: Text(
                                    " \u{20B9}${(walletPageController.selectedList.userEarning.value / 100).toStringAsFixed(0)}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        color: AppColor().whiteColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
                    child: Html(
                      data: walletPageController.selectedList.details,
                      /* onLinkTap: (url, _, __, ___) {
                           Utils().customPrint("Opening $url");
                          makeLaunch(url!);
                        },*/
                      style: {
                        "body": Style(
                            fontSize: FontSize(13.0),
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontStyle: FontStyle.normal),
                        'h1': Style(
                          color: Colors.white,
                          textAlign: TextAlign.left,
                        ),
                        'p': Style(
                            textAlign: TextAlign.left,
                            color: Colors.white,
                            alignment: Alignment.topLeft,
                            fontSize: FontSize.small),
                        'ul': Style(
                          color: Colors.white,
                          textAlign: TextAlign
                              .left, /*margin:  EdgeInsets.only(left: 10)*/
                        )
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
            child: Container(
              //height: 70,
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: AppColor().reward_card_bg,
                  border: Border.all(
                    width: 1,
                    color: AppColor().reward_grey_bg,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Important",
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            color: AppColor().whiteColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "If You have installed the app before You won’t get the rewards.",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: AppColor().whiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isTrue(),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
              child: Container(
                //height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColor().reward_card_bg,
                    border: Border.all(
                      width: 1,
                      color: AppColor().reward_grey_bg,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Progress Started",
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                              color: AppColor().whiteColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                        width: 2.0, color: Colors.white),
                                  ),
                                  onChanged: (value) {
                                    //print(value);
                                    //checkbox_bool.value = value;
                                    //Utils().customPrint('checkbox_bool 1 ${checkbox_bool}');
                                  },
                                  value: true,
                                ),
                                Text(
                                  'Click on Install Button',
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                        width: 2.0, color: Colors.white),
                                  ),
                                  onChanged: (value) {
                                    print(value);
                                    //checkbox_bool2.value = value;
                                    //Utils().customPrint('checkbox_bool 1 ${checkbox_bool2}');
                                  },
                                  value: false, //checkbox_bool2.value,
                                ),
                                Text(
                                  'Install and open the application',
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        elevation: 0,
        child: GestureDetector(
          onTap: () async {
            Map<String, Object> map = new Map<String, Object>();
            map["offer_name"] = walletPageController.selectedList.name;
            map["offer_clicked"] = "Yes";
            map["USER_ID"] = walletPageController.user_id;
            map["deviceId"] = await Utils().getUniqueDeviceId();
            try {
              if (walletPageController.selectedList.gmngEarning != null &&
                  walletPageController.selectedList.gmngEarning.value != null &&
                  walletPageController.selectedList.gmngEarning.value != '') {
                int amt = walletPageController.selectedList.gmngEarning.value;
                map["offer_gmngEarning"] = amt / 100;
              }
              if (walletPageController.selectedList.userEarning != null &&
                  walletPageController.selectedList.userEarning.value != null &&
                  walletPageController.selectedList.userEarning.value != '') {
                int amt = walletPageController.selectedList.userEarning.value;
                map["offer_userEarning"] = amt / 100;
              }
            } catch (e) {}
            //appsflyer
            AppsflyerController c = Get.put(AppsflyerController());
            c.logEventAf(EventConstant.EVENT_Offerwall, map);
            //clevertap
            CleverTapController cleverTapController =
                Get.put(CleverTapController());
            cleverTapController.logEventCT(EventConstant.EVENT_Offerwall, map);
            //end

            //app checking insalled or not
            String appInstalled = "false";
            if (walletPageController.selectedList.appPackage != null &&
                walletPageController.selectedList.appPackage.android != null) {
              Utils().customPrint(
                  "open App: ${await findAppByPkgName("${walletPageController.selectedList.appPackage.android}")}");
              appInstalled = await findAppByPkgName(
                  "${walletPageController.selectedList.appPackage.android}");
            }

            final param = {
              "advertiserDealId": "${walletPageController.selectedList.id}",
              "appInstalled": appInstalled,
              "deviceId": await Utils().getUniqueDeviceId()
            };
            //return;

            await walletPageController.createUserDeal(context, param);
            await _userController.getWalletAmount();
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 50, right: 50),
            child: Container(
              width: 280,
              height: 55,
              margin: EdgeInsets.only(right: 10),
              /*  padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 15),*/
              decoration: BoxDecoration(
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
                border: Border.all(color: AppColor().whiteColor, width: 2),
                borderRadius: BorderRadius.circular(20),
                // color: AppColor().whiteColor
              ),
              alignment: Alignment.center,
              child: Text(
                "INSTALL",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("get notification done ");
    //Utils().customPrint("didChangeAppLifecycleState UnityListS1 ===================================================");
    if (state == AppLifecycleState.resumed) {
      Utils().customPrint(
          "didChangeAppLifecycleState  UnityListS2   ===================================================");
      //WalletPageController walletPageController = Get.put(WalletPageController());
      await walletPageController.getAdvertisersDeals();
      //isTrue();
      Utils().customPrint('distinctList1 below ${lootBoxId}');
      for (int i = 0;
          i < walletPageController.offerWallList.value.data.length;
          i++) {
        if (lootBoxId == walletPageController.offerWallList.value.data[i].id) {
          //Utils().customPrint('distinctList1 0 ${walletPageController.offerWallList.value.data[i].name}');
          walletPageController.selectedList =
              walletPageController.offerWallList.value.data[i];
          // Utils().customPrint('distinctList1 1 ${walletPageController.selectedList.name}');
          setState(() {});
          break;
        }
      }
    }
  }

  bool isTrue() {
    bool tmpBool = false;
    walletPageController.selectedList.userDeal != null &&
            walletPageController.subtractDate((DateTime.parse(
                    "${walletPageController.selectedList.userDeal.expireDate}"))) >
                0
        ? tmpBool = true
        : tmpBool = false;
    return tmpBool;
  }

  findAppByPkgName(String pkgName) async {
    try {
      bool isInstalled = await DeviceApps.isAppInstalled(pkgName);
      if (isInstalled) {
        Utils().customPrint('open App...IF');
        return "true";
      } else {
        Utils().customPrint('open App...ELSE');
        return "false";
      }
    } catch (e) {
      Utils().customPrint('open App...E');
      return "false";
    }
  }
}
