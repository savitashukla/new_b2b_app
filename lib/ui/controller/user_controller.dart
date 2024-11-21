import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/model/ProfileModel/ProfileDataR.dart';
import 'package:gmng/model/VersionUpdate/Version_Update_Model.dart';
import 'package:gmng/notificationservice/LocalNotificationService.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/app_down_screen.dart';
import 'package:gmng/ui/controller/BaseController.dart';
import 'package:gmng/utills/OnlyOff.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:lottie/lottie.dart';
import 'package:onetaplogin/onetaplogin.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/AppSettingResponse.dart';
import '../../model/BannerModel/BannerResC.dart';
import '../../model/HomeModel/HomePageListModel.dart';
import '../../model/VIPModel/VIPModulesAll.dart';
import '../../model/VersionUpdate/Version_Update_Model.dart';
import '../../model/wallet/WalleModelR.dart';
import '../../res/AppColor.dart';
import '../../utills/event_tracker/FaceBookEventController.dart';
import '../../webservices/WebServicesHelper.dart';
import '../main/dashbord/DashBord.dart';
import 'FreshChatController.dart';

class UserController extends GetxController with GetTickerProviderStateMixin {
  var deposit_bal = 0.0.obs;
  var winning_bal = 0.0.obs;
  var bonuse_bal = 0.0.obs;
  var gmng_coin_bal = 0.0.obs;
  var homePageBalance = 0.0.obs;
  var showProgressDownloade = false.obs;
  var iswalletCheck = 1.obs;
  SharedPreferences prefs;
  SharedPreferences prefs1;
  var maxAmountWithdraw = 0.obs;
  var minAmountWithdraw = 0.obs;
  var maxAmountUserLavWithdraw = 0.obs;
  var minAmountUserLavWithdraw = 0.obs;
  var noOfTransactionsPerDayWithdraw = 0.obs;
  var version_Update_Model = Version_Update_Model().obs;
  var vipmodulesAllL = VIPModulesAll().obs;
  String type = "appStore";
  String _localPath;
  bool _permissionReady;
  TargetPlatform platform;
  String version;
  String code;
  String packageName;
  String token;
  String user_id;
  var currentIndex = 2.obs;
  List<WalletModel> wallateList;
  var wallet_s = false.obs;
  var profileDataRes = ProfileDataR().obs;
  Map<String, dynamic> getUserSemmaryV;
  var checkWallet_class_call = false.obs;
  var appSettingReponse = AppSettingResponse().obs;
  var progress = "0".obs;
  var progressPer = 0.0.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var permission;
  var addressLine1 = "".obs;
  var addressLine2 = "".obs;
  var clickDownload = false.obs;
  var gmngInstantCash = 0.0.obs;

  List<Placemark> placeMarks = [];

  // vip var
  var maxDailyLimitV = 0.obs;
  var maxAmountUserWithdrawVIP = 0.obs;
  var descriptionAccordingVIPLevel = "".obs;
  var transactionFee = 0.obs;
  var instantCashLimitNextLevel = 0.obs;
  var cashback_depositPercent = 0.obs;
  var current_vip_banner = ''.obs;
  AnimationController animationController;
  var descriptionAccordingNextVIPLevel = "".obs;
  //var userVipLevelString = 'test'.obs;
  //var instantCashLimitPrevLevel = 0.obs;
  //new variables for VIP modules
  var descriptionAccordingZeroVIPLevel = "".obs;
  var descriptionAccordingOneVIPLevel = "".obs;
  var descriptionAccordingTwoVIPLevel = "".obs;
  var descriptionAccordingThreeVIPLevel = "".obs;
  var descriptionAccordingFourVIPLevel = "".obs;
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)'); //used in removing 0 after decimal

  String getDepositeBalnace() {
    double varr = double.parse('${deposit_bal ?? "0"}');
    var deposite = varr / 100;
    var d2 = deposite.toPrecision(2);
    return d2.toString();
  }

  String getWinningBalance() {
    double varr = double.parse('${winning_bal ?? "0"}');
    var deposite = varr / 100;
    var d2 = deposite.toPrecision(2);
    return d2.toString();
  }

  String getTotalBalnace() {
    var total = (winning_bal / 100 + deposit_bal / 100);
    var d2 = total.toPrecision(2);
    Utils().customPrint("getWalletAmount total :: ${d2.toString()}");
    return d2.toString();
  }

  String getBonuseCashBalance() {
    var deposite = bonuse_bal;
    return deposite.toStringAsFixed(2).replaceAll(regex, '');
  }

  int getBonuseCashBalanceInt() {
    var deposite = bonuse_bal;
    return deposite.toInt();
  }

  String getGmngCoinCashBalance() {
    double deposite = (gmng_coin_bal ~/ 100) as double;
    var d2 = deposite.toPrecision(2);
    return d2.toString();
    return deposite.toString();
  }

  Future<void> getFavGmae() async {
    // AppString.gamesMyFavSelected.value=null;

    if (onlyOffi.gamesMyFavSelected.value != null &&
        onlyOffi.gamesMyFavSelected.value.length > 0) {
      // onlyOffi.gamesMyFavSelected.value.clear();
    }
    prefs = await SharedPreferences.getInstance();

    var getValues = prefs.getString("gamesMyFavStore");

    if (getValues != null) {
      var mapData = await jsonDecode(getValues);
      //   Games listasdfg=mapData;
      print("call selected game call ${mapData}");
      Games aaa = await Games.fromJson(mapData);
      if (aaa != null) {
        onlyOffi.gamesMyFavSelected.value = [];
        onlyOffi.gamesMyFavSelected.value.add(aaa);
        print(
            "call selected game call contro ${onlyOffi.gamesMyFavSelected.value.length}");
        //  Get.to(() => DashBord(2, ""));
      } else {
        print("else part call here");
      }
    } else {
      print("gamesMyFavStore call null ");
    }
  }

  String getUserReferalCode() {
    String referral_code = "";
    if (AppString.referAndEarn.value == "inactive") {
      referral_code = "N/A";
    } else {
      if (profileDataRes.value != null &&
          profileDataRes.value != null &&
          profileDataRes.value.referral != null &&
          profileDataRes.value.referral.length > 0) {
        for (Referral ref in profileDataRes.value.referral) {
          if (ref.isActive) {
            referral_code = ref.code;
          }
        }
      }
    }

    return referral_code;
  }

  double getInstantCashInt() {
    var instantCash = gmngInstantCash;
    if (instantCash > 0) {
      var instantCashInt = instantCash.toInt();
      return (instantCashInt / 100);
    } else {
      return instantCash.toDouble();
    }
  }

  var bannerModelRV = BannerModelR().obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    onlyOffi.countValuesAR.value = prefs.getInt("countValues");
    prefs1 = await SharedPreferences.getInstance();
    getFavGmae();

    prefs1.setString("page", "home");
    prefs1.setString("id_Call", "");

    FreshChatController freshChatController = Get.put(FreshChatController());

    await LocalNotificationService.onSelectNotificationLunchT();
    if (LocalNotificationService.onSelectNotification) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String channel_id = prefs.getString("channel_id");
      print("channel id $channel_id");
      if (channel_id.compareTo("65984") == 0) {
        Freshchat.showConversations(
            filteredViewTitle: "General", tags: ["general"]);
      } else if (channel_id.compareTo("166496") == 0) {
        Freshchat.showConversations(
            filteredViewTitle: "App Installation", tags: ["app installation"]);
      } else if (channel_id.compareTo("166493") == 0) {
        Freshchat.showConversations(
            filteredViewTitle: "Result Issue", tags: ["result issue"]);
      } else if (channel_id.compareTo("166166") == 0) {
        Freshchat.showConversations(filteredViewTitle: "KYC", tags: ["kyc"]);
      } else if (channel_id.compareTo("164716") == 0) {
        Freshchat.showConversations(
            filteredViewTitle: "Other", tags: ["other"]);
      } else if (channel_id.compareTo("166551") == 0) {
        Freshchat.showConversations(
            filteredViewTitle: "Withdrawal/Deposit",
            tags: ["withdrawal/deposit"]);
      } else if (channel_id.compareTo("166490") == 0) {
        Freshchat.showConversations(
            filteredViewTitle: "Sponsorships", tags: ["sponsorships"]);
      } else {
        SetFreshchatUser();
        Freshchat.showFAQ();
      }
    }

    try {
      await FirebaseCrashlytics.instance.setUserIdentifier(user_id);
    } catch (E) {}

    try {
      await FirebaseAnalytics.instance.setUserId(id: user_id);
    } catch (E) {}
    Utils().customPrint(
        "data is call home pages ============================>=${prefs.getString("page")}");
    Map<String, dynamic> map = {"user_id": "$user_id"};

    //FaceBookEventController().logEventFacebook("home_pages", map);
    //FaceBookEventController().logPurchase(10);
    getAppSetting();
    callAllProfileData();
    await getAppversion();

    //saving device info
    try {
      var map_deviceinfo = {
        "deviceId": await Utils().getUniqueDeviceId(),
        "appVersion": "${version.toString()}",
        "appType": "website", //need to update in esports|pro|apple|custom apps
        "appPackage": "${packageName.toString()}",
        "appCode": "${code.toString()}"
      };
      saveDeviceInfo(map_deviceinfo);

      //isPopUp banner
      Utils().getBannerAsPerPageType(token, AppString().appTypes, 'home');
    } catch (E) {}

    super.onInit();
  }

  @override
  void dispose() {
    //if (animationController != null) {
    animationController.dispose();
    //}
    super.dispose();
  }

  Future<void> getForceUpdate(BuildContext context) async {
    await getAppversion();
    var platform = "android";
    if (Platform.isIOS) {
      platform = "ios";
    }
    if (ApiUrl().isPlayStore) {
      type = "appStore";
    } else {
      type = "website";
    }
    Map<String, dynamic> response =
        await WebServicesHelper().getVersion_Update(token, type, platform);
    if (response != null) {
      version_Update_Model.value = Version_Update_Model.fromJson(response);

      //   showAlertDialog(context);
      if (version_Update_Model.value.data != null &&
          version_Update_Model.value.data.length > 0) {
        var server_version = version_Update_Model.value.data[0].version;
        Utils().customPrint("version code installed ${code}");
        Utils().customPrint("sever version code ${server_version}");
        Utils().customPrint(
            "version_Update_Model.value.data[0].isBlocked ${version_Update_Model.value.data[0].isBlocked}");

        if (version_Update_Model.value.data[0].isBlocked) {
          showBottomSheetDownloadNew(context);
        }

        if (int.parse(code) < int.parse(server_version)) {
          if (Platform.isIOS) {
            showAlertDialog(context);
            return;
          }
          if (Platform.isAndroid) {
            if (ApiUrl().isPlayStore) {
              //   showAlertDialog(context);
              //   return;
            } else {
              showBottomSheetDownloadNew(
                  context); // -----------------------------------------------------------
            }
          }
        } else {
          if (Platform.isAndroid) {
            _permissionReady = await _checkPermission();
            if (_permissionReady) {
              try {
                await _prepareSaveDir();
                if (_localPath != null && _localPath != '') {
                  var isExist = File("${_localPath}GMNG-pro.apk").existsSync();
                  Utils().customPrint('delete work file exists: $isExist');
                  if (isExist) {
                    File("${_localPath}GMNG-pro.apk")
                        .deleteSync(); //delete file
                    return;
                  }
                }
              } catch (e) {
                Utils().customPrint('delete work file error: ${e.toString()}');
              }
            } else {
              Fluttertoast.showToast(msg: "Please enable permission!");
            }
          }
        }
      }
    }
  }

  //playstore
  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Update"),
      onPressed: () async {
        if (Platform.isAndroid) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          var appPackageName = packageInfo.packageName;
          Utils().customPrint('appPackageName=> ${appPackageName}');
          try {
            launch("market://details?id=" + appPackageName);
          } on PlatformException {
            launch("https://play.google.com/store/apps/details?id=" +
                appPackageName);
          } finally {
            launch("https://play.google.com/store/apps/details?id=" +
                appPackageName);
          }
        } else {}

        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Update".tr,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
      ),
      content: Text("New version available".tr),
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

  //our force update popup
  void showBottomSheetDownload(BuildContext context) {
    Future<bool> _onWillPop() async {
      Fluttertoast.showToast(msg: "Please Update Application");
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
                              "New Updates",
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
                        height: 10,
                      ),
                      Container(
                          height: 100,
                          child: Image.asset("assets/images/logo_login.webp")),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => version_Update_Model.value != null
                            ? version_Update_Model.value.data.length > 0
                                ? Text(
                                    "${version_Update_Model.value.data[0].description ?? ""}",
                                    maxLines: 20,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontSize: 15),
                                  )
                                : Container(
                                    height: 0,
                                  )
                            : Container(
                                height: 0,
                              ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () async {
                          _permissionReady = await _checkPermission();
                          if (_permissionReady) {
                            try {
                              await _prepareSaveDir(); //creating local path
                              if (_localPath != '') {
                                var isExist = File("${_localPath}GMNG-pro.apk")
                                    .existsSync();
                                Utils().customPrint(
                                    'download work file exists: $isExist');
                                if (isExist) {
                                  Utils().customPrint(
                                      'download work return: $isExist');
                                  OpenFile.open(
                                      "${_localPath}GMNG-pro.apk"); //open for install
                                  return;
                                }
                              }

                              showProgressDownloade.value =
                                  true; //progressBar enable
                              await showBottomSheetDownloadNew(context);
                              //progressBar
                              Utils().customPrint(
                                  'download work download URL: ${version_Update_Model.value.data[0].downloadUrl}');
                              Utils().customPrint(
                                  'download work FILE PATH: ${_localPath}GMNG-pro.apk');

                              await Dio().download(
                                version_Update_Model.value.data[0].downloadUrl,
                                "${_localPath}GMNG-pro.apk",
                                onReceiveProgress: (rcv, total) {
                                  //print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
                                  progress.value =
                                      ((rcv / total) * 100).toStringAsFixed(0);
                                  progressPer.value =
                                      double.parse(progress.value) / 100;
                                  Timer(
                                      Duration(
                                          seconds: int.parse(progress.value)),
                                      () {
                                    Utils().customPrint(
                                        "Yeah, this line is printed after 3 second");
                                  });
                                },
                              );
                              Utils().customPrint("Download Completed.");
                              Utils().customPrint(
                                  'download work complete: ${_localPath}GMNG-pro.apk');
                              showProgressDownloade.value = false;
                              OpenFile.open("${_localPath}GMNG-pro.apk");
                            } catch (e) {
                              Utils().customPrint(
                                  'download work error: ${e.toString()}');
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "plz enable permission");
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            top: 15,
                            bottom: 15,
                          ),
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    ImageRes().rectangle_orange_gradient_box)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Update",
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

  Future<void> getLocationPer() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location Permission Denied');
        return Future.error('Location permissions are denied');
      }
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  getAppversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    code = packageInfo.buildNumber;
    packageName = packageInfo.packageName;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath());

    Utils().customPrint('download work local path: ${_localPath}');
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    /*else{
     Utils().customPrint("_localPath$_localPath");
    }*/
  }

  onTapped(int index) {
    if (currentIndex.value != index) {
      if (index == 0) {
        DashBord(0, "");
        /*     controller.startInit();
          Map<String, dynamic> parmse = {};
          FirebaseEvent().firebaseEvent("subscription_page_opens", parmse);*/
      }

      if (index == 1) {
        DashBord(1, "");
        /* Map<String, dynamic> parmse = {};
          FirebaseEvent().firebaseEvent("calendar_open", parmse);

          _calendarController.startInit();*/
      }

      if (index == 2) {
        //   homeController.startInit();
      }

      if (index == 3) {
        DashBord(3, "");
        // _orderHistoryController.startInit();
      }

      if (index == 4) {
        DashBord(4, "");
        // profileController.startInit(context);
      }
      currentIndex.value = index;
    }
  }

  Future<void> callAllProfileData() async {
    await getProfileData();
    getVIPLevel();
    getWalletAmount();
  }

  Future<void> getWalletAmount() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    if (user_id != null && user_id != "") {
      Map<String, dynamic> responsestr =
          await WebServicesHelper().getWalletData(token, user_id);

      if (responsestr != null) {
        WalletModelR walletModelR = WalletModelR.fromJson(responsestr);

        // wallateList.addAll(walletModelR.data);
        for (int i = 0; i < walletModelR.data.length; i++) {
          if (walletModelR.data[i].type.compareTo("deposit") == 0) {
            deposit_bal.value = walletModelR.data[i].balance;
            Utils().customPrint(
                "getWalletAmount deposit_bal :: ${deposit_bal.value}");
          } else if (walletModelR.data[i].type.compareTo("winning") == 0) {
            winning_bal.value = walletModelR.data[i].balance;
            Utils().customPrint(
                "getWalletAmount winning_bal:: ${winning_bal.value}");
          } else if (walletModelR.data[i].type.compareTo("bonus") == 0) {
            bonuse_bal.value =
                double.parse((walletModelR.data[i].balance).toStringAsFixed(2));
          } else if (walletModelR.data[i].type.compareTo("coin") == 0) {
            gmng_coin_bal.value = walletModelR.data[i].balance;
          } else if (walletModelR.data[i].type.compareTo("instantCash") == 0) {
            print("call instantCash values");
            gmngInstantCash.value = walletModelR.data[i].balance;
            SharedPreferences prefs = await SharedPreferences.getInstance();

            print(
                "call instantCash values receive values ${AppString.instanceAddDepositTime}");
            if (AppString.instanceAddDepositTime) {
              prefs.setDouble("instantCashAddedS", gmngInstantCash.value);
              AppString.instanceAddDepositTime = false;
            } else {
              AppString.instanceAddDepositTime = false;
              var instantCashAddedGet = prefs.getDouble("instantCashAddedS");
              print(
                  "call instantCash values instantCashAddedGet ${instantCashAddedGet}");
              print(
                  "call instantCash values gmngInstantCash.value ${gmngInstantCash.value}");
              if (instantCashAddedGet != null) {
                if (gmngInstantCash.value > instantCashAddedGet) {
                  double greaterAmount =
                      gmngInstantCash.value - instantCashAddedGet;
                  print("get Instance values$greaterAmount");
                  double instantCashAddedLess5 =
                      prefs.getDouble("instantCashAddedLess5");

                  if (greaterAmount >= 500) {
                    print(
                        "call instantCash values gmngInstantCash.value > instantCashAddedGet");
                    prefs.setDouble("instantCashAddedLess5", 0);
                    showCustomDialogConfettiNew();
                    prefs.setDouble("instantCashAddedS", gmngInstantCash.value);
                  } else if (instantCashAddedLess5 != null &&
                      instantCashAddedLess5 >= 400) {
                    prefs.setDouble("instantCashAddedLess5", 0);
                    prefs.setDouble("instantCashAddedS", gmngInstantCash.value);
                    showCustomDialogConfettiNew();
                  } else if (instantCashAddedLess5 != null &&
                      instantCashAddedLess5 < 500) {
                    print(
                        "check grater values ${instantCashAddedLess5 + greaterAmount}");

                    if ((instantCashAddedLess5 + greaterAmount) >= 500) {
                      prefs.setDouble("instantCashAddedLess5", 0);
                      prefs.setDouble(
                          "instantCashAddedS", gmngInstantCash.value);
                      showCustomDialogConfettiNew();
                    } else {
                      prefs.setDouble("instantCashAddedLess5",
                          instantCashAddedLess5 + greaterAmount);
                      prefs.setDouble(
                          "instantCashAddedS", gmngInstantCash.value);
                    }
                  } else {
                    prefs.setDouble("instantCashAddedLess5", greaterAmount);
                    prefs.setDouble("instantCashAddedS", gmngInstantCash.value);
                  }
                } else {
                  prefs.setDouble("instantCashAddedS", gmngInstantCash.value);
                  print(
                      "call instantCash values ${gmngInstantCash.value} store  ${instantCashAddedGet} ${gmngInstantCash.value > instantCashAddedGet}");
                  print("call instantCash values  low ");
                }
              } else {
                print("call instantCash values else ");
                prefs.setDouble("instantCashAddedS", gmngInstantCash.value);
              }
            }
          }
        }
        var profile = {
          'Winning Balance': getWinningBalance(),
          'Deposit Balance': getDepositeBalnace(),
          'Bonus Balance': getBonuseCashBalance(),
        };
        CleverTapController cleverTapController =
            Get.put(CleverTapController());
        cleverTapController.setUserProfile(profile);
        homePageBalance.value = deposit_bal.value + winning_bal.value;
      } else {
        // Fluttertoast.showToast(msg: "Some Error");
      }
    }
  }

  Future<void> SetFreshchatUser() async {
    try {
      FreshchatUser freshchatUser = await Freshchat.getUser;
      if (profileDataRes.value.username != null) {
        freshchatUser.setFirstName(profileDataRes.value.username);
      }

      if (profileDataRes.value.name != null &&
          profileDataRes.value.name.last != null) {
        freshchatUser.setLastName(profileDataRes.value.name.last);
      }
      if (profileDataRes.value.email != null &&
          profileDataRes.value.email.address != null) {
        freshchatUser.setEmail(profileDataRes.value.email.address);
      }
      if (profileDataRes.value.mobile != null &&
          profileDataRes.value.mobile.number != null) {
        freshchatUser.setPhone(
            "+91", profileDataRes.value.mobile.number.toString());
      }
      Freshchat.setUser(freshchatUser);
    } catch (e) {}
  }

  Future<void> showFAQ() async {
    Freshchat.showFAQ();
  }

  Future<void> getUserProfileSummary() async {
    getUserSemmaryV = null;

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    if (user_id != null && user_id != '') {
      Map<String, dynamic> response =
          await WebServicesHelper().getUserProfileSummary(token, user_id);
      if (response != null) {
        getUserSemmaryV = response;
      }
    }
  }

  /* Future<void> getVIPLevel() async {
    if (token == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      // user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> response =
        await WebServicesHelper().getVIPLevel(token, "");
    if (response != null) {
      print("getVIPLevel res..  ${response}");

      vipmodulesAllL.value = VIPModulesAll.fromJson(response);

      for (int index = 0; index < vipmodulesAllL.value.data.length; index++) {
        print(
            "getVIPLevel description ${vipmodulesAllL.value.data[index].description}");
        if (profileDataRes.value.level.id != null) {
          if (profileDataRes.value.level.id
                  .compareTo(vipmodulesAllL.value.data[index].id) ==
              0) {
            print(
                "getVIPLevel description matched ${vipmodulesAllL.value.data[index].id}");
            print(
                "getVIPLevel description matched ${vipmodulesAllL.value.data[index].description}");
            descriptionAccordingVIPLevel.value =
                vipmodulesAllL.value.data[index].description;
            maxDailyLimitV.value=vipmodulesAllL.value.data[index].withdrawal.maxDailyLimit;

            maxAmountUserWithdrawVIP.value=vipmodulesAllL.value.data[index].withdrawal.perTransactionLimit~/100;
            transactionFee.value=vipmodulesAllL.value.data[index].withdrawal.fee;
          }
        }
      }
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }*/

  Widget showDialogProgressDownloade(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Center(
              child: Container(
                padding:
                    EdgeInsets.only(left: 11, right: 11, top: 11, bottom: 10),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/store_back.png"))),
                //    height: 270,
                child: Obx(
                  () => CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 20.0,
                    //animation: true,
                    percent: progressPer.value,
                    center: Text(
                      "${progress.value}.0%",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24.0,
                          color: Colors.white),
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 11),
                      child: const Text(
                        "Downloading ...",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColor().colorPrimary,
                  ),
                ),
              ),
            ));
      },
    );
  }

  //GupShup API Otp-In API
  Future<void> getGupShupOptInApi(Map<String, dynamic> param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Map<String, dynamic> response =
        await WebServicesHelper().getGupShupOptInApi(token, param);

    /* Utils().customPrint('response $response');
    if (response != null) {
    } else {
      Utils().customPrint('response promo code ERROR');
    }*/
  }

  void showBottomSheetDownloadNew(BuildContext context) {
    //Fluttertoast.showToast(msg: "Please Update Application");
    Future<bool> _onWillPop() async {
      Fluttertoast.showToast(msg: "Please Update Application");
      return false;
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, top: 0),
              //  height: 500,
              child: WillPopScope(
                onWillPop: _onWillPop,
                child: Stack(
                  children: [
                    Container(
                      height: 400,
                      child: Image(
                          fit: BoxFit.fill,
                          image:
                              AssetImage(ImageRes().new_rectangle_box_blank)),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          left: 10,
                          right: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 35,
                          ),
                          Container(
                              height: 40,
                              child: Image.asset("assets/images/update.gif")),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Update App",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: FontSizeC().front_larger23,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Obx(
                            () => version_Update_Model.value != null
                                ? version_Update_Model.value.data.length > 0 &&
                                        version_Update_Model
                                                .value.data[0].description !=
                                            null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        margin: const EdgeInsets.only(
                                            top: 25, bottom: 25),
                                        decoration: BoxDecoration(
                                            color: AppColor().reward_grey_bg,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10, left: 20),
                                          child: Text(
                                            "${version_Update_Model.value.data[0].description ?? ""}",
                                            textScaleFactor: 1.0,
                                            maxLines: 20,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 50,
                                      )
                                : Container(
                                    height: 60,
                                  ),
                          ),
                          Obx(
                            () => clickDownload.isTrue
                                ? Column(
                                    children: [
                                      Container(
                                        height: 6,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 70, vertical: 3),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                        ),
                                        child: Obx(
                                          () => LinearProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                AppColor().colorPrimary),
                                            backgroundColor:
                                                AppColor().colorGray,
                                            value: progressPer.value,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await _prepareSaveDir(); //creating local path
                                          if (_localPath != '') {
                                            var isExist = File(
                                                    "${_localPath}GMNG-pro.apk")
                                                .existsSync();
                                            Utils().customPrint(
                                                'download work file exists: $isExist');
                                            if (isExist) {
                                              prefs = await SharedPreferences
                                                  .getInstance();
                                              bool downloade_done = prefs
                                                  .getBool("downloade_done");

                                              Utils().customPrint(
                                                  'download work return: $isExist');

                                              if (downloade_done != null) {
                                                if (downloade_done) {
                                                  progressPer.value = 1;
                                                  OpenFile.open(
                                                      "${_localPath}GMNG-pro.apk"); //open for install
                                                  return;
                                                }
                                              } //open for install
                                              return;
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                          height: 42,
                                          // margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            boxShadow: const [
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
                                            border: Border.all(
                                                color: AppColor().whiteColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            // color: AppColor().whiteColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "DOWNLOADING",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      clickDownload.value = true;
                                      _permissionReady =
                                          await _checkPermission();
                                      if (_permissionReady) {
                                        try {
                                          await _prepareSaveDir(); //creating local path
                                          if (_localPath != '') {
                                            var isExist = File(
                                                    "${_localPath}GMNG-pro.apk")
                                                .existsSync();
                                            Utils().customPrint(
                                                'download work file exists: $isExist');

                                            if (isExist) {
                                              prefs = await SharedPreferences
                                                  .getInstance();
                                              bool downloade_done = prefs
                                                  .getBool("downloade_done");

                                              Utils().customPrint(
                                                  'download work return: $isExist');

                                              if (downloade_done != null) {
                                                if (downloade_done) {
                                                  progressPer.value = 1;
                                                  //   Navigator.pop(context);
                                                  OpenFile.open(
                                                      "${_localPath}GMNG-pro.apk"); //open for install
                                                  return;
                                                }
                                              }
                                            }
                                          }
                                          Utils().customPrint(
                                              'download work download URL: ${version_Update_Model.value.data[0].downloadUrl}');
                                          Utils().customPrint(
                                              'download work FILE PATH: ${_localPath}GMNG-pro.apk');

                                          await Dio().download(
                                            version_Update_Model
                                                .value.data[0].downloadUrl,
                                            "${_localPath}GMNG-pro.apk",
                                            onReceiveProgress:
                                                (rcv, total) async {
                                              progress.value =
                                                  ((rcv / total) * 100)
                                                      .toStringAsFixed(0);
                                              progressPer.value =
                                                  double.parse(progress.value) /
                                                      100;
                                              //   print("downloade done");
                                            },
                                          );

                                          if (progressPer.value == 1) {
                                            prefs = await SharedPreferences
                                                .getInstance();
                                            prefs.setBool(
                                                "downloade_done", true);
                                          }

                                          print("downloade done");

                                          OpenFile.open(
                                              "${_localPath}GMNG-pro.apk");
                                        } catch (e) {
                                          Utils().customPrint(
                                              'download work error: ${e.toString()}');
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "plz enable permission");
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .4,
                                      height: 42,
                                      // margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        boxShadow: const [
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
                                        border: Border.all(
                                            color: AppColor().whiteColor,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                        // color: AppColor().whiteColor
                                      ),
                                      child: Center(
                                        child: Text(
                                          "DOWNLOAD",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Please sit back and relax",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: FontSizeC().front_very_small12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> getAppSetting() async {
    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> response =
        await WebServicesHelper().getAppSetting(token, user_id);
    if (response != null) {
      Utils().customPrint('getAppSetting ::::: data ${response}');

      appSettingReponse.value = null;
      appSettingReponse.value = AppSettingResponse.fromJson(response);
      Utils().customPrint(
          "minAmount deposit==> ${appSettingReponse.value.deposit.minAmount}");

      minAmountWithdraw.value =
          appSettingReponse.value.withdrawRequest.minAmount ~/ 100;
      maxAmountWithdraw.value =
          appSettingReponse.value.withdrawRequest.maxAmount ~/ 100;
      Utils().customPrint(
          "data max==> ${appSettingReponse.value.withdrawRequest.maxAmount}");

      //FTR user work popup
      //Utils().customPrint('getAppSetting ::::: ${appSettingReponse.value.newUserFlow[0].gameId}');
      //Utils().customPrint('getAppSetting ::::: ${appSettingReponse.value.newUserFlow[0].eventIds}');
      Utils().customPrint(
          'getAppSetting ::::: ${appSettingReponse.value.newUserFlow.length}');

      //saving AppDown/WalletDown more... Values
      for (FeaturesStatus obj in appSettingReponse.value.featuresStatus) {
        print('getAppSetting ::::: ${obj.id} - ${obj.status}');
        if (obj.id == 'offerWallLoot' && obj.status == 'active') {
          AppString.offerWallLoot.value = 'active';
        } else if (obj.id == 'offerWallLoot' && obj.status == 'inactive') {
          AppString.offerWallLoot.value = 'inactive';
        }
        if (obj.id == 'profileUpdate' && obj.status == 'active') {
          AppString.profileUpdate.value = 'active';
        } else if (obj.id == 'profileUpdate' && obj.status == 'inactive') {
          AppString.profileUpdate.value = 'inactive';
        }
        if (obj.id == 'buyStoreItem' && obj.status == 'active') {
          AppString.buyStoreItem.value = 'active';
        } else if (obj.id == 'buyStoreItem' && obj.status == 'inactive') {
          AppString.buyStoreItem.value = 'inactive';
        }
        if (obj.id == 'linkAccount' && obj.status == 'active') {
          AppString.linkAccount.value = 'active';
        } else if (obj.id == 'linkAccount' && obj.status == 'inactive') {
          AppString.linkAccount.value = 'inactive';
        }
        if (obj.id == 'joinContest' && obj.status == 'active') {
          AppString.joinContest.value = 'active';
        } else if (obj.id == 'joinContest' && obj.status == 'inactive') {
          AppString.joinContest.value = 'inactive';
        }
        if (obj.id == 'createTeam' && obj.status == 'active') {
          AppString.createTeam.value = 'active';
        } else if (obj.id == 'createTeam' && obj.status == 'inactive') {
          AppString.createTeam.value = 'inactive';
        }
        if (obj.id == 'joinClan' && obj.status == 'active') {
          AppString.joinClan.value = 'active';
        } else if (obj.id == 'joinClan' && obj.status == 'inactive') {
          AppString.joinClan.value = 'inactive';
        }
        if (obj.id == 'leaveClan' && obj.status == 'active') {
          AppString.leaveClan.value = 'active';
        } else if (obj.id == 'leaveClan' && obj.status == 'inactive') {
          AppString.leaveClan.value = 'inactive';
        }
        if (obj.id == 'acceptTeamInvitation' && obj.status == 'active') {
          AppString.acceptTeamInvitation.value = 'active';
        } else if (obj.id == 'acceptTeamInvitation' &&
            obj.status == 'inactive') {
          AppString.acceptTeamInvitation.value = 'inactive';
        }
        if (obj.id == 'esportPaymentEnable' && obj.status == 'active') {
          AppString.esportPaymentEnable.value = 'active';
        } else if (obj.id == 'esportPaymentEnable' &&
            obj.status == 'inactive') {
          AppString.esportPaymentEnable.value = 'inactive';
        }
        if (obj.id == 'appUp' && obj.status == 'inactive') {
          Get.to(() => AppDownScreen());
          break;
        }
        if (obj.id == 'bureauIdEnable' && obj.status == 'active') {
          AppString.bureauIdEnable.value = 'active';
        } else if (obj.id == 'bureauIdEnable' && obj.status == 'inactive') {
          AppString.bureauIdEnable.value = 'inactive';
        }
      }
    } else {
      //Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getProfileData() async {
    // Utils().customPrint("setUserProfile  ------------------starting");
    profileDataRes.value = null;

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }

    if (user_id != null && user_id != '') {
      Map<String, dynamic> response =
          await WebServicesHelper().getProfileData(token, user_id);

      try {
        if (response != null) {
          profileDataRes.value = ProfileDataR.fromJson(response);

          AppString.mobile = profileDataRes.value.mobile.number.toString();
          AppString.email = profileDataRes.value.email != null &&
                  profileDataRes.value.email.address != null
              ? profileDataRes.value.email.address
              : "test@gmng.pro";
          AppString.username = profileDataRes.value.name != null &&
                  profileDataRes.value.name.first != null &&
                  profileDataRes.value.name.first.isNotEmpty
              ? profileDataRes.value.name.first
              : profileDataRes.value.username;

          prefs.setString("user_name", "${profileDataRes.value.username}");

          CleverTapController cleverTapController =
              Get.put(CleverTapController());
          var profile = {
            'Name': profileDataRes.value.name != null &&
                    profileDataRes.value.name.first != null
                ? profileDataRes.value.name.first
                : profileDataRes.value.username,
            'Identity':
                profileDataRes.value.id != null && profileDataRes.value.id != ""
                    ? profileDataRes.value.id
                    : "-",
            'UserID':
                profileDataRes.value.id != null && profileDataRes.value.id != ""
                    ? profileDataRes.value.id
                    : "-",
            'Email': profileDataRes.value.email != null &&
                    profileDataRes.value.email.address != null
                ? profileDataRes.value.email.address
                : "-", //testing@gmng.pro or dont pass
            'Phone': profileDataRes.value.mobile != null &&
                    profileDataRes.value.mobile.number != null
                ? "+91" + profileDataRes.value.mobile.number.toString()
                : "-", //123456789
            'Photo': profileDataRes.value.photo != null &&
                    !profileDataRes.value.photo.url.isEmpty
                ? profileDataRes.value.photo.url
                : "-", //n/a
            'UserName': profileDataRes.value.username != null
                ? profileDataRes.value.username
                : "-", //testUser
            'Current App Version': code != null && code != "" ? code : "-",
            'MSG-email': true,
            'MSG-push': true,
            'MSG-sms': true,
            'MSG-whatsapp': true,
            'Is VIP': profileDataRes.value != null &&
                    profileDataRes.value.level != null &&
                    profileDataRes.value.level.value > 0
                ? true
                : false,
            'Vip Level': profileDataRes.value != null &&
                    profileDataRes.value.level != null
                ? profileDataRes.value.level.value
                : '0'
          };

          prefs.setString(
              "user_photo",
              profileDataRes.value.photo != null &&
                      profileDataRes.value.photo != null &&
                      profileDataRes.value.photo.url != null
                  ? profileDataRes.value.photo.url
                  : "-");

          cleverTapController.updateUserProfile(profile);

          SetFreshchatUser();

          if (profileDataRes.value.settings != null &&
              profileDataRes.value.settings.withdrawRequest != null &&
              profileDataRes.value.settings.withdrawRequest.maxAmount != null &&
              profileDataRes.value.settings.withdrawRequest.minAmount != null) {
            maxAmountUserLavWithdraw.value =
                profileDataRes.value.settings.withdrawRequest.maxAmount ~/ 100;
            minAmountUserLavWithdraw.value =
                profileDataRes.value.settings.withdrawRequest.minAmount ~/ 100;
            noOfTransactionsPerDayWithdraw.value = profileDataRes
                .value.settings.withdrawRequest.noOfTransactionsPerDay;
          }
          if (profileDataRes.value.serverTime != null &&
              profileDataRes.value.serverTime != '') {
            AppString.serverTime = profileDataRes.value.serverTime;
            Utils().customPrint(
                'profileDataRes serverTime: ${Utils().getStartTimeHHMMSS(profileDataRes.value.serverTime)}');
            Utils().customPrint(
                'profileDataRes serverTime: ${AppString.serverTime}');
          }
          //gupshup opt in work
          if (profileDataRes.value.gupshupOptInId == null ||
              profileDataRes.value.gupshupOptInId == '') {
            final param = {
              "phoneNumber": profileDataRes.value.mobile != null &&
                      profileDataRes.value.mobile.number != null
                  ? "+91" + profileDataRes.value.mobile.number.toString()
                  : ""
            };

            getGupShupOptInApi(param);
            Utils().customPrint(
                'profileDataRes gupshupOptInId: ${profileDataRes.value.gupshupOptInId}');
          } else {
            Utils().customPrint(
                'profileDataRes gupshupOptInId: ${profileDataRes.value.gupshupOptInId}');
          }
          //Bureau ID work
          if (AppString.bureauIdEnable.value == 'active') {
            if (profileDataRes.value.bureauSecurityData != null &&
                profileDataRes.value.bureauSecurityData.length == 0) {
              //call SDK methods
              //transaction random
              Utils().customPrint('Bureau ID Implementations');
              var transactionID = user_id + Utils().getRandomString(10);
              var status = await Onetaplogin.submitDeviceIntelligence(
                  ApiUrl.BUREAU_CLIENT_ID,
                  transactionID, //this need to be change everytime
                  user_id,
                  env: "Sandbox"); //Sandbox//Production
              print("status this is call $status");

              if (status.toString() == "Success") {
                //fetchDataFromBureauSendToOurServer(transactionID);
                Utils().customPrint(
                    'profileDataRes bureauSecurityData 1: ${profileDataRes.value.bureauSecurityData}');
              }
            } else {
              Utils().customPrint(
                  'profileDataRes bureauSecurityData 2: ${profileDataRes.value.bureauSecurityData}');
            }
          } else {
            Utils().customPrint(
                'profileDataRes bureauSecurityData inactive: ${profileDataRes.value.bureauSecurityData}');
          }
          //Bureau ID Implementation
          if (profileDataRes.value.settings != null &&
              profileDataRes.value.settings.featuresStatus != null &&
              profileDataRes.value.settings.featuresStatus.length > 0) {
            //here we need to code for blocking UIs
            //..
            //..
            for (FeaturesStatus obj
                in profileDataRes.value.settings.featuresStatus) {
              //case 1
              if (obj.id == 'promoCodes' && obj.status == 'active') {
                AppString.promoCodes.value = 'active';
              } else if (obj.id == 'promoCodes' && obj.status == 'inactive') {
                AppString.promoCodes.value = 'inactive';
              }
              //case 2
              if (obj.id == 'offerWallLoot' && obj.status == 'active') {
                AppString.offerWallLoot.value = 'active';
              } else if (obj.id == 'offerWallLoot' &&
                  obj.status == 'inactive') {
                AppString.offerWallLoot.value = 'inactive';
              }
              //case 3
              if (obj.id == 'referAndEarn' && obj.status == 'active') {
                AppString.referAndEarn.value = 'active';
              } else if (obj.id == 'referAndEarn' && obj.status == 'inactive') {
                AppString.referAndEarn.value = 'inactive';
              }
            }

            Utils()
                .customPrint('BureauID Dynamic ${AppString.promoCodes.value}');
            Utils().customPrint(
                'BureauID Dynamic ${AppString.offerWallLoot.value}');
            Utils().customPrint(
                'BureauID Dynamic ${AppString.referAndEarn.value}');
          } else {
            Utils().customPrint('BureauID Dynamic NA');
          }
        }

        // vip cong.. pop check
        try {
          //dynamic work
          if (profileDataRes.value.level != null &&
              profileDataRes.value.level.value > 0) {
            prefs = await SharedPreferences.getInstance();
            bool become_vip_yes = prefs
                .getBool("become_vip_yes${profileDataRes.value.level.value}");
            Utils().customPrint("become_vip_yes $become_vip_yes");
            if (become_vip_yes == null || become_vip_yes) {
              prefs.setBool(
                  "become_vip_yes${profileDataRes.value.level.value}", false);
              Utils().VIPCongratulation(profileDataRes.value.level.value);
            }
          }

          //taking total deposit --deposit_from_bank from user api
          //Utils().customPrint('Vip level testing: ${profileDataRes.value.stats.depositFromBank.value}');
          //Utils().customPrint('profileDataRes deposit: ${profileDataRes.value.depositMethods.length}');
        } catch (E) {}
      } catch (e) {
        Utils().customPrint("setUserProfile  ------------------ERROR $e");
      }
    } else {
      Utils().customPrint("setUserProfile  ------------------ null");
    }
  }

  Future<void> getVIPLevel() async {
    if (token == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      // user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> response =
        await WebServicesHelper().getVIPLevel(token, "");
    if (response != null) {
      print("getVIPLevel1 res..  ${response}");

      vipmodulesAllL.value = VIPModulesAll.fromJson(response);

      for (int index = 0; index < vipmodulesAllL.value.data.length; index++) {
        if (profileDataRes.value.level != null &&
            profileDataRes.value.level.id != null) {
          if (profileDataRes.value.level.id ==
              vipmodulesAllL.value.data[index].id) {
            //print("getVIPLevel1 description matched ${vipmodulesAllL.value.data[index].id}");
            //print("getVIPLevel1 description matched ${vipmodulesAllL.value.data[index].description}");

            descriptionAccordingVIPLevel.value =
                vipmodulesAllL.value.data[index].description;
            maxDailyLimitV.value =
                vipmodulesAllL.value.data[index].withdrawal.maxDailyLimit;

            //perTransactionLimit
            maxAmountUserWithdrawVIP.value = vipmodulesAllL
                        .value.data[index].withdrawal.perTransactionLimit !=
                    null
                ? vipmodulesAllL
                        .value.data[index].withdrawal.perTransactionLimit ~/
                    100
                : null;
            //transactionFee
            transactionFee.value =
                vipmodulesAllL.value.data[index].withdrawal.fee != null
                    ? vipmodulesAllL.value.data[index].withdrawal.fee
                    : null;

            //cashback depositPercent
            cashback_depositPercent
                .value = vipmodulesAllL.value.data[index].cashback != null &&
                    vipmodulesAllL.value.data[index].cashback.depositPercent !=
                        null
                ? vipmodulesAllL.value.data[index].cashback.depositPercent
                : null;

            //banner current of VIP level
            try {
              current_vip_banner.value =
                  vipmodulesAllL.value.data[index].banner.url;
            } catch (e) {}
          }

          //saving vip levels desc
          if (vipmodulesAllL.value.data[index].value == 0) {
            descriptionAccordingZeroVIPLevel.value =
                vipmodulesAllL.value.data[index].description;
          } else if (vipmodulesAllL.value.data[index].value == 1) {
            descriptionAccordingOneVIPLevel.value =
                vipmodulesAllL.value.data[index].description;
          } else if (vipmodulesAllL.value.data[index].value == 2) {
            descriptionAccordingTwoVIPLevel.value =
                vipmodulesAllL.value.data[index].description;
          } else if (vipmodulesAllL.value.data[index].value == 3) {
            descriptionAccordingThreeVIPLevel.value =
                vipmodulesAllL.value.data[index].description;
          } else if (vipmodulesAllL.value.data[index].value == 4) {
            descriptionAccordingFourVIPLevel.value =
                vipmodulesAllL.value.data[index].description;
          }
        } else {
          //print("getVIPLevel1 description user level ${'NULL'} vip: ${vipmodulesAllL.value.data[index].id}");
        }
      }
      //code for banner`
      onlyOffi.userVipLevelList.clear();
      //onlyOffi.userVipLevelString = '';
      String userVipLevelStringHelper = '';
      var level =
          profileDataRes.value != null && profileDataRes.value.level != null
              ? profileDataRes.value.level.value
              : -1; // profileDataRes.value.level.value;

      //dynamic work
      for (int index = 0; index < vipmodulesAllL.value.data.length; index++) {
        //print("getVIPLevel1 ----- ${level}");
        if (vipmodulesAllL.value.data[index].value >= level) {
          onlyOffi.userVipLevelList.value
              .add(vipmodulesAllL.value.data[index].id);
          userVipLevelStringHelper += vipmodulesAllL.value.data[index].id + ',';
        }
        if (vipmodulesAllL.value.data[index].value == (level + 1)) {
          instantCashLimitNextLevel.value =
              vipmodulesAllL.value.data[index].criteria.instantCashLimit;
          descriptionAccordingNextVIPLevel.value =
              vipmodulesAllL.value.data[index].description;
          print("getVIPLevel1 ----- ${instantCashLimitNextLevel.value}");
        }
      }

      //end

      //static work
      /*if (level == 4) {
      } else if (level == 3) {
      } else if (level == 2) {
        for (int index = 0; index < vipmodulesAllL.value.data.length; index++) {
          if (vipmodulesAllL.value.data[index].value >= 2) {
            onlyOffi.userVipLevelList.value.add(vipmodulesAllL.value.data[index].id);
            //string form
            userVipLevelStringHelper += vipmodulesAllL.value.data[index].id + ',';
          }
          //instantCashForNextLevel
          if (vipmodulesAllL.value.data[index].value == 3) {
            instantCashLimitNextLevel.value = vipmodulesAllL.value.data[index].criteria.instantCashLimit;
            descriptionAccordingNextVIPLevel.value = vipmodulesAllL.value.data[index].description;
          }
        }
      } else if (level == 1) {
        for (int index = 0; index < vipmodulesAllL.value.data.length; index++) {
          if (vipmodulesAllL.value.data[index].value >= 1) {
            onlyOffi.userVipLevelList.value.add(vipmodulesAllL.value.data[index].id);
            //string form
            userVipLevelStringHelper += vipmodulesAllL.value.data[index].id + ',';
          }
          //instantCashForNextLevel
          if (vipmodulesAllL.value.data[index].value == 2) {
            instantCashLimitNextLevel.value = vipmodulesAllL.value.data[index].criteria.instantCashLimit;
            descriptionAccordingNextVIPLevel.value = vipmodulesAllL.value.data[index].description;
          }
        }
      } else if (level == 0) {
        for (int index = 0; index < vipmodulesAllL.value.data.length; index++) {
          if (vipmodulesAllL.value.data[index].value >= 0) {
            onlyOffi.userVipLevelList.value.add(vipmodulesAllL.value.data[index].id);
            //string form
            userVipLevelStringHelper += vipmodulesAllL.value.data[index].id + ',';
          }
          //instantCashForNextLevel
          if (vipmodulesAllL.value.data[index].value == 1) {
            instantCashLimitNextLevel.value = vipmodulesAllL.value.data[index].criteria.instantCashLimit;
            descriptionAccordingNextVIPLevel.value = vipmodulesAllL.value.data[index].description;
          }
        }
      }*/

      Utils().customPrint('userVipLevel1 ${onlyOffi.userVipLevelList.length}');
      Utils().customPrint('userVipLevel1 ${onlyOffi.userVipLevelList}');
      Utils().customPrint('userVipLevel1 ${instantCashLimitNextLevel.value}');
      if (userVipLevelStringHelper.length > 0) {
        AppString.userVipLevelString.value = userVipLevelStringHelper
            .trim()
            .replaceRange(userVipLevelStringHelper.length - 1,
                userVipLevelStringHelper.length, '');
      }
      Utils()
          .customPrint('userVipLevel1 ${AppString.userVipLevelString.value}');
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  //Vip redeem amount is low
  // VIP pop up
  void showBottomSheetInfoInstantVIP() {
    print("call data dec ${descriptionAccordingVIPLevel.value}");
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: navigatorKey.currentState.context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(navigatorKey.currentState.context)
                        .viewInsets
                        .bottom,
                    left: 10,
                    right: 10),
                decoration: BoxDecoration(
                    color: AppColor().border_inside,
                    border: Border.all(
                      width: 5,
                      color: AppColor().border_outside,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(
                          0.0,
                          5.0,
                        ),
                        blurRadius: 1.0,
                        spreadRadius: .3,
                        color: AppColor().border_outside_Dark,
                        inset: true,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 0),
                          child: Text(
                            "Benefits of your VIP level",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new IconButton(
                              icon: new Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(
                                    navigatorKey.currentState.context);
                              }),
                        )
                      ],
                    ),
                    Visibility(
                      visible: profileDataRes.value != null &&
                              profileDataRes.value.level != null
                          ? profileDataRes.value.level.value > 0
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                              onTap: () {
                                // Fluttertoast.showToast(msg: 'Banner Clicked!');
                              },
                              child: Image(
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                image: current_vip_banner != null &&
                                        current_vip_banner.value != null
                                    ? NetworkImage(current_vip_banner.value)
                                    : AssetImage(
                                        "assets/images/vip_banner_level0.png"),
                                fit: BoxFit.fill,
                              ),
                            )),
                      ),
                    ),
                    Obx(
                      () => descriptionAccordingVIPLevel.value != null
                          ? Html(
                              data: descriptionAccordingVIPLevel.value,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(12 *
                                      MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .textScaleFactor),
                                  fontWeight: FontWeight.normal,
                                  textAlign: TextAlign.left,
                                  color: Colors.white,
                                ),
                                'h1': Style(
                                  fontSize: FontSize(12 *
                                      MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .textScaleFactor),
                                  color: Colors.white,
                                  textAlign: TextAlign.left,
                                ),
                                'p': Style(
                                  fontSize: FontSize(12 *
                                      MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .textScaleFactor),
                                  textAlign: TextAlign.left,
                                  color: Colors.white,
                                  //   alignment: Alignment.centerLeft,
                                  fontFamily: "Montserrat",
                                ),
                                'ul': Style(
                                  fontSize: FontSize(12 *
                                      MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .textScaleFactor),
                                  color: Colors.white,
                                  textAlign: TextAlign
                                      .left, /*margin:  EdgeInsets.only(left: 10)*/
                                )
                              },
                            )
                          : SizedBox(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        //Navigator.pop(navigatorKey.currentState.context);
                        BaseController base_controller =
                            Get.put(BaseController());
                        base_controller.openwhatsappOTPV();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                        width: MediaQuery.of(navigatorKey.currentState.context)
                                .size
                                .width -
                            200,
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
                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/whatsapp_circle.png'),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Text(
                              "CONNECT",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat",
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  //saving device info
  Future<void> saveDeviceInfo(Map<String, dynamic> param) async {
    //showProgress(context, '', true);
    Map<String, dynamic> response =
        await WebServicesHelper().saveDeviceInfo(token, user_id, param);
    //hideProgress(context);
    if (response != null) {
      Utils().customPrint('saveDeviceInfo: ${response}');
    }
  }

  //testing
  //GlobalKey gkCart_ = GlobalKey();
  GlobalKey<CartIconKey> gkCart = GlobalKey<CartIconKey>();
  Function(GlobalKey) runAddToCardAnimation;

/*  void listClick(GlobalKey gkImageContainer) async {
    await runAddToCardAnimation(gkImageContainer);
    //await gkCart.currentState.runCartAnimation((++_cartQuantityItems).toString());
  }*/

  //instant cash pop
  void showCustomDialogConfettiNew() {
    if (animationController == null) {
      animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 2000));
      animationController.repeat();
    }

    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.0),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () {
            // Fluttertoast.showToast(msg: "msg");
            Navigator.pop(navigatorKey.currentState.context);
          },
          child: Stack(children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900].withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10)),
                    //height: 50,
                    //width: 230,
                  ),
                ),
              ),
            ),
            Container(
                height: double.infinity,
                width: double.infinity,
                child: Image(
                  image: AssetImage('assets/images/confetti_2.png'),
                  fit: BoxFit.fitHeight,
                )),
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 210,
                      width: 250,
                      //color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20)),
                      child: Card(
                        color: Colors.black.withOpacity(0.0),
                        //color: Colors.blue,
                        elevation: 0,
                        //margin: EdgeInsets.all(20),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Stack(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            alignment: Alignment.center,
                            children: [
                              /*Container(
                                  //color: Colors.red,
                                  margin: EdgeInsets.only(bottom: 50),
                                  child: */ /*Image.asset(
                                    "assets/images/green_tick_circle.png",
                                    fit: BoxFit.fill,
                                    height: 100,
                                  ),*/ /*
                                      Lottie.asset(
                                    'assets/lottie_files/tick_addmoney.json',
                                    repeat: false,
                                    //height: 100,
                                    //width: 210,
                                    fit: BoxFit.fill,
                                  ),
                                ),*/
                              OverflowBox(
                                maxHeight: 250,
                                maxWidth: 250,
                                child: Lottie.asset(
                                  'assets/lottie_files/tick_addmoney.json',
                                  repeat: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 135.0),
                                child: Text(
                                  //"Deposited \u{20B9}${selectAmount.value} Successfully",
                                  "Instant Cash Added\nSuccessfully",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      width: 250,
                      //key: gkCart,
                      //color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20)),
                      child: Card(
                        color: Colors.black.withOpacity(0.0),
                        elevation: 0,
                        margin: EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                  "assets/images/ic_create_tem_upload.webp",
                                  color: Colors.green,
                                  height: 25,
                                )),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  " Instant Cash ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                AnimatedBuilder(
                                    animation: animationController,
                                    builder: (c, anim) => Transform(
                                          transform: Matrix4.identity()
                                            ..setEntry(3, 2, 0.0025)
                                            ..rotateY(
                                                animationController.value *
                                                    3.14159265359),
                                          alignment: FractionalOffset.center,
                                          child: Container(
                                            height: 25,
                                            child: Image.asset(
                                                "assets/images/bonus_coin.png"),
                                          ),
                                        )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    //addToCartPopUp(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
                child: Container(
                  height: 60,
                  width: 250,
                  //key: gkCart_,
                  //color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Card(
                    color: Colors.black.withOpacity(0.0),
                    elevation: 0,
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Image.asset(
                              "assets/images/ic_create_tem_upload.webp",
                              color: Colors.green,
                              height: 25,
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              " Bonus Cash ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: AppColor().whiteColor),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            AnimatedBuilder(
                                animation: animationController,
                                builder: (c, anim) => Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.0025)
                                        ..rotateY(animationController.value *
                                            3.14159265359),
                                      alignment: FractionalOffset.center,
                                      child: Container(
                                        height: 25,
                                        child: Image.asset(
                                            "assets/images/bonus_coin.png"),
                                      ),
                                    )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            OverflowBox(
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              child: Lottie.asset(
                'assets/lottie_files/golden_confetti_new.json',
                repeat: false,
              ),
            ),
          ]),
        );
      },
    );
  }

  void showCustomDialogConfettiNewFTD() {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",
      //barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.0),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () {
            // Fluttertoast.showToast(msg: "msg");
            AppString.isUserFTR = false;
            Navigator.pop(navigatorKey.currentState.context);
          },
          child: AddToCartAnimation(
            gkCart: gkCart,
            rotation: false,
            dragToCardCurve: Curves.easeIn,
            dragToCardDuration: const Duration(milliseconds: 2000),
            previewCurve: Curves.linearToEaseOut,
            previewDuration: const Duration(milliseconds: 10),
            previewHeight: 0,
            previewWidth: 0,
            opacity: 1,
            initiaJump: false,
            receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
              this.runAddToCardAnimation = addToCardAnimationMethod;
            },
            child: Stack(children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[900].withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      //height: 50,
                      //width: 230,
                    ),
                  ),
                ),
              ),
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image(
                    image: AssetImage('assets/images/confetti_2.png'),
                    fit: BoxFit.fitHeight,
                  )),
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 210,
                        width: 250,
                        //color: Colors.white,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20)),
                        child: Card(
                          color: Colors.black.withOpacity(0.0),
                          //color: Colors.blue,
                          elevation: 0,
                          //margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Stack(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              alignment: Alignment.center,
                              children: [
                                OverflowBox(
                                  maxHeight: 250,
                                  maxWidth: 250,
                                  child: Lottie.asset(
                                    'assets/lottie_files/tick_addmoney.json',
                                    repeat: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 145.0),
                                  child: Text(
                                    //"Deposited \u{20B9}${selectAmount.value} Successfully",
                                    "SignUp Real Money Credited Successfully",
                                    //"\u{20B9}${(appSettingReponse.value.signupCreditPolicy.user.value / 100).toStringAsFixed(0)} Credited Successfully",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        color: AppColor().whiteColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //addToCartPopUp(),
                    ],
                  ),
                ),
              ),
              OverflowBox(
                maxHeight: double.infinity,
                maxWidth: double.infinity,
                child: Lottie.asset(
                  'assets/lottie_files/golden_confetti_new.json',
                  repeat: false,
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  ShowButton(var isClickHelp) {
    return Container(
      width: 111,
      height: 31,
      margin: EdgeInsets.only(right: 5),
      /*  padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),*/
      decoration: BoxDecoration(
        boxShadow: [
          isClickHelp != ""
              ? BoxShadow(
                  offset: Offset(00, -1.0),
                  blurRadius: 1.0,
                  spreadRadius: .1,
                  color: Color(0xFF545654),
                  inset: true,
                )
              : BoxShadow(
                  offset: Offset(00, -1.0),
                  blurRadius: 1.0,
                  spreadRadius: .1,
                  color: Color(0xFF4AEA66),
                  inset: true,
                )
        ],
        color: isClickHelp != ""
            ? AppColor().gray_vip_button
            : AppColor().banner_cash_g,
        border: Border.all(color: AppColor().whiteColor, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 13,
              width: 13,
              child: SvgPicture.asset(
                "assets/images/plus_sv.svg",
                color: AppColor().whiteColor,
              )

              /*Image.asset(
                              "assets/images/plus_o.png",
                              color: Colors.white,
                            ),*/
              ),
          SizedBox(
            width: 5,
          ),
          Text(
            "ADD CASH".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: "Montserrat",
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  //fetch Data From Bureau & Send To Our Server
  Future<void> fetchDataFromBureauSendToOurServer(
      String randomiseTransactionId) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    //raw request body
    Map<String, dynamic> params = {"sessionKey": randomiseTransactionId};
    //header
    String username = ApiUrl.BUREAU_CLIENT_ID;
    String password = ApiUrl.BUREAU_PASSWORD;
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);
    //calling
    Map<String, dynamic> response =
        await WebServicesHelper().bureauApiFetchingDetails(basicAuth, params);

    if (response != null) {
      Utils()
          .customPrint('fetchDataFromBureauSendToOurServer DATA ${response}');
      //update user bureau data
      //raw request body
      Map<String, dynamic> params = {
        "bureauSecurityData": [
          {"deviceId": await Utils().getUniqueDeviceId(), "response": response}
        ]
      };
      //API CALL
      updateUserBureauData(params);
    } else {
      //hideProgress(context);
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  //Send To Our Server API for Bureau work
  Future<void> updateUserBureauData(Map<String, dynamic> params) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    //calling
    Map<String, dynamic> response =
        await WebServicesHelper().updateUserBureauData(token, user_id, params);

    if (response != null) {
      Utils().customPrint('updateUserBureauData DATA ${response}');
    }
  }
}
