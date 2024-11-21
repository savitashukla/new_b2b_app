import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/BannerModel/BannerResC.dart';
import 'package:gmng/model/tamasha/WebViewTamashaModel.dart';
import 'package:gmng/model/unity_history/OnlyUnityHistoryModel.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';
import 'package:gmng/utills/event_tracker/FaceBookEventController.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:gmng/webservices/WebServicesHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app.dart';
import '../../../model/tamasha/TamashaEventListD.dart';
import 'TamashaWebView.dart';

class TamashaListingController extends GetxController {
  var game_id;

  TamashaListingController(this.game_id);

  var unityEventList = TamashaEventListD().obs;
  SharedPreferences prefs;
  String user_id;
  var onlyUnityHistoryModel = OnlyUnityHistoryModel().obs;
  String token;
  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;
  var checkTr = true.obs;

  // pagination add
  var scrollcontroller = ScrollController();
  var currentpage = 0.obs;
  var total_limit = 10;
  var totalAmountValues = 0.obs;
  RxList unity_history_userRegistrations = new List<HistoryData>().obs;
  var bannerModelRV = BannerModelR().obs;
  var webViewData = WebViewTamashaModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getESportsEventList();

    // pagination add

    scrollcontroller.addListener(() {
      if (scrollcontroller.position.atEdge &&
          scrollcontroller.position.pixels != 0) {
        if (totalAmountValues > currentpage.value) {
          currentpage.value = currentpage.value + 10;
          getUnityHistoryOnly(game_id);
        }
        Utils().customPrint("data pagination");
      }
    });
    //call banner api
    getBanner(game_id);
  }

  Future<void> getESportsEventList() async {
    unityEventList.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getTamashaEventList(token);
    if (response != null) {
      unityEventList.value = TamashaEventListD.fromJson(response);
      //Utils().customPrint('TAMASHA LIST ${unityEventList.value.data.length}');
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getUnityHistoryOnly(String game_id) async {
    onlyUnityHistoryModel.value = null;

    Map<String, dynamic> response = await WebServicesHelper().getUnityHistory(
        token, user_id, game_id, total_limit, currentpage.value);
    if (response != null) {
      onlyUnityHistoryModel.value = OnlyUnityHistoryModel.fromJson(response);

      if (onlyUnityHistoryModel.value.data.length > 0) {
        unity_history_userRegistrations
            .addAll(onlyUnityHistoryModel.value.data);
        totalAmountValues.value = onlyUnityHistoryModel.value.pagination.total;
        print("data history call ${unity_history_userRegistrations.value[0]}");
      } else {
        //Fluttertoast.showToast(msg: "Data Not Found!");
      }
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getBanner(String game_id) async {
    Utils().customPrint('Tamasha Banner: $game_id');
    if (token != null && token != '') {
      Map<String, dynamic> response_str =
          await WebServicesHelper().getBannerViaGameId(token, game_id);
      if (response_str != null) {
        bannerModelRV.value = BannerModelR.fromJson(response_str);
        Utils().customPrint('Unity Banner: ${bannerModelRV.value.data.length}');
      }
    }
  }

  Future<void> getCallGameUrlTamasha(String contestId) async {
    final param = {
      "contestId": contestId,
    };
    Map<String, dynamic> response_str =
        await WebServicesHelper().getTamashaWebView(token, param);
    //Utils.launchURLApp(response_str["webViewUrl"]);
    //return;

    if (response_str != null) {
      if (response_str['isThirdPartyLimitExhausted'] != null &&
          response_str['isThirdPartyLimitExhausted']) {
        Utils.alertLimitExhausted();
        return true;
      }

      webViewData.value = WebViewTamashaModel.fromJson(response_str);
      Utils().customPrint('getCallGameUrlTamasha ${webViewData.value}');
    } else {
      Fluttertoast.showToast(msg: "Something Went Wrong");
    }

    /* if (response_str["webViewUrl"] != null) {
      Navigator.push(
        navigatorKey.currentState.context,
        MaterialPageRoute(
          builder: (BuildContext context) => TamashaWebview(
            response_str["webViewUrl"],
            "gameid",
            "event_id",
            "",
          ),
        ),
      );
    }*/
  }
}
