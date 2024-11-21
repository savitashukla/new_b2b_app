import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_unique_device_id/flutter_unique_device_id.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmng/model/BannerModel/BannerResC.dart';
import 'package:gmng/model/CountryRestrictions.dart';
import 'package:gmng/model/LoginModel/hash_rummy.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/common/Progessbar.dart';
import 'package:gmng/ui/controller/HomePageController.dart';
import 'package:gmng/ui/controller/Pocket52_Controller.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/dialog/helperProgressBar.dart';
import 'package:gmng/ui/main/GameZop/GameZopList.dart';
import 'package:gmng/ui/main/UnitEventList/UnityList.dart';
import 'package:gmng/ui/main/cash_free/CashFreeScreen.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/ui/main/esports/ESports.dart';
import 'package:gmng/ui/main/how_to_pay_rummy.dart';
import 'package:gmng/ui/main/myteam11_ballabazzi/MyTeam11_Ballbazi_Controller.dart';
import 'package:gmng/ui/main/reward/Rewards.dart';
import 'package:gmng/ui/main/wallet/OfferWallScreen.dart';
import 'package:gmng/utills/OnlyOff.dart';
import 'package:gmng/utills/bridge.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:gmng/webservices/WebServicesHelper.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*
import 'package:social_share/social_share.dart';
*/
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

import '../app.dart';
import '../model/HomeModel/HomePageListModel.dart';
import '../ui/main/freakx/FreakxList.dart';
import 'event_tracker/AppsFlyerController.dart';
import 'event_tracker/EventConstant.dart';

class Utils {
  static ProgessDialog progessbar;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var permission;
  var addressLine1 = "".obs;
  var addressLine2 = "".obs;
  static var permissionAlow = false;
  List<Placemark> placeMarks = [];
  static var language = "en".obs;
  static var language_country = "US".obs;
  static var stateV = "".obs;
  static var city = "".obs;
  static var country = "".obs;
  static var permission_deniedCount = 0.obs;
  static var permission_denied = false.obs;

  var currentIndexSlider = 0.obs;

  int countAffi = 0;

  var appBtnBgColor = const Color(0xFFc23705).obs;
  var appBtnTxtColor = const Color(0xffFFFFFF).obs;

  static showCustomTosst(String messgae) {
    Fluttertoast.showToast(
        msg: messgae,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: AppColor().blackColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  int daysBetween(DateTime today_pref, DateTime tomm_cale) {
    today_pref = DateTime(today_pref.year, today_pref.month, today_pref.day);
    tomm_cale = DateTime(tomm_cale.year, tomm_cale.month, tomm_cale.day);
    return (today_pref.difference(tomm_cale).inDays);
  }

  showErrorMessage(String title, String message) {
    Get.snackbar(
      "",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      borderRadius: 1,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      isDismissible: true,
      forwardAnimationCurve: Curves.linear,
    );
  }

  getCurrentdateString() {
    final now = DateTime.now().toUtc();
    String dateS = now.toIso8601String().toString();
    return dateS;
  }

  funShare(String ref_code) async {
    try {
      await Share.share(
          "Bro Mere link se GMNG app download kar https://gmng.onelink.me/GRb6/refer Hum dono ko 10-10 rs cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${ref_code}");
    } catch (e) {
      return null;
    }
  }

  funShareS(String ref_code) async {
    try {
      await Share.share(ref_code);
    } catch (e) {
      return null;
    }
  }

  shareTelegram(String ref_code) async {
    try {
      //SocialShare.shareTelegram(ref_code);
    } catch (e) {
      return null;
    }
  }

/*  launchInstagram() async {
    const nativeUrl = "instagram://user?username=severinas_app";
    const webUrl = "https://www.instagram.com/severinas_app/";
    if (await canLaunch(nativeUrl)) {
      await launch(nativeUrl);
    } else if (await canLaunch(webUrl)) {
      await launch(webUrl);
    } else {
    Utils().customPrint("can't open Instagram");
    }
  }*/
  shareInstagram(String ref_code) async {
    try {
      //   SocialShare.shareInstagramStory(ref_code);
    } catch (e) {
      Fluttertoast.showToast(msg: "not  installed");
      return null;
    }
  }

  funClan(String ref_code) async {
    try {
      await Share.share(ref_code);
    } catch (e) {
      return null;
    }
  }

  static showCustomTosstError(String messgae) {
    Fluttertoast.showToast(
        msg: messgae,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: AppColor().colorPrimary,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showProgessBar(BuildContext buildContext) {
    if (progessbar == null) {
      progessbar = new ProgessDialog(buildContext);
    }

    progessbar.setMessage("please wait ..");
    progessbar.show();
  }

  static hideProgessBar() {
    if (progessbar == null) return;
    progessbar.hide();
  }

  String genrateBasicAuth(String username, String password) {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return basicAuth;
  }

  static launchURLApp(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showDialogCustom(String title, String message) {
    Get.defaultDialog(
        title: "Welcome to Flutter Dev'S",
        middleText:
            "FlutterDevs is a protruding flutter app development company with "
            "an extensive in-house team of 30+ seasoned professionals who know "
            "exactly what you need to strengthen your business across various dimensions",
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.black),
        middleTextStyle: TextStyle(color: Colors.black),
        radius: 30);
  }

  String getStartTimeHHMMSS(String time) {
    return DateFormat(
            "yyyy-MM-dd'T'HH:mm:ss") //here we can change format as we want
        .format(DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(time, true).toLocal());
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);


      latitude.value = position.latitude;
      longitude.value = position.longitude;
      placeMarks = await placemarkFromCoordinates(
          latitude.value, longitude.value,
          localeIdentifier: "en");
      country.value = placeMarks[0].country;
      stateV.value = placeMarks[0].administrativeArea;
      city.value = placeMarks[0].subAdministrativeArea;
      Utils().customPrint("Sate call ${stateV.value}");
      addressLine1.value = "${placeMarks[0].name}";
      addressLine2.value =
          "${placeMarks[0].subLocality}, ${placeMarks[0].locality}";

      //State Saving In CleverTap & Appsflyers
      CleverTapController cleverTapController = Get.put(CleverTapController());
      AppsflyerController appsflyerController = Get.put(AppsflyerController());
      if (stateV.value != null && stateV.value != '') {
        Map<String, Object> map = new Map<String, Object>();
        map["stateV"] = stateV.value;
        cleverTapController.logEventCT(EventConstant.State, map);
        FirebaseEvent().firebaseEvent(EventConstant.State_F, map);
        appsflyerController.logEventAf(EventConstant.State, map);
      }

      Utils().customPrint(
          'full adress Values call  ${placeMarks[0].locality}, ${placeMarks[0].administrativeArea},${placeMarks[0].subAdministrativeArea}, ${placeMarks[0].thoroughfare},${placeMarks[0].street},${placeMarks[0].street} ');

      //CleverTap Location Work
      Utils().customPrint('LOCATION latitude: ${latitude.value}');
      Utils().customPrint('LOCATION longitude: ${longitude.value}');
      if (longitude.value != null && longitude.value != null) {
        //set cleverTap location work
        var lat = latitude.value;
        var long = longitude.value;
        cleverTapController.setLocation(lat, long);
      }
    } catch (e) {}
/*
  Utils().customPrint(
        "addressLine1.value ${addressLine1.value} addressLine2.value${addressLine2.value}");*/
  }

  Future<void> getLocationPer() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location Permission Denied');
        return Future.error('Location permissions are denied');
      }
    } else {
      getPermission();
    }
  }

  void getPermission() {
    if ((permission == LocationPermission.always) ||
        (permission == LocationPermission.whileInUse)) {
      permissionAlow = true;
      // getCurrentLocation();
    }
  }

  String getBasicAuth(String username, String password) {
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    Utils().customPrint("Authrization =>>> ${basicAuth}");
    return basicAuth;
  }

  String genrateRendomNumber() {
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    return randomNumber.toString();
  }

  //custom loader
  static Future<void> alertForLocationRestriction(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'IMPORTANT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Wrap(
                children: [
                  Text(
                    'Sorry, If your current residence is from ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                  Text(
                    //' Assam, Odisha, Andhra Pradesh, Telangana, Nagaland & Sikkim,',
                    AppString.StateNameConcat != ''
                        ? AppString.StateNameConcat
                        : ' Assam, Odisha, Andhra Pradesh, Telangana, Nagaland & Sikkim,',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    ),
                  ),
                  Text(
                    ' You cannot participate in contests on GMNG',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'Ok');
                },
                child: Text('OK',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    )),
              ),
            ],
          );
        })) {

    }
  }

  static Future<void> alertForLocationRestrictionCounty(
      BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'IMPORTANT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Wrap(
                children: [
                  Text(
                    'Sorry,',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                  Text(
                    ' You cannot participate in contests on GMNG because you are Out of India',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'Ok');
                },
                child: Text('OK',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    )),
              ),
            ],
          );
        })) {

    }
  }

  //here goes the function
  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  String getDepositeBalnace(var deposit_bal) {
    //double varr=deposit_bal  as double;

    double varr = double.parse('${deposit_bal ?? "0"}');
    var deposite = varr / 100;

    var d2 = deposite.toPrecision(2);

    return d2.toString();
  }

  String getTodayDatesWithFormat() {
    // DateTime datetime  = DateTime.now().toUtc();
    DateTime datetime = DateTime.now();
    //2022-05-28T06:17:02.712Z
    //2022-06-12 20:41:24.528583
    String today = new DateFormat("yyyy/MM/dd'T'HH:mm:ss").format(datetime);
    // String today =new DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(new DateTime.now());
    Utils().customPrint("today== ${new DateTime.now()}");
    Utils().customPrint("today== ${today}");
    return today;
  }

  Future<String> getLocation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      language.value = prefs.getString("language");
      Utils().customPrint("language_language ${language} ");
      language_country.value = prefs.getString("language_country");
      Utils().customPrint("language");
      Utils().customPrint(language.value);
      Utils().customPrint(language_country.value);
      if (language.value == null) {
        language.value = "en";
        language_country.value = "US";
      }
    } catch (E) {
      language.value = "en";
      language_country.value = "US";
    }

    return "${language.value}";
  }

  String getTodayDates() {
    DateTime datetime = DateTime.now();
    String dateTimeCurrent;

    if (AppString.serverTime != null && AppString.serverTime != '') {
      //server time
      dateTimeCurrent = getStartTimeHHMMSS(AppString.serverTime);
      Utils().customPrint("today current 1 ${dateTimeCurrent}");
    } else {
      //local time
      dateTimeCurrent =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(datetime);
      Utils().customPrint("today current 2 ${dateTimeCurrent}");
    }

    // Utils().customPrint("today== ${new DateTime.now()}");
    Utils().customPrint("today current ${dateTimeCurrent}");

    return dateTimeCurrent;
  }

  Future<String> getTodayDatesPref() async {
    DateTime datetime = DateTime.now();
    String dateTimeCurrent;

    if (AppString.serverTime != null && AppString.serverTime != '') {
      dateTimeCurrent = getStartTimeHHMMSS(AppString.serverTime);
      Utils().customPrint("dateTimeCurrent 1 ${dateTimeCurrent}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("location_Check_Date", dateTimeCurrent);
    } else {
      dateTimeCurrent =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(datetime);
      Utils().customPrint("dateTimeCurrent 2 ${dateTimeCurrent}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("location_Check_Date", dateTimeCurrent);
    }
    Utils().customPrint("dateTimeCurrent ${dateTimeCurrent}");
  }

  void SettingAllowPermission(BuildContext context) {
    Future<bool> _onWillPop() async {
      Fluttertoast.showToast(msg: "Please Give Location Permission");

      return false;
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Wrap(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 10,
                      right: 10),
                  decoration: BoxDecoration(
                      color: AppColor().whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "Important",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Inter",
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(height: 1, color: AppColor().grey_li),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          height: 60,
                          child: Image.asset("assets/images/location_per.png")),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Allow location permission",
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "To Continue on this app we need to ensure that you're not from a restricted state",
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);

                            Geolocator.openAppSettings();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 15,
                            ),
                            margin: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "SHARE LOCATION",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<bool> checkResLocation(BuildContext context) async {
    if (permission_deniedCount.value >= 1) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission_denied.value = true;
        permission_deniedCount.value++;
        //Fluttertoast.showToast(msg: "msg denied");
      } else {
        permission_deniedCount.value = 0;
        permission_denied.value = false;
        await getCurrentLocation();
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location_Check_Date = prefs.getString("location_Check_Date");

    if (location_Check_Date != null && location_Check_Date.isNotEmpty) {
      Utils().customPrint(
          "LOCATION 1: --------- check date values ${stateV.value}");

      if (daysBetween(DateTime.parse(location_Check_Date),
              DateTime.parse(getTodayDates())) <
          0) {
        Utils().customPrint(
            "LOCATION Date Compare : --------- check date values ${stateV.value}");

        await getLocationPer();

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission_denied.value = true;
          permission_deniedCount.value++;
          SettingAllowPermission(context);
          return true;
          //Fluttertoast.showToast(msg: "msg denied");
        } else {
          permission_deniedCount.value = 0;
          permission_denied.value = false;
          await getCurrentLocation();
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("location_Check_Date", getTodayDates());
        prefs.setString("stateValues", stateV.value);
        prefs.setString("country", country.value);

        if (stateV.value != null) {
          // if (country.value.compareTo("India") == 0) {
          //function
          if (checkForBannedStates(stateV.value)) {
            alertForLocationRestriction(context);

            return true;
          }
          /* if (stateV.value.compareTo("Andhra Pradesh") == 0 ||
                stateV.value.compareTo("Assam") == 0 ||
                stateV.value.compareTo("Telangana") == 0 ||
                stateV.value.compareTo("Orissa") == 0 ||
                stateV.value.compareTo("Sikkim") == 0 ||
                stateV.value.compareTo("Nagaland") == 0) {
              alertForLocationRestriction(context);

              return true;
            }*/
          else {
            return false;
          }
          /* } else {
            alertForLocationRestrictionCounty(context);
            return true;
          }*/
        } else {
          if (permission_denied.value) {
            SettingAllowPermission(context);
            return true;
          }
          {
            Utils().customPrint(
                "LOCATION Date Compare  permission_denied : --------- check date values ${stateV.value}");

            getLocationPer().then((value) => getCurrentLocation());

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("stateValues", stateV.value);
            prefs.setString("country", country.value);

            if (stateV.value != null) {
              //if (country.value.compareTo("India") == 0) {
              /*if (stateV.value.compareTo("Andhra Pradesh") == 0 ||
                    stateV.value.compareTo("Assam") == 0 ||
                    stateV.value.compareTo("Telangana") == 0 ||
                    stateV.value.compareTo("Orissa") == 0 ||
                    stateV.value.compareTo("Sikkim") == 0 ||
                    stateV.value.compareTo("Nagaland") == 0) {
                  alertForLocationRestriction(context);

                  return true;
                }*/
              if (checkForBannedStates(stateV.value)) {
                alertForLocationRestriction(context);

                return true;
              } else {
                return false;
              }
              /*  } else {
                alertForLocationRestrictionCounty(context);
                return true;
              }*/
            }
          }
        }
      } else {
        Utils().customPrint(
            "LOCATION 3: --------- call check data show ${daysBetween(DateTime.parse(location_Check_Date), DateTime.parse(getTodayDates()))}");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String stateValues = prefs.getString("stateValues");
        String countryV = prefs.getString("country");

        //Fluttertoast.showToast(msg: "4 store data ${stateValues}");
        Utils().customPrint("LOCATION 4: --------- store data ${stateValues}");
        if (countryV != null) {
          //if (countryV.compareTo("India") == 0) {
          if (stateValues != null && stateValues.isNotEmpty) {
            /*if (stateValues.compareTo("Andhra Pradesh") == 0 ||
                  stateValues.compareTo("Assam") == 0 ||
                  stateValues.compareTo("Telangana") == 0 ||
                  stateValues.compareTo("Orissa") == 0 ||
                  stateValues.compareTo("Sikkim") == 0 ||
                  stateValues.compareTo("Nagaland") == 0) {
                alertForLocationRestriction(context);

                return true;
              }*/
            if (checkForBannedStates(stateV.value)) {
              alertForLocationRestriction(context);

              return true;
            } else {
              return false;
            }
          } else {
            Fluttertoast.showToast(
                msg: "Please Allow Location Permission From Settings");
            Utils().customPrint(
                "LOCATION 5: --------- Please Allow Location Permission From Settings.");
            return true;
          }
          /*} else {
            alertForLocationRestrictionCounty(context);
            return true;
          }*/
        } else {
          if (permission_denied.value) {
            SettingAllowPermission(context);
            return true;
          }
          {
            await getLocationPer();

            permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              permission_denied.value = true;
              permission_deniedCount.value++;
              SettingAllowPermission(context);
              return true;
              //Fluttertoast.showToast(msg: "msg denied");
            } else {
              permission_deniedCount.value = 0;
              permission_denied.value = false;
              await getCurrentLocation();
            }

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("stateValues", stateV.value);
            prefs.setString("country", country.value);
            if (country.value != null) {
              //if (country.value.compareTo("India") == 0) {
              /*if (stateV.value.compareTo("Andhra Pradesh") == 0 ||
                    stateV.value.compareTo("Assam") == 0 ||
                    stateV.value.compareTo("Telangana") == 0 ||
                    stateV.value.compareTo("Orissa") == 0 ||
                    stateV.value.compareTo("Sikkim") == 0 ||
                    stateV.value.compareTo("Nagaland") == 0) {
                  alertForLocationRestriction(context);
                  return true;
                }*/
              if (checkForBannedStates(stateV.value)) {
                alertForLocationRestriction(context);

                return true;
              } else {
                return false;
              }
              /* } else {
                alertForLocationRestrictionCounty(context);
                return true;
              }*/
            } else {
              getLocationPer().then((value) => getCurrentLocation());
              Fluttertoast.showToast(
                  msg: "Please Allow Location Permission From Settings");
              return true;
            }
          }
        }
      }
    } else {
      Utils().customPrint(
          "LOCATION 6: --------- Please Allow Location Permission From Settings.empty date and state${stateV.value}");
      getTodayDatesPref();

      await getLocationPer();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission_denied.value = true;
        permission_deniedCount.value++;
        SettingAllowPermission(context);
        return true;
        //Fluttertoast.showToast(msg: "msg denied");
      } else {
        permission_deniedCount.value = 0;
        permission_denied.value = false;
        await getCurrentLocation();
      }

      if (stateV.value != null && stateV.value.isNotEmpty) {
        //if (country.value.compareTo("India") == 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("stateValues", stateV.value);
        prefs.setString("country", country.value);

        /* if (stateV.value.compareTo("Andhra Pradesh") == 0 ||
              stateV.value.compareTo("Assam") == 0 ||
              stateV.value.compareTo("Telangana") == 0 ||
              stateV.value.compareTo("Orissa") == 0 ||
              stateV.value.compareTo("Sikkim") == 0 ||
              stateV.value.compareTo("Nagaland") == 0) {
            alertForLocationRestriction(context);
            return true;
          }*/
        if (checkForBannedStates(stateV.value)) {
          alertForLocationRestriction(context);

          return true;
        } else {
          return false;
        }
        /* } else {
          alertForLocationRestrictionCounty(context);
          return true;
        }*/
      } else {
        if (permission_denied.value) {
          SettingAllowPermission(context);
          return true;
        }
        {
          await getLocationPer();
          if (permission_denied.value) {
            SettingAllowPermission(context);
            return true;
          } else {
            await getCurrentLocation();
          }

          // await getLocationPer().then((value) => getCurrentLocation());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("stateValues", stateV.value);
          prefs.setString("country", country.value);
          if (country.value != null) {
            //if (country.value.compareTo("India") == 0) {
            /*if (stateV.value.compareTo("Andhra Pradesh") == 0 ||
                  stateV.value.compareTo("Assam") == 0 ||
                  stateV.value.compareTo("Telangana") == 0 ||
                  stateV.value.compareTo("Orissa") == 0 ||
                  stateV.value.compareTo("Sikkim") == 0 ||
                  stateV.value.compareTo("Nagaland") == 0) {
                alertForLocationRestriction(context);
                return true;
              }*/
            if (checkForBannedStates(stateV.value)) {
              alertForLocationRestriction(context);

              return true;
            } else {
              return false;
            }
            /* } else {
              alertForLocationRestrictionCounty(context);
              return true;
            }*/
          } else {
            getLocationPer().then((value) => getCurrentLocation());
            return true;
          }
        }
      }
    }
  }

  checkLocationEsportS() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location Permission Denied');
        return Future.error('Location permissions are denied');
      }
      permission_denied.value = true;
      permission_deniedCount.value++;
    } else {
      if (stateV.value != null && stateV.compareTo("") == 0) {
        permission_deniedCount.value = 0;
        permission_denied.value = false;
      } else {
        permission_deniedCount.value = 0;
        permission_denied.value = false;
        await getCurrentLocation();
      }
    }
  }

  bool checkForBannedStates(String StateName) {
    Utils().customPrint('BANNED STATES: 2 $StateName');
    if (AppString.restrictedStatesData != null) {
      for (States obj in AppString.restrictedStatesData.states) {
        Utils().customPrint('BANNED STATES: 3 ${obj.name}');
        if (StateName.compareTo(obj.name) == 0) {
          Utils().customPrint('BANNED STATES: 4 ${obj.name}');
          return true;
        }
      }
    }
    return false;
  }

  /*customPrint(var data) async {
    try {
      if (kDebugMode) {
        //print('debug mode');
      print(data);
      } else {
        //print('release mode');
      }
    } catch (e) {}
  }*/
  customPrint(var data) async {
    try {
      if (ApiUrl().is_debug_mode) {
        print("$data");
      } else {}
    } catch (e) {}
  }

  void alertaffiliatCongratulation() {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(navigatorKey.currentState.context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Container(
          height: 480,
          child: Center(
            child: Stack(
              children: [
                Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  color: Colors.transparent,
                  child: Wrap(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(navigatorKey.currentState.context);
                        },
                        child: Image(
                            width:
                                MediaQuery.of(navigatorKey.currentState.context)
                                    .size
                                    .width,
                            fit: BoxFit.fill,
                            height: 480,
                            image: AssetImage(
                                "assets/images/affiliate_congrats_banner.png")),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50, top: 20),
                      child: GestureDetector(
                          child: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onTap: () {
                            //  click_pay = true;
                            Navigator.pop(navigatorKey.currentState.context);
                          }),
                    )
                  ],
                )
              ],
            ),
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

  void VIPCongratulation(var level) {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(navigatorKey.currentState.context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Container(
          height: 480,
          child: Center(
            child: Stack(
              children: [
                Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  color: Colors.transparent,
                  child: Wrap(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(navigatorKey.currentState.context);
                        },
                        child: Image(
                            width:
                                MediaQuery.of(navigatorKey.currentState.context)
                                    .size
                                    .width,
                            fit: BoxFit.fill,
                            height: 480,
                            image: AssetImage(
                                "assets/images/vip_congrats_${level}.png")),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50, top: 20),
                      child: GestureDetector(
                          child: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onTap: () {
                            //  click_pay = true;
                            Navigator.pop(navigatorKey.currentState.context);
                          }),
                    )
                  ],
                )
              ],
            ),
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

  //helping dialog
  void showCustomDialogWebViewInvible(BuildContext context, var url_server) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: false,
          child: Container(
            child: Center(
              child: Container(
                  height: 200,
                  width: 300,
                  //color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                      child: WebView(
                    initialUrl: url_server,
                    javascriptMode: JavascriptMode.unrestricted,
                    gestureNavigationEnabled: true,
                    onWebViewCreated: (WebViewController webViewController) {
                      //webViewCompleter.complete(webViewController);
                    },
                    onProgress: (progr) {
                      //Utils().customPrint('onProgress : $progr');
                    },
                    onPageStarted: (url) {},
                    onWebResourceError: (error) {
                      //Utils().customPrint('onWebResourceError : ${error.errorCode}');
                    },
                    onPageFinished: (url) {
                      hideProgress(context);
                      Utils().customPrint('onPageFinished ----> BRFORE : $url');
                      //Utils().customPrint('onPageFinished ---->AFTER : $url');
                      if (url.contains("market://details?")) {
                        //Fluttertoast.showToast(msg: 'Found!');
                        Utils().customPrint('onPageFinished for Market : $url');
                        Utils.launchURLApp(url);
                        Navigator.pop(context);
                      } else {
                        Utils().customPrint(
                            'onPageFinished for All : $url_server');
                        //Fluttertoast.showToast(msg: 'Url Not Found!');
                        Utils.launchURLApp(url_server);
                        Navigator.pop(context);
                      }
                    },
                    zoomEnabled: false,
                  ))),
            ),
          ),
        );
      },
    );
  }

  void showOfferWaleFeedBack(int amount) {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(ImageRes().hole_popup_bg))),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 310,
              child: Card(
                margin: EdgeInsets.only(top: 25, bottom: 10),
                elevation: 0,
                //color: AppColor().wallet_dark_grey,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      navigatorKey.currentState.context);
                                },
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  child: Image.asset(ImageRes().close_icon),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: Center(
                              child: Image(
                                  width: MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .size
                                          .width -
                                      100,
                                  fit: BoxFit.fill,
                                  height: 65,
                                  image:
                                      AssetImage(ImageRes().offer_coin_come)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Text(
                          "Money Credited",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: AppColor().whiteColor),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: ' ',
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${AppString().txt_currency_symbole}${amount ~/ 100} ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: AppColor().green_color)),
                              TextSpan(
                                text:
                                    'Credited to your account \n Play more to earn more',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    color: AppColor().whiteColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.of(navigatorKey.currentState.context).pop();
                        },
                        child: Container(
                          width:
                              MediaQuery.of(navigatorKey.currentState.context)
                                      .size
                                      .width -
                                  230,
                          height: 40,
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
                                  fontFamily: "Montserrat",
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        );
      },
    );
  }

  //new pop up
  void showWalletDown(BuildContext context) {
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
            height: 300,
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
                        Center(
                            child: SvgPicture.asset(
                          ImageRes().wallet_down,
                          height: 50,
                          //color: AppColor().whiteColor,
                        )),
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
                        "Wallet Down",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: AppColor().whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "We are facing some technical issues with bank servers. Please be assured that your money is safe.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: AppColor().whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
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
                          child: Text("OKAY",
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
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  //new pop up
  void showKycDown(BuildContext context) {
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
            height: 300,
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
                        Center(
                            child: Image(
                          height: 50,
                          image: AssetImage(ImageRes().kyc_down),
                          //fit: BoxFit.fill,
                        )),
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
                        "KYC Down",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: AppColor().whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "We are facing some technical issues with KYC. We will be back in sometime.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: AppColor().whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
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
                          child: Text("OKAY",
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
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  String populateAmountToUpper(String amount) {
    //var amount = '19';
    //it make enterAmt to upper value ex- 18 to 20, 2 to 10, 98 to 100.
    int amountFinal = 0;
    for (int i = 0; i < 10; i++) {
      if (amount.contains('0')) {
        print('testing:: inner ${amount}');
        break;
      }
      amountFinal = int.parse(amount);
      amount = (amountFinal + 1).toString();
    }
    return amount;
  }

  subtractDate() {
//  var difference = DateTime.now().subtract(Duration(hours: 24, minutes: 0, seconds:0));

    final startTime = DateTime(2023, 06, 06, 24, 00, 00);
    var difference =
        DateTime.now().difference(DateTime(2023, 06, 06, 24, 00, 00)).inMinutes;

    DateTime nowDate = DateTime.now();
    int currYear = nowDate.hour;

// var differencem = difference * 60;
    //Utils().customPrint("current system date utcCurrentDate $utcCurrentDate");
    Utils().customPrint("current system date expireDate $difference");
    //Utils().customPrint("current system date difference $differencem");
    var getHourse = 24 - DateTime.now().hour;

    return getHourse * 60 * 60;
  }

  void alertOldWallet(BuildContext context) {
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
            height: 180,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 30),
                      child: Text(
                        'Please Enter Amount And Click on This Banner Again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.offAll(() => DashBord(4, ""));
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width - 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColor().green_color_light,
                              AppColor().green_color,
                            ],
                          ),

                          boxShadow: const [
                            BoxShadow(
                              offset: const Offset(
                                0.0,
                                1.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: Color(0xFF067906),
                              //inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFffffff),
                              //inset: true,
                            ),
                          ],

                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Nunito",
                              color: Colors.white),
                        ),
                      ),
                    ),
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

  static void alertLimitExhausted() {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 20),
                      child: Text(
                        'Daily Limit Reached, \n Contact Support To increase the Limit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(navigatorKey.currentState.context);

                        UserController controller = Get.put(UserController());
                        controller.SetFreshchatUser();
                        Freshchat.showFAQ();
                        // Get.offAll(() => DashBord(4, ""));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        width: MediaQuery.of(navigatorKey.currentState.context)
                                .size
                                .width -
                            250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColor().green_color_light,
                              AppColor().green_color,
                            ],
                          ),

                          boxShadow: const [
                            BoxShadow(
                              offset: const Offset(
                                0.0,
                                1.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: Color(0xFF067906),
                              //inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFffffff),
                              //inset: true,
                            ),
                          ],

                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Text(
                          "Contact Support",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Nunito",
                              color: Colors.white),
                        ),
                      ),
                    ),
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

  void insufficientInstant() {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
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
            height: 150,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 30),
                      child: Text(
                        'Insufficient Balance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.offAll(() => DashBord(4, ""));
                        Navigator.pop(navigatorKey.currentState.context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        width: MediaQuery.of(navigatorKey.currentState.context)
                                .size
                                .width -
                            250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColor().green_color_light,
                              AppColor().green_color,
                            ],
                          ),

                          boxShadow: const [
                            BoxShadow(
                              offset: const Offset(
                                0.0,
                                1.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: Color(0xFF067906),
                              //inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFffffff),
                              //inset: true,
                            ),
                          ],

                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Nunito",
                              color: Colors.white),
                        ),
                      ),
                    ),
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

  void alertInsufficientBalance(BuildContext context) {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
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
            height: 280,
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image(
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/rupee.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(navigatorKey.currentState.context);
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
                      padding: const EdgeInsets.only(left: 0, top: 5),
                      child: Text(
                        'Insufficient Balance'.tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 40, bottom: 10),
                      child: Text(
                        'You don\'t have sufficient balance to join this contest.'
                            .tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //Get.offAll(() => DashBord(4, ""));
                              Get.to(() => CashFreeScreen());
                              //Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 10, bottom: 10),
                              width: MediaQuery.of(
                                          navigatorKey.currentState.context)
                                      .size
                                      .width -
                                  250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().green_color_light,
                                    AppColor().green_color,
                                  ],
                                ),

                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      1.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFF067906),
                                    //inset: true,
                                  ),
                                  BoxShadow(
                                    offset: Offset(00, 00),
                                    blurRadius: 00,
                                    color: Color(0xFFffffff),
                                    //inset: true,
                                  ),
                                ],

                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Text(
                                "ADD MONEY".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Nunito",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text("  "),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              AppString.isClickFromHome = false;
                              AppString.contestAmount = 0;
                              Get.to(() => OfferWallScreen());
                              //Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 10, bottom: 10),
                              width: MediaQuery.of(
                                          navigatorKey.currentState.context)
                                      .size
                                      .width -
                                  250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().button_bg_redlight,
                                    AppColor().button_bg_reddark,
                                  ],
                                ),

                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      1.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFFED234B),
                                    //inset: true,
                                  ),
                                  BoxShadow(
                                    offset: Offset(00, 00),
                                    blurRadius: 00,
                                    color: Color(0xFFffffff),
                                    //inset: true,
                                  ),
                                ],

                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Text(
                                "GET FREE MONEY".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Nunito",
                                    color: Colors.white),
                              ),
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

  void thanksPopUp() {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
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
            height: 160,
            child: Card(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    /*   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(navigatorKey.currentState.context);
                          },
                          child: Container(
                            height: 18,
                            width: 18,
                            child: Image.asset(ImageRes().close_icon),
                          ),
                        )
                      ],
                    ),

*/
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Thank You For Showing Interest We will call you back in 24 hours",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: AppColor().whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(navigatorKey.currentState.context).pop();
                      },
                      child: Container(
                        width: 150,
                        height: 40,
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
                                fontFamily: "Montserrat",
                              )),
                        ),
                      ),
                    ),
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

  void tamashaLHistoryPending() {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
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
            height: 170,
            child: Card(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Some results may take some time to get updated please wait a few minutes and check again",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: AppColor().whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(navigatorKey.currentState.context).pop();
                      },
                      child: Container(
                        width: 150,
                        height: 40,
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
                                fontFamily: "Montserrat",
                              )),
                        ),
                      ),
                    ),
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

  void showPopMiniMumDeposit(var minimumAmount) {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
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
            height: 300,
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
                        Center(
                            child: Image(
                          height: 50,
                          image: AssetImage(ImageRes().kyc_down),
                          //fit: BoxFit.fill,
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(navigatorKey.currentState.context);
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
                        "Minimum Deposit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: AppColor().whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Please make a ${minimumAmount ~/ 100} deposit to withdraw money from your account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: AppColor().whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(navigatorKey.currentState.context).pop();
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
                          child: Text("OKAY",
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
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  void getWhatIsLootBox() {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(navigatorKey.currentState.context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height:
                MediaQuery.of(navigatorKey.currentState.context).size.height -
                    70,
            width: MediaQuery.of(navigatorKey.currentState.context).size.width,
            /*    decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg))),*/
            child: Center(
              child: Card(
                elevation: 1,
                margin: EdgeInsets.only(left: 0, right: 0),
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CarouselSlider(
                              items: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image(
                                        height: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .height,
                                        width: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .width,
                                        fit: BoxFit.fill,
                                        image:
                                            AssetImage(ImageRes().step_o_offer),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image(
                                        height: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .height,
                                        width: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .width,
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            ImageRes().step_two_offer),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image(
                                        height: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .height,
                                        width: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .width,
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            ImageRes().step_thi_offer),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image(
                                        height: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .height,
                                        width: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .width,
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            ImageRes().step_fore_offer),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              options: CarouselOptions(
                                height: MediaQuery.of(
                                            navigatorKey.currentState.context)
                                        .size
                                        .height -
                                    80,
                                autoPlay: true,
                                disableCenter: true,
                                viewportFraction: 1,
                                aspectRatio: 3,
                                enlargeCenterPage: false,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 1000),
                                onPageChanged: (index, reason) {
                                  currentIndexSlider.value = index;
                                  print(
                                      "call data currentIndexSlider$currentIndexSlider");
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentIndexSlider.value == 0
                                            ? appBtnBgColor.value
                                            : appBtnTxtColor.value),
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentIndexSlider.value == 1
                                            ? appBtnBgColor.value
                                            : appBtnTxtColor.value),
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentIndexSlider.value == 2
                                            ? appBtnBgColor.value
                                            : appBtnTxtColor.value),
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentIndexSlider.value == 3
                                            ? appBtnBgColor.value
                                            : appBtnTxtColor.value),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 50, top: 20),
                              child: GestureDetector(
                                  child: Image(
                                      height: 20,
                                      width: 20,
                                      image: AssetImage(ImageRes().close_icon)),
                                  onTap: () {
                                    //  click_pay = true;
                                    Navigator.pop(
                                        navigatorKey.currentState.context);
                                  }),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
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

  void alertaffiliat(String getUserReferalCode, String user_id) {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        print("call aff${onlyOffi.countValuesAR.value}");
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(ImageRes().affiliat_bg))),
                padding: EdgeInsets.symmetric(horizontal: 00),
                height: 520,
                child: Card(
                  margin: EdgeInsets.only(top: 25, bottom: 10),
                  elevation: 100,
                  //color: AppColor().wallet_dark_grey,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(00),
                          child: Image(
                            height: 115,
                            width:
                                MediaQuery.of(navigatorKey.currentState.context)
                                    .size
                                    .width,
                            fit: BoxFit.fill,
                            image: AssetImage(ImageRes().affiliate_banner_top),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  height: 135,
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/sing_up_deposit.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  height: 135,
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/affiliate_30_off.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 188,
                          width:
                              MediaQuery.of(navigatorKey.currentState.context)
                                  .size
                                  .width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(00),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      ImageRes().affiliat_referral))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "REFER",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        color: AppColor().yellow_color),
                                  ),
                                  Text(
                                    " 3 FRIENDS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        color: AppColor().green_color_light),
                                  ),
                                  Text(
                                    " TO BECOME A AFFILIATE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        color: AppColor().yellow_color),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            child: Obx(
                                              () => Image(
                                                  fit: BoxFit.fill,
                                                  image: onlyOffi.countValuesAR
                                                                  .value !=
                                                              null &&
                                                          onlyOffi.countValuesAR
                                                                  .value >=
                                                              1
                                                      ? AssetImage(
                                                          'assets/images/green_tick_circle.png')
                                                      : AssetImage(
                                                          'assets/images/whatsapp_circle.png')),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Step 1",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColor().GreenColorA,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Montserrat",
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      //   width: 90,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 14),
                                        child: Obx(
                                          () => DottedLine(
                                            direction: Axis.horizontal,
                                            lineLength: double.infinity,
                                            lineThickness: 1.0,
                                            dashLength: 4.0,
                                            dashColor:
                                                onlyOffi.countValuesAR.value !=
                                                            null &&
                                                        onlyOffi.countValuesAR
                                                                .value >=
                                                            1
                                                    ? AppColor().GreenColorA
                                                    : Colors.white,
                                            //  dashGradient: [Colors.red, Colors.blue],
                                            dashRadius: 0.0,
                                            dashGapLength: 4.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            child: Obx(
                                              () => Image(
                                                fit: BoxFit.fill,
                                                image: onlyOffi.countValuesAR
                                                                .value !=
                                                            null &&
                                                        onlyOffi.countValuesAR
                                                                .value >=
                                                            1
                                                    ? onlyOffi.countValuesAR
                                                                .value >=
                                                            2
                                                        ? AssetImage(
                                                            'assets/images/green_tick_circle.png')
                                                        : AssetImage(
                                                            'assets/images/whatsapp_circle.png')
                                                    : AssetImage(
                                                        'assets/images/whatsapp_circle_gre.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => Text(
                                            "Step 2",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: onlyOffi.countValuesAR
                                                                .value !=
                                                            null &&
                                                        onlyOffi.countValuesAR
                                                                .value >=
                                                            1
                                                    ? AppColor().GreenColorA
                                                    : AppColor().whiteColor,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "Montserrat",
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 14),
                                        child: Obx(
                                          () => DottedLine(
                                            direction: Axis.horizontal,
                                            lineLength: double.infinity,
                                            lineThickness: 1.0,
                                            dashLength: 4.0,
                                            dashColor:
                                                onlyOffi.countValuesAR.value !=
                                                            null &&
                                                        onlyOffi.countValuesAR
                                                                .value >=
                                                            2
                                                    ? AppColor().GreenColorA
                                                    : Colors.white,
                                            //  dashGradient: [Colors.red, Colors.blue],
                                            dashRadius: 0.0,
                                            dashGapLength: 4.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            child: Obx(
                                              () => Image(
                                                fit: BoxFit.fill,
                                                image: onlyOffi.countValuesAR
                                                                .value !=
                                                            null &&
                                                        onlyOffi.countValuesAR
                                                                .value >=
                                                            2
                                                    ? onlyOffi.countValuesAR
                                                                .value >=
                                                            3
                                                        ? AssetImage(
                                                            'assets/images/green_tick_circle.png')
                                                        : AssetImage(
                                                            'assets/images/whatsapp_circle.png')
                                                    : AssetImage(
                                                        'assets/images/whatsapp_circle_gre.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => Text(
                                            "Step 3",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: onlyOffi.countValuesAR
                                                                .value !=
                                                            null &&
                                                        onlyOffi.countValuesAR
                                                                .value >=
                                                            2
                                                    ? AppColor().GreenColorA
                                                    : AppColor().whiteColor,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "Montserrat",
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  print("refferal code ${getUserReferalCode}");
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  onlyOffi.countValuesAR.value =
                                      prefs.getInt("countValues");

                                  Map<String, dynamic> map = {
                                    "number_of_referral":
                                        "${onlyOffi.countValuesAR.value}",
                                    "USER_ID": "$user_id}"
                                  };

                                  CleverTapController cleverTapController =
                                      Get.put(CleverTapController());

                                  cleverTapController.logEventCT(
                                      EventConstant.User_Refer_Affiliate, map);
                                  FirebaseEvent().firebaseEvent(
                                      EventConstant.User_Refer_Affiliate_F,
                                      map);

                                  if (onlyOffi.countValuesAR.value == null) {
                                    String urlCall =
                                        "https://gmng.onelink.me/GRb6?af_xp=app&pid=Cross_sale&c=Referral%20code%20pre-fill&is_retargeting=true&af_dp=gmng%3A%2F%2F&referral_code=$getUserReferalCode";
                                    var encoded = Uri.encodeFull(urlCall);

                                    await WhatsappShare.share(
                                        text:
                                            "Bro Mere link se GMNG app download kar  Hum dono ko 10-10 rs "
                                            "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code -$getUserReferalCode",
                                        linkUrl: encoded,
                                        phone: "9555775577");

                                    onlyOffi.countValuesAR.value =
                                        prefs.getInt("countValues");
                                    if (onlyOffi.countValuesAR.value == null) {
                                      onlyOffi.countValuesAR.value = 0;
                                      countAffi =
                                          onlyOffi.countValuesAR.value + 1;
                                    } else {
                                      countAffi =
                                          onlyOffi.countValuesAR.value + 1;
                                    }
                                    prefs.setInt("countValues", countAffi);
                                    print("count countAffi $countAffi");
                                  } else if (onlyOffi.countValuesAR.value < 3) {
                                    String urlCall =
                                        "https://gmng.onelink.me/GRb6?af_xp=app&pid=Cross_sale&c=Referral%20code%20pre-fill&is_retargeting=true&af_dp=gmng%3A%2F%2F&referral_code=$getUserReferalCode";
                                    var encoded = Uri.encodeFull(urlCall);

                                    await WhatsappShare.share(
                                        text:
                                            "Bro Mere link se GMNG app download kar  Hum dono ko 10-10 rs "
                                            "cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code -$getUserReferalCode",
                                        linkUrl: encoded,
                                        phone: "9555775577");
                                    onlyOffi.countValuesAR.value =
                                        prefs.getInt("countValues");
                                    if (onlyOffi.countValuesAR.value == null) {
                                      onlyOffi.countValuesAR.value = 0;
                                      countAffi =
                                          onlyOffi.countValuesAR.value + 1;
                                    } else {
                                      countAffi =
                                          onlyOffi.countValuesAR.value + 1;
                                    }

                                    prefs.setInt("countValues", countAffi);

                                    print("count countAffi more $countAffi");

                                    if (countAffi == 3) {
                                      prefs.setBool("affiliateCong", true);
                                      Navigator.pop(
                                          navigatorKey.currentState.context);
                                    } else {
                                      prefs.setBool("affiliateCong", false);
                                    }
                                  } else {}
                                },
                                child: Container(
                                  height: 45,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    color: AppColor().green_color_light,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "REFER NOW",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Montserrat',
                                          color: AppColor().whiteColor),
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
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        );
      },
    );
  }

  //get device info
  Future<Map<String, dynamic>> getDeviceID() async {
    var deviceInfo = DeviceInfoPlugin();
    var deviceData = <String, dynamic>{};

    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfo.androidInfo);
      return deviceData;
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfo.iosInfo);
      return deviceData;
    } else if (Platform.isWindows) {
      deviceData = _readWindowsDeviceInfo(await deviceInfo.windowsInfo);
      return deviceData;
    }
  }

//Android Method For Device Info
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures
      /*   'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,*/
    };
  }

  //iOS Method For Device Info
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  //web Method For Device Info
  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      /*'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,*/
    };
  }

  Future<void> getPermissionPhone() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> status = await [
      Permission.phone,
    ].request();
    customPrint('statuses: ${status[Permission.phone]}');
  }

  void alertForVipBanner(BuildContext context, String text) {
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
            height: 180,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 30),
                      child: Text(
                        '$text',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.offAll(() => DashBord(4, ""));
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width - 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColor().green_color_light,
                              AppColor().green_color,
                            ],
                          ),

                          boxShadow: const [
                            BoxShadow(
                              offset: const Offset(
                                0.0,
                                1.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: Color(0xFF067906),
                              //inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFffffff),
                              //inset: true,
                            ),
                          ],

                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Nunito",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
          ),
        );
      },
    );
  }

  //get Device Info
  Future<String> getUniqueDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      String uniqueDeviceId;
      try {
        uniqueDeviceId = await UniqueDeviceId.get;
      } on PlatformException {
        //uniqueDeviceId = 'Failed to get platform version.';
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id;
      }
      return uniqueDeviceId;
    } else {
      var androidDeviceInfo = "";
      return androidDeviceInfo;
    }
  }

  //isPopup banner =true work
  void popUpBanner(var url, var item, var homePageListModel) {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(navigatorKey.currentState.context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Container(
          height: 480,
          child: Center(
            child: Stack(
              children: [
                Card(
                  elevation: 1,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  color: Colors.transparent,
                  child: Wrap(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            //Navigator.pop(navigatorKey.currentState.context);
                            //Fluttertoast.showToast(msg: 'Banner Click! ${item.screen}');
                            if (item.externalUrl != null &&
                                !item.externalUrl.isEmpty) {
                              //external
                              launchURLApp(item.externalUrl);
                            } else if (item.gameId != null) {
                              //internal
                              Utils().customPrint(
                                  'Click Banner : TEST ${item.gameId}');
                              bool isMatched = false;
                              for (GameCategories objMain
                                  in homePageListModel.value.gameCategories) {
                                if (objMain.name == 'Esports') {
                                  for (Games objSub in objMain.games) {
                                    if (objSub.id == item.gameId) {
                                      AppString.gameName = objSub.name;
                                      Get.to(() => ESports(
                                          item.gameId,
                                          objSub.banner.url,
                                          objSub.howToPlayUrl,
                                          item.eventId != null
                                              ? item.eventId
                                              : ""));
                                      isMatched = true;
                                      break;
                                    }
                                  }
                                } else if (objMain.name == 'GMNG Originals') {
                                  for (Games objSub in objMain.games) {
                                    if (objSub.id == item.gameId) {
                                      if (objSub.thirdParty != null) {
                                        if (objSub.thirdParty.name ==
                                            'Gamezop') {
                                          Fluttertoast.showToast(msg: "Under Maintenance");

                                          /* Get.to(() => GameJobList(item.gameId,
                                              objSub.banner.url, objSub.name));
                                          isMatched = true;*/
                                        } else if (objSub.thirdParty.name ==
                                            'Freakx') {
                                          Get.to(() => FreakxList(item.gameId,
                                              objSub.banner.url, objSub.name));
                                          isMatched = true;
                                        }
                                      } else {
                                        Get.to(() => UnityList(item.gameId,
                                            objSub.banner.url, objSub.name));
                                        isMatched = true;
                                      }
                                      break;
                                    }
                                  }
                                }
                              }
                              if (isMatched == false) {
                                if (item.gameId != null &&
                                    item.gameId == '62de6babd6fc1704f21b0ab4') {
                                  //BalleBazi || Fantasy
                                  MyTeam11_Ballbazi_Controller
                                      team11Controller =
                                      Get.put(MyTeam11_Ballbazi_Controller());
                                  await team11Controller.getLoginTeam11BB(
                                      navigatorKey.currentState.context,
                                      '62de6babd6fc1704f21b0ab4');

                                  /*  BallbaziLoginController
                                      ballbaziLoginController =
                                      Get.put(BallbaziLoginController());
                                  ballbaziLoginController.getLoginBallabzi(
                                      navigatorKey.currentState.context);*/
                                } else if (item.gameId != null &&
                                    item.gameId == '62de6babd6fc1704f21b0ab5') {
                                  //Pocker
                                  Pocket52LoginController
                                      _pocket52loginController =
                                      Get.put(Pocket52LoginController());
                                  _pocket52loginController.getLoginWithPocket52(
                                      navigatorKey.currentState.context);
                                  //    Get.offAll(DashBord(2, ''));
                                } else if (item.gameId != null &&
                                    item.gameId == '62e7d76654628211b0e49d25') {
                                  final param = {
                                    "state": "haryana",
                                    "country": "india"
                                  };

                                  Fluttertoast.showToast(msg: "Under Maintenance");

                                  // getHashForRummy(param);
                                }
                              }
                            } else if (item.type == 'internalScreen') {
                              if (item.screen == 'offerWall') {
                                Get.to(() => OfferWallScreen());
                              } else if (item.screen == 'wallet') {
                                UserController controller = Get.find();
                                controller.currentIndex.value = 4;
                                controller.getWalletAmount();
                                Get.offAll(() => DashBord(4, ""));
                              } else if (item.screen == 'referral') {
                                Get.to(() => Rewards());
                              }
                            }
                          },
                          child: Image(
                            width:
                                MediaQuery.of(navigatorKey.currentState.context)
                                    .size
                                    .width,
                            fit: BoxFit.fill,
                            height: 480,
                            image: NetworkImage(url),
                            //image: AssetImage("assets/images/vip_congrats_1.png")),
                          )),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50, top: 20),
                      child: GestureDetector(
                          child: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onTap: () {
                            //  click_pay = true;
                            Navigator.pop(navigatorKey.currentState.context);
                          }),
                    )
                  ],
                )
              ],
            ),
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

  //CT like banner work
  static var bannerModelRV = BannerModelR().obs;

  Future<void> getBannerAsPerPageType(
      String token, String appTypes, String screen) async {
    Utils().customPrint('getBannerAsPerPageType Banner');
    if (token != null && token != '') {
      Map<String, dynamic> response_str =
          await WebServicesHelper().getBannerAsPerPageType(token, appTypes);
      if (response_str != null) {
        bannerModelRV.value = BannerModelR.fromJson(response_str);
        Utils().customPrint(
            'getBannerAsPerPageType Banner length : ${bannerModelRV.value.data.length} ');
        if (bannerModelRV.value.data != null &&
            bannerModelRV.value.data.length > 0) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          for (var objMain in bannerModelRV.value.data) {
            if (objMain.image.url != null && objMain.image.url != '') {
              if (screen == 'home' && screen == objMain.category) {
                String image = prefs.getString("home_image_ispopup");
                //print("home_image_ispopup : $image");
                //print("obj.image.url : ${objMain.image.url}");
                //print("test compare to : ${image.toString().compareTo(objMain.image.url.toString()) != 0}");
                if (image == null ||
                    image == '' ||
                    image.toString().compareTo(objMain.image.url.toString()) !=
                        0) {
                  prefs.setString("home_image_ispopup", objMain.image.url);
                  HomePageController controller = Get.put(HomePageController());
                  popUpBanner(
                      objMain.image.url, objMain, controller.homePageListModel);
                  break;
                }
              } else if (screen == 'wallet' && screen == objMain.category) {
                String image = prefs.getString("wallet_image_ispopup");
                if (image == null ||
                    image == '' ||
                    image.toString().compareTo(objMain.image.url.toString()) !=
                        0) {
                  prefs.setString("wallet_image_ispopup", objMain.image.url);
                  HomePageController controller = Get.put(HomePageController());
                  popUpBanner(
                      objMain.image.url, objMain, controller.homePageListModel);
                  break;
                }
              } else if (screen == 'offerWall' && screen == objMain.category) {
                String image = prefs.getString("offerWall_image_ispopup");
                if (image == null ||
                    image == '' ||
                    image.toString().compareTo(objMain.image.url.toString()) !=
                        0) {
                  prefs.setString("offerWall_image_ispopup", objMain.image.url);
                  HomePageController controller = Get.put(HomePageController());
                  popUpBanner(
                      objMain.image.url, objMain, controller.homePageListModel);
                  break;
                }
              } else if (screen == 'referral' && screen == objMain.category) {
                String image = prefs.getString("referral_image_ispopup");
                if (image == null ||
                    image == '' ||
                    image.toString().compareTo(objMain.image.url.toString()) !=
                        0) {
                  prefs.setString("referral_image_ispopup", objMain.image.url);
                  HomePageController controller = Get.put(HomePageController());
                  popUpBanner(
                      objMain.image.url, objMain, controller.homePageListModel);
                  break;
                }
              }
            }
          }
        }
      }
    }
  }

  //rummy api
  Future<void> getHashForRummy(Map<String, dynamic> param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Map<String, dynamic> response =
        await WebServicesHelper().getHashForRummy(token, param);

    Utils().customPrint('response $response');
    if (response != null) {
      Utils().customPrint('response ${response['loginRequest']['params']}');
      RummyModel rummyModel =
          RummyModel.fromJson(response['loginRequest']['params']);
      Utils().customPrint('LoginResponseLoginResponse ${rummyModel}');

      final Map<String, String> data = {
        "user_id": rummyModel.user_id,
        "name": rummyModel.name,
        "state": rummyModel.state,
        "country": rummyModel.country,
        "session_key": rummyModel.session_key,
        "timestamp": rummyModel.timestamp,
        "client_id": rummyModel.client_id,
        "hash": rummyModel.hash,
      };

      String reposnenative = await NativeBridge().OpenRummy(data);
      Utils().customPrint("data====> ${reposnenative}");
      try {
        switch (reposnenative) {
          case "click_add_amount":
            UserController controller = Get.find();
            controller.currentIndex.value = 4;
            controller.getWalletAmount();
            Get.offAll(() => DashBord(4, ""));
            break;
          case "topBarClicked":
            Get.to(() => how_to_play_rummy());
            break;
          default:
            Utils().customPrint("click_buyin_success=====================>");
            break;
        }
      } catch (e) {
        //error
      }
    } else {
      Utils().customPrint('response promo code ERROR');
    }
  }

  //offerwall popup
  void creatDealPopupError(BuildContext context, String text) {
    showGeneralDialog(
      context: context, //navigatorKey.currentState.context,
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
            height: 150,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 30),
                      child: Text(
                        '$text',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.offAll(() => DashBord(4, ""));
                        Navigator.pop(navigatorKey.currentState.context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        width: MediaQuery.of(navigatorKey.currentState.context)
                                .size
                                .width -
                            250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColor().green_color_light,
                              AppColor().green_color,
                            ],
                          ),

                          boxShadow: const [
                            BoxShadow(
                              offset: const Offset(
                                0.0,
                                1.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: Color(0xFF067906),
                              //inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFffffff),
                              //inset: true,
                            ),
                          ],

                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Text(
                          "OK",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Nunito",
                              color: Colors.white),
                        ),
                      ),
                    ),
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

  //random alpha-numeric generator
  Random _rnd = Random();
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  //page down
  Future<bool> onWillPop() async {
    //  SystemNavigator.pop();
    return false;
  }

  void showLootBoxDown(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: onWillPop,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(ImageRes().hole_popup_bg))),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 300,
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
                          Center(
                            child: /*Image(
                                height: 50,
                                image: AssetImage(ImageRes().kyc_down),
                                //fit: BoxFit.fill,
                              )*/
                                SvgPicture.asset(
                              ImageRes().settings_app_down,
                              height: 50,
                              //color: AppColor().whiteColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //Navigator.pop(context);
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
                          "LootBox Down",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: AppColor().whiteColor),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "We are facing some technical issues. We will be back in sometime.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              color: AppColor().whiteColor),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () async {
                          //Navigator.of(context).pop();
                          Get.offAll(() => DashBord(2, ""));
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
                            child: Text("OKAY",
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
                  ),
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        );
      },
    );
  }
}
