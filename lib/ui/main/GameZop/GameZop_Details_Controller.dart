import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/unity_history/UnityDetailsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../webservices/WebServicesHelper.dart';

class Unity_Details_Controller extends GetxController {
  /* var game_id;

  Unity_Details_Controller(this.game_id);*/

  SharedPreferences prefs;
  String user_id;
  var unityEventListDetails = UnityDetailsModel().obs;

  String token;
  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;
  var checkTr = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getUnityListDetails();
  }

  Future<void> getUnityListDetails() async {
    unityEventListDetails.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getUnityHistoryDetails(token, user_id, "");
    if (response != null) {
      unityEventListDetails.value = UnityDetailsModel.fromJson(response);
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
