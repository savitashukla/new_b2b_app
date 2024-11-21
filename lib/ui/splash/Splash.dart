import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/ui/main/UnitEventList/UnityList.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/ui/main/leaderboard/LeaderBoard.dart';
import 'package:gmng/ui/main/myteam11_ballabazzi/MyTeam11_Ballbazi_Controller.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/CountryRestrictions.dart';
import '../../model/LoginModel/hash_rummy.dart';
import '../../notificationservice/LocalNotificationService.dart';
import '../../utills/bridge.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../../utills/event_tracker/CleverTapController.dart';
import '../../webservices/WebServicesHelper.dart';
import '../controller/Ballbazi_Controller.dart';
import '../controller/BaseController.dart';
import '../controller/ClanController.dart';
import '../controller/LeaderBoardController.dart';
import '../controller/Pocket52_Controller.dart';
import '../controller/user_controller.dart';
import '../login/Login.dart';
import '../main/Freakx/FreakxList.dart';
import '../main/GameZop/GameZopList.dart';

Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class Splash extends StatefulWidget {
  @override
  _SplshScreen createState() => _SplshScreen();
}

class _SplshScreen extends State<Splash> {
  final splashDelay = 0;

//game id

  UserPreferences userPreferences;
  LeaderBoardController leaderBoardController;
  AppsflyerController affiliatedController11 = Get.put(AppsflyerController());

  //VideoPlayerController videoPlayerController;
  ClanController clanController;

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    //Get.to(()=>readotp());
    Get.offAll(() => Login());
    /*LoginResponse data;
    Get.offAll(() => OtpVerification(data, "LOGIN", "9598848185"));*/
  }

  @override
  Future<void> initState() {
    super.initState();

    Get.put(CleverTapController());
    getCountryRestrictions();
    BaseController().getSettingPublicM();
    /* videoPlayerController =
        VideoPlayerController.asset('assets/video/splash_ss.mp4')
          ..initialize().then((_) {
            setState(() {});
            //videoPlayerController.play();
            //   videoPlayerController.setVolume(0);
          });*/

    userPreferences = new UserPreferences(context);
    userPreferences
        .getStringValues("token")
        .then((userData) => {
              if (userData != null && !userData.isEmpty)
                {
                  new Future.delayed(const Duration(seconds: 1), () async {
                    print(
                        "call  all exception  static ${AppsflyerController.page_name.value}");

                    /* try {
                      await getStrValues();
                    } catch (E) {
                      AppsflyerController. page_name.value = "home";
                      AppsflyerController. event_id_call.value = "";
                      Utils().customPrint("event id exception");
                    }*/

                    if (AppsflyerController.page_name.value != null &&
                        AppsflyerController.page_name.value.compareTo("home") ==
                            0) {
                      if (AppsflyerController.event_id_call.value.isNotEmpty &&
                          AppsflyerController.event_id_call.value
                                  .compareTo("62de6babd6fc1704f21b0ab5") ==
                              0) {
                        if (Platform.isIOS) {
                          Fluttertoast.showToast(msg: "Coming soon");
                        } else {
                          Pocket52LoginController _pocket52loginController;
                          _pocket52loginController =
                              Get.put(Pocket52LoginController());
                          _pocket52loginController
                              .getLoginWithPocket52(context);
                          Get.offAll(DashBord(
                              2, AppsflyerController.event_id_call.value));
                        }
                      } else if (AppsflyerController
                              .event_id_call.value.isNotEmpty &&
                          AppsflyerController.event_id_call.value
                                  .compareTo("62de6babd6fc1704f21b0ab4") ==
                              0) {
                        /* BallbaziLoginController ballbaziLoginController;
                        ballbaziLoginController =
                            Get.put(BallbaziLoginController());
                        ballbaziLoginController.getLoginBallabzi(context);*/
                        MyTeam11_Ballbazi_Controller team11Controller =
                            Get.put(MyTeam11_Ballbazi_Controller());
                        await team11Controller.getLoginTeam11BB(
                            context, '62de6babd6fc1704f21b0ab4');
                        Get.offAll(DashBord(
                            2, AppsflyerController.event_id_call.value));
                      } else if (AppsflyerController
                              .event_id_call.value.isNotEmpty &&
                          AppsflyerController.event_id_call.value
                                  .compareTo("62e7d76654628211b0e49d25") ==
                              0) {
                        final param = {"state": "haryana", "country": "india"};

                        Fluttertoast.showToast(msg: "Under Maintenance");

                        //  getHashForRummy(param);
                        // Get.offAll(DashBord(2, ""));
                      } else if (AppsflyerController.event_id_call.value
                              .compareTo("6396cf4ddc61af69e2840b49") ==
                          0) {

                        Fluttertoast.showToast(msg: "Under Maintenance");

                     /*   Get.offAll(GameJobList(
                            AppsflyerController.event_id_call.value,
                            "",
                            "Quick Ludo"));*/
                      } else if (AppsflyerController.event_id_call.value
                              .compareTo("639b3459187f2cd3e24efde9") ==
                          0) {
                        Get.to(FreakxList(
                            AppsflyerController.event_id_call.value,
                            "",
                            "Cricket"));
                      } else if (AppsflyerController.event_id_call.value
                              .compareTo("62de6babd6fc1704f21b0aae") ==
                          0) {
                        Get.to(UnityList(
                            AppsflyerController.event_id_call.value,
                            "",
                            "Carrom"));
                      } else if (AppsflyerController.event_id_call.value
                              .compareTo("62de6babd6fc1704f21b0a96") ==
                          0) {
                        Get.to(UnityList(
                            AppsflyerController.event_id_call.value,
                            "",
                            "Ludo"));
                      } else {
                        Get.offAll(DashBord(2, ""));
                      }
                    } else if (AppsflyerController.page_name.value != null &&
                        AppsflyerController.page_name.value
                                .compareTo("wallet") ==
                            0) {
                      if (AppsflyerController.event_id_call.isNotEmpty &&
                          AppsflyerController.event_id_call.value
                                  .compareTo("addmoney") ==
                              0) {
                        Get.offAll(DashBord(4, ""));
                      } else {
                        Get.offAll(DashBord(4, ""));
                      }
                    } else if (AppsflyerController.page_name.value != null &&
                        AppsflyerController.page_name.value
                                .compareTo("lootbox") ==
                            0) {
                      AppString.isClickFromHome = true;
                      Get.offAll(DashBord(0, ""));
                      //   Get.to(() => OfferWallScreen());
                      // Get.offAll(OfferWallScreen());
                      //}
                    } else if (AppsflyerController.page_name.value != null &&
                        AppsflyerController.page_name.value.compareTo("clan") ==
                            0) {
                      if (AppsflyerController.event_id_call.value != null &&
                          AppsflyerController.event_id_call.value.isNotEmpty) {
                        clanController = Get.put(ClanController());

                        clanController.getEventList(
                            "", AppsflyerController.event_id_call.value);
                        clanController.matches.value = true;
                        clanController.getJoinedContestList("");
                        clanController.updateSelectedClan();
                        Get.offAll(DashBord(3, ""));
                      } else {
                        Get.offAll(DashBord(3, ""));
                      }
                    } else if (AppsflyerController.page_name.value != null &&
                        AppsflyerController.page_name.value
                                .compareTo("rewards") ==
                            0) {
                      //currentIndex.value = 1;
                      Get.offAll(DashBord(1, ""));
                    } else if (AppsflyerController.page_name.value != null &&
                        AppsflyerController.page_name.value
                                .compareTo("leaderboard") ==
                            0) {
                      if (AppsflyerController.event_id_call.value != null &&
                          AppsflyerController.event_id_call.value.isNotEmpty) {
                        leaderBoardController =
                            Get.put(LeaderBoardController());

                        leaderBoardController.type.value = "monthly";
                        leaderBoardController.selectedgame.value =
                            AppsflyerController.event_id_call.value;
                        leaderBoardController.getLeaderBoardList(
                            AppsflyerController.event_id_call.value,
                            leaderBoardController.type.value);
                        Get.offAll(LeaderBoard());
                        //  Get.offAll(DashBord(0, ""));
                      } else {
                        Get.offAll(LeaderBoard());
                        // Get.offAll(DashBord(0, ""));
                      }
                    } else {
                      // currentIndex.value = 2,
                      Get.offAll(DashBord(2, ""));
                    }
                  }),
                }
              else
                {/*videoPlayerController.setVolume(1)*/ _loadWidget()}
            })
        .catchError((handleError) => {
              {_loadWidget()}
            });

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        Utils().customPrint(
            "FirebaseMessaging.instance.getInitialMessage${message.toString()}");

        if (message != null) {
          //  LocalNotificationService.showNotificationWithDefaultSound("");
          if (message.notification != null) {
            LocalNotificationService.createanddisplaynotification(message);
            Utils().customPrint("New Notification");
          } else {
            LocalNotificationService.showNotificationWithDefaultSound("");
          }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        Utils().customPrint("FirebaseMessaging.onMessageOpenedApp.listen");

        //  Utils().customPrint("Aditi Rao Agle Sakal yeah${message.notification.title}");
        //    Utils().customPrint("FirebaseMessaging.onMessage.listen${message.notification.body}");
        //    LocalNotificationService.createanddisplaynotification(message);Aditi Rao Agle Sakal

        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);
        } else {
          // LocalNotificationService.showNotificationWithDefaultSound("");
        }
      },
    );

/*    FirebaseMessaging.onMessage.listen((event) {
      // fetchRideInfo(getRideID(message), context);
          (Map<String, dynamic> message) async => fetchRideInfo(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // fetchRideInfo(getRideID(message), context);
          (Map<String, dynamic> message) async => fetchRideInfo(message);
    });*/

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        Utils().customPrint("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          Utils().customPrint(message.notification.title);
          Utils().customPrint(message.notification.body);
          Utils().customPrint("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/splash_back.png"),
        fit: BoxFit.fitWidth,
      )),
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image(
                  height: 70,
                  //width: 40,
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/gmng_logo.png")),
            ),
            Container(
              height: 0,
            ),
            /*        Image(
                height: 100,
                width: 100,
                //color: Colors.transparent,
                fit: BoxFit.fill,
                image: AssetImage("assets/images/progresbar_images.gif")),*/

            //flutterM()
            //  Obx(() =>    splashController.splashPro.value?showProgressUnity(context, "", false):Container(height: 0,))
            //splashController.splashPro.value?showProgressD(context, "", false):Container(height: 0,)
          ],
        ),
      ),
    ); /*Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Visibility(
              visible: false,
              child: Container(height: 0,*/ /*child: VideoPlayer(videoPlayerController)*/ /*)),
        ),
      ],
    ));*/
  }

  Future<void> getStrValues() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //   page_name.value = prefs.getString("page") ?? "home";
      //  event_id_call.value = prefs.getString("id_Call") ?? "";
    } catch (E) {
      Utils().customPrint("");
      Fluttertoast.showToast(msg: "call  all exception$E");
    }
  }

  Future<void> getCountryRestrictions() async {
    Utils().customPrint('getCountryRestrictions: STARTED');
    var response = await WebServicesHelper().getCountryRestrictions();
    if (response != null) {
      if (response[0] != null) {
        AppString.restrictedStatesData =
            CountryRestrictions.fromJson(response[0]);
        Utils().customPrint(
            'getCountryRestrictions: ${AppString.restrictedStatesData.states}');
        //extra work
        int count = AppString.restrictedStatesData.states.length;
        AppString.StateNameConcat = '';
        for (int i = 0; i < count; i++) {
          if (i == count - 1) {
            AppString.StateNameConcat +=
                '${AppString.restrictedStatesData.states[i].name}';
          } else {
            AppString.StateNameConcat +=
                '${AppString.restrictedStatesData.states[i].name}, ';
          }
        }
        Utils().customPrint(
            'getCountryRestrictions: ${AppString.StateNameConcat}');
      }
    } else {
      Fluttertoast.showToast(msg: "ERROR!");
    }
  }

  Future<void> getHashForRummy(Map<String, dynamic> param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Map<String, dynamic> response =
        await WebServicesHelper().getHashForRummy(token, param);

    Utils().customPrint('response $response');
    if (response != null) {
      if (response['isThirdPartyLimitExhausted']) {
        Utils.alertLimitExhausted();
        return true;
      } else {
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
            default:
              Utils().customPrint("click_buyin_success=====================>");
              break;
          }
        } catch (e) {
          //error
        }
      }
    } else {
      Utils().customPrint('response promo code ERROR');
    }
  }
}
