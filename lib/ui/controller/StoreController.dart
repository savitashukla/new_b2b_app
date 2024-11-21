import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/StoreModel/StoreModelR.dart';
import 'package:gmng/model/StoreModel/store_p_history.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/InGame/InGameCheck.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../../utills/event_tracker/CleverTapController.dart';
import '../../utills/event_tracker/EventConstant.dart';
import '../../webservices/WebServicesHelper.dart';

class StoreController extends GetxController {
  var mapList = [
    "All",
    "BGMI",
    "Livik",
    "Miramar",
    "CALL OF DUTY",
    "Vikendi",
    "Sanhok"
  ].obs;
  SharedPreferences prefs;
  var inGameCheckModel = InGameCheck().obs;
  TextEditingController inGameName = new TextEditingController();
  TextEditingController iNGameId = new TextEditingController();
  String token;
  String user_id;
  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;
  var checkTr = true.obs;
  var storeValues = StoreModelR().obs;
  var butRe = "".obs;
  var soreHistory = "".obs;
  var store_p_historyR = Store_p_history().obs;
  var tabIndex = 0.obs;

  var game_id_name = "InGameID".obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getStoreList("");
  }

  Future<void> getStoreList(String game_id) async {
    storeValues.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getStoreApi(token, game_id);
    if (response != null) {
      storeValues.value = StoreModelR.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<Map> getINGameCheck(String game_id) async {
    Utils().customPrint("game_id ===>${game_id}");
    Utils().customPrint("user_id ===>${user_id}");
    inGameCheckModel.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getInGameCheck(token, user_id, game_id);
    if (response != null) {
      inGameCheckModel.value = InGameCheck.fromJson(response);
      iNGameId.text = inGameCheckModel.value.inGameId;
      inGameName.text = inGameCheckModel.value.inGameName;
      // mapKey["Enter you InGameID"].value=inGameCheckModel.value.inGameId;
      // mapKey["Enter you InGameName"]=inGameCheckModel.value.inGameName;
      return response;
    } else {
      return null;
    }
  }

  Future<Map> getINGamePost(String game_id, String store_id) async {
    final param = {"inGameId": iNGameId.text, "inGameName": inGameName.text};
    Map<String, dynamic> response =
        await WebServicesHelper().getInGamePost(param, token, user_id, game_id);
    if (response != null) {
      getBuyStore(store_id);
    }

    return response;
  }

/*  Future<Map> updateIngameId(String game_id, String store_id) async {
    final param = {"inGameId": iNGameId.text, "inGameName": inGameName.text};

    Map<String, dynamic> response = await WebServicesHelper().updateIngameId(
        param, token, user_id, game_id, inGameCheckModel.value.id);
    if (response != null) {
      inGameCheckModel.value = InGameCheck.fromJson(response);
      iNGameId.text = inGameCheckModel.value.inGameId;
      inGameName.text = inGameCheckModel.value.inGameName;

      getBuyStore(store_id);

      return response;
    } else {
      return response;
    }
  }*/

  Future<void> getBuyStore(String STORE_ID) async {
    butRe.value = null;
    //final param = {"inGameId": iNGameId.text, "inGameName": inGameName.text};
    var payload = {
      "quantity": 1,
      "storeItemId": STORE_ID,
      "inGameId": iNGameId.text,
      "inGameName": inGameName.text
    };
    Map<String, dynamic> response =
        await WebServicesHelper().getBuyStore(payload, token);
    if (response != null) {
      StoreItem data;
      if (storeValues.value != null && storeValues.value.data.length > 0) {
        for (int i = 0; i < storeValues.value.data.length; i++) {
          if (STORE_ID == storeValues.value.data[i].id) {
            data = storeValues.value.data[i];
            break;
          }
        }
      }

      CleverTapController cleverTapController = Get.put(CleverTapController());
      int amount = data.price.value ~/ 100;
      Map<String, Object> map = new Map<String, Object>();

      map["Store Item name"] = data.name;
      map["Store item id"] = STORE_ID;
      map["Item Cost"] = amount.toString();
      map["USER_ID"] = user_id;
      cleverTapController.logEventCT(
          EventConstant.EVENT_CLEAVERTAB_Store_Purchase, map);
      FirebaseEvent().firebaseEvent(
          EventConstant.EVENT_CLEAVERTAB_Store_Purchase_F, map);

      map["Name"] = "Store Purchase";
      AppsflyerController affiliatedController = Get.put(AppsflyerController());
      affiliatedController.logEventAf(
          EventConstant.EVENT_CLEAVERTAB_Store_Purchase, map);

      Fluttertoast.showToast(msg: "Successful store buy");

      butRe.value = response.toString();
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getBuyHistory() async {
    store_p_historyR.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getStoreHistory(token, user_id);
    if (response != null) {
      store_p_historyR.value = Store_p_history.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
