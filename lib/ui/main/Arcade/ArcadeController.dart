import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/ESportsEventList.dart';
import '../../../webservices/WebServicesHelper.dart';

class ArcadeController extends GetxController {
  var game_id;

  ArcadeController(this.game_id);

  var arcadeEventList = ESportEventListModel().obs;
  SharedPreferences prefs;
  String user_id;
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
    getESportsEventList();
  }

  Future<void> getESportsEventList() async {
    arcadeEventList.value = null;
    Map<String, dynamic> response = await WebServicesHelper()
        .getUnitEventList(token, game_id, "", "", user_id,"active");
    if (response != null) {
      arcadeEventList.value = ESportEventListModel.fromJson(response, "",true,false);
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
