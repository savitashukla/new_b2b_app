import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../model/responsemodel/PreJoinUnityResponseModel.dart';
import '../../../model/unity_history/OnlyUnityHistoryModel.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../dashbord/DashBord.dart';
import 'GameZopWebview.dart';

class Match_Making_Screen_Controller extends GetxController {
  String event_id;
  String gameid;

  Match_Making_Screen_Controller(this.gameid, this.event_id);

  SharedPreferences prefs;

  String user_id;

  String token;
  var onlyUnityHistoryModel = OnlyUnityHistoryModel().obs;

  PreJoinUnityResponseModel preJoinResponseModel;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    getUnityHistoryOnly(gameid);
    getPreJoinEventGameZob(event_id);
  }

  Future<Map> getPreJoinEventGameZob(String event_id) async {
    //print("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${user_id}");
    final param = {
      "userId": user_id,
      "thirdParty": {"type": "gameZop", "gameCode": "SkhljT2fdgb"}
    };

    Map<String, dynamic> response = await WebServicesHelper()
        .getPreEventJoinGameJob(param, token, event_id);
    debugPrint(' respone is finaly ${response}');
    if (response != null && response['statusCode'] == null) {
      preJoinResponseModel = PreJoinUnityResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount1 deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          Fluttertoast.showToast(msg: "Please add Amount.");
          Get.offAll(() => DashBord(4, ""));
          //Utils().alertInsufficientBalance(context);
        } else {
          Future.delayed(const Duration(seconds: 5), () {
            Get.off(() => GameJobWebview(
                preJoinResponseModel.webViewUrl, gameid, event_id, "0", ""));
          });
        }
      } else {
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(response);
        Utils().showErrorMessage("", appBaseErrorModel.error);
      }
    } else if (response['statusCode'] != 400) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else if (response['statusCode'] != 500) {
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else {
      Utils().customPrint('respone is finaly2${response}');
    }
  }

  Future<void> getUnityHistoryOnly(String game_id) async {
    onlyUnityHistoryModel.value = null;

    Map<String, dynamic> response = await WebServicesHelper()
        .getUnityHistory(token, user_id, game_id, 1, 0);
    if (response != null) {
      onlyUnityHistoryModel.value = OnlyUnityHistoryModel.fromJson(response);
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
