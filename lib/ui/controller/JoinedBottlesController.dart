import 'package:get/get.dart';
import 'package:gmng/model/ESportsEventList.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ESportListEvent/JoinedBattlesPlayersModel.dart';
import '../../model/ESportListEvent/UserJoinedResult.dart';
import '../../model/ESportListEvent/UserJoinedSoloResult.dart';
import '../../webservices/WebServicesHelper.dart';

class JoinedBattlesController extends GetxController {
  var remainingDayData = .6.obs;
  var joinedDetailsType = "Details".obs;
  SharedPreferences prefs;
  String event_id="";
  String user_id;
  String token;
  String round_id;
  var joinedBattlesDetailsModel = ContestModel().obs;
  var joinedBattlesPlayersModel = JoinedBattlesPlayersModel().obs;
  var joinedUserDetailsResult = UserJoinedResult().obs;
  var joinedUserDetailsSoloResult = UserJoinedSoloResult().obs;
  JoinedBattlesController(this.event_id);

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    getJoinedBattlesDetails(event_id);
   // getDetailsPlayers(event_id);

  }

  String DateFormatSet() {
    DateFormat("dd/MM/yyyy").format(
      DateFormat("yyyy-MM-dd").parse(""),
    );
  }

  Future<void> getDetailsPlayers(String event_id) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    joinedBattlesPlayersModel.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getDetailsPlayers(token, event_id);
    // Fluttertoast.showToast(msg: "$response");
    if (response != null) {
      joinedBattlesPlayersModel.value =
          JoinedBattlesPlayersModel.fromJson(response);
      Utils().customPrint("TYPE====>joinedBattlesPlayersModel");
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }
  Future<void> getDetailsUserInfo(String event_id) async {
    joinedUserDetailsResult.value = null;
    Map<String, dynamic> response =
    await WebServicesHelper().getDetailsUserInfo(user_id,token, event_id);
    Utils().customPrint('user info ==>${response.toString()}');
    // Fluttertoast.showToast(msg: "$response");
    if (response != null) {
      // Fluttertoast.showToast(msg: "$response");
      joinedUserDetailsResult.value =
          UserJoinedResult.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getDetailsUserInfoSolo(String event_id) async {
    joinedUserDetailsSoloResult.value = null;
    Map<String, dynamic> response =
    await WebServicesHelper().getDetailsUserInfo(user_id,token, event_id);
    Utils().customPrint('solo user info ==>${response.toString()}');
    // Fluttertoast.showToast(msg: "$response");
    if (response != null) {
      // Fluttertoast.showToast(msg: "$response");
      joinedUserDetailsSoloResult.value = UserJoinedSoloResult.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }


  Future<void> getJoinedBattlesDetails(String event_id) async {
    joinedBattlesDetailsModel.value = null;
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    Map<String, dynamic> response =
        await WebServicesHelper().getJoinedBattlesDetails(token, event_id);

    if (response != null) {
      joinedBattlesDetailsModel.value =
          ContestModel.fromJson(response);
     // Utils().customPrint("team size  ====>"+joinedBattlesDetailsModel.value.teamTypeId.size.toString());
      if(joinedBattlesDetailsModel.value!=null&& !joinedBattlesDetailsModel.value.isSoloContest()){
        getDetailsUserInfo(event_id);
      }else{
        getDetailsUserInfoSolo(event_id);
      }
    }
    getDetailsPlayers(event_id);
    // Fluttertoast.showToast(msg: "$response");
    if (response != null) {
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
