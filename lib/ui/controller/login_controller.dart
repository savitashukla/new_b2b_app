import 'dart:async';
import 'dart:io';

import 'package:android_multiple_identifier/android_multiple_identifier.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_information/device_information.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unique_device_id/flutter_unique_device_id.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/LoginModel/LoginResponse.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/TrueCallerLogin.dart';
import '../../res/firebase_events.dart';
import '../../utills/Platfrom.dart';
import '../../utills/Utils.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../../utills/event_tracker/CleverTapController.dart';
import '../../utills/event_tracker/FaceBookEventController.dart';
import '../../utills/event_tracker/FacebookEventApi.dart';
import '../../webservices/ApiUrl.dart';
import '../../webservices/WebServicesHelper.dart';
import '../dialog/helperProgressBar.dart';
import '../login/OtpVerification.dart';
import '../main/dashbord/favourite_game/FavouriteGame.dart';

class Login_Controller extends GetxController {
  SharedPreferences prefs;
  var referral_code_s = "".obs;
  var referral_codeb = false.obs;
  TextEditingController emailController = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();
  TextEditingController referral_code = new TextEditingController();
  var btnControllerProfile = RoundedLoadingButtonController();
  String version;
  String code;
  String packageName;
  var login_number = "8107357227".obs;
  var password = "123456".obs;
  var device_type = "".obs;
  var storeType = "playStore".obs;
  var only_number = "".obs;
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());
  String deviceTokenToSendPushNotification;

  var storeData;
  static final facebookAppEvents = FacebookAppEvents();

  var signature = "".obs;

  var imei_number = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    prefs = await SharedPreferences.getInstance();
    try {
      if (AppsflyerController.referral_code_af.value != null) {
        if (AppsflyerController.referral_code_af.value.isNotEmpty) {
          referral_codeb.value = true;
          referral_code.text = AppsflyerController.referral_code_af.value;
          referral_code_s.value = AppsflyerController.referral_code_af.value;
          print("referral_code_s.value${referral_code_s.value}");
        }
      } else {
        referral_codeb.value = false;
      }
    } catch (E) {}

    getAppversion();
    getImeiNumber();
    //getting phone permission
    //Utils().getPermissionPhone();

    // prefs.clear();
    /*  getDeviceTokenToSendNotification().then((token) {
      SharedPreferences.getInstance().then((value) => {
        value.setString(
            "fcm_token", deviceTokenToSendPushNotification.toString())
      });
    Utils().customPrint("fcm_token : $deviceTokenToSendPushNotification");
    });*/
  }

  Future<void> cupertinoDialog(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'By proceeding you agree the following:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'I am 18 years or older and not a resident of the following states: Andhra Pradesh, Assam, Telangana, Orissa, Sikkim and Nagaland.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                  color: AppColor().clan_header_dark,
                ),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'DisAgree');
                },
                child: Text('DisAgree',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    )),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'Agree');
                  onSubmit(context);
                },
                child: Text('Agree',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().DartGreenColorLow,
                    )),
              ),
            ],
          );
        })) {
      case 'Agree':
        break;
      case 'DisAgree':
        Fluttertoast.showToast(msg: 'Oh! No... Try to provide you best');
        break;
    }
  }

  Future<void> onSubmitTrueCaller(String signature, String signatureAlgo,
      String payloadeV, Map<String, dynamic> payloade, String phone) async {
    Map<String, Object> map_ = new Map<String, Object>();
    map_["Phone Number"] = phone;
    cleverTapController.logEventCT(EventConstant.EVENT_Prelogin, map_);
    FirebaseEvent().firebaseEvent(EventConstant.EVENT_Prelogin_F, map_);

    //appsflyerController.logEventAf(EventConstant.EVENT_Prelogin, map);

    var only_number1;
    if (phone.isEmpty || phone == null) {
      Fluttertoast.showToast(msg: "Please Enter Number");
      return;
    }

    if (phone.length > 10) {
      only_number1 = phone.substring(phone.length - 10);
    } else {
      only_number1 = phone;
    }

    String deviceId = await getId();

    if (deviceTokenToSendPushNotification == null) {
      final FirebaseMessaging _fcm = FirebaseMessaging.instance;
      final token = await _fcm.getToken();
      deviceTokenToSendPushNotification = token.toString();
    }
    Utils().customPrint("email is ->${only_number1}");
    try {
      storeData = prefs.getString("mediaSource");
      debugPrint("storeData data Login${prefs.getString("mediaSource")}");
      debugPrint("storeData${storeData}");
    } on PlatformException {}
    Utils().customPrint('only_number.value ------> 2 ${only_number.value}');
    //pid work
    String pid_mediaSource = "";
    if (prefs.getString("mediaSource") != null &&
        prefs.getString("mediaSource") != '') {
      pid_mediaSource = prefs.getString("mediaSource");
    } else if (prefs.getString("pid") != null && prefs.getString("pid") != '') {
      pid_mediaSource = prefs.getString("pid");
    } else {
      pid_mediaSource = '';
    }

    //device info
    Map<String, dynamic> device_data = await Utils().getDeviceID();
    //Utils().customPrint('DEVICE TEST: ${device_data.toString()}');

    //end device info
    final param = {
      "mobileNumber": only_number1,
      "countryCode": AppString().txt_country,
      "referralCode": referral_code_s.value ?? "",
      "trueCaller": {
        "signature": signature,
        "signatureAlgorithm": signatureAlgo,
        "payload": payloadeV,
        "data": payloade,
      },
      "device": {
        "fcmId": deviceTokenToSendPushNotification,
        "info": deviceId,
        "type": device_type.value,
        "version": version,
        //new work
        "id": deviceId != null ? deviceId : "-",
        "name": device_data['device'] != null ? device_data['device'] : "-",
        "productName":
            device_data['product'] != null ? device_data['product'] : "-",
        "cpuName": "-",
        "IMEI": [imei_number.value],
        "platformVersion": version,
        "apiLevel": "33",
        "hardware":
            device_data['hardware'] != null ? device_data['hardware'] : "-",
        "mode": "-",
        "manufacturer": device_data['manufacturer'] != null
            ? device_data['manufacturer']
            : "-"
      },
      "registeredThrough": {
        "appVersion": code,
        "appType": storeType.value,
        "appPackage": packageName
      },
      "campaign": storeData != null
          ? {
              "mediaSource": pid_mediaSource ?? "",
              "campaign": prefs.getString("campaign") ?? "",
              "appsFlyerId": prefs.getString("campaignId") ?? "",
              "campaignId": prefs.getString("campaignId") ?? "",
              "campaignName": prefs.getString("campaignName") ?? "",
              "campaignType": prefs.getString("campaignType") ?? "",
              "isDeferred": prefs.getBool("isDeferred") ?? false,
              "afAdSet": prefs.getString("afAdSet") ?? "",
              "afAdSetId": prefs.getString("afAdSetId") ?? "",
              "afSub": prefs.getString("afSub") ??
                  "" /*,
              "pid": prefs.getString("pid") ?? ""*/
            }
          : {}
    };
    //FirebaseEvent().firebaseEvent('login_page_call', param);
    FirebaseEvent().firebaseEvent(EventConstant.EVENT_FIREBASE_Login, param);
    Utils().customPrint("api login request $param");
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getUserLogin(param);
    Utils().customPrint('response on view ${responsestr}');

    if (responsestr != null) {
      TrueCallerLogin loginResponseModel =
          TrueCallerLogin.fromJson(responsestr);
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      prefs.setString("token", loginResponseModel.auth.token);
      prefs.setString("user_id", loginResponseModel.userId);

      AppString.isUserFTR = false;
      if (loginResponseModel.isNew) {
        //for FTR user pop-up work
        //Utils().customPrint('getAppSetting ::::: NEW USER');
        //Fluttertoast.showToast(msg: "NEW USER");
        AppString.isUserFTR = true;
        //end
        Map<String, Object> map = new Map<String, Object>();
        //map["Phone Number"] = phone; //for CT ravi
        map["App Type"] = ApiUrl().isPlayStore ? "GMNG Esports" : "GMNG Pro";
        map["App Version"] = version ?? ""; //ravi
        map["Referal Code Used"] =
            '${referral_codeb.value} ${referral_code_s.value}'; //ravi
        map["Date"] = Utils().getTodayDates(); //ravi

        try {
          map["Campaign Name"] = prefs.getString("campaignName") ?? "";
          map["Campaign ID"] = prefs.getString("campaignId") ?? "";
          map["afAdSetId"] = prefs.getString("afAdSetId") ?? "";

          //map["Campaign Type"] = prefs.getString("campaignType") ?? "";
        } catch (E) {}
        map["Name"] = "Register Screen";
        map["user_id"] = loginResponseModel.userId;
        map["USER_ID"] = loginResponseModel.userId;
        map["code"] = "+91";
        appsflyerController.logEventAf("af_complete_registration", map);

        map["mobile"] = phone;
        cleverTapController.logEventCT(
            EventConstant.EVENT_CLEAVERTAB_Registration, map);

        FirebaseEvent()
            .firebaseEvent(EventConstant.EVENT_FIREBASE_Registration, map);
        //FaceBookEventController().logEventFacebook("fb_complete_registration", map);

        final params = {
          "event_name": "fb_complete_registration",
          "event_time": "${DateTime.now().millisecondsSinceEpoch}",
          "event_id": "",
          "action_source": "App",
          "user_data": {
            "client_ip_address": "",
            "client_user_agent": "Register Screen",
            "external_id": [loginResponseModel.userId],
          },
          "custom_data": {}
        };
        FacebookEventApi().FacebookEventC(params);
      } else {
        Map<String, Object> map = new Map<String, Object>();
        map["Name"] = "Login Screen";
        map["user_id"] = loginResponseModel.userId;
        map["USER_ID"] = loginResponseModel.userId;
        map["code"] = "+91";
        appsflyerController.logEventAf("af_login", map);
        map["mobile"] = phone;
        //FaceBookEventController().logEventFacebook("fb_login", map);
        cleverTapController.logEventCT(
            EventConstant.EVENT_CLEAVERTAB_Login, map);
        FirebaseEvent().firebaseEvent(EventConstant.EVENT_FIREBASE_Login, map);
      }

      Map<String, Object> map2 = new Map<String, Object>();
      map2["Name"] = "Otp verifiction Screen";
      //map2["mobile"] = phone;
      map2["user_id"] = loginResponseModel.userId;
      map2["USER_ID"] = loginResponseModel.userId;
      map2["code"] = "+91";
      appsflyerController.logEventAf(EventConstant.EVENT_OTP_VERIFICTION, map2);
      FaceBookEventController()
          .logEventFacebook(EventConstant.EVENT_OTP_VERIFICTION, map2);

      final params = {
        "event_name": "event_otp_verifiction",
        "event_time": "${DateTime.now().millisecondsSinceEpoch}",
        "event_id": "",
        "action_source": "App",
        "user_data": {
          "client_ip_address": "",
          "client_user_agent": "Login Screen",
          "external_id": [loginResponseModel.userId],
        },
        "custom_data": {}
      };
      FacebookEventApi().FacebookEventC(params);
      FirebaseEvent()
          .firebaseEvent(EventConstant.EVENT_FIREBASE_Registration, map2);
      Get.to(() => FavouriteGame());

      if (!Platfrom().isWeb()) {}
      try {
        prefs.setString("mediaSource", "");
        prefs.setString("campaign", "");
        prefs.setString("appsFlyerId", "");
        prefs.setString("afAdSetId", "");
        prefs.setString("campaignId", "");
        prefs.setString("campaignName", "");
        prefs.setString("campaignType", "");
        prefs.setString("afAdSet", "");
        prefs.setString("afAdSetId", "");
        prefs.setString("afSub", "");
        prefs.setBool("isDeferred", false);
      } catch (E) {}
    } else {
      //Navigator.of(context).pop();
    }
  }

  Future<void> onSubmit(BuildContext context) async {
    String phone = emailController.text;
    //prelogin events
    Map<String, Object> map_ = new Map<String, Object>();
    map_["Phone Number"] = phone;
    cleverTapController.logEventCT(EventConstant.EVENT_Prelogin, map_);
    FirebaseEvent().firebaseEvent(EventConstant.EVENT_Prelogin_F, map_);
    //appsflyerController.logEventAf(EventConstant.EVENT_Prelogin, map);

    var result = await validateMobile(phone);
    if (result == '0') {
      //return Utils.showCustomTosst("Please enter valid phone number");
      return;
    }
    //showProgressDismissible(context, '', false);
    showProgress(context, '', true);
    Utils().customPrint('Login pressed');
    Utils().customPrint('checkNumber :: $result');
    Utils().customPrint('only_number.value :: ${only_number.value}');

    String deviceId = await getId();
    Utils().customPrint("Phone is ->${phone}");

    if (deviceTokenToSendPushNotification == null) {
      final FirebaseMessaging _fcm = FirebaseMessaging.instance;
      final token = await _fcm.getToken();
      deviceTokenToSendPushNotification = token.toString();
    }

    try {
      //  SharedPreferences prefs = await SharedPreferences.getInstance();
      storeData = prefs.getString("mediaSource");
      Utils()
          .customPrint("storeData data Login${prefs.getString("mediaSource")}");
      Utils().customPrint("storeData${storeData}");
    } on PlatformException {}
    Utils().customPrint('only_number.value ------> 2 ${only_number.value}');
    //pid work
    String pid_mediaSource = "";
    if (prefs.getString("mediaSource") != null &&
        prefs.getString("mediaSource") != '') {
      pid_mediaSource = prefs.getString("mediaSource");
    } else if (prefs.getString("pid") != null && prefs.getString("pid") != '') {
      pid_mediaSource = prefs.getString("pid");
    } else {
      pid_mediaSource = '';
    }
    //device info
    Map<String, dynamic> device_data = await Utils().getDeviceID();
    //Utils().customPrint('DEVICE TEST: ${device_data.toString()}');

    //end device info

    final param = {
      "mobileNumber": only_number.value,
      "countryCode": AppString().txt_country,
      "referralCode": referral_code_s.value ?? "",
      "device": {
        "fcmId": deviceTokenToSendPushNotification,
        "info": deviceId,
        "type": device_type.value,
        "version": version,
        //new work
        "id": deviceId != null ? deviceId : "-",
        "name": device_data['device'] != null ? device_data['device'] : "-",
        "productName":
            device_data['product'] != null ? device_data['product'] : "-",
        "cpuName": "-",
        "IMEI": [imei_number.value],
        "platformVersion": version,
        "apiLevel": "33",
        "hardware":
            device_data['hardware'] != null ? device_data['hardware'] : "-",
        "mode": "-",
        "manufacturer": device_data['manufacturer'] != null
            ? device_data['manufacturer']
            : "-"
      },
      "registeredThrough": {
        "appVersion": code,
        "appType": ApiUrl().isPlayStore ? "playStore" : "website",
        "appPackage": packageName
      },
      "campaign": storeData != null
          ? {
              //"mediaSource": prefs.getString("mediaSource") ?? "",
              "mediaSource": pid_mediaSource ?? "",
              "campaign": prefs.getString("campaign") ?? "",
              "appsFlyerId": prefs.getString("appsFlyerId") ?? "",
              "campaignId": prefs.getString("campaignId") ?? "",
              "campaignName": prefs.getString("campaignName") ?? "",
              "campaignType": prefs.getString("campaignType") ?? "",
              "isDeferred": prefs.getBool("isDeferred") ?? false,
              "afAdSet": prefs.getString("afAdSet") ?? "",
              "afAdSetId": prefs.getString("afAdSetId") ?? "",
              "afSub": prefs.getString("afSub") ??
                  "" /*,
              "pid": prefs.getString("pid") ?? ""*/
            }
          : {}
    };
    //FirebaseEvent().firebaseEvent('login_page_call', param);
    FirebaseEvent().firebaseEvent(EventConstant.EVENT_FIREBASE_Login, param);
    //showProgress(context, '', true);
    debugPrint("api login request $param");
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getUserLogin(param);
    Utils().customPrint('response on view ${responsestr}');
    btnControllerProfile.reset();

    if (responsestr != null) {
      if (!Platfrom().isWeb()) {
        // final signature = await SmsAutoFill().getAppSignature;
        // debugPrint("signature" + signature);
      }

      LoginResponse LoginResponseLoginResponse =
          LoginResponse.fromJson(responsestr);
      try {
        if (LoginResponseLoginResponse.statusCode == null) {
          prefs = await SharedPreferences.getInstance();
          prefs.setString("user_id", LoginResponseLoginResponse.userId);
          prefs.setString("user_mobileNo", only_number.value);
          hideProgress(context);

          //  Get.to(()=>readotp());
          Get.to(() => OtpVerification(
              LoginResponseLoginResponse, "LOGIN", only_number.value));
        } else {
          Utils.showCustomTosst("${LoginResponseLoginResponse.error}}");
        }
      } catch (E) {}
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<String> validateMobile(String value) async {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      Fluttertoast.showToast(msg: 'Please enter mobile number');
      return '0';
    } else if (value.length != 10) {
      Fluttertoast.showToast(msg: 'Mobile number length must be 10');
      return '0';
    } else if (!regExp.hasMatch(value)) {
      Fluttertoast.showToast(msg: 'Please enter valid mobile number');
      return '0';
    } else {
      if (value.contains(" ")) {
        Fluttertoast.showToast(msg: 'Please remove space');
        return '0';
      } else {
        only_number.value = value;
        return '1';
      }
    }
  }

  void launchURLApp() async {
    var url = "https://gmng.pro";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    debugPrint("Token Value $deviceTokenToSendPushNotification");
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/progresbar_images.gif"))),
          ),
        );
      },
    );
  }

  getAppversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    code = packageInfo.buildNumber;
    packageName = packageInfo.packageName;
  }

  void showProgressbar(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.transparent,
            child: Image(
                height: 100,
                width: 100,
                //color: Colors.transparent,
                fit: BoxFit.fill,
                //   image:AssetImage("assets/images/pg.gif")),

                image: AssetImage("assets/images/progresbar_images.gif")),
          ),
        );
      },
    );
  }

  //get Device Info
  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (ApiUrl().isPlayStore) {
      storeType.value = "playStore";
    } else {
      storeType.value = "website";
    }
    if (Platform.isIOS) {
      device_type.value = "IOS";
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      device_type.value = "android";
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
      device_type.value = "website";
      var androidDeviceInfo = "";
      return androidDeviceInfo;
    }
  }

  Future<void> getImeiNumber() async {
    try {
      await AndroidMultipleIdentifier.requestPermission();
      //  idMapaa = await AndroidMultipleIdentifier.idMap,
      imei_number.value = await DeviceInformation.deviceIMEINumber;
      print("check imei data ${imei_number.value}");
    } catch (e) {
      imei_number.value = '0';
      print("check imei data ${imei_number.value} Error");
    }
  }
}
